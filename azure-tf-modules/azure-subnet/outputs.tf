output "frontend_sn_name" {
  value = "${element(concat(azurestack_subnet.frontend_sn.*.name, list("")), 0)}"
}

output "frontend_sn_id" {
  value = "${element(concat(azurestack_subnet.frontend_sn.*.id, list("")), 0)}"
}