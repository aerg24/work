#Скрипт для миграции диска SCSI 0:1 машин из папки $folder на хранилище $datastore и замены Storage Policy  на $policy
$datastore = Get-Datastore -Name 'napfas6250-2-vol1'
$folder = get-folder -Type VM -Name 'SRV3-R780-CL514'
$policy = Get-SpbmStoragePolicy -Name 'USER'

$vms = Get-VM -Location $folder |Where {$_.Name -Notlike "Edge-*"}

foreach ($vm in $vms) {
    $hd = Get-HardDisk $vm | Where-Object {$_.ExtensionData.UnitNumber -eq "1"}
    if($hd){
        Write-Host $vm.Name, $hd.Name, $hd.Filename
	   move-HardDisk -HardDisk $hd -Datastore $datastore -StorageFormat Thin -Confirm:$false 
	   Set-SpbmEntityConfiguration $hd -StoragePolicy $policy
	   Get-SpbmEntityConfiguration $vm, $hd
    }
}
