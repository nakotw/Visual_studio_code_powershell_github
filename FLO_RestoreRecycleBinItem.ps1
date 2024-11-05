Get-PnPRecycleBinItem  |
    Select-Object Title, ID, AuthorEmail, DeletedbyEmail, DeletedDate, DirName | 
        Out-GridView -PassThru |
            ForEach-Object { Restore-PnPRecycleBinItem -Identity $_.Id.Guid -Force}