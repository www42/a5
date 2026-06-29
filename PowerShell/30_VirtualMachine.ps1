# Alle VMs in der Subscription
Get-AzVM

# VMs in einer RG mit Status
Get-AzVM -ResourceGroupName "rg-demo-prod" -Status

# VM starten / stoppen / neu starten
Start-AzVM   -ResourceGroupName "rg-demo-prod" -Name "vm-web-01"
Stop-AzVM    -ResourceGroupName "rg-demo-prod" -Name "vm-web-01" -Force
Restart-AzVM -ResourceGroupName "rg-demo-prod" -Name "vm-web-01"

# Einfache Windows-VM erstellen
$vmCred = Get-Credential -Message "VM-Admin-Credentials"

New-AzVM `
    -ResourceGroupName "rg-demo-prod" `
    -Name              "vm-web-01" `
    -Location          "germanywestcentral" `
    -Image             "Win2022Datacenter" `
    -Size              "Standard_B2s" `
    -Credential        $vmCred

# VM-Größe ändern
$vm = Get-AzVM -ResourceGroupName "rg-demo-prod" -Name "vm-web-01"
$vm.HardwareProfile.VmSize = "Standard_B4ms"
Update-AzVM -VM $vm -ResourceGroupName "rg-demo-prod"