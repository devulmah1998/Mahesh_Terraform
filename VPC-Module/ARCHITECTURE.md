# AWS VPC Architecture

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                              AWS Region (us-east-1)                      │
│                                                                           │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    VPC (10.0.0.0/16)                             │   │
│  │                                                                   │   │
│  │  ┌────────────────────────┐      ┌────────────────────────┐    │   │
│  │  │  Availability Zone A   │      │  Availability Zone B   │    │   │
│  │  │                        │      │                        │    │   │
│  │  │  ┌──────────────────┐ │      │  ┌──────────────────┐ │    │   │
│  │  │  │  Public Subnet   │ │      │  │  Public Subnet   │ │    │   │
│  │  │  │  10.0.1.0/24     │ │      │  │  10.0.2.0/24     │ │    │   │
│  │  │  │                  │ │      │  │                  │ │    │   │
│  │  │  │  ┌────────────┐  │ │      │  │                  │ │    │   │
│  │  │  │  │ NAT Gateway│  │ │      │  │                  │ │    │   │
│  │  │  │  └─────┬──────┘  │ │      │  │                  │ │    │   │
│  │  │  └────────┼─────────┘ │      │  └──────────────────┘ │    │   │
│  │  │           │            │      │                        │    │   │
│  │  │           │            │      │                        │    │   │
│  │  │  ┌────────▼─────────┐ │      │  ┌──────────────────┐ │    │   │
│  │  │  │  Private Subnet  │ │      │  │  Private Subnet  │ │    │   │
│  │  │  │  10.0.11.0/24    │ │      │  │  10.0.12.0/24    │ │    │   │
│  │  │  │                  │ │      │  │                  │ │    │   │
│  │  │  │  [EC2 Instances] │ │      │  │  [EC2 Instances] │ │    │   │
│  │  │  │  [RDS Databases] │ │      │  │  [RDS Databases] │ │    │   │
│  │  │  └──────────────────┘ │      │  └──────────────────┘ │    │   │
│  │  └────────────────────────┘      └────────────────────────┘    │   │
│  │                                                                 │   │
│  │  ┌──────────────────────────────────────────────────────────┐ │   │
│  │  │              Internet Gateway                             │ │   │
│  │  └────────────────────────────┬─────────────────────────────┘ │   │
│  └───────────────────────────────┼───────────────────────────────┘   │
│                                   │                                    │
└───────────────────────────────────┼────────────────────────────────────┘
                                    │
                                    ▼
                              Internet
```

## Components

### 1. VPC (Virtual Private Cloud)
- **CIDR Block**: 10.0.0.0/16
- **DNS Hostnames**: Enabled
- **DNS Support**: Enabled
- Provides isolated network environment

### 2. Public Subnets (2)
- **Subnet 1**: 10.0.1.0/24 (AZ: us-east-1a)
- **Subnet 2**: 10.0.2.0/24 (AZ: us-east-1b)
- **Features**:
  - Auto-assign public IP enabled
  - Direct internet access via Internet Gateway
  - Hosts NAT Gateway, Load Balancers, Bastion hosts

### 3. Private Subnets (2)
- **Subnet 1**: 10.0.11.0/24 (AZ: us-east-1a)
- **Subnet 2**: 10.0.12.0/24 (AZ: us-east-1b)
- **Features**:
  - No public IP assignment
  - Internet access via NAT Gateway
  - Hosts application servers, databases

### 4. Internet Gateway (IGW)
- Enables communication between VPC and internet
- Attached to VPC
- Used by public subnets

### 5. NAT Gateway
- Deployed in public subnet (AZ-A)
- Enables private subnet resources to access internet
- Elastic IP attached
- High availability (AWS managed)

### 6. Route Tables

#### Public Route Table
```
Destination      Target
10.0.0.0/16      local
0.0.0.0/0        igw-xxxxx (Internet Gateway)
```
- Associated with public subnets
- Routes internet traffic to IGW

#### Private Route Table
```
Destination      Target
10.0.0.0/16      local
0.0.0.0/0        nat-xxxxx (NAT Gateway)
```
- Associated with private subnets
- Routes internet traffic to NAT Gateway

## Traffic Flow

### Inbound Traffic (Internet → Public Subnet)
```
Internet → Internet Gateway → Public Subnet → Resources
```

### Outbound Traffic (Public Subnet → Internet)
```
Resources → Public Subnet → Internet Gateway → Internet
```

### Outbound Traffic (Private Subnet → Internet)
```
Resources → Private Subnet → NAT Gateway → Internet Gateway → Internet
```

### Internal Traffic (VPC)
```
Any Subnet ↔ Any Subnet (within VPC)
```

## High Availability

- **Multi-AZ Deployment**: Resources spread across 2 availability zones
- **Redundancy**: Multiple subnets in different AZs
- **Fault Tolerance**: If one AZ fails, other AZ continues operating

## Security Layers

1. **Network ACLs** (Subnet level - stateless)
2. **Security Groups** (Instance level - stateful)
3. **Route Tables** (Control traffic routing)
4. **Private Subnets** (No direct internet access)

## Use Cases

### Public Subnets
- Web servers
- Load balancers
- NAT Gateways
- Bastion hosts

### Private Subnets
- Application servers
- Database servers
- Backend services
- Internal microservices

## Scalability

- Add more subnets in additional AZs
- Increase CIDR range if needed
- Add multiple NAT Gateways for higher throughput
- Deploy Auto Scaling Groups across subnets

## Cost Optimization

- **NAT Gateway**: ~$0.045/hour + data processing charges
- **Elastic IP**: Free when attached to running instance
- **Data Transfer**: Charges apply for data out to internet

**Optional**: Set `enable_nat_gateway = false` to save costs in dev/test environments
