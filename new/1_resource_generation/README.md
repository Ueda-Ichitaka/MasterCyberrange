## Execution Instructions
The terraform plans in this directory construct the infrastructure for the given scenario.
````
~/new/1_resource_generation
````
Application of the plans
````
terraform apply -auto-approve
````
Destruction of the infrastructure
````
terraform destroy
````

## Implementation Notes
When first creating a new openstack_compute_flavor_v2, it has to be generated inside a dummy file.
Otherwise, it will not be integrated into OpenStack correctly and thus will not be available for the creation of compute instances.

When creating large scenarios, a terraform destroy may prove necessary to free up all resources at the beginning of the scenario creation.
Otherwise, the execution may fail due to a perceived lack of resources.