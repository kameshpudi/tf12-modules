output "name" {
  value = module.demo_resourcegroup.resource_group_name
}
output "public_ip" {
  value = module.demo_win_vm.public_ip
}
output "hostname" {
  value = module.demo_win_vm.hostname
}

