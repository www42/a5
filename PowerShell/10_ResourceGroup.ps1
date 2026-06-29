# Alle Resource Groups (RGs) auflisten
Get-AzResourceGroup

# Neue RG erstellen
New-AzResourceGroup -Name "rg-demo-prod" -Location "germanywestcentral"

# RG nach Name filtern
Get-AzResourceGroup -Name "rg-demo-*"

# Alle Ressourcen in einer RG
Get-AzResource -ResourceGroupName "rg-demo-prod"

# RG löschen (mit Bestätigungsdialog)
Remove-AzResourceGroup -Name "rg-demo-prod"

# Ohne Bestätigung (z. B. im Skript)
Remove-AzResourceGroup -Name "rg-demo-prod" -Force -AsJob