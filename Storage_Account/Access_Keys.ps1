# Manage storage account access keys
# ----------------------------------

# https://learn.microsoft.com/en-us/azure/storage/common/storage-account-keys-manage?tabs=azure-cli

# Name of your storage account
$storageAccountName = 'sagfna5xyz'

# View keys
az storage account keys list --account-name $storageAccountName
az storage account keys list --account-name $storageAccountName --query '[0]'
az storage account keys list --account-name $storageAccountName --query '[0].value' --output tsv

# Rotate key
az storage account keys renew --account-name $storageAccountName --key primary
# '--key primary' is deprecated, use '--key key1' instead
az storage account keys renew --account-name $storageAccountName --key key1