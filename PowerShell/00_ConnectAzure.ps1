# Standard-Login — öffnet Login-Fenster (kann verdeckt sein)
Connect-AzAccount

# Bestimmten Tenant angeben
Connect-AzAccount -TenantId "00000000-0000-0000-0000-000000000000"

# Subscription wechseln
Set-AzContext -SubscriptionId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Aktuellen Kontext prüfen
Get-AzContext