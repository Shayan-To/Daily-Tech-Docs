$Server = "root@104.251.217.218"

While ($True)
{
    $SR = Read-Host "Send/Receive"
    If ($SR -eq "S" -or $SR -eq "R")
    {
        Break
    }
}

While ($True)
{
    Write-Host
    $Path = Read-Host "Path"

    If ($Path.Length -eq 0)
    {
        Break
    }

    If ($Path[0] -ne "/"[0])
    {
        If ($Path[0] -eq '"'[0] -and $Path[$Path.Length - 1] -eq '"'[0])
        {
            $Path = $Path.Substring(1, $Path.Length - 2)
        }

        $Path = $Path.Substring($Path.IndexOf("#"[0]) + 1)
    }
    $Path = $Path.Replace("\"[0], "/"[0])
    Write-Host "Path: $Path"

    $Remote = "${Server}:$Path"
    $Local = ".$Path"

    If ($SR -eq "S")
    {
        $Arg1 = $Local
        $Arg2 = $Remote
    }
    Else
    {
        $Arg1 = $Remote
        $Arg2 = $Local
    }

    $Commands = [System.Collections.Generic.List[String]]::New()

    $Parent = $Path.Substring(0, $Path.LastIndexOf("/"[0]) + 1)
    If ($SR -eq "S")
    {
        $Commands.Add("ssh $Server 'mkdir -p $Parent'")
    }
    Else
    {
        $Commands.Add("mkdir -p .$Parent")
    }

    $Commands.Add("scp '$Arg1' '$Arg2'")

    Write-Host
    Write-Host "Commands:"
    $Commands | % {Write-Host "    $_"}

    Pause

    $Commands | % {Write-Host $_; bash -c "$_"}

    Write-Host
    Write-Host "-----"
}
