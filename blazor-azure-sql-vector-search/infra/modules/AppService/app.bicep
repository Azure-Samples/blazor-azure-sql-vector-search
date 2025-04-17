param location string = resourceGroup().location
param appName string
param appServicePlanId string
param linuxFxVersion string = 'DOTNETCORE|9.0'

// Azure SQL 
// param sqlDatabaseName string
// param sqlServerName string

resource app 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
        linuxFxVersion: linuxFxVersion
    }
  }
  tags: {
    'azd-service-name': 'blazor-azure-sql-vector-search'
  }
}

output appId string = app.id
output appDefaultHostName string = app.properties.defaultHostName
output systemAssignedPrincipalId string = app.identity.principalId

