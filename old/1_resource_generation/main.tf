
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
    splunk = {
      source  = "splunk/splunk"
      version = "1.4.22"
    }
  }
}

provider "openstack" {
}

provider "splunk" {
  url                  = "localhost:8089"
  username             = "admin"
  password             = "password"
  insecure_skip_verify = true
}
