module "gke" {
  source                        = "../../modules/gke"
  create                        = var.gke_create
  project                       = var.project
  cluster                       = "${var.env}-gke"
  cluster_initial_node_count    = var.cluster_initial_node_count
  gke_version                   = var.gke_version
  machine_type                  = var.machine_type
  gke_tags                      = var.gke_tags
  vpc_network                   = module.vpc.vpc_id
  subnetwork_vpc_name           = module.gke_subnetwork.subnet_id
  gke_service_account           = module.sa-gke.service_account_emails[0]
  gke_master_ipv4_cidr_block    = var.gke_master_ipv4_cidr_block
  cluster_secondary_range_name  = var.gke_secondary_ip_range[0]["secondary_ip_range_name"]
  services_secondary_range_name = var.gke_secondary_ip_range[1]["secondary_ip_range_name"]

  depends_on = [
    module.vpc,
    module.gke_subnetwork,
    module.sa-gke
  ]
}
