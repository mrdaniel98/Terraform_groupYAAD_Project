variable "region" {
  description = "AWS region for the resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets CIDR blocks and AZs"
  default = [
    { cidr = "10.1.1.0/24", az = "us-east-1a" },
    { cidr = "10.1.2.0/24", az = "us-east-1b" },
    { cidr = "10.1.3.0/24", az = "us-east-1c" },
  ]
}

variable "private_subnets" {
  description = "Private subnets CIDR blocks and AZs"
  default = [
    { cidr = "10.1.5.0/24", az = "us-east-1a" },
    { cidr = "10.1.6.0/24", az = "us-east-1b" },
  ]
}

variable "tags" {
  description = "Default tags for resources"
  default = {
    Project = "FinalProject"
  }
}
