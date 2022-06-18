param resourceName string
param serverName string
param worldName string
param serverPass string
param dnshNameLabel string
param location string = resourceGroup().location
param storageAccountName string = 'str${uniqueString(resourceGroup().id)}'

param containerGroupName string = 'aci-${resourceName}'
param image string = 'lloesche/valheim-server'
param cpuCores int = 2
param memoryInGb int = 4
param restartPolicy string = 'Always'

var shareName = 'valheim'

resource storage 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Premium_LRS'
  }
  kind: 'FileStorage'
  properties: {}
}

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-04-01' = {
  name: '${storage.name}/default/${shareName}'
}

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: containerGroupName
  location: location
  properties: {
    containers: [
      {
        name: containerGroupName
        properties: {
          image: image
          ports: [
            {
              port: 2456
              protocol: 'UDP'
            }
            {
              port: 2457
              protocol: 'UDP'
            }
          ]
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
          environmentVariables: [
            {
              name: 'SERVER_NAME'
              value: serverName
            }
            {
              name: 'WORLD_NAME'
              value: worldName
            }
            {
              name: 'SERVER_PASS'
              value: serverPass
            }
          ]
          volumeMounts: [
            {
              name: 'valheim-server-data'
              mountPath: '/config'
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: restartPolicy
    ipAddress: {
      type: 'Public'
      dnsNameLabel: dnshNameLabel
      ports: [
        {
          port: 2456
          protocol: 'UDP'
        }
        {
          port: 2457
          protocol: 'UDP'
        }
      ]
    }
    volumes: [
      {
        name: 'valheim-server-data'
        azureFile: {
          shareName: shareName
          storageAccountName: storage.name
          storageAccountKey: storage.listKeys().keys[0].value
        }
      }
    ]
  }
}
