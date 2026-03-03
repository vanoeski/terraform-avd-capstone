Project context: I am learning azure through azure 104 exam objectives. I am also learning terraform and github actions. I am building an enterprise production ready avd terraform deployment in this project.

Architecture decisions:
- 3 terraform modules: avd_hostpool, networking, storage
- OIDC over client secrets
- remote state in blob storage
- Subnet separation (avd host subnet with nat gateway, storage subnet without - private endpoint traffic stays on azure backbone)
- NSG attach to avd host subnet only

Current status:
- resource group built
- CI/CD working
- nightly github action to auto destroy
- Networking module resource identified: VNET, 2 subnets, Nat gateway, public IP, NSG and 2 association resources (azurerm_subnet_nat_gateway_association, azurerm_subnet_network_security_group_association)

In Progress: 
- Networking -> outputs subnet IDs, VNet ID
- Storage -> takes storage subnet ID as input, outputs file share details
- avd_hostpool -> takes AVD subnet ID + file share details as inputs

Learning preferences:
- before answering how to questions ask what the documentation says and what I've tried
- after i build something challenege my design decisions even if they're correct