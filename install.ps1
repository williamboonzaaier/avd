$connectTestResult = Test-NetConnection -ComputerName lscsaacentralusvmstorage.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"lscsaacentralusvmstorage.file.core.windows.net`" /user:`"localhost\lscsaacentralusvmstorage`" /pass:`"qjF8Wzrg44v3NOBTVQGrr48rdWsvIjI87cBk297C40l9Oll0kvGyblfeE6e6Hq3/fEPOi2dhpAz19Xz9XwhJaA==`""
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\lscsaacentralusvmstorage.file.core.windows.net\sharedinfo" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}

Start-Sleep -Seconds 3
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\lscsaacentralusvmstorage.file.core.windows.net\sharedinfo" -Persist


$MyWallpaper="Z:\Shared files\Install software\Background_V2.png"
$code = @' 
using System.Runtime.InteropServices; 
namespace Win32{ 
    
     public class Wallpaper{ 
        [DllImport("user32.dll", CharSet=CharSet.Auto)] 
         static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni) ; 
         
         public static void SetWallpaper(string thePath){ 
            SystemParametersInfo(20,0,thePath,3); 
         }
    }
 } 
'@

add-type $code 
[Win32.Wallpaper]::SetWallpaper($MyWallpaper)

Copy-Item "Z:\Shared files\Install software\layoutmodification.xml" -Destination "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell"
