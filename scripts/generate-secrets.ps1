# Generate ENCRYPTION_KEY for Twenty CRM
$bytes = New-Object byte[] 32
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
$key = [Convert]::ToBase64String($bytes)
Write-Host "ENCRYPTION_KEY=$key"
Write-Host ""
Write-Host "Add this to Render env vars and keep it secret."
