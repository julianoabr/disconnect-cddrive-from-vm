#Requires -RunAsAdministrator
#Requires -Version 4.0   

<#
.Synopsis
   Disconnect CD/DVD Drive and ISO Files
.DESCRIPTION
   Disconnect CD/DVD Drive and ISO Files
.EXAMPLE
   Inserir posteriormente
.EXAMPLE
   Inserir posteriormente
.CREATEDBY
    Juliano Alves de Brito Ribeiro (find me at julianoalvesbr@live.com or https://github.com/julianoabr or https://youtube.com/@powershellchannel)
.VERSION INFO
    0.2
.VERY IMPORTANT
    Powershell Rocks and Jesus Christ is the ROCK
#>


[System.String]$dsName = Read-Host "Type Datastore Name"


$vmListOnDS = @()

$vmListOnDS = Get-Datastore -Name $dsName | Get-VM | Select-Object -ExpandProperty Name

foreach ($vmOnDS in $vmListOnDS)
{
    
     $dvdDriveISODS = Get-CDDrive -VM $vmOnDS 

     if ($dvdDriveISODS.IsoPath -ne $null){

        [System.String]$dvdISOPath = $dvdDriveISODS.IsoPath
     
        Write-Host "VM: $vmOnDS has Datastore ISO File pointed in your DVD Drive:$dvdISOPath " -ForegroundColor White -BackgroundColor Red
        
        Set-CDDrive -CD $dvdDriveISODS -NoMedia -Confirm:$false -Verbose

        #Wait for question to be created

        Start-Sleep -Seconds 10 -Verbose

        $vQuestion = Get-VM -Name $vmOnDS  | Get-VMQuestion
        
        $vQuestionText = $vQuestion.Text 

        if ($vQuestionText -like "*locked*"){

            Set-VMQuestion -VMQuestion $vQuestion -Option button.yes -Confirm:$false -Verbose

        }#end of IF Question
        else{
        
            Write-Host "VM: $vmOnDS has not Linux locking the DVD/CD DRIVE" -ForegroundColor White -BackgroundColor DarkBlue

        }#end of Else Question
                
     
     }#end of If
     else{
     
     Write-Host "VM: $vmOnDS has no Datastore ISO File pointed in your DVD Drive" -ForegroundColor White -BackgroundColor DarkBlue    
     
     }#end of Else


}#end of Foreach
