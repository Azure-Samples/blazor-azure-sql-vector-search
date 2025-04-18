param location string
param openAIResourceName string


resource openAIResource 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' = {
  name: openAIResourceName
  location: location
  sku: {
    name: 'S0'
    capacity: 5
  }
  kind: 'OpenAI'
  properties: {
    apiProperties: {
      enableManagedIdentity: true
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource gpt35Model 'Microsoft.CognitiveServices/accounts/deployments@2024-04-01-preview' = {
  parent: openAIResource
  name: '${openAIResourceName}GPT35'
  sku: {
    name: 'Standard'
    capacity: 5
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-35-turbo'
      version: '0125'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 5
    raiPolicyName: 'Microsoft.Default'
  }
}

resource textEmbeddingModel 'Microsoft.CognitiveServices/accounts/deployments@2024-04-01-preview' = {
  parent: openAIResource
  dependsOn: [
    gpt35Model
  ]
  name: '${openAIResourceName}Embedding'
  sku: {
    name: 'Standard'
    capacity: 5
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'text-embedding-ada-002'
      version: '2'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 5
    raiPolicyName: 'Microsoft.Default'
  }
}

output openAIResourceId string = openAIResource.id
output openAIResourceEndpoint string = openAIResource.properties.endpoint
output gptDeploymentName string = gpt35Model.name
output gptModelName string = gpt35Model.properties.model.name


