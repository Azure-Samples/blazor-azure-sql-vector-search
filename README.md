# Clone and deploy a .NET 9 Blazor chat app connected to Azure OpenAI
 Please see the [documentation](https://learn.microsoft.com/azure/app-service/deploy-intelligent-apps-dotnet-to-azure-sql) for more detailed information about this sample.

## Prerequisites
- Azure OpenAI resource with deployed embeddings and chat models
- Azure SQL database resource with vector embeddings

### 1. Clone the sample app
```
git clone https://github.com/Azure-Samples/blazor-azure-sql-vector-search.git
```

### 2. Add Azure OpenAI and Azure SQL credentials
Go to the `appsettings.json` file and insert the following values from your Azure OpenAI and Azure SQL resources.

**Azure OpenAI**
- `DEPLOYMENT_NAME = <deployment-name>`
- `ENDPOINT = <endpoint>`
- `API_KEY = <api-key>`
- `MODEL_ID = <model-id>`

**Azure SQL**
- `AZURE_SQL_CONNECTIONSTRING = <connection-string>`

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AzureOpenAI": {
    "DEPLOYMENT_NAME": "<deployment-name>",
    "ENDPOINT": "https://<endpoint-name>.openai.azure.com/",
    "API_KEY": "<api-key>",
    "MODEL_ID": "<model-id>"
  },
    "ConnectionStrings": {
    "AZURE_SQL_CONNECTIONSTRING": "<connection-string>"
  },
  "AllowedHosts": "*"
}
```

### 3. Update SQL query embeddings model
In the `Chat.razor` file, update the following value to be used in the stored procedure
- `@model = <azure-openai-embeddings-model>`

```
 // Hybrid search query
 var sql =
             @"DECLARE @e VECTOR(1536);
			EXEC dbo.GET_EMBEDDINGS @model = '<azure-openai-embeddings-model>', @text = '@userMessage', @embedding = @e OUTPUT;

				 -- Comprehensive query with multiple filters.
			SELECT TOP(5)
				f.Score,
				f.Summary,
				f.Text,
				VECTOR_DISTANCE('cosine', @e, VectorBinary) AS Distance,
				CASE
					WHEN LEN(f.Text) > 100 THEN 'Detailed Review'
					ELSE 'Short Review'
				END AS ReviewLength,
				CASE
					WHEN f.Score >= 4 THEN 'High Score'
					WHEN f.Score BETWEEN 2 AND 3 THEN 'Medium Score'
					ELSE 'Low Score'
				END AS ScoreCategory
			FROM finefoodembeddings10k$ f
			WHERE
				f.UserId NOT LIKE 'Anonymous%' -- User-based filter to exclude anonymous users
				AND f.Score >= 4 -- Score threshold filter
				AND LEN(f.Text) > 50 -- Text length filter for detailed reviews
             AND (f.Text LIKE '%juice%') -- Inclusion of specific words
			ORDER BY
				Distance,  -- Order by distance
				f.Score DESC, -- Secondary order by review score
				ReviewLength DESC; -- Tertiary order by review length
		";
```

### 3. Run the application
Once the values are saved, run the application using F5 and navigate to the Chat blade. You can then ask a question in the input field to start the chat and receive a response from your Azure OpenAI service grounded in your Azure SQL data.

### 4. Deploy to App Service
You can deploy the web app as you normally would. Although your secrets in app settings are encrypted at rest, we highly recommend setting up managed identity to secure your resources. Please see the documentation for this sample to secure your resources with [managed identity](https://learn.microsoft.com/azure/app-service/deploy-intelligent-apps-dotnet-to-azure-sql#secure-your-data-with-managed-identity)
