function get-computersystem {
    Get-CimInstance win32_computersystem | format-table TotalPhysicalMemory, CsProcessors, Manufacturer, CsNetworkAdapters, Model
}


function get-operatingsystem {
    Get-CimInstance win32_operatingsystem | Format-table Name, Version
}

function get-processor {
    Get-CimInstance win32_processor | Format-table Description, MaxClockSpeed, NumberOfCores
}

function get-physicalmemory {
    Get-CimInstance win32_physicalmemory | Format-Table Manufacturer, Description, BankLabel, Capacity
}

function get-networkadapter {
    Get-CimInstance win32_networkadapterconfiguration | where-object ipenabled -eq $True | format-table description, index, ipaddress, ipsubnet, dnsdomain, dnsserversearchorder
}

function get-videocontroller {
   Get-CimInstance win32_videocontroller | format-table VideoProcessor, Description, CurrentHorizontalResolution, CurrentVerticalResolution
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