module "dev-vpc" {
    source = "./fuel50-test"
    vpcname = "dev-vpc"
    cidr = "10.0.1.0./24"
    enable_dns_support = true
    enable_classiclink = false
    enable_classiclink_dns_support = false
    enable_ipv6 = true
    vpcenvironment = "dev"
  
}