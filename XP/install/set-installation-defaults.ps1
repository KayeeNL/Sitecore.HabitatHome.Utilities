Param(
    [string] $ConfigurationFile = "configuration-xp0.json"
)

Write-Host "Setting Defaults and creating $ConfigurationFile"

$json = Get-Content -Raw .\install-settings.json -Encoding Ascii |  ConvertFrom-Json

Write-host "Setting default 'Assets and prerequisites' parameters"

$assets = $json.assets
$assets.root = "$PSScriptRoot\assets"
$assets.psRepository = "https://sitecore.myget.org/F/sc-powershell/api/v2/"
$assets.psRepositoryName = "SitecoreGallery"
$assets.licenseFilePath = Join-Path $assets.root "license.xml"
$assets.installerVersion = "2.0.0-beta0229"
$assets.sitecoreVersion = "9.1.0 rev. 001320"
$assets.identityServerVersion = "2.0.0 rev. 00128"
$assets.certificatesPath = Join-Path $assets.root "Certificates"
$assets.jreRequiredVersion = "8.0.1710"
$assets.dotnetMinimumVersionValue = "394802"
$assets.dotnetMinimumVersion = "4.7.1"
$assets.installPackagePath = Join-Path $assets.root "installpackage.aspx"

# Settings
Write-Host "Setting default 'Site' parameters"
# Site Settings
$site = $json.settings.site
$site.prefix = "habitathome"
$site.suffix = "dev.local"
$site.webroot = "C:\inetpub\wwwroot"
$site.hostName = $json.settings.site.prefix + "." + $json.settings.site.suffix
$site.enableInstallationImprovements = (Get-ChildItem $pwd -filter "enable-installation-improvements.json" -Recurse).FullName
$site.disableInstallationImprovements = (Get-ChildItem $pwd -filter "disable-installation-improvements.json" -Recurse).FullName
$site.addSiteBindingWithSSLPath = (Get-ChildItem $pwd -filter "add-new-binding-and-certificate.json" -Recurse).FullName
$site.configureSearchIndexes = (Get-ChildItem $pwd -filter "configure-search-indexes.json" -Recurse).FullName
$site.habitatHomeSslCertificateName = $site.prefix + "." + $site.suffix

Write-Host "Setting default 'SQL' parameters"
$sql = $json.settings.sql
# SQL Settings

$SqlStrongPassword = "Str0NgPA33w0rd!!" # Used for all other services

$sql.server = "."
$sql.adminUser = "sa"
$sql.adminPassword = "12345"
$sql.coreUser = $site.prefix + "coreuser"
$sql.corePassword = $SqlStrongPassword
$sql.masterUser = $site.prefix + "masteruser"
$sql.masterPassword = $SqlStrongPassword
$sql.webUser = $site.prefix + "webuser"
$sql.webPassword = $SqlStrongPassword
$sql.collectionUser = $site.prefix + "collectionuser"
$sql.collectionPassword = $SqlStrongPassword
$sql.reportingUser = $site.prefix + "reportinguser"
$sql.reportingPassword = $SqlStrongPassword
$sql.processingPoolsUser = $site.prefix + "poolsuser"
$sql.processingPoolsPassword = $SqlStrongPassword
$sql.processingEngineUser = $site.prefix + "processingengineuser"
$sql.processingEnginePassword = $SqlStrongPassword
$sql.processingTasksUser = $site.prefix + "tasksuser"
$sql.processingTasksPassword = $SqlStrongPassword
$sql.referenceDataUser = $site.prefix + "referencedatauser"
$sql.referenceDataPassword = $SqlStrongPassword
$sql.marketingAutomationUser = $site.prefix + "marketingautomationuser"
$sql.marketingAutomationPassword = $SqlStrongPassword
$sql.formsUser = $site.prefix + "formsuser"
$sql.formsPassword = $SqlStrongPassword
$sql.exmMasterUser = $site.prefix + "exmmasteruser"
$sql.exmMasterPassword = $SqlStrongPassword
$sql.messagingUser = $site.prefix + "messaginguser"
$sql.messagingPassword = $SqlStrongPassword
$sql.minimumVersion = "13.0.4001"

Write-Host "Setting default 'xConnect' parameters"
# XConnect Parameters
$xConnect = $json.settings.xConnect
$xConnect.ConfigurationPath = (Get-ChildItem $pwd -filter "xconnect-xp0.json" -Recurse).FullName
$xConnect.certificateConfigurationPath = (Get-ChildItem $pwd -filter "xconnect-createcert.json" -Recurse).FullName
$xConnect.solrConfigurationPath = (Get-ChildItem $pwd -filter "xconnect-solr.json" -Recurse).FullName
$xConnect.packagePath = Join-Path $assets.root $("Sitecore " + $assets.sitecoreVersion + " (OnPrem)_xp0xconnect.scwdp.zip")
$xConnect.siteName = $site.prefix + "_xconnect." + $site.suffix
$xConnect.certificateName = [string]::Join(".", @($site.prefix, $site.suffix, "xConnect.Client"))
$xConnect.siteRoot = Join-Path $site.webRoot -ChildPath $xConnect.siteName


Write-Host "Setting default 'Sitecore' parameters"
# Sitecore Parameters
$sitecore = $json.settings.sitecore
$sitecore.solrConfigurationPath = (Get-ChildItem $pwd -filter "sitecore-solr.json" -Recurse).FullName
$sitecore.configurationPath = (Get-ChildItem $pwd -filter "sitecore-xp0.json" -Recurse).FullName
$sitecore.sslConfigurationPath = "$PSScriptRoot\certificates\sitecore-ssl.json"
$sitecore.packagePath = Join-Path $assets.root $("Sitecore " + $assets.sitecoreVersion + " (OnPrem)_single.scwdp.zip")
$sitecore.siteRoot = Join-Path $site.webRoot -ChildPath $site.hostName
$sitecore.adminPassword = "b"
$sitecore.exmCryptographicKey = "0x0000000000000000000000000000000000000000000000000000000000000000"
$sitecore.exmAuthenticationKey = "0x0000000000000000000000000000000000000000000000000000000000000000"
$sitecore.telerikEncryptionKey = "PutYourCustomEncryptionKeyHereFrom32To256CharactersLong"
Write-Host "Setting default 'IdentityServer' parameters"
$identityServer = $json.settings.identityServer
$identityServer.packagePath = Join-Path $assets.root $("Sitecore.IdentityServer " + $assets.identityServerVersion + " (OnPrem)_identityserver.scwdp.zip")
$identityServer.configurationPath = (Get-ChildItem $pwd -filter "IdentityServer.json" -Recurse).FullName 
$identityServer.name = "IdentityServer." + $site.hostname
$identityServer.url = ("https://{0}" -f $identityServer.name)
$identityServer.clientSecret = "ClientSecret"
Write-Host "Setting default 'Solr' parameters"
# Solr Parameters
$solr = $json.settings.solr
$solr.url = "https://localhost:8721	/solr"
$solr.root = "c:\solr"
$solr.serviceName = "Solr"

Write-Host "Setting default 'modules' parameters"
# Modules
$modulesConfig = Get-Content -Raw .\assets.json -Encoding Ascii |  ConvertFrom-Json

$modules = $json.modules

$sitecore = $modulesConfig.sitecore

$config = @{
    id          = $sitecore.id
    name        = $sitecore.name
    packagePath = Join-Path $assets.root ("\{0}" -f $sitecore.fileName) 
    url         = $sitecore.url
    extract     = $sitecore.extract
    download    = $sitecore.download
    source      = $sitecore.source
}

$config = $config| ConvertTo-Json

$modules += (ConvertFrom-Json -InputObject $config) 
$config = @{}
foreach ($module in $modulesConfig.modules) {
    $config = @{
        id          = $module.id
        name        = $module.name
        packagePath = Join-Path $assets.root ("packages\{0}" -f $module.fileName) 
        url         = $module.url
        install     = $module.install
        download    = $module.download
        source      = $module.source
    } 
    $config = $config| ConvertTo-Json

    $modules += (ConvertFrom-Json -InputObject $config) 
    $config=@{}
}
$json.modules = $modules

Write-Host ("Saving Configuration file to {0}" -f $ConfigurationFile)

Set-Content $ConfigurationFile  (ConvertTo-Json -InputObject $json -Depth 3 )