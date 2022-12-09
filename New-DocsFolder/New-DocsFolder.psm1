function New-DocsFolder {
param(
    [Parameter (Mandatory=$true, Position=1)]
    [string]$DocsGroupName
)
#Перевод первого символа в верхний регистр
function ToProperCase ($DocsGroupName) { 
  (Get-Culture).TextInfo.ToTitleCase($DocsGroupName.ToLower()) 
  }

  $DocsGroupName = ToProperCase $DocsGroupName



Write-Host
Write-Host ″Which Share Name″ -BackgroundColor White -ForegroundColor Red
Write-Host
Write-Host ″1. Fs-Cluster01″ -ForegroundColor Green
Write-Host ″2. FS-SPB″ -ForegroundColor Green
Write-Host ″3. Exit″ -ForegroundColor Green
Write-Host
$choice = Read-Host ″Select the menu item″
Switch($choice){
  1{$serverfqdn='msc-fs01.msc.sigma-it.local'}
  2{$serverfqdn='FS-SPB.msc.sigma-it.local'}
  3{Write-Host ″Exit″; exit}
    default {Write-Host ″Wrong choice, try again.″ -ForegroundColor Red}
}
#Обрезание fqdn
$sharename=$serverfqdn.Split('.') -replace 'msc-fs01', 'Fs-Cluster01' | Select-Object -First 1


New-ADGroup -GroupScope DomainLocal -Name "Rights.$sharename.$DocsGroupName.RW" -path 'OU=File,OU=Resources,OU=HQ,DC=msc,DC=sigma-it,DC=local'
New-ADGroup -GroupScope DomainLocal -Name "Rights.$sharename.$DocsGroupName.R" -path 'OU=File,OU=Resources,OU=HQ,DC=msc,DC=sigma-it,DC=local'
New-ADGroup -GroupScope Global -Name "Access.File.$DocsGroupName.RW" -path 'OU=File,OU=Access,OU=HQ,DC=msc,DC=sigma-it,DC=local'
New-ADGroup -GroupScope Global -Name "Access.File.$DocsGroupName.R" -path 'OU=File,OU=Access,OU=HQ,DC=msc,DC=sigma-it,DC=local'

Add-ADGroupMember -Identity "Rights.$sharename.$DocsGroupName.RW" -Members "Access.File.$DocsGroupName.RW"
Add-ADGroupMember -Identity "Rights.$sharename.$DocsGroupName.R" -Members "Access.File.$DocsGroupName.R"

$dir="\\$sharename\work\$DocsGroupName"
mkdir $dir 
<#
#Отключение наследования. Но надо ли? 
$acl=Get-Acl \\$sharename\work\$DocsGroupName 
$acl.SetAccessRuleProtection($true,$true)
$acl | Set-Acl \\$sharename\work\$DocsGroupName 
#>



Add-NTFSAccess -Path $dir  -Account "Rights.$sharename.$DocsGroupName.RW" -AccessRights 'Modify' -PassThru
Add-NTFSAccess -Path $dir  -Account "Rights.$sharename.$DocsGroupName.R" -AccessRights 'Read' -PassThru
Disable-NTFSAccessInheritance -Path \\$sharename\work\$DocsGroupName
}
# SIG # Begin signature block
# MIIImwYJKoZIhvcNAQcCoIIIjDCCCIgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrd2yA9FICf5BcFOr6isuxfXE
# WXKgggXxMIIF7TCCBNWgAwIBAgITdgAAErFuRYTleptK2AABAAASsTANBgkqhkiG
# 9w0BAQsFADBcMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxGDAWBgoJkiaJk/IsZAEZ
# FghzaWdtYS1pdDETMBEGCgmSJomT8ixkARkWA21zYzEUMBIGA1UEAxMLbXNjLUNB
# MDEtQ0EwHhcNMjIwNTAyMDk0NjIxWhcNMjMwNTAyMDk0NjIxWjCBkDEVMBMGCgmS
# JomT8ixkARkWBWxvY2FsMRgwFgYKCZImiZPyLGQBGRYIc2lnbWEtaXQxEzARBgoJ
# kiaJk/IsZAEZFgNtc2MxDzANBgNVBAsTBkFkbWluczE3MDUGA1UEAwwu0J/QtdGC
# 0YDQvtCyINCQ0LvQtdC60YHQtdC5INCu0YDRjNC10LLQuNGHIGFkbTCCASIwDQYJ
# KoZIhvcNAQEBBQADggEPADCCAQoCggEBAK/FIlNoMJ0tPv51uD/Inr+5EWGNLFfe
# qGt7wyqLY+ff2/Dujh9nvm3j9xvblyyxrfvM4n8490VaLoCWyJhBgZuWYGGLn3Ud
# BOe5MwDq8wLd9GSRwDpnUrM87zEMSU5zLAO2AUViOpFl5qyM4TZdFrJpBoTei+aw
# Gt1FVQS1OC/Zz9RREL8CK1Pq54ZDEDwtCIu84VAro1DPjLfTYpjxGZBWh2bZAo8X
# C+vE121jH7idAsnzmABHTUw6phB+On1xdX/TJsYXg6z511txjOzIfOAxkm4ZNtGH
# lZ8XGi9cnBgZLXduO+WRu5hGwW+D57LJetZRGFVycGlneeVA1QX59HUCAwEAAaOC
# AnEwggJtMCUGCSsGAQQBgjcUAgQYHhYAQwBvAGQAZQBTAGkAZwBuAGkAbgBnMBMG
# A1UdJQQMMAoGCCsGAQUFBwMDMA4GA1UdDwEB/wQEAwIHgDAdBgNVHQ4EFgQUI5nU
# bgLdeCGIp6OmBlS3qzErySAwHwYDVR0jBBgwFoAUrz/nvV23brb4pS2TbSSZBCn7
# ytQwgdcGA1UdHwSBzzCBzDCByaCBxqCBw4aBwGxkYXA6Ly8vQ049bXNjLUNBMDEt
# Q0EoMSksQ049U1BCLUNBMDEsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZp
# Y2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9bXNjLERDPXNpZ21h
# LWl0LERDPWxvY2FsP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmpl
# Y3RDbGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludDCBxwYIKwYBBQUHAQEEgbowgbcw
# gbQGCCsGAQUFBzAChoGnbGRhcDovLy9DTj1tc2MtQ0EwMS1DQSxDTj1BSUEsQ049
# UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJh
# dGlvbixEQz1tc2MsREM9c2lnbWEtaXQsREM9bG9jYWw/Y0FDZXJ0aWZpY2F0ZT9i
# YXNlP29iamVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwOwYDVR0RBDQw
# MqAwBgorBgEEAYI3FAIDoCIMIGF5dXBldHJvdi1hZG1AbXNjLnNpZ21hLWl0Lmxv
# Y2FsMA0GCSqGSIb3DQEBCwUAA4IBAQCJPZdEHSfiUaXdx+xQWfc0ZvNjVeZAyhda
# 8q8crtZFslwnsN3ApmLliwBpVAPiRxhnBYiu/y57/npQbSeJvNbTXVgqg1SanUwp
# o3Tmcrc5LVYRlPcD1KwQq3jx+mdyEgPMKNWCz/n3LClDldafhaLVJwMTz6KUAfVz
# 1wZF53oQyTvyKvk1mAu5x596fhkMfrLgh2ZhR8MFNRmfwNnbcSyAZsvBXOswyyIm
# G7mFDUt1e0RYWoDGBVgef7OZSK1bvuFN92X0QeWu8xQ46hUC5/oQvOlK34K0Wny9
# 3pXnfamh8pQR83sWI/oL+dWPJxnBvcxQh95nTFJLqfCEBB/khZlpMYICFDCCAhAC
# AQEwczBcMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxGDAWBgoJkiaJk/IsZAEZFghz
# aWdtYS1pdDETMBEGCgmSJomT8ixkARkWA21zYzEUMBIGA1UEAxMLbXNjLUNBMDEt
# Q0ECE3YAABKxbkWE5XqbStgAAQAAErEwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcC
# AQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYB
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFImVsDH73BRr
# ze7iIVo0BLRU6ODuMA0GCSqGSIb3DQEBAQUABIIBABpYoxfEyhAgjPItwAmDj4/v
# /HTQ4hKgTdSC89QVs6T9EWT9ekLLNXgjXBBfytjo2vXJV94rtZuQS9/uNGwMNtPT
# HMpXMfO3Mqmwj9bW2fkQMYwvd6joh7vitEZEtPgdxlly8HJr9Mwh66YaLPlu4IsV
# c3+2IFjTuim4pgyjyHJtbg8NM+k/po2hRDlPTimTojPifSktPXAW5oPuTJjXjHO9
# uk2uTg8hLWaWwja77cLNgo3nkjIRssO85Ezs3LEeC3o0FPUxihxsBAZcu+4NMb75
# EY5aAboW1hRD2L9mbTaOWUtcWadBG+j69VnUzrTFZWhpvXcRyZG3kYEs4MxN0dA=
# SIG # End signature block
