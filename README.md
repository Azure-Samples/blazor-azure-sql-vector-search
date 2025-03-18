# Clone and deploy a .NET 9 Blazor chat app connected to Azure OpenAI

### Follow the steps to run the sample app locally

### 1. Clone the sample app
```
git clone https://github.com/Azure-Samples/blazor-azure-sql-vector-search.git
```

### 2. Add Azure OpenAI and Azure SQL credentials
Go to the `appsettings.json` file and insert the following values from your Azure OpenAI and Azure SQL resources.

**Azure OpenAI**
- DEPLOYMENT_NAME = <deployment-name>
- ENDPOINT = <endpoint>
- API_KEY = <api-key>
- MODEL_ID = <model-id>

**Azure SQL**
- AZURE_SQL_CONNECTIONSTRING= <connection-string>

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

### 3. Run the application
Once the values are saved, run the application using F5 and navigate to the Chat blade. You can then ask a question in the input field to start the chat and receive a response from your Azure OpenAI service grounded in your Azure SQL data.
