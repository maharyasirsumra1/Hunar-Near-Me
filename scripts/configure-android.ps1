$ErrorActionPreference = 'Stop'
$root = Join-Path $PSScriptRoot '..\flutter_app\android\app\src'
$main = Join-Path $root 'main\AndroidManifest.xml'
if (!(Test-Path $main)) { throw "Flutter Android project missing. Run flutter create first." }
$xml = Get-Content -Raw $main
$perms = @('android.permission.INTERNET','android.permission.ACCESS_FINE_LOCATION','android.permission.ACCESS_COARSE_LOCATION','android.permission.RECORD_AUDIO')
foreach($p in $perms){
  if(!$xml.Contains($p)){
    $xml = $xml.Replace('<application', "<uses-permission android:name=`"$p`" />`r`n    <application")
  }
}
Set-Content $main -Value $xml -Encoding UTF8
$debugDir = Join-Path $root 'debug'
New-Item -ItemType Directory -Force $debugDir | Out-Null
$debugManifest = @'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <application android:usesCleartextTraffic="true" />
</manifest>
'@
Set-Content (Join-Path $debugDir 'AndroidManifest.xml') -Value $debugManifest -Encoding UTF8
Write-Host 'Added Internet/GPS/microphone permissions; enabled HTTP only for DEBUG builds.'
