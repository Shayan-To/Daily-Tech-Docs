Param($Dest)

If ($Dest -ne "Server" -and $Dest -ne "Local")
{
    Exit
}

$Server = "root@104.251.217.218"
$SocketFile = "/tmp/ssh_socket"

Write-Host
If ($Dest -eq "Server")
{
    Write-Host "Trasfer files for server at $Server."
}
Else
{
    Write-Host "Trasfer files for local."
}
Write-Host

While ($True)
{
    $SR = Read-Host "Send/Receive (R|S)"
    If ($SR -eq "S" -or $SR -eq "R")
    {
        Break
    }
}

If ($Dest -eq "Server")
{
    Write-Host "Opening connection to the server..."
    bash -c "rm -f $SocketFile"
    Start-Process bash -ArgumentList "-c 'ssh -N -M -o 'ServerAliveInterval=60' -o 'ControlPath=$SocketFile' $Server'" -NoNewWindow
}

Try
{
    While ($True)
    {
        Write-Host
        $Path = Read-Host "Path [exit]"

	    $Path = $Path.Trim()

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
        $Path = $Path.Replace("\", "\\").Replace("'", "\'")

        $Commands = [System.Collections.Generic.List[String]]::New()

        $Parent = $Path.Substring(0, $Path.LastIndexOf("/"[0]) + 1)

        If ($SR -eq "S")
        {
            $Command = "mkdir -p `$'$Parent'"
            If ($Dest -eq "Server")
            {
                $Command = $Command.Replace("\", "\\").Replace("'", "\'")
                $Commands.Add("ssh -o 'ControlPath=$SocketFile' $Server `$'$Command'")
            }
            Else
            {
                $Commands.Add("echo ' ' | sudo -Sp '' $Command")
            }
        }
        Else
        {
            $Commands.Add("mkdir -p `$'.$Parent'")
        }

        If ($Dest -eq "Server")
        {
            If ($SR -eq "S")
            {
                $Commands.Add("scp -o 'ControlPath=$SocketFile' `$'.$Path' `$'${Server}:$Path'")
            }
            Else
            {
                $Commands.Add("scp -o 'ControlPath=$SocketFile' `$'${Server}:$Path' `$'.$Path'")
            }
        }
        Else
        {
            If ($SR -eq "S")
            {
                $Commands.Add("echo ' ' | sudo -Sp '' cp `$'.$Path' `$'$Path'")
            }
            Else
            {
                $Commands.Add("echo ' ' | sudo -Sp '' cp `$'$Path' `$'.$Path'")
            }
        }

        If ($SR -eq "S")
        {
            If ($Dest -eq "Server")
            {
                $Permission = Read-Host "Permission (chmod - rwx) [nothing]"
                $Permission = $Permission.Trim()
            }
            Else
            {
                $Permission = Read-Host "Permission (chmod - rwx) [777]"
                $Permission = $Permission.Trim()
                If ($Permission.Length -ne 0)
                {
                    $Permission = "777"
                }
            }

            If ($Permission.Length -ne 0)
            {
                $Command = "chmod $Permission `$'$Path'"
                If ($Dest -eq "Server")
                {
                    $Command = $Command.Replace("\", "\\").Replace("'", "\'")
                    $Commands.Add("ssh -o 'ControlPath=$SocketFile' $Server `$'$Command'")
                }
                Else
                {
                    $Commands.Add("echo ' ' | sudo -Sp '' $Command")
                }
            }
        }

        Write-Host
        Write-Host "Commands:"
        $Commands | % {Write-Host "    $_"}

        Pause

        $Commands | % {Write-Host; Write-Host $_; bash -c "$_"}

        Write-Host
        Write-Host "-----"
    }
}
Finally
{
    Write-Host "Closing connection to the server..."
    bash -c "ssh -o 'ControlPath=$SocketFile' -O stop $Server"
}
