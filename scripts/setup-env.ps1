$ErrorActionPreference='Stop'
$project=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$api=Join-Path $project 'backend\.env'
if(Test-Path $api){Write-Host 'backend/.env already exists. To change credentials, edit it directly.'; exit 0}
$phone=Read-Host 'Enter initial admin mobile (e.g. 03001234567)'
if($phone -notmatch '^03\d{9}$'){throw 'Please use Pakistani 03XXXXXXXXX format'}
$secure=Read-Host 'Choose a strong admin password (12+ chars)' -AsSecureString
$bstr=[Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
try{$password=[Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)}finally{[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)}
if($password.Length -lt 12){throw 'Admin password must contain at least 12 characters'}
$rnd=New-Object byte[] 64
$rng=[Security.Cryptography.RandomNumberGenerator]::Create()
try{$rng.GetBytes($rnd)}finally{$rng.Dispose()}
$secret=[Convert]::ToBase64String($rnd)
# Avoid leaking generated credentials to version control; backend/.env is gitignored.
$text=@"
PORT=4000
NODE_ENV=development
DATABASE_URL=postgres://hunar:hunar_dev_password@localhost:5432/hunar
JWT_SECRET=$secret
CORS_ORIGINS=http://localhost:3000
ADMIN_PHONE=$phone
ADMIN_PASSWORD=$password
PUBLIC_API_URL=http://localhost:4000
UPLOAD_DIR=uploads
WORKER_EASYPaisa_NUMBER=
WORKER_JAZZCASH_NUMBER=
"@
Set-Content -Path $api -Value $text -Encoding UTF8
$admin=Join-Path $project 'admin\.env.local'
if(!(Test-Path $admin)){Set-Content -Path $admin -Value 'BACKEND_INTERNAL_URL=http://localhost:4000' -Encoding UTF8}
Write-Host 'Environment files created. Keep backend/.env private and change database credentials before deploying publicly.'
