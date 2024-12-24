output "route_table_map" {
  value = [for rt in local.route_table_map : rt]
}