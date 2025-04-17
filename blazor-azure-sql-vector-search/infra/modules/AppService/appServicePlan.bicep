param location string = resourceGroup().location
param appServicePlanName string
param appServicePlanSku string
param appServicePlanCapacity int

var uniqueNameComponent = uniqueString(resourceGroup().id)

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${appServicePlanName}-${uniqueNameComponent}'
  location: location
  sku: {
    name: appServicePlanSku
    capacity: appServicePlanCapacity
  }
  properties: {
      reserved: true // isLinux app
  }
}

output appServicePlanId string = appServicePlan.id
