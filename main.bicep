targetScope='subscription'

param worldName string
param serverPass string
param serverName string // FDQN: [dnshNameLabel].westeurope.azurecontainer.io
param storageAccountName string
param location string = deployment().location
param image string = 'lloesche/valheim-server'
var resourceName = '${serverName}-${location}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'rg-${resourceName}' 
  location: location
}

module valheimServer 'valheim-server.bicep' = {
  name: 'valheimServerModule'
  scope: resourceGroup
  params: {
    location: location
    dnshNameLabel: serverName
    storageAccountName: storageAccountName
    serverName: serverName
    resourceName: resourceName
    worldName: worldName
    serverPass: serverPass
    image: image
  }
}
