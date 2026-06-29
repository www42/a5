# Alle Role Assignments in einer RG
Get-AzRoleAssignment -ResourceGroupName "rg-demo-prod"

# Assignments eines bestimmten Users
Get-AzRoleAssignment -SignInName "user@contoso.com"

# Rolle zuweisen (Contributor auf RG-Ebene)
New-AzRoleAssignment`
    -SignInName          "user@contoso.com"`
    -RoleDefinitionName  "Contributor"`
    -ResourceGroupName   "rg-demo-prod"

# Service Principal eine Rolle zuweisen
$sp = Get-AzADServicePrincipal -DisplayName "my-app-sp"

New-AzRoleAssignment`
    -ObjectId            $sp.Id`
    -RoleDefinitionName  "Storage Blob Data Reader"`
    -Scope               "/subscriptions/<sub-id>/resourceGroups/rg-demo-prod"

# Rolle entfernen
Remove-AzRoleAssignment`
    -SignInName         "user@contoso.com"`
    -RoleDefinitionName "Contributor"`
    -ResourceGroupName  "rg-demo-prod"

# Verfügbare Built-in Roles anzeigen
Get-AzRoleDefinition | Select-Object Name, IsCustom | Sort-Object Name