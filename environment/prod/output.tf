output "route_table_map" {
  description = "value of the route table map"
  value = [for rt in local.route_table_map : rt]
}