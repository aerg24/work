$myVMs = Get-VM -Location s10_clu3
$VMsWithSnaps = @()
foreach ($vm in $myVMs) {
    $vmView = $vm | Get-View
    if ($vmView.snapshot -ne $null) {
        Write-Host "VM $vm has a snapshot"
        $SnapshotEvents = Get-VIEvent -Entity $vm -type info -MaxSamples 1000 | Where { 
            $_.FullFormattedMessage.contains("Create virtual machine snapshot")}
        try {
        $user = $SnapshotEvents[0].UserName
        $time = $SnapshotEvents[0].CreatedTime
        } catch [System.Exception] {
            $user = $SnapshotEvents.UserName
            $time = $SnapshotEvents.CreatedTime
        }
        $VMInfo = “” | Select "VM","CreationDate","User"
        $VMInfo."VM" = $vm.Name
        $VMInfo."CreationDate" = $time
        $VMInfo."User" = $user
        $VMsWithSnaps += $VMInfo
    }
}
$VMsWithSnaps | Sort CreationDate
