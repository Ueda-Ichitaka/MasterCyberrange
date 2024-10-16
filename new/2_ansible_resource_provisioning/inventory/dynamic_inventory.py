#!/usr/bin/env python3

import sys
import subprocess
import json
import os

class SetEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, set):
            return list(obj)
        return json.JSONEncoder.default(self, obj)

def get_terraform_outputs():
    terraform_config_path = os.path.abspath('../1_resource_generation')
    p = subprocess.run(['terraform', 'output', '-json'], cwd=terraform_config_path, capture_output=True)
    return json.loads(p.stdout)

if __name__ == '__main__':
    inventory = {}
    terraform_output = get_terraform_outputs()

    access_proxy_ip = terraform_output['access-proxy_ip']['value']
    access_proxy_user = terraform_output['access-proxy_username']['value']
    #access_proxy_ip = '10.1.3.152'
    #access_proxy_user = 'debian'

    inventory["proxy"] = {
        'hosts': [access_proxy_ip],
        'vars': {
            'ansible_user': access_proxy_user
        }
    }
    inventory["ansible_controller"] = {
        'hosts': [access_proxy_ip],
        'vars': {
            'ansible_user': access_proxy_user
        }
    }
    inventory["access_via_proxy"] = {
        'vars': {
            'ansible_ssh_common_args': f'-vvvv -o ProxyCommand="ssh -vvvv -A -p 22 -W %h:%p -q -l {access_proxy_user} {access_proxy_ip}" -o StrictHostKeyChecking=no'  
        } 
    }
    inventory["access_via_proxy_2"] = {
        'vars': {
            'ansible_ssh_common_args': f'-vvvv -o ProxyCommand="ssh -vvvv -A -p 22 -W %h:%p {access_proxy_user}@{access_proxy_ip}" -o StrictHostKeyChecking=no'  
        } 
    }

    sys.stdout.write(json.dumps(inventory, indent=2, cls=SetEncoder))