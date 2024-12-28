
```markdown
# VPC Module

This folder contains a Terraform module to deploy a Virtual Private Cloud (VPC) in AWS. This module is designed to create a foundational network environment for your cloud infrastructure by managing subnets, route tables, internet gateways, NAT gateways, and related components.

---

## How to Use This Module

This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use by adding a `module` configuration block and setting its `source` parameter to the location of this folder:

```hcl
module "vpc" {
  # TODO: Update the source URL or local source
  source = "github.com/your-repo-name/terraform-aws-vpc//modules/vpc"

  # VPC setup
  cidr                 = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  # Subnet configuration
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  # Tags for resources
  app_name        = "production-vpc"
  environment = "production"
  aws_region      = "eu-west-1"
}
```

### Key Input Parameters

* `source`: Specifies the URL of this module. Use the `//` syntax to target the subfolder containing this module.  
* `cidr`: Defines the CIDR block for the VPC.  
* `environment`: Indicates the environment for this VPC, such as `production`, `staging`, or `development`.  
* `public_subnets` & `private_subnets`: CIDR blocks for public and private subnets.  
* `tags`: Key-value pairs to tag the resources.

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
│   │   ├── terraform.tfvars
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
```



```