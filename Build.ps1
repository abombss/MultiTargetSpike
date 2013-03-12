Param(
  [ValidateSet('Debug','Release')]
  [string[]]$Configuration=@('Debug'),

  [ValidateSet('Net45','Net40','Net35')]
  [string[]]$Platforms=@('Net45','Net40','Net35'),

  [string]$Version='1.0.0-alpha-0001-build-00001',

  [switch]$DisablePackaging=$false,

  [ValidateSet('quiet','normal','detailed','diagnostic')]
  [string]$Verbosity='normal',

  [ValidateSet('Clean','Build','Rebuild')]
  [string[]]$Targets='Build',

  [string]$BaseOutDir = (Join-Path $pwd 'Binaries')
)

$Configuration | 
  %{ $config = $_; ( $Platforms | 
    % { & msbuild /p:Configuration=$config /p:Platform=$_ /p:OutDir="$BaseOutDir\$config\$_\" /t:$(Join-String $Targets -Separator ',') /verbosity:$Verbosity } 
  ); 
  if (-not $DisablePackaging) { &msbuild /p:Configuration=$config /p:Platform=Package /p:OutDir="$BaseOutDir\$config\Package\" /t:$(Join-String $Targets -Separator ',') /verbosity:$Verbosity }
}
