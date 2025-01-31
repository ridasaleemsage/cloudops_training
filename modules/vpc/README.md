# VPC Module

This folder contains a Terraform module to deploy a Virtual Private Cloud (VPC) in AWS. This module is designed to create a foundational network environment for your cloud infrastructure by managing subnets, route tables, internet gateways, NAT gateways, and related components.

---

## How to Use This Module

This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use by adding a `module` configuration block and setting its `source` parameter to the location of this folder:

```hcl
module "vpc" {
  # TODO: Update the source URL or local source
  source = "../../modules/vpc"

  # VPC setup
  cidr                 = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  # Subnet configuration
  subnets = {
    public = [
      {
        cidr                    = "10.0.1.0/24"
        availability_zone       = "eu-west-1a"
        map_public_ip_on_launch = true
      }
    ],
    private = [
      {
        cidr              = "10.0.4.0/24"
        availability_zone = "eu-west-1a"
        tags = {
          Type = "private"
        }
      }
    ]
  }

  # Tags for resources
  app_name        = "prod-vpc"
  environment     = "prod"
  aws_region      = "eu-west-1"
}
```

### Key Input Parameters

* `source`: Specifies the URL of this module. Use the `//` syntax to target the subfolder containing this module incase of URL.  
* `cidr`: Defines the CIDR block for the VPC.  
* `environment`: Indicates the environment for this VPC, such as `production`, `staging`, or `development`.  
* `subnets`: Objects with CIDR blocks, availability zones, tags, and map_public_ip_on_launch for public and private subnets.  
* `tags`: Key-value pairs to tag the resources.
* `instance_tenancy`: A tenancy option for instances launched into the VPC - Default/Dedicated.

See [variables.tf](variables.tf) for the full list of customizable inputs.

---

## Rolling Out Updates

To make updates to your VPC:

1. Modify the variables in the module block.  
2. Run `terraform plan` to review the changes.  
3. Apply the changes with `terraform apply`.  

---

## Example for Environments

This module is designed to work across different environments. Here's an example of how you might structure your folder for `production` and `staging` environments using a local path for the module.

### Folder Structure

```
├── environments/
│   ├── prod/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── local.tf
│   │   ├── provider.tf
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── local.tf
│   │   ├── provider.tf
├── examples/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── output.tf
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── local.tf
│   │   ├── data.tf
```