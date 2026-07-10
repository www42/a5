# Azure Container Registry (ACR) and Azure Container Instance (ACI)
# =================================================================

# 1.) Login to Azure
# ------------------
az login
az account show


# 2.) Set Region
# ---------------
az policy assignment list --query "[].{Name:name, DisplayName:displayName, Scope:scope}" -o table
az policy assignment show --name "sys.regionrestriction"
az policy assignment show --name "sys.regionrestriction" --query "parameters"
az policy assignment show --name "sys.regionrestriction" --query "parameters.listOfAllowedLocations.value"

$location = 'swedencentral'


# 3.) Create Resource Group
# -------------------------
$resourceGroupName = 'rg-container'
az group create --name $resourceGroupName --location $location

az group list --query "[].{Name:name,Location:location}" --output table


# 4.) Register Azure Resource Provider
# ------------------------------------
az provider register --namespace 'Microsoft.ContainerRegistry'
az provider register --namespace 'Microsoft.ContainerInstance'

az provider show --namespace 'Microsoft.ContainerRegistry' --query "registrationState" --output  tsv
az provider show --namespace 'Microsoft.ContainerInstance' --query "registrationState" --output  tsv


# 5.) Create Azure Container Registry (ACR)
# -----------------------------------------
$acrName = 'timmyacr'
az acr create --name $acrName --resource-group $resourceGroupName --sku Basic --admin-enabled $true

az acr show --name $acrName --query "{Name:name,LoginServer:loginServer,Location:location,AdminUserEnabled:adminUserEnabled}"


# 6.) Create Dockerfile
# ---------------------
# Als 'UTF-8' speichern, nicht 'UTF-8 with BOM'!

mkdir foo
cd foo
echo '<html><h1>Hello Mannheim! Hello Heidelberg!</h1></html>' > index.html
echo FROM nginx > Dockerfile
echo COPY index.html /usr/share/nginx/html >> Dockerfile
dir


# Build Docker Image in Azure
#  ---------------------------
az acr build --image foo/nginx:v1 --registry $acrName --file Dockerfile .
# --> Does not work with Azure for Students :-(


# 7.) Build Docker Image Locally
# ------------------------------
gcm docker
docker version

docker image ls

az acr login --name $acrName
docker build -t "$acrName.azurecr.io/foo/nginx:v1" -f Dockerfile .

docker image ls "$acrName.azurecr.io/foo/nginx:v1"

docker push "$acrName.azurecr.io/foo/nginx:v1"

az acr repository list --name $acrName --output table
az acr repository show-tags --name $acrName --repository foo/nginx --output table


# 8.) Deploy Azure Container Instance (ACI)
# -----------------------------------------
$acrUsername = az acr credential show --name $acrName --query username -o tsv
$acrPassword = az acr credential show --name $acrName --query "passwords[0].value" -o tsv

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
# Browser http://<ip>
Invoke-WebRequest -Uri http://$ip


# Bonus: Pull - Tag - Push
# ------------------------
# Pull any image from Docker Hub https://hub.docker.com/
$image = 'bharathshetty4/supermario'
docker pull $image
docker image ls $image

# Tag image
$repo = 'mario'
$fullTag = "$acrName.azurecr.io/$repo/$image"
docker tag $image $fullTag

# Push image to ACR
az acr login --name $acrName --username $acrUsername --password $acrPassword
docker push $fullTag


# Cleanup
# ----------
cd ..
rm -r -f foo

docker image rm "$acrName.azurecr.io/foo/nginx:v1"

az container delete --name 'aci-hello' --resource-group $resourceGroupName --yes