ansible-playbook -i '10.1.2.190,' windows_post.yml --extra-vars 'ansible_user=TestAcc ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 attack_range_password=secreT123% ansible_port=5986 hostname=win-tf-test-2 create_domain=1 win_sysmon_config=SwiftOnSecurity.xml cloud_provider=local join_domain=1 prelude=0 crowdstrike_falcon=0'

ansible-playbook -i '10.1.2.190,' windows.yml --extra-vars 'ansible_user=TestAcc ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 ansible_port=5986 attack_range_password=secreT123% use_prebuilt_images_with_packer=0 cloud_provider=local splunk_uf_win_url=https://download.splunk.com/products/universalforwarder/releases/9.0.5/windows/splunkforwarder-9.0.5-e9494146ae5c-x64-release.msi '

# Access via proxy from cyberrange host
./proxy.sh ansible windows -m win_command -a "cmd.exe /c dir"

# Ansible playbook via proxy
./proxy.sh ansible-playbook windows_test.yml