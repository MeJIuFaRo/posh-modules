function SignFile {
    param(
    [Parameter (Mandatory=$true, Position=1)]
    [string]$Path
)
    
$cert = (Get-ChildItem cert:\CurrentUser\my -CodeSigningCert)[0] #### 0-значит первый сертификат из списка

Set-AuthenticodeSignature -Certificate $cert -FilePath (Get-ChildItem $Path)

}
