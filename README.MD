# Valheim Azure Bicep
[Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep) templates to generate Azure resource group and resources needed for hosting Valheim dedicated server.


# Overview
Hosting of the Valheim dedicated server is done with [Container Instances](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview)

Docker image for the server is by default [lloesche/valheim-server-docker](https://github.com/lloesche/valheim-server-docker)  

Server files are stored in [Premium File Storage Account](https://azure.microsoft.com/en-us/pricing/details/storage/files/)

Whole shabang is based on this great [blog post](https://jakelunn.medium.com/host-a-valheim-dedicated-server-using-azure-container-instances-81d35b061f08) by Jake Lunn

# Prequises
 [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

# Edit parameters
Edit `main.parameters.json` and fill out the parameters :

```
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
      "serverName": {
        "value": "my-valheim"
      },
      "serverPass": {
        "value": "password"
      },
      "worldName": {
        "value": "My valheim world"
      },
      "storageAccountName": {
        "value": "stomyvalheim"
      }
    }
}
```

### Parameters
`serverName`
 - Used for naming resources, dns configurations
 - Example: `my-valheim` would result in :
    - ResourceGroup: `rg-my-valheim`
    - Container Instances Resource: `aci-my-valheim-westeurope`
    - FQDN: `my-valheim.westeurope.azurecontainer.io` 
        - **This is the address you use to connect to the valheim server**

`serverPass`
- Server Password

`worldName`
- World name in Valheim

`storageAccountName`
- Resource name for storage account (eg `stomyvalheim`)

# Deployment

Make sure you are authenticated with Azure CLI and that you have right subscription selected:

Login:
```
az login
```

List subscriptions:
```
az account list -o table
```

Set subscription:
```
az account set -s <name or id>
```

Then we can start the deployment:
```
az deployment sub create -c --name my-first-deployment --location westeurope --template-file main.bicep --parameters main.parameters.json
```
