# ---------------------------------------------------------------------------
# Author: Keith Hill
# Desc:   Prompt, colors and host window title updates suited to UAC enabled
#         Windows Vista and Windows 7.  Elevated (admin) prompts are easy
#         distinguish from non-elevated prompts.
# Date:   Nov 07, 2009
# Site:   http://pscx.codeplex.com
# Usage:  In your options hashtable place the following setting:
#
#         PromptTheme = 'Modern'
# ---------------------------------------------------------------------------
#requires -Version 3
param([hashtable]$Theme)

Set-StrictMode -Version Latest

# ---------------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------------
$Theme.HostBackgroundColor   = if ($Pscx:IsAdmin) { 'DarkRed' } else { 'Black' }
$Theme.HostForegroundColor   = if ($Pscx:IsAdmin) { 'White'   } else { 'Cyan'  }
$Theme.PromptForegroundColor = if ($Pscx:IsAdmin) { 'Gray'    } else { 'White' }

# ---------------------------------------------------------------------------
# Prompt ScriptBlock
# ---------------------------------------------------------------------------
$Theme.PromptScriptBlock = {
    param($Id) 
    
    if ($NestedPromptLevel) {
        new-object string ([char]0xB7), $NestedPromptLevel
    }
    
    $sepChar = '>' # [char]0xBB
    if ($Pscx:IsAdmin) {
        $sepChar = '#'
    }
    
    $path = ''    
    "${Id}$path$sepChar"
}

# ---------------------------------------------------------------------------
# Window Title Update ScriptBlock
# ---------------------------------------------------------------------------
$Theme.UpdateWindowTitleScriptBlock = {
    $adminPrefix = ''
    if ($Pscx:IsAdmin) {
        $adminPrefix = 'Admin'
    }
    $location = Get-Location
    $version = $PSVersionTable.PSVersion
    
    $bitness = ''
    if ([IntPtr]::Size -eq 8) {
        $bitness = ' (x64)'
    }
    elseif ($Pscx:IsWow64Process) {
        $bitness = ' (x86)'
    }
    
    "$adminPrefix $location - Windows PowerShell $version$bitness"
}

# ---------------------------------------------------------------------------
# Startup Message ScriptBlock
# ---------------------------------------------------------------------------
$Theme.StartupMessageScriptBlock = {
    $logo = "Windows PowerShell $($PSVersionTable.PSVersion)"
    if ([IntPtr]::Size -eq 8) {
        $logo += ' (x64)'
    }
    elseif ($Pscx:IsWow64Process)
    {
        $logo += ' (x86)'
    }
    $logo
    
    $user =	"`nLogged in on $([DateTime]::Now.ToString((Get-Culture))) as $($Pscx:WindowsIdentity.Name)"
    
    if ($Pscx:IsAdmin) { 
        $user += ' (Elevated).' 
    }
    else { 
        $user += '.' 
    }
    
    $user
}
# SIG # Begin signature block
# MIIccgYJKoZIhvcNAQcCoIIcYzCCHF8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUuE6HU1EoDZbCKke9CjKjLrEd
# OUigghehMIIFKjCCBBKgAwIBAgIQBLQS3h09OUqqdSKUe3ftPjANBgkqhkiG9w0B
# AQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMB4XDTE2MTAxMjAwMDAwMFoXDTE5MTAx
# NzEyMDAwMFowZzELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNPMRUwEwYDVQQHEwxG
# b3J0IENvbGxpbnMxGTAXBgNVBAoTEDZMNiBTb2Z0d2FyZSBMTEMxGTAXBgNVBAMT
# EDZMNiBTb2Z0d2FyZSBMTEMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDDHT8E4dIiat1nGhayMJznISOTlfF48p2a7FNvIFG2ccoScZXJj53TmVkAF74J
# vFNld8ooNVig5BoqeO/Qq6MogKGLBl2gIaruHYwgll79z6aIsRJc6e9TjacIJZtr
# AUGGBg+5hl9fDygpfLQ3x0xEyTPbKcpDimc9MB5LSgclOwLXZflaEVqHvtHFDd3H
# FmuMtSS3ryhH8DrTglZNjYSbYTDBKVfq+J40Vzs5qhS86NiO2bZb+YVMQpDoZ6Yd
# EgXlOE6t4BHRoNX2r1VvnlUpwUnanRLkpGSq9nWmZF/YIUM13Zv7ceLwtnh8KrxI
# kaRr0kmYcJfv69kBI6e2Ezf5AgMBAAGjggHFMIIBwTAfBgNVHSMEGDAWgBRaxLl7
# KgqjpepxA8Bg+S32ZXUOWDAdBgNVHQ4EFgQU3UkpEeo3RgECtRdGHPkvZ6VK9PMw
# DgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGA1UdHwRwMG4w
# NaAzoDGGL2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3VyZWQtY3Mt
# ZzEuY3JsMDWgM6Axhi9odHRwOi8vY3JsNC5kaWdpY2VydC5jb20vc2hhMi1hc3N1
# cmVkLWNzLWcxLmNybDBMBgNVHSAERTBDMDcGCWCGSAGG/WwDATAqMCgGCCsGAQUF
# BwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAgGBmeBDAEEATCBhAYI
# KwYBBQUHAQEEeDB2MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
# b20wTgYIKwYBBQUHMAKGQmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydFNIQTJBc3N1cmVkSURDb2RlU2lnbmluZ0NBLmNydDAMBgNVHRMBAf8EAjAA
# MA0GCSqGSIb3DQEBCwUAA4IBAQB7bGUp27a8g3rslXsg8vJ5kSdoay0XAiJqRlZW
# J7yN89iw9Pf+KJaApRaGnG/DPpNz/KFDm3XOSeimCDAxWfJJiUjpClZGOA06BYUg
# +UmF1/3AuTkUaFPig5ZgwabS9Cc3JKg1ue6kHFYerTncA1Axcw/TkVemZayUdi1w
# gfMz01YYQ1Dr0LormXLC3br4kxlYY3vWmBMSgjYgiTNH+FkEMOcFEDFgGXLKUpyS
# tr2G+1UPgGhlNf4b/51Ul736M5L+tbkLYp4rO7WG5ojb+HOMHwEm/YiaK1V5QBii
# mQYYY7RQJ34sRORnWDH2MJbvrTNoQQoaDgT2u2bAaEc6RKYBMIIFMDCCBBigAwIB
# AgIQBAkYG1/Vu2Z1U0O1b5VQCDANBgkqhkiG9w0BAQsFADBlMQswCQYDVQQGEwJV
# UzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQu
# Y29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcNMTMx
# MDIyMTIwMDAwWhcNMjgxMDIyMTIwMDAwWjByMQswCQYDVQQGEwJVUzEVMBMGA1UE
# ChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYD
# VQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMIIB
# IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA+NOzHH8OEa9ndwfTCzFJGc/Q
# +0WZsTrbRPV/5aid2zLXcep2nQUut4/6kkPApfmJ1DcZ17aq8JyGpdglrA55KDp+
# 6dFn08b7KSfH03sjlOSRI5aQd4L5oYQjZhJUM1B0sSgmuyRpwsJS8hRniolF1C2h
# o+mILCCVrhxKhwjfDPXiTWAYvqrEsq5wMWYzcT6scKKrzn/pfMuSoeU7MRzP6vIK
# 5Fe7SrXpdOYr/mzLfnQ5Ng2Q7+S1TqSp6moKq4TzrGdOtcT3jNEgJSPrCGQ+UpbB
# 8g8S9MWOD8Gi6CxR93O8vYWxYoNzQYIH5DiLanMg0A9kczyen6Yzqf0Z3yWT0QID
# AQABo4IBzTCCAckwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYw
# EwYDVR0lBAwwCgYIKwYBBQUHAwMweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzAB
# hhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9j
# YWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQw
# gYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2lj
# ZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwTwYDVR0gBEgwRjA4
# BgpghkgBhv1sAAIEMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0
# LmNvbS9DUFMwCgYIYIZIAYb9bAMwHQYDVR0OBBYEFFrEuXsqCqOl6nEDwGD5LfZl
# dQ5YMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEB
# CwUAA4IBAQA+7A1aJLPzItEVyCx8JSl2qB1dHC06GsTvMGHXfgtg/cM9D8Svi/3v
# Kt8gVTew4fbRknUPUbRupY5a4l4kgU4QpO4/cY5jDhNLrddfRHnzNhQGivecRk5c
# /5CxGwcOkRX7uq+1UcKNJK4kxscnKqEpKBo6cSgCPC6Ro8AlEeKcFEehemhor5un
# XCBc2XGxDI+7qPjFEmifz0DLQESlE/DmZAwlCEIysjaKJAL+L3J+HNdJRZboWR3p
# +nRka7LrZkPas7CM1ekN3fYBIM6ZMWM9CBoYs4GbT8aTEAb8B4H6i9r5gkn3Ym6h
# U/oSlBiFLpKR6mhsRDKyZqHnGKSaZFHvMIIGajCCBVKgAwIBAgIQAwGaAjr/WLFr
# 1tXq5hfwZjANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMM
# RGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQD
# ExhEaWdpQ2VydCBBc3N1cmVkIElEIENBLTEwHhcNMTQxMDIyMDAwMDAwWhcNMjQx
# MDIyMDAwMDAwWjBHMQswCQYDVQQGEwJVUzERMA8GA1UEChMIRGlnaUNlcnQxJTAj
# BgNVBAMTHERpZ2lDZXJ0IFRpbWVzdGFtcCBSZXNwb25kZXIwggEiMA0GCSqGSIb3
# DQEBAQUAA4IBDwAwggEKAoIBAQCjZF38fLPggjXg4PbGKuZJdTvMbuBTqZ8fZFnm
# fGt/a4ydVfiS457VWmNbAklQ2YPOb2bu3cuF6V+l+dSHdIhEOxnJ5fWRn8YUOawk
# 6qhLLJGJzF4o9GS2ULf1ErNzlgpno75hn67z/RJ4dQ6mWxT9RSOOhkRVfRiGBYxV
# h3lIRvfKDo2n3k5f4qi2LVkCYYhhchhoubh87ubnNC8xd4EwH7s2AY3vJ+P3mvBM
# MWSN4+v6GYeofs/sjAw2W3rBerh4x8kGLkYQyI3oBGDbvHN0+k7Y/qpA8bLOcEaD
# 6dpAoVk62RUJV5lWMJPzyWHM0AjMa+xiQpGsAsDvpPCJEY93AgMBAAGjggM1MIID
# MTAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggr
# BgEFBQcDCDCCAb8GA1UdIASCAbYwggGyMIIBoQYJYIZIAYb9bAcBMIIBkjAoBggr
# BgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzCCAWQGCCsGAQUF
# BwICMIIBVh6CAVIAQQBuAHkAIAB1AHMAZQAgAG8AZgAgAHQAaABpAHMAIABDAGUA
# cgB0AGkAZgBpAGMAYQB0AGUAIABjAG8AbgBzAHQAaQB0AHUAdABlAHMAIABhAGMA
# YwBlAHAAdABhAG4AYwBlACAAbwBmACAAdABoAGUAIABEAGkAZwBpAEMAZQByAHQA
# IABDAFAALwBDAFAAUwAgAGEAbgBkACAAdABoAGUAIABSAGUAbAB5AGkAbgBnACAA
# UABhAHIAdAB5ACAAQQBnAHIAZQBlAG0AZQBuAHQAIAB3AGgAaQBjAGgAIABsAGkA
# bQBpAHQAIABsAGkAYQBiAGkAbABpAHQAeQAgAGEAbgBkACAAYQByAGUAIABpAG4A
# YwBvAHIAcABvAHIAYQB0AGUAZAAgAGgAZQByAGUAaQBuACAAYgB5ACAAcgBlAGYA
# ZQByAGUAbgBjAGUALjALBglghkgBhv1sAxUwHwYDVR0jBBgwFoAUFQASKxOYspkH
# 7R7for5XDStnAs0wHQYDVR0OBBYEFGFaTSS2STKdSip5GoNL9B6Jwcp9MH0GA1Ud
# HwR2MHQwOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
# c3VyZWRJRENBLTEuY3JsMDigNqA0hjJodHRwOi8vY3JsNC5kaWdpY2VydC5jb20v
# RGlnaUNlcnRBc3N1cmVkSURDQS0xLmNybDB3BggrBgEFBQcBAQRrMGkwJAYIKwYB
# BQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0
# cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEQ0EtMS5j
# cnQwDQYJKoZIhvcNAQEFBQADggEBAJ0lfhszTbImgVybhs4jIA+Ah+WI//+x1Gos
# Me06FxlxF82pG7xaFjkAneNshORaQPveBgGMN/qbsZ0kfv4gpFetW7easGAm6mlX
# IV00Lx9xsIOUGQVrNZAQoHuXx/Y/5+IRQaa9YtnwJz04HShvOlIJ8OxwYtNiS7Dg
# c6aSwNOOMdgv420XEwbu5AO2FKvzj0OncZ0h3RTKFV2SQdr5D4HRmXQNJsQOfxu1
# 9aDxxncGKBXp2JPlVRbwuwqrHNtcSCdmyKOLChzlldquxC5ZoGHd2vNtomHpigtt
# 7BIYvfdVVEADkitrwlHCCkivsNRu4PQUCjob4489yq9qjXvc2EQwggbNMIIFtaAD
# AgECAhAG/fkDlgOt6gAK6z8nu7obMA0GCSqGSIb3DQEBBQUAMGUxCzAJBgNVBAYT
# AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2Vy
# dC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0w
# NjExMTAwMDAwMDBaFw0yMTExMTAwMDAwMDBaMGIxCzAJBgNVBAYTAlVTMRUwEwYD
# VQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAf
# BgNVBAMTGERpZ2lDZXJ0IEFzc3VyZWQgSUQgQ0EtMTCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAOiCLZn5ysJClaWAc0Bw0p5WVFypxNJBBo/JM/xNRZFc
# gZ/tLJz4FlnfnrUkFcKYubR3SdyJxArar8tea+2tsHEx6886QAxGTZPsi3o2CAOr
# DDT+GEmC/sfHMUiAfB6iD5IOUMnGh+s2P9gww/+m9/uizW9zI/6sVgWQ8DIhFonG
# cIj5BZd9o8dD3QLoOz3tsUGj7T++25VIxO4es/K8DCuZ0MZdEkKB4YNugnM/JksU
# kK5ZZgrEjb7SzgaurYRvSISbT0C58Uzyr5j79s5AXVz2qPEvr+yJIvJrGGWxwXOt
# 1/HYzx4KdFxCuGh+t9V3CidWfA9ipD8yFGCV/QcEogkCAwEAAaOCA3owggN2MA4G
# A1UdDwEB/wQEAwIBhjA7BgNVHSUENDAyBggrBgEFBQcDAQYIKwYBBQUHAwIGCCsG
# AQUFBwMDBggrBgEFBQcDBAYIKwYBBQUHAwgwggHSBgNVHSAEggHJMIIBxTCCAbQG
# CmCGSAGG/WwAAQQwggGkMDoGCCsGAQUFBwIBFi5odHRwOi8vd3d3LmRpZ2ljZXJ0
# LmNvbS9zc2wtY3BzLXJlcG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUHAgIwggFWHoIB
# UgBBAG4AeQAgAHUAcwBlACAAbwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkA
# YwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEA
# bgBjAGUAIABvAGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMA
# UABTACAAYQBuAGQAIAB0AGgAZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkA
# IABBAGcAcgBlAGUAbQBlAG4AdAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwA
# aQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8A
# cgBhAHQAZQBkACAAaABlAHIAZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMA
# ZQAuMAsGCWCGSAGG/WwDFTASBgNVHRMBAf8ECDAGAQH/AgEAMHkGCCsGAQUFBwEB
# BG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsG
# AQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
# cmVkSURSb290Q0EuY3J0MIGBBgNVHR8EejB4MDqgOKA2hjRodHRwOi8vY3JsMy5k
# aWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3JsMDqgOKA2hjRo
# dHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
# Y3JsMB0GA1UdDgQWBBQVABIrE5iymQftHt+ivlcNK2cCzTAfBgNVHSMEGDAWgBRF
# 66Kv9JLLgjEtUYunpyGd823IDzANBgkqhkiG9w0BAQUFAAOCAQEARlA+ybcoJKc4
# HbZbKa9Sz1LpMUerVlx71Q0LQbPv7HUfdDjyslxhopyVw1Dkgrkj0bo6hnKtOHis
# dV0XFzRyR4WUVtHruzaEd8wkpfMEGVWp5+Pnq2LN+4stkMLA0rWUvV5PsQXSDj0a
# qRRbpoYxYqioM+SbOafE9c4deHaUJXPkKqvPnHZL7V/CSxbkS3BMAIke/MV5vEwS
# V/5f4R68Al2o/vsHOE8Nxl2RuQ9nRc3Wg+3nkg2NsWmMT/tZ4CMP0qquAHzunEIO
# z5HXJ7cW7g/DvXwKoO4sCFWFIrjrGBpN/CohrUkxg0eVd3HcsRtLSxwQnHcUwZ1P
# L1qVCCkQJjGCBDswggQ3AgEBMIGGMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxE
# aWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMT
# KERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBDb2RlIFNpZ25pbmcgQ0ECEAS0Et4d
# PTlKqnUilHt37T4wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKEC
# gAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwG
# CisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFABgJ0/aIBZPgJ276zVIkvMxw/vM
# MA0GCSqGSIb3DQEBAQUABIIBAHs5Pru8MZNAvWXU57tWWz3W2KnB2A2rj54VeALt
# dAKmfsIXJVCusIlnU4waJ/vDumTzYjLa+kDaUyM851leXSMEMjsWfcLvWivE+gIi
# EU/xx1hmy+OLq2mpPh5FvYoiVo8Urc8+H/r8rShXS9entBE6anzvZo0HmbSh76p/
# hunqNhM+tzSFhvZIXhPaIluCIm54p0cGYkni6uBImxihTFhej/rBYcXu/l8DD2HV
# 9EB6QbEXAonf029bZsYV6Bu3vIm90TzBOE0WNlaOd+gBDsApcSOWxa+YqjbG9DbT
# 4Nwb6OO0NNPeVvpXnOHG3laEQwhJ25zT9mAjlscLE5W4ePahggIPMIICCwYJKoZI
# hvcNAQkGMYIB/DCCAfgCAQEwdjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGln
# aUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhE
# aWdpQ2VydCBBc3N1cmVkIElEIENBLTECEAMBmgI6/1ixa9bV6uYX8GYwCQYFKw4D
# AhoFAKBdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8X
# DTE4MDExNzAyNDY0MFowIwYJKoZIhvcNAQkEMRYEFCUTFTJtDAZUbVD/SvHv/0Sq
# PY2AMA0GCSqGSIb3DQEBAQUABIIBAJCk8yKGtIecy7l3BR9eKgsjNfVHZd4Amoq3
# dmBh1SXj7F/6AkOm5G+1SKtWbJgA8Ta613dglnPJGfqlNejZPcajGTF57U0+ylBR
# OKKGNNDQNa7HdpldWevwNRaS26bLbWZpD9n3vqh6iGW+iZXM1GKSkxUWajPlmozs
# kbLVXyNO4RZZLPgZSyyqf2k92aLzaUFQhYiozRd9HUpafY6pcgl8CGzRyAjR7gL/
# nNp2fpxtAuk6DEYEvwM9nDZv73ALYJWUsQ/dazJUQVgEQdJYWy1QrBsTystT4Fvl
# zXFRPy7xO2/o8av3G7dcAbZRq09JW3KzkLpZhGg8FOnAxYI5cTQ=
# SIG # End signature block
