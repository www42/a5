# Storage Account erstellen
New-AzStorageAccount `
    -ResourceGroupName  "rg-demo-prod" `
    -Name               "stdemoprod001" `
    -Location           "germanywestcentral" `
    -SkuName            "Standard_LRS" `
    -Kind               "StorageV2" `
    -AllowBlobPublicAccess $false

# Storage-Kontext holen (für Blob-Operationen)
$ctx = (Get-AzStorageAccount `
    -ResourceGroupName "rg-demo-prod" `
    -Name "stdemoprod001").Context

# Container erstellen
New-AzStorageContainer -Name "uploads" -Context $ctx

# Datei hochladen
Set-AzStorageBlobContent `
    -File      "C:\demo\report.pdf" `
    -Container "uploads" `
    -Blob      "reports/report.pdf" `
    -Context   $ctx

# Blobs auflisten
Get-AzStorageBlob -Container "uploads" -Context $ctx

# SAS-Token generieren (1 Stunde gültig)
New-AzStorageContainerSASToken `
    -Name       "uploads" `
    -Permission "rl" `
    -ExpiryTime (Get-Date).AddHours(1) `
    -Context    $ctx