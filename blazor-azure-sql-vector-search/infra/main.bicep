param location string = resourceGroup().location
param appName string = 'app-${uniqueString(resourceGroup().id)}'
param appServicePlanName string = 'ASP-${appName}'
param appServicePlanSku string = 'P1V2'
param appServicePlanCapacity int = 1
// Azure Key Vault
param keyVaultName string = 'kv-${appName}'
// Azure OpenAI
param openAIResourceName string = 'openAI-${appName}'

// Azure SQL
// param sqlServerName string
// param sqlAdminUsername string
// @secure()
// param sqlAdminPassword string
// param sqlDatabaseName string


module appServicePlan 'modules/AppService/appServicePlan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    location: location
    appServicePlanName: appServicePlanName
    appServicePlanSku: appServicePlanSku
    appServicePlanCapacity: appServicePlanCapacity
  }
}

module app 'modules/AppService/app.bicep' = {
  name: appName
  params: {
    location: location
    appName: appName
    appServicePlanId: appServicePlan.outputs.appServicePlanId
    // sqlDatabaseName: sqlDatabaseName
    // sqlServerName: sqlServerName
  }
}

// module AzureSQL 'modules/AzureSQL/AzureSQL.bicep' = {
//   name: 'azureSQLDeployment'
//   params: {
//     sqlServerName: sqlServerName
//     sqlAdminUsername: sqlAdminUsername
//     sqlAdminPassword: sqlAdminPassword
//     sqlDatabaseName: sqlDatabaseName
//     location: location
//     //appName: app.outputs.uniqueAppName
//   }
// }

module AzureOpenAI 'modules/AzureOpenAI/AzureOpenAI.bicep' = {
  name: 'openAIDeployment'
  params: {
    location: location
    openAIResourceName: openAIResourceName
  }
}

module KeyVault 'modules/KeyVault/KeyVault.bicep' = {
  name: 'keyVaultDeploy'
  dependsOn: [
    AzureOpenAI
  ]
  params: {
    keyVaultName: keyVaultName
    location: location
    appName: appName
    openAIResourceEndpoint: AzureOpenAI.outputs.openAIResourceEndpoint
    gptDeploymentName: AzureOpenAI.outputs.gptDeploymentName
    gptModelName: AzureOpenAI.outputs.gptModelName
  }
}

module KeyVaultRefs 'modules/AppService/EnvironmentVars.bicep' = {
  name: 'keyVaultRefsDeployment'
  dependsOn: [
    app
    KeyVault
  ]
  params: {
    appName: appName
    keyVaultName: KeyVault.outputs.keyVaultName
    openAIResourceEndpoint: AzureOpenAI.outputs.openAIResourceEndpoint
    gptDeploymentName: AzureOpenAI.outputs.gptDeploymentName
    gptModelName: AzureOpenAI.outputs.gptModelName
  }
}

output openAIResourceEndpoint string = AzureOpenAI.outputs.openAIResourceEndpoint
output gptDeploymentName string = AzureOpenAI.outputs.gptDeploymentName
output gptModelName string = AzureOpenAI.outputs.gptModelName











