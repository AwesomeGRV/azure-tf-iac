# Azure Infrastructure as Code - Production Ready Terraform

This repository contains a comprehensive, production-ready Terraform codebase for deploying Azure infrastructure following the Azure Well-Architected Framework, DevSecOps, and SRE best practices.

## Architecture Overview

This infrastructure deploys a complete Azure environment with the following components:

### Core Infrastructure
- **Resource Groups**: Organized by workload and layer
- **Virtual Network**: Private networking with multiple subnets
- **Azure Firewall**: Network security and traffic filtering
- **DDoS Protection**: Network-level protection

### Compute Resources
- **Azure Kubernetes Service (AKS)**: Container orchestration with availability zones
- **Virtual Machines**: Linux VMs in availability sets with managed identities
- **Availability Sets**: High availability for VM workloads

### Storage & Database
- **Storage Account**: Multiple storage types with private endpoints
- **MySQL Flexible Server**: Managed database with zone redundancy
- **Private Endpoints**: Secure access to storage and database

### Application Services
- **App Service**: Web application hosting with private endpoints
- **Function App**: Serverless compute with private endpoints
- **Application Insights**: Application performance monitoring
- **API Management**: API gateway and management with security policies
- **Azure CDN**: Content delivery and caching
- **Azure Front Door**: Global load balancing and WAF
- **Notification Hubs**: Push notifications for mobile and web apps
- **Cognitive Services**: AI/ML capabilities (optional)
- **Data Factory**: Data integration and ETL (optional)

### Security & Identity
- **Key Vault**: Secure secrets management with RBAC
- **Managed Identities**: Service-to-service authentication
- **Network Security Groups**: Micro-segmentation
- **Private DNS Zones**: Internal name resolution

### Monitoring & Operations
- **Log Analytics Workspace**: Centralized logging
- **Azure Monitor**: Metrics and alerting
- **Diagnostic Settings**: Resource-level logging
- **Action Groups**: Notification and automation

## Features

### Security
- Zero-trust network architecture
- Private endpoints for all PaaS services
- Managed identities instead of service principals
- Least-privilege RBAC assignments
- TLS 1.2+ enforcement
- Encryption at rest enabled

### Reliability
- Availability zones for supported services
- Zone-redundant storage and databases
- Health probes and auto-scaling
- Proper timeouts and retries
- Idempotent resource configuration

### Cost Management
- Comprehensive tagging strategy
- Right-sized resource SKUs
- Auto-scaling to optimize costs
- Monitoring for cost optimization

### Compliance
- Azure Policy integration ready
- Audit logging enabled
- Data classification tags
- Retention policies configured

## Prerequisites

### Required Tools
- Terraform >= 1.5.0
- Azure CLI >= 2.40.0
- Git

### Azure Permissions
- Subscription Owner or User Access Administrator
- Contributor role on target subscription
- Role assignments for managed identities

### Authentication
Configure Azure CLI authentication:
```bash
az login
az account set --subscription <subscription-id>
```

## Quick Start

### 1. Clone Repository
```bash
git clone <repository-url>
cd azure-tf-iac
```

### 2. Configure Variables
Copy the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your specific values:
```hcl
location = "East US"
environment = "production"
prefix = "mycompany"
admin_username = "azureadmin"
admin_ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan Deployment
```bash
terraform plan -var-file=terraform.tfvars
```

### 5. Apply Infrastructure
```bash
terraform apply -var-file=terraform.tfvars
```

### 6. Access Resources
After deployment, retrieve outputs:
```bash
terraform output
```

## Configuration

### Variables

#### Core Variables
- `location`: Azure region for deployment
- `environment`: Environment (dev/staging/production)
- `prefix`: Resource naming prefix
- `tags`: Resource tags for cost and ownership

#### Networking Variables
- `vnet_address_space`: Virtual network address space

#### Compute Variables
- `aks_node_count`: Number of AKS nodes
- `aks_vm_size`: VM size for AKS nodes
- `admin_username`: Admin username for VMs
- `admin_ssh_key`: SSH public key for VM access

#### Storage Variables
- `storage_account_tier`: Storage account tier (Standard/Premium)
- `storage_account_replication_type`: Replication type (LRS/ZRS/GZRS)
- `mysql_administrator_login`: MySQL admin username
- `mysql_sku_name`: MySQL server SKU

#### Application Variables
- `app_service_plan_sku`: App Service Plan SKU
- `function_app_sku`: Function App SKU
- `apim_sku_name`: API Management SKU name
- `apim_publisher_name`: API Management publisher name
- `apim_publisher_email`: API Management publisher email
- `cdn_sku_name`: CDN profile SKU name
- `front_door_sku_name`: Front Door SKU name
- `enable_waf`: Enable WAF on Front Door
- `notification_hub_sku`: Notification Hub SKU name
- `notification_hub_namespace`: Notification Hub namespace
- `cognitive_services_sku`: Cognitive Services SKU name
- `enable_cognitive_services`: Enable Cognitive Services
- `data_factory_sku`: Data Factory SKU name
- `enable_data_factory`: Enable Data Factory

#### Monitoring Variables
- `enable_monitoring`: Enable Azure Monitor and Log Analytics
- `log_retention_days`: Log retention period

### Outputs

The deployment provides comprehensive outputs for integration:

#### Network Outputs
- `vnet_id`, `vnet_name`: Virtual network information
- `firewall_public_ip`: Firewall public IP address
- Subnet IDs for integration

#### Compute Outputs
- `aks_cluster_name`, `aks_kube_config`: AKS cluster information
- `vm_names`, `vm_public_ips`: Virtual machine details
- SSH keys for VM access

#### Storage Outputs
- `storage_account_name`, `storage_account_primary_key`: Storage account credentials
- `mysql_server_fqdn`, `mysql_connection_string`: Database connection details

#### Security Outputs
- `key_vault_name`, `key_vault_uri`: Key Vault information
- Managed identity details

#### Application Outputs
- `app_service_default_hostname`: Web application URL
- `function_app_default_hostname`: Function App URL
- `api_management_gateway_url`: API Management gateway URL
- `api_management_portal_url`: API Management developer portal URL
- `cdn_endpoint_host_name`: CDN endpoint hostname
- `front_door_endpoint_host_name`: Front Door endpoint hostname
- `notification_hub_connection_string`: Notification Hub connection string
- `cognitive_services_endpoint`: Cognitive Services endpoint
- `data_factory_name`: Data Factory name

#### Monitoring Outputs
- `log_analytics_workspace_id`: Log Analytics workspace ID
- `application_insights_app_id`: Application Insights ID

## Module Structure

```
modules/
├── networking/          # Virtual network, subnets, firewall, NSGs
├── security/            # Key Vault, managed identities, RBAC
├── compute/             # AKS, VMs, availability sets
├── storage-account/      # Storage account with containers and file shares
├── mysql/               # MySQL Flexible Server database
├── redis/               # Redis Cache for caching
├── sql-database/        # Azure SQL Database
├── applications/        # App Service, Function App
├── api-management/      # API Management service
├── cdn/                # Azure CDN for content delivery
├── front-door/         # Azure Front Door with WAF
├── notification-hubs/   # Push notifications
├── cognitive-services/   # AI/ML capabilities
├── data-factory/       # Data integration and ETL
└── monitoring/          # Azure Monitor, Log Analytics, alerts
```

### Networking Module
- Virtual network with multiple subnets
- Azure Firewall with DDoS protection
- Network security groups for micro-segmentation
- Route tables for traffic management
- Private DNS zones

### Security Module
- Key Vault with access policies
- User-assigned managed identities
- RBAC role assignments
- Network access controls

### Compute Module
- AKS cluster with Azure AD integration
- Virtual machines with availability sets
- SSH key generation
- Managed identity assignments

### Storage Account Module
- Storage account with multiple containers and file shares
- Blob, table, and queue storage
- Private endpoints for secure access
- Versioning and retention policies
- Diagnostic logging and metrics

### MySQL Module
- MySQL Flexible Server with zone redundancy
- Private endpoints and DNS zones
- High availability configuration
- Automated backup and maintenance windows
- Diagnostic logging and monitoring

### Redis Module
- Redis Cache for high-performance caching
- Private endpoints and DNS zones
- Data persistence and backup configuration
- Memory optimization policies

### SQL Database Module
- Azure SQL Database with auditing
- Private endpoints and DNS zones
- Threat detection and extended auditing
- Azure AD integration
- Diagnostic logging

### Applications Module
- App Service with private endpoints
- Function App with private endpoints
- Application Insights integration
- Managed identities for services
- Service Bus queues and topics
- Event Grid subscriptions

### API Management Module
- API gateway with security policies and rate limiting
- Developer portal for API documentation
- Private endpoints and DNS zones
- Integration with Key Vault for secrets
- Diagnostic logging and monitoring

### CDN Module
- Azure CDN profile with compression
- Content delivery optimization
- Integration with App Service origins
- Diagnostic logging and metrics

### Front Door Module
- Global load balancing and traffic routing
- Web Application Firewall (WAF) protection
- Health probes and failover
- SSL/TLS termination
- Custom rules for SQL injection and rate limiting

### Notification Hubs Module
- Push notifications for mobile and web apps
- Multi-platform support (iOS, Android, Windows)
- Scalable messaging infrastructure
- Connection string management

### Cognitive Services Module (Optional)
- AI/ML capabilities for various services
- Custom subdomain configuration
- Network security with private endpoints
- Support for multiple cognitive services

### Data Factory Module (Optional)
- Data integration and ETL pipelines
- Managed identity for authentication
- Scalable data processing
- Integration with other Azure services

### Monitoring Module
- Log Analytics workspace
- Application Insights
- Metric alerts and action groups
- Diagnostic settings
- Autoscale configurations

## Best Practices Implemented

### Security
- Private networking by default
- No public access to PaaS services
- Managed identities for authentication
- Least-privilege RBAC
- Encryption at rest and in transit
- Network security groups with minimal rules

### Reliability
- Availability zones for high availability
- Zone-redundant storage and databases
- Health monitoring and alerting
- Auto-scaling capabilities
- Backup and retention policies

### Cost Optimization
- Right-sized resource SKUs
- Auto-scaling to match demand
- Comprehensive tagging
- Monitoring for cost alerts

### Operations
- Infrastructure as code
- Idempotent configurations
- Comprehensive monitoring
- Automated alerting
- Centralized logging

## Customization

### Adding New Resources
1. Create new module in `modules/` directory
2. Define variables, main configuration, and outputs
3. Reference module in root `main.tf`
4. Add outputs to root `outputs.tf`

### Modifying Existing Resources
1. Update relevant module files
2. Test with `terraform plan`
3. Apply changes with `terraform apply`

### Environment-Specific Configurations
Create separate variable files for different environments:
```bash
# Development
terraform apply -var-file=terraform.tfvars.dev

# Staging
terraform apply -var-file=terraform.tfvars.staging

# Production
terraform apply -var-file=terraform.tfvars.prod
```

## Maintenance

### Regular Tasks
- Review and update Terraform providers
- Monitor Azure service updates
- Review cost optimization opportunities
- Update security configurations
- Validate compliance requirements

### Backup and Recovery
- All infrastructure is codified in Terraform
- State files should be backed up to secure storage
- Key Vault secrets are backed up automatically
- Database backups are configured automatically

### Scaling
- AKS cluster can be scaled via node count or auto-scaling
- App Service can be scaled via plan upgrades
- Storage can be scaled via tier changes
- Database can be scaled via SKU changes

## Troubleshooting

### Common Issues

#### Terraform State Issues
```bash
# Refresh state
terraform refresh

# Import existing resources
terraform import <resource_type>.<resource_name> <resource_id>
```

#### Permission Issues
Ensure your Azure account has:
- Subscription Owner or User Access Administrator role
- Contributor role on target resource group
- Permissions to create managed identities

#### Network Connectivity
- Check firewall rules
- Verify private endpoint configurations
- Validate DNS zone settings
- Review NSG rules

#### Resource Limits
- Check subscription quotas
- Monitor resource group limits
- Verify regional availability

### Support
For issues with this codebase:
1. Check Azure documentation
2. Review Terraform provider documentation
3. Validate variable configurations
4. Test with minimal configuration

## Contributing

### Development Workflow
1. Create feature branch
2. Make changes in separate modules
3. Test with `terraform validate` and `terraform plan`
4. Update documentation
5. Submit pull request

### Code Standards
- Follow Terraform best practices
- Use consistent naming conventions
- Add comprehensive comments
- Include resource tags
- Implement proper dependencies

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Security

For security concerns or vulnerabilities:
- Report issues through private channels
- Do not commit sensitive information
- Use Azure Key Vault for secrets
- Follow security best practices

## Version History

- v1.0.0: Initial production-ready release
- Complete Azure infrastructure deployment
- Security and compliance features
- Monitoring and alerting capabilities
