Function Set-LocalPrinters {
    param (
        [string]$server,

        [string]$printerName
    )
    $printerPath = $null
    $PrinterPath = "\\$($server)\$($printerName)"
    $netConn = Test-NetConnection -ComputerName $Server | select-object PingSucceeded, NameResolutionSucceeded
    if (($netconn.PingSucceeded) -and ($netConn.NameResolutionSucceeded)) {
        write-host "Installation de $printerName ..." -ForegroundColor Green
        if (Get-Printer -Name "\\SRVPRINT2\203 Photocopieur" -ErrorAction SilentlyContinue) {
            Write-Host "L'imprimante $printerPath est deja installee" -ForegroundColor Green
        }
        else {
            Write-Host "Installation de $printerPath" -ForegroundColor Green
            & cscript /noLogo C:\windows\System32\Printing_Admin_Scripts\fr-FR\prnmngr.vbs -ac -p $printerPath
            if (Get-Printer -Name "\\SRVPRINT2\203 Photocopieur" -ErrorAction SilentlyContinue) {
                Write-Host "$printerPath a ete installe avec succes"
                New-Item "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$printerName.log" -Force
            }
            else {
                Write-Warning "Erreur : $printerPath non installee"
            }
        }
    }
    else {
        Write-Host "Le serveur n'est pas joignable. $printerPath ne sera pas installee." -ForegroundColor Red
    }
}

$printers = @(
    [PSCustomObject]@{
        Printer = "COP203P01"
        Server = "SRVPRINT2"
    }
)

foreach ($p in $printers) {
    Set-LocalPrinters -server $p.Server -printerName $p.Printer
}