# Login to Azure as interactive user
# ----------------------------------

# PowerShell

# Disconnect-AzAccount  
Connect-AzAccount
Get-AzContext | Format-List *


# Azure CLI

#az logout
az login
az account show