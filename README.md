Databricks E2 workspace with BYOVPC



Creates a E2 workspace in databricks

Creates AWS IAM cross-account role, AWS S3 root bucket, VPC with Internet gateway, NAT, routing, one public subnet,  
two private subnets in two different AZs. Then it ties all together and creates an E2 workspace.


## Inputs

Change variables in main.tf
Change variables in secrets.tfvars
Execute 
terraform plan -var-file="secret.tfvars"
terraform apply -var-file="secret.tfvars"

## Outputs
See output.tf

When you want to create a new workspace but want to reuse the same vpc, public subnet, nat, igw, public routes.
Do the following
```
terraform import module.networking.aws_vpc.vpc <vpc-02093d47118a96895>
terraform import module.networking.aws_internet_gateway.ig <igw-042a7ee46a4f1d274>
terraform import module.networking.aws_nat_gateway.nat <nat-09994a76855896915>
terraform import module.networking.aws_eip.nat_eip <eipalloc-01aebd8931c497fe7>
terraform import module.networking.aws_security_group.default <sg-0cd3ef63bc6225e46>
terraform import 'module.networking.aws_subnet.public_subnet[0]' <subnet-0f694b63efea69175>
terraform import module.networking.aws_route_table.public <rtb-0a986f1973805db48>
terraform import module.networking.aws_route.public_internet_gateway <rtb-080a368238881e807_0.0.0.0/0>
terraform import 'module.networking.aws_route_table_association.public[0]' <'subnet-0f694b63efea69175/rtb-0a986f1973805db48'>
terraform import databricks_mws_credentials.this <accountid>/<credentialsid> # if you want to reuse credentials id
```
verify with
```
terraform state list
```

