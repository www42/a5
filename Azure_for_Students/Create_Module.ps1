$moduleName = 'MyAzure'
$moduleRoot = $env:PSModulePath.Split(';')[0]
$moduleFile = "$moduleRoot/$moduleName/$moduleName.psm1"
New-Item -ItemType File -Path $moduleFile -Force
code $moduleFile