output "access-proxy_ip" {
    description = "Floating IP of the Access Proxy"
    value = openstack_networking_floatingip_v2.floatip-access-proxy.address
}
output "access-proxy_username" {
    value = data.openstack_images_image_v2.debian12.properties["os_admin_user"]
}