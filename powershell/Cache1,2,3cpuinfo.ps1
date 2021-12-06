function get-computersystem {
    Get-CimInstance win32_computersystem | format-table TotalPhysicalMemory, CsProcessors, Manufacturer, CsNetworkAdapters, Model
}


function get-operatingsystem {
    Get-CimInstance win32_operatingsystem | Format-tabel OsName, OsVersion
}




function get-diskreport {
    $diskdrives = Get-CIMInstance CIM_diskdrive

$mydrives = foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Model=$disk.Model
                                                               "Drive Size (GB)"=$disk.Size / 1gb -as [int]
                                                               Location=$partition.deviceid
                                                               "Drive Letter"=$logicaldisk.deviceid
                                                               "Free(GB)"=$logicaldisk.FreeSpace / 1gb -as [int]
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               "PercentFree"=$logicaldisk.freespace * 100 / $logicaldisk.size -as [int]
                                                               }
           }
      }
  }
  $mydrives | format-table Location, Manufacturer, Model, "Drive Size (GB)", "Drive Letter", "Size(GB)", "Free(GB)", "Percentfree"

  }
  get-diskreport