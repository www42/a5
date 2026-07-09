# Azure Container Registry (ACR) and Azure Container Instance (ACI)
# =================================================================

# 1.) Login to Azure
# ------------------
az login
az account show


# 2.) Set Region
# ---------------
#   https://learn.microsoft.com/en-us/cli/azure/policy/assignment?view=azure-cli-latest#az-policy-assignment-list
az policy assignment list --query "[].{Name:name, DisplayName:displayName, Scope:scope}" -o table
az policy assignment show --name "sys.regionrestriction"
az policy assignment show --name "sys.regionrestriction" --query "parameters"
az policy assignment show --name "sys.regionrestriction" --query "parameters.listOfAllowedLocations.value"

$location = 'swedencentral'


# 3.) Create Resource Group
# -------------------------
#   https://learn.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-create
$resourceGroupName = 'rg-container'
az group create --name $resourceGroupName --location $location

az group list --query "[].{Name:name,Location:location}" --output table


# 4.) Register Azure Resource Provider
# ------------------------------------
#   https://learn.microsoft.com/en-us/cli/azure/provider?view=azure-cli-latest#az-provider-register
az provider register --namespace 'Microsoft.ContainerRegistry'

az provider show --namespace 'Microsoft.ContainerRegistry' --query "registrationState" --output  tsv


# 5.) Create Azure Container Registry (ACR)
# -----------------------------------------
#   https://learn.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest#az-acr-create
$acrName = 'timmyacr'
az acr create --name $acrName --resource-group $resourceGroupName --sku Basic --admin-enabled $true

az acr show --name $acrName --query "{Name:name,LoginServer:loginServer,Location:location,AdminUserEnabled:adminUserEnabled}"


# 6.) Create Dockerfile
# ---------------------
mkdir foo
cd foo
echo '<html><h1>Hello Mannheim! Hello Heidelberg!</h1></html>' > index.html
echo FROM nginx > Dockerfile
echo COPY index.html /usr/share/nginx/html >> Dockerfile
dir


# Build Docker Image in Azure --> Does not work with Azure for Students :-(
#   https://learn.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest#az-acr-build
az acr build --image foo/nginx:v1 --registry $acrName --file Dockerfile .


# 7.) Build Docker Image Locally
# ------------------------------
gcm docker
docker version

#   https://docs.docker.com/reference/cli/docker/image/ls/
docker image ls

az acr login --name $acrName
docker build -t "$acrName.azurecr.io/foo/nginx:v1" -f Dockerfile .

docker image ls "$acrName.azurecr.io/foo/nginx:v1"

#   https://docs.docker.com/reference/cli/docker/image/push/
docker push "$acrName.azurecr.io/foo/nginx:v1"

az acr repository list --name $acrName --output table
az acr repository show-tags --name $acrName --repository foo/nginx --output table


# 8.) Deploy Azure Container Instance (ACI)
# -----------------------------------------
$acrUsername = az acr credential show --name $acrName --query username -o tsv
$acrPassword = az acr credential show --name $acrName --query "passwords[0].value" -o tsv

#   https://learn.microsoft.com/en-us/cli/azure/container?view=azure-cli-latest#az-container-create
az container create `
   --resource-group $resourceGroupName `
   --name 'aci-hello' `
   --image "$acrName.azurecr.io/foo/nginx:v1" `
   --cpu 1 --memory 1.5 `
   --registry-login-server "$acrName.azurecr.io" `
   --registry-username $acrUsername `
   --registry-password $acrPassword `
   --ip-address Public `
   --ports 80 `
   --os-type Linux

az container show --resource-group $resourceGroupName --name 'aci-hello' --query "{Name:name,IpAddress:ipAddress.ip, State:instanceView.state}" --output table
$ip = az container show --resource-group $resourceGroupName --name 'aci-hello' --query "ipAddress.ip" --output tsv


# 9.) Test ACI
# -------------
# Browser http://$ip
Invoke-WebRequest -Uri http://$ip



# Cleanup
cd ..
rm -r -f foo

docker image rm "$acrName.azurecr.io/foo/nginx:v1"

az container delete --name 'aci-hello' --resource-group $resourceGroupName --yes