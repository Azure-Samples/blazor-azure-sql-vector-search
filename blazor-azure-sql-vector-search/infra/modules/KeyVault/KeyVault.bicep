@description('Specifies the name of the key vault.')
param keyVaultName string

@description('Specifies the SKU to use for the key vault.')
param keyVaultSku object = {
  name: 'standard'
  family: 'A'
}

@description('Specifies the Azure location where the resources should be created.')
param location string

param gptDeploymentName string
param gptModelName string
param openAIResourceEndpoint string

param appName string

// Use app to get identity principal id
resource app 'Microsoft.Web/sites@2022-09-01' existing = {
  name: appName
}

// create Key Vault resource with application access policy
resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: tenant().tenantId
    sku: keyVaultSku
    accessPolicies: [
      // App Service Managed Identity Access policy
      {
      tenantId: tenant().tenantId
      objectId: app.identity.principalId
      permissions: {
          secrets: [
            'all'
          ]
          certificates: [
            'all'
          ]
          keys: [
            'all'
          ]
        }
    } 
     // User Principal Access Policy - must be enabled manually in portal
    // {
    //   tenantId: tenant().tenantId
    //   objectId: // user principal id here - only can be retrieved via CLI
    //   permissions: {
    //     secrets: [
    //       'get'
    //       'list'
    //     ]
    //   }
    // }
    ]
    enabledForTemplateDeployment: true
  }
}

// Key Vault Secrets
resource secret1 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: 'endpoint'
  parent: keyVault
  properties: {
    value: openAIResourceEndpoint
  }
}

resource secret2 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: 'modelId'
  parent: keyVault
  properties: {
    value: gptModelName
  }
}

resource secret3 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: 'deploymentName'
  parent: keyVault
  properties: {
    value: gptDeploymentName
  }
}

// output key vault uris
output secret1Uri string = secret1.properties.secretUri
output secret2Uri string = secret2.properties.secretUri
output secret3Uri string = secret3.properties.secretUri

output keyVaultName string = keyVault.name

output location string = location
output resourceGroupName string = resourceGroup().name
output resourceId string = keyVault.id

