param sqlServerName string
param sqlAdminUsername string
@secure()
param sqlAdminPassword string
param sqlDatabaseName string
param location string = resourceGroup().location
//param appName string


//stack overflow answer
// resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
//   name: 'sql-msi'
//   location: location
// }

// app identity
// resource app 'Microsoft.Web/sites@2022-09-01' existing = {
//   name: appName
// }

// original working version without auth
// resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
//   name: sqlServerName
//   location: location
//   properties: {
//     administratorLogin: sqlAdminUsername
//     administratorLoginPassword: sqlAdminPassword
//   }
// }

// stack overflow answer
resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminUsername
    administratorLoginPassword: sqlAdminPassword
    //version: '12.0'
    //administrators: {
      // administratorType: 'ActiveDirectory'
      // azureADOnlyAuthentication: true
      // principalType: 'Application'
      // login: sqlAdminUsername
      // sid: app.identity.principalId
      // tenantId: tenant().tenantId
      // login: managedIdentity.name
      // sid: managedIdentity.properties.principalId
      // tenantId: managedIdentity.properties.tenantId
    //}
  }
}

// testing auth options
// resource sqlAuth 'Microsoft.Sql/servers/azureADOnlyAuthentications@2024-05-01-preview' = {
//   parent: sqlServer
//   name: 'default'
//   properties: {
//     azureADOnlyAuthentication: true
//   }
// }

// SQL DB
resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: {
    name: 'S0'
    tier: 'Standard'
  }
}

// // Not needed when deploying SQL by itself
// resource sqlDatabaseRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(sqlDatabase.id, managedIdentity.id, 'db_datareader') // Unique name for the role assignment
//   properties: {
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'db_datareader') // Example: db_datareader role
//     principalId: managedIdentity.properties.principalId // The principal ID of the managed identity
//     principalType: 'ServicePrincipal' // The type of the principal (ServicePrincipal for managed identities)
//   }
// }

output sqlServerName string = sqlServer.name
output sqlDatabaseName string = sqlDatabase.name


