# Clone and deploy a .NET 9 Blazor chat app connected to Azure OpenAI

### Follow the steps to run the sample app

### 1. Clone the app
Clone the application to your machine

### 2. Add OpenAI information
Go to the `appsettings.json` file and insert the following values from your Azure OpenAI data.
- DEPLOYMENT_NAME = <deployment-name>
- ENDPOINT = <endpoint>
- API_KEY = <api-key>
- MODEL_ID = <model-id>

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "OpenAI": {
    "DEPLOYMENT_NAME": "<deployment-name>",
    "ENDPOINT": "https://<endpoint-name>.openai.azure.com/",
    "API_KEY": "<api-key>",
    "MODEL_ID": "<model-id>"
  },
  "AllowedHosts": "*"
}
```

### 3. Run the application
Once the values are saved, run the application using F5 and navigate to the Chat blade. You can then ask a question in the input field to start the chat and receive a response from your Azure OpenAI service.
