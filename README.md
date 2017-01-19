# Kaguwa Tools
Kaguwa Tools is a PowerShell module that contains various tools for day-to-day work.
At it's initial release (and the initial purpose of the module) it contains but one 
Cmdlet, `Get-NetworkConnection`. 

* [About](#about)
* [Installation](#installation)
* [Cmdlets](#cmdlets)
    * [Get-NetworkConnection](#getnetworkconnection)
* [Version and Updates](#version)

##<a name=about>About</a>
The components of `Get-NetworkConnection` are the DLLs: `Kaguwa.Tools.dll` and `Kaguwa.Helpers.dll`.
Their respective projects can be found:

* [Kaguwa.Tools](https://github.com/KarlGW/Kaguwa.Tools)
* [Kaguwa.Helpers](https://github.com/KarlGW/Kaguwa.Helpers)

As mentioned earlier more Cmdlets are on the way.

##<a name=installation>Installation</a>
There are various ways on how to install this module. The basic and simplest way is to clone
the project to your local machine and copy it to your user profiles PowerShell module folder:

```
git clone https://github.com/KarlGW/KaguwaTools.git
Copy-Item .\KaguwaTools\KaguwaTools -Recurse -Destination $env:PSModulePath.Split(";")[0]
```
##<a name="cmdlets">Cmdlets</a>

###<a name="getnetworkconnection>`Get-NetworkConnection`</a>

This Cmdlet is supposed to mimic the behaviour of `netstat.exe -ano` but instead delivering 
an object, The PowerShell way. It began as a function named `Get-Netstat` that parsed the 
results from `netstat.exe -ano` and returned them as a `PSCustomObject`. This took a lot longer 
than the original command and didn't get the right feel. 

Instead it uses `iphlpapi.dll` to contact the OS and get the information from there directly, and turning the 
results into a list of `Kaguwa.Tools.Network.Type.NetworkConnection` objects.

###Parameters

| Param         | Type       | Mandatory | Allowed Values |                                                           |
|---------------|------------|-----------|----------------------------------------------------|-----------------------------------------------------------|
| `ProcessName` | *string[]* | False     |                                                    | Filters the returned list by the provided process names.  |
| `ProcessId`   | *int[]*    | False     |                                                    | Filters the returned list by the provided process ids.    |
| `State`       | *string*   | False     | *ESTABLISHED*, *LISTENING*, *TIME_WAIT*, *CLOSING* | Filters the returned list by state.


###Examples

To get a complete list of connections.

`Get-NetworkConnection`

To get a list of connections that are listed as ESTABLISHED.

`Get-NetworkConnection -State ESTABLISHED`

To get all the connections with with the process name of *chrome* and *svchost*

`Get-NetworkConnection -ProcessName chrome,svchost`

or

`"chrome","svchost" | Get-NetworkConnection`

*More TBA*

##<a name="version">Version and Updates</a>

###v.0.1.6228.5310
First release.