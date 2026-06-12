# AWS Windows Server 2022 Infrastructure with Terraform

This project provisions a complete Windows Server 2022 infrastructure on AWS using Terraform, including Active Directory Domain Services configuration, Group Policy Objects, and automated scheduled tasks.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Modules](#modules)
- [Deployment Guide](#deployment-guide)
- [Post-Deployment Configuration](#post-deployment-configuration)
- [Connecting to the Server](#connecting-to-the-server)
- [Useful Commands](#useful-commands)
- [Troubleshooting](#troubleshooting)
- [Clean Up](#clean-up)
- [Cost Estimates](#cost-estimates)

## 🏗 Architecture Overview

This infrastructure deploys:

- **Windows Server 2022 EC2 Instance** (t3.medium)
- **Default VPC** with automatic public subnet assignment
- **Security Group** allowing RDP access (port 3389)
- **S3 Bucket** with versioning and encryption
- **Active Directory Domain Services** (post-deployment)
- **Auto-launch Notepad GPO** (user logon)
- **Daily Reboot Scheduled Task** (3:00 AM)

## 📝 Prerequisites

### Required Tools

| Tool | Version | Installation |
|------|---------|--------------|
| Terraform | >= 1.5.0 | [Download](https://developer.hashicorp.com/terraform/downloads) |
| AWS CLI | >= 2.0 | [Download](https://aws.amazon.com/cli/) |
| PowerShell | 5.1+ | Windows built-in |

### AWS Requirements

- AWS account with administrative privileges
- AWS CLI configured with credentials:
  ```bash
  aws configure