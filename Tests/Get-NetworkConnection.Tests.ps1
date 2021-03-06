$here = (Split-Path -Parent $MyInvocation.MyCommand.Path)

# Import the module.
Import-Module "$($here)\..\NetworkConnection\lib\Kaguwa.Commands.Network.dll"

Describe "Get-NetworkConnection" {

    Context "Call without parameters" {

        It "Should return a list of NetworkConnection objects" {
            $connections = Get-NetworkConnection
            $connections[0].GetType().Name | Should Be "NetworkConnection"
        }

    }

    Context "Properties" {

        It "Should have have property 'Protocol'" {
            $connections = Get-NetworkConnection
            $connections[0].PSObject.Properties.Match("Protocol").Count | Should Be 1
        }

        It "Should have have property 'LocalAddress'" {
            $connections = Get-NetworkConnection
            $connections[0].PSObject.Properties.Match("LocalAddress").Count | Should Be 1
        }

        It "Should have have property 'LocalPort'" {
            $connections = Get-NetworkConnection
            $connections[0].PSObject.Properties.Match("LocalPort").Count | Should Be 1
        }

        It "Should have have property 'RemoteAddress'" {
            $connections = Get-NetworkConnection
            $connections[0].PSObject.Properties.Match("RemoteAddress").Count | Should Be 1
        }

        It "Should have have property 'RemotePort'" {
            $connections = Get-NetworkConnection
            $connections[0].PSObject.Properties.Match("RemotePort").Count | Should Be 1
        }

        It "Should have have property 'State'" {
            $connections = Get-NetworkConnection
            $connections[0].PSObject.Properties.Match("State").Count | Should Be 1
        }

        It "Should have have property 'ProcessId'" {
            $connections = Get-NetworkConnection
            $connections[0].PSObject.Properties.Match("ProcessId").Count | Should Be 1
        }

        It "Should have have property 'ProcessName'" {
            $connections = Get-NetworkConnection
            $connections[0].PSObject.Properties.Match("ProcessId").Count | Should Be 1
        }
    }

    Context "Take pipeline input" {

        It "Should take input from pipeline by ProcessName" {
            $total = (Get-NetworkConnection).Count
            $connections = "svchost" | Get-NetworkConnection

            $connections[0].GetType().Name | Should Be "NetworkConnection"
            $connections[0].Count | Should Not Be $total
        }

        It "Should take input from pipeline by ProcessName, multiple values" {
            $allSame = $true
            $total = (Get-NetworkConnection).Count
            $connections = "svchost","System" | Get-NetworkConnection

            for ($i = 0; $i -lt $connections.Count; $i++) {
                if ($connections[$i].ProcessName -ne "svchost" -and $connections[$i].ProcessName -ne "System") {
                    $allSame = $false
                }
            }

            $connections[0].GetType().Name | Should Be "NetworkConnection"
            $connections[0].Count | Should Not Be $total
            $allSame | Should Be $true
        }

        It "Should take input from pipeline from an object, multiple values" {
            $connections = Get-NetworkConnection

            $procFromCmdlet = (Get-NetworkConnection)[0].ProcessId
            $proc = Get-Process -Id $procFromCmdlet

            { $proc | Get-NetworkConnection } | Should Not Be $null
            { ($proc | Get-NetworkConnection).Count } | Should Not Be $connections.Count

        }

        It "Should take input from pipeline from an object" {
            $allSame = $true
            $proc = Get-Process | Where-Object {$_.ProcessName -eq "svchost" -or $_.ProcessName -eq "System"}
            $connections = $proc | Get-NetworkConnection

            for ($i = 0; $i -lt $connections.Count; $i++) {
                if ($connections[$i].ProcessName -ne "svchost" -and $connections[$i].ProcessName -ne "System") {
                    $allSame = $false
                }
            }

            $connections | Should Not Be $null
            $allSame | Should Be $true
        }
    }

    Context "Using parameters" {
        # Change all the following to handle mocks.
        It "Should filter by ProcessName" {
            $allSame = $true
            $connections =  Get-NetworkConnection -ProcessName svchost
            
            for ($i = 0; $i -lt $connections.Count; $i++) {
                if ($connections[$i].ProcessName -ne "svchost") {
                    $allSame = $false
                }
            }

            $allSame | Should Be $true
        }

        It "Should filter by ProcessName, multiple values" {
            $allSame = $true
            $connections =  Get-NetworkConnection -ProcessName svchost,System
            
            for ($i = 0; $i -lt $connections.Count; $i++) {
                if ($connections[$i].ProcessName -ne "svchost" -and $connections[$i].ProcessName -ne "System") {
                    $allSame = $false
                }
            }

            $allSame | Should Be $true
        }

        It "Should filter by ProcessId" {
            $allSame = $true
            $connections =  Get-NetworkConnection
            $procId = (Get-Process -Id $connections[0].ProcessId).Id
            $conns = Get-NetworkConnection -ProcessId $procId
            
            for ($i = 0; $i -lt $conns.Count; $i++) {
                if ($conns[$i].ProcessId -ne $procId) {
                    $allSame = $false
                }
            }

            $allSame | Should Be $true
        }

        It "Should filter by ProcessId, multiple values" {
            $allSame = $true
            $connections =  Get-NetworkConnection
            $procIds = (Get-Process -Id $connections[0].ProcessId,$connections[1].ProcessId).Id
            $conns = Get-NetworkConnection -ProcessId $procIds
            
            for ($i = 0; $i -lt $conns.Count; $i++) {
                if ($conns[$i].ProcessId -ne $procIds[0] -and $conns[$i].ProcessId -ne $procIds[1]) {
                    $allSame = $false
                }
            }

            $allSame | Should Be $true
        }

        It "Should filter by State ESTABLISHED" {
            $allSame = $true
            $connections =  Get-NetworkConnection -State ESTABLISHED

            for ($i = 0; $i -lt $connections.Count; $i++) {
                if ($connections[$i].State -ne "ESTABLISHED") {
                    $allSame = $false
                }
            }

            $allSame | Should Be $true
        }

        It "Should filter by State LISTENING" {
            $allSame = $true
            $connections =  Get-NetworkConnection -State LISTENING

            for ($i = 0; $i -lt $connections.Count; $i++) {
                if ($connections[$i].State -ne "LISTENING") {
                    $allSame = $false
                }
            }

            $allSame | Should Be $true
        }
    }
}

Describe "Get-NetworkConnectionHost" {

    Context "Without Parameters" {
        It "Should get the local host name if no parameters are provided" {

            (Get-NetworkConnectionHost).HostName | Should Be $env:COMPUTERNAME
        }
    }

    Context "With Parameters" {

        It "Should  get the name and IP address of the remote host" {
            $remoteIp = "198.211.121.94"
            $remoteName = "kaguwaweb02.kaguwa.se"

            (Get-NetworkConnectionHost codecloudandrants.io).IPAddress | Should Be $remoteIp
            (Get-NetworkConnectionHost $remoteIp).HostName | Should Be $remoteName
        }

        It "Should return a message in HostName if 0.0.0.0 is used" {
            
            (Get-NetworkConnectionHost "0.0.0.0").HostName | Should Be "IPv4 address 0.0.0.0 and IPv6 address ::0 cannot be used."
        }
    }
}