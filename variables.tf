variable "project_id" {
  description = "Google Cloud Project ID where AlloyDB resources will be created."
  type        = string
}

variable "region" {
  description = "Google Cloud region where the AlloyDB cluster and instances will be deployed."
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier for the AlloyDB cluster."
  type        = string
}

variable "network_self_link" {
  description = "Self-link of the VPC network configured with Private Service Access for AlloyDB."
  type        = string
}

variable "db_user" {
  description = "Initial database administrator username created during cluster provisioning."
  type        = string
}

variable "environment" {
  description = "Environment label applied to AlloyDB resources (e.g., dev, test, stage, prod)."
  type        = string
  default     = "dev"
}

variable "primary_cpu_count" {
  description = "Number of vCPUs allocated to the AlloyDB primary instance."
  type        = number
  default     = 2
}

variable "read_pool_cpu_count" {
  description = "Number of vCPUs allocated to the AlloyDB read pool instance."
  type        = number
  default     = 2
}

variable "read_pool_node_count" {
  description = "Number of nodes to provision in the AlloyDB read pool."
  type        = number
  default     = 1
}

variable "create_read_pool" {
  description = "Whether to create a read pool instance for read scaling."
  type        = bool
  default     = false
}

variable "availability_type" {
  description = "Instance availability type. ZONAL or REGIONAL."
  type        = string
  default     = "ZONAL"
}

variable "database_version" {
  type        = string
  description = "database version"
}