param appName string
param keyVaultName string
param location string

param gptDeploymentName string
param gptModelName string
param openAIResourceEndpoint string

// app
resource app 'Microsoft.Web/sites@2022-09-01' existing = {
  name: appName
}

// Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

module keyVaultSecrets '../KeyVault/KeyVault.bicep' = {
  name: 'keyVaultSecretsDeployment'
  params: {
    location: location
    keyVaultName: keyVault.name
    appName: appName
    gptDeploymentName: gptDeploymentName
    gptModelName: gptModelName
    openAIResourceEndpoint: openAIResourceEndpoint
  }  
}

resource appSettings 'Microsoft.Web/sites/config@2022-09-01' = {
  name: 'appsettings'
  kind: 'string'
  parent: app
  properties: {
    ENDPOINT: '@Microsoft.KeyVault(SecretUri=${keyVaultSecrets.outputs.secret1Uri})'
    MODEL_ID: '@Microsoft.KeyVault(SecretUri=${keyVaultSecrets.outputs.secret2Uri})'
    DEPLOYMENT_NAME: '@Microsoft.KeyVault(SecretUri=${keyVaultSecrets.outputs.secret3Uri})'
    API_KEY: '@Microsoft.KeyVault(SecretUri=API_KEY)'
    AZURE_SQL_CONNECTION_STRING: '<CONNECTION_STRING>'
  }
}
