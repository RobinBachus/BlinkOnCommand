Function Blink
{
	param([switch]$r); #if called with the "-r" switch, the module will be reloaded before execution
	if ($r){
		ReloadModule -s
		Blink
		#TODO: Fix closing pws window on exit
		exit 0
	}
	
	$DefaultPort= [System.IO.Ports.SerialPort]::getportnames()
	if (-not ([string]::IsNullOrEmpty($DefaultPort))) {
		Write-Host("Blinking light on serial port $DefaultPort")
		#Try to connect to the Default com
		try
		{
			$port= new-Object System.IO.Ports.SerialPort $DefaultPort,9600,None,8,one #opens serial port
			$port.ReadTimeout = 2000
			$port.open() #opens serial connection
			$port.WriteLine(264) #writes your content to the serial connection
		}
		catch [UnauthorizedAccessException]
		{
			Write-Host("Acces to $DefaultPort was denied")
			exit 1
		}
		
		#Check if the light blinked 
		try
		{
			if(!$port.ReadLine() -like "On"){
				throw [System.TimeoutException]::new()
			}
			else{
				Write-Host("Light blinked")
			}
		}
		catch [TimeoutException]
		{
			Write-Host('TimeoutException: LED did not blink')
		}
		$port.Close() #closes serial connection
	}
	else {
		Write-Host("No ports found")
	}
}

Function BlinkAt
{
	param(
		[switch]$r, #if called with the "-r" switch, the module will be reloaded before execution
		[Parameter(Mandatory=$true)]
		[string[]]$Ports, 
		[Parameter(Mandatory=$true)]
		[int]$Blinks); 
	if ($r){
		ReloadModule -s
		& BlinkAt $Ports $Blinks
		#TODO: Fix closing pws window on exit
		exit	
	}
	$ErrorActionPreference = 'silentlycontinue'
	$PortsLenght= $Ports.Count
	write-host "Blingking LEDs on $PortsLenght board(s) $Blinks times each:"
	for ( $i = 0; $i -lt $PortsLenght; $i++ ) {
		$SerialPort=$Ports[$i]
		#Try to connect to the board
		try
		{
			$port= new-Object System.IO.Ports.SerialPort $SerialPort,9600,None,8,one #opens serial port
			$port.ReadTimeout = 2000
			$port.open() #opens serial connection
		}
		catch [UnauthorizedAccessException]
		{
			Write-Host('Acces to $DefaultPort was denied')
			exit 1
		}
		for ( $j = 1; $j -le $Blinks; $j++ ) {
			Write-Host("${j}: Blinking light on serial port $SerialPort")	
			$port.WriteLine(264) #writes your content to the serial connection
			try
			{
				$null=$port.ReadLine()
			}
			catch [TimeoutException]
			{
				Write-Host('TimeoutException: LED did not blink')
			}
			catch [InvalidOperationException]
			{
				Write-Host("`nInvalidOperationException: Attempting to reconnect $SerialPort")
				try {
					$port= new-Object System.IO.Ports.SerialPort $SerialPort,9600,None,8,one #opens serial port
					$port.ReadTimeout = 2000
					$port.open() #opens serial connection
					$port.WriteLine(264) #writes your content to the serial connection	
					Write-Host("Succesfully reconnected and blinked LED `r`n")
				}
				catch {
					Write-Host("Attempt failed, check connection to ${SerialPort} `r`n")
				}
			}
			catch {
				Write-Host("Something went wrong: $PSItem.Exception.Message")
			}
			finally {
			Start-Sleep -Seconds 1
			}
		}
		$port.Close() #closes serial connection
		}
}

Function GetPortNames
{
	$SerialPorts= [System.IO.Ports.SerialPort]::getportnames()
	if (-not ([string]::IsNullOrEmpty($SerialPorts))) {
		Write-Host("Port name(s): $SerialPorts")
	}
	else {
		Write-Host("No ports found")
	}
}

Function ReloadModule #Reloads the Blink module on case of changes/updates
{
	param([switch]$s); # "-s" switch to silence output
	if ($s){
		$NULL= ImportModuleBlink
		$NULL= GetModuleBlink
	}
	else {
	ImportModuleBlink
	GetModuleBlink
	}
}

Function ImportModuleBlink
{
	Import-Module -Name C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Blink\Blink.psm1 -Force
}

Function GetModuleBlink #Reloads the Blink module on case of changes/updates
{
	Get-Command -Module Blink
}

Export-ModuleMember -Function * -Alias * -Variable *

# for Arduino layout see C:\Users\robin\iCloudDrive\PC\Scripts\Arduino\Tests\CableTest\RedLed\SerialRead.ino