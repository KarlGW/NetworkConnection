# NetworkConnection
At it's initial release (and the initial purpose of the module) it contains but one 
Cmdlet, `Get-NetworkConnection`. 

* [About](#about)
* [Installation](#installation)
* [Cmdlets](#cmdlets)
 * [Get-NetworkConnection](#getnetworkconnection)
* [Version and Updates](#version)

##<a name=about>About</a>
The components of `Get-NetworkConnection` are the DLLs: `Kaguwa.Commands.Network.dll` and `Kaguwa.Network.dll`.
Their respective projects can be found:

* [Kaguwa.Commands.Network](https://github.com/KarlGW/Kaguwa.Commands)
* [Kaguwa.Network](https://github.com/KarlGW/Kaguwa.Network)

This Cmdlet is supposed to mimic the behaviour of `netstat.exe -ano` but instead delivering 
an object, The PowerShell way. It began as a function named `Get-Netstat` that parsed the 
results from `netstat.exe -ano` and returned them as a `PSCustomObject`. This took a lot longer 
than the original command and didn't get the right feel. 

Instead it uses `iphlpapi.dll` to contact the OS and get the information from there directly, and turning the 
results into a list of `NetworkConnection` objects.

I made tests comparing it to `netstat.exe -ano`.

```
PS C:\Users\Karl> Measure-Command  { Get-NetworkConnection }


Days              : 0
Hours             : 0
Minutes           : 0
Seconds           : 0
Milliseconds      : 5
Ticks             : 51629
TotalDays         : 5,9755787037037E-08
TotalHours        : 1,43413888888889E-06
TotalMinutes      : 8,60483333333333E-05
TotalSeconds      : 0,0051629
TotalMilliseconds : 5,1629



PS C:\Users\Karl> Measure-Command { netstat -ano }


Days              : 0
Hours             : 0
Minutes           : 0
Seconds           : 0
Milliseconds      : 14
Ticks             : 142500
TotalDays         : 1,64930555555556E-07
TotalHours        : 3,95833333333333E-06
TotalMinutes      : 0,0002375
TotalSeconds      : 0,01425
TotalMilliseconds : 14,25
```

##<a name=installation>Installation</a>
There are various ways on how to install this module. The basic and simplest way is to clone
the project to your local machine and copy it to your user profiles PowerShell module folder:

```
git clone https://github.com/KarlGW/NetworkConnection.git
Copy-Item .\NetworkConnection\NetworkConnection -Recurse -Destination $env:PSModulePath.Split(";")[0]
```

##<a name="cmdlets">Cmdlets</a>
Cmdlets listed with short information and description.

###<a name="getnetworkconnection>Get-NetworkConnection</a>
Gets active TCP/UDP connections from the local system.

####Parameters

| Param         | Type       | Mandatory | Allowed Values |                                                           |
|---------------|------------|-----------|----------------------------------------------------|-----------------------------------------------------------|
| `ProcessName` | *string[]* | False     |                                                    | Filters the returned list by the provided process names.  |
| `ProcessId`   | *int[]*    | False     |                                                    | Filters the returned list by the provided process ids.    |
| `State`       | *string*   | False     | *ESTABLISHED*, *LISTENING*, *TIME_WAIT*, *CLOSING* | Filters the returned list by state.


####Examples

To get a complete list of connections.

`Get-NetworkConnection`

To get a list of connections that are listed as ESTABLISHED.

`Get-NetworkConnection -State ESTABLISHED`

To get all the connections with with the process name of *chrome* and *svchost*

`Get-NetworkConnection -ProcessName chrome,svchost`

or

`"chrome","svchost" | Get-NetworkConnection`

*You can get more examples from `Get-Help Get-NetworkConnection`*

##<a name="version">Version and Updates</a>

###v.0.1.0
First release.

##<a name="upcoming">Upcoming changes</a>

* Case in-sensitive filtering of ProcessName.
* Support wildcard for ProcessName (uses Regex in the current version)