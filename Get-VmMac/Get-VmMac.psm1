function Get-VmMac {
    param(
    [Parameter (Mandatory=$true, Position=1)]
    [string]$MacAddress,
    [array]$Viserver = @("vc.sigma-it.local", "vc-msc.msc.sigma-it.local", "vc2.sigma-it.local", "vc-msc3.sigma-it.local")
)



$MacAddress=$MacAddress -replace '-',':'

$usr = 'monitor@vsphere.local'
$pas = 'Mixer12#'


Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false | Out-Null
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false | Out-Null

Foreach ($server in $viserver){

    Connect-VIServer -Server $server -Protocol https -User $usr -Password $pas | Out-Null

    $vmNet=Get-VM | Get-NetworkAdapter | Where-Object {$_.MacAddress -eq $MacAddress }
    
    if ($null -ne $vmNet) {

        $VM=Get-VM $vmnet.Parent

        Write-Host "======" -noNewline
        write-host " $server " -foregroundcolor Red -backgroundcolor white -noNewline
        write-host "======"
        $vm | Select-Object @{N='Name';E={$vm.Name}}, @{N='State';E={$vm.PowerState}}, @{N='Sockets';E={$vm.NumCpu}}, @{N='Cores';E={$vm.CoresPerSocket}}, @{N='RAM';E={$vm.MemoryGB}}, @{N='NetworkName';E={$vmNet.NetworkName}},@{N="IP Address";E={@($_.guest.IPAddress[0])}}, @{N='MacAddress';E={$vmNet.MacAddress}}, @{N='Notes';E={$vm.Notes}} 
        Clear-Variable vm,vmnet

    }

    Disconnect-VIServer $server -Confirm:$false | Out-Null
}
}