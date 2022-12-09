function Convert-PFX {
    param(
    [Parameter (Mandatory=$true, Position=1)]
    [string]$PathPfx,
    [string]$Passwd
)

$Pathcrt=$PathPfx.Replace('pfx','crt')
$Pathkey=$PathPfx.Replace('pfx','key')
openssl pkcs12 -in $PathPfx -clcerts -nokeys -out $Pathcrt -passin pass:$Passwd -passout pass:$Passwd
openssl pkcs12 -in $PathPfx -nocerts -out $Pathkey -passin pass:$Passwd -passout pass:$Passwd
openssl rsa -in $Pathkey -out $Pathkey -passin pass:$Passwd
}