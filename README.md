# NetworkConnection
At it's initial release (and the initial purpose of the module) it contains but one 
Cmdlet, `Get-NetworkConnection`. 

* [About](#about)
* [Installation](#installation)
* [Cmdlets](#cmdlets)
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


###Get-NetworkConnection
Gets active TCP/UDP connections from the local system.

####Parameters

| Param         | Type       | Mandatory | Allowed Values |                                                           |
|---------------|------------|-----------|----------------------------------------------------|-----------------------------------------------------------|
| `ProcessName` | *String[]* | False     |                                                    | Filters the returned list by the provided process names.  |
| `ProcessId`   | *Int[]*    | False     |                                                    | Filters the returned list by the provided process ids.    |
| `State`       | *String*   | False     | *Established*, *Listening*, *Time_Wait*, *Closing* | Filters the returned list by state.


###Get-NetworkConnectionHost
Gets host name from IP address and IP address from host name.

####Parameters

| Param  | Type       | Mandatory | Allowed Values |                                   |
|--------|------------|-----------|----------------|-----------------------------------|
| `Host` | *String[]* | False     |                | Host name/IP address to resolve.  |


####Examples

To get a complete list of connections.

`Get-NetworkConnection`

To get a list of connections that are listed as Established.

`Get-NetworkConnection -State Established`

To get all the connections with with the process name of *chrome* and *svchost*

`Get-NetworkConnection -ProcessName chrome,svchost`

or

`"chrome","svchost" | Get-NetworkConnection`

*You can get more examples from `Get-Help Get-NetworkConnection`*

###Get-NetworkConnectionHost
Gets host name from IP address and IP address from host name.

####Parameters

| Param  | Type       | Mandatory | Allowed Values |                                   |
|--------|------------|-----------|----------------|-----------------------------------|
| `Host` | *string[]* | False     |                | Host name/IP address to resolve.  |


####Examples

To get the host name and IP address from local host.

`Get-NetworkConnectionHost`

To get resolve multiple entries.

`Get-NetworkConnectionHost -Host 192.168.0.10,codecloudandrants.io,google.com`

To resolve multiple entries from pipeline.

`"codecloudandrants.io","google.com" | Get-NetworkConnectionHost`

To resolve entries from Get-NetworkConnection.

`Get-NetworkConnection -ProcessName chrome | Get-NetworkConnectionHost`


##<a name="version">Version and Updates</a>

###v0.2.0
Fixes and features.

* Added new cmdlet `Get-NetworkConnectionHost`. Works like the *nix command `host`.
* Added wildcard support for `ProcessName` in `Get-NetworkConnection` and removed Regex.
* Added parameter sets so that only one of `ProcessName` and `ProcessId` can be used.
* `Get-NetworkConnectionHost` can take results from `Get-NetworkConnection` from pipeline.
* `LocalAddress` and `RemoteAddress` are now `string`s.

###v0.1.2
Various fixes.

* Fixed `ProcessId` to only return the correct ProcessId and not everything that begins with that integer.
* Updated manifest and how it loads the module.
* Removed unecessary files that were not used.

###v0.1.1
Fixed manifest with description.

###v.0.1.0
First release.

##<a name="upcoming">Upcoming changes</a>

* Case in-sensitive filtering of ProcessName.
* Support wildcard for ProcessName (uses Regex in the current version).
* Should be able to make DNS-resolution if a parameter is specified.