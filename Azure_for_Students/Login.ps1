# Login to Azure as interactive user
# ----------------------------------

# PowerShell

# Disconnect-AzAccount  
Connect-AzAccount
Get-AzContext | Format-List *

Get-AzResourceGroup | Format-Table ResourceGroupName,Location,ProvisioningState


# Azure CLI

#az logout
az login
az account show

az group list -o table