# terraform-with-azure

## Install Terraform for Windows
1. [Download Terraform](https://www.terraform.io/downloads.html). This article was tested using Terraform version 1.1.4.

2. From the download, extract the executable to a directory of your choosing (for example, c:\terraform).

3. [Update your system's global path](https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows) to the executable.

4. Open a terminal in VS Code.

5. Verify the global path configuration with the terraform command.

         terraform -version

# Authenticate using the Azure CLI

Terraform must authenticate to Azure to create infrastructure.
In your terminal, use the Azure CLI tool to setup your account permissions locally.

    az login --tenant 'TenantID'

# set the account with the Azure CLI
Once you have chosen the account subscription ID, set the account with the Azure CLI.

    az account set --subscription "subscription-id"

# Create a Service Principal
create a Service Principal. A Service Principal is an application within Azure Active Directory with the authentication tokens Terraform needs to perform actions on your behalf. Update the <SUBSCRIPTION_ID> with the subscription ID you specified in the previous step.

    az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"

# Set your environment variables
HashiCorp recommends setting these values as environment variables rather than saving them in your Terraform configuration.

    $ $Env:ARM_CLIENT_ID = "<APPID_VALUE>"
    $ $Env:ARM_CLIENT_SECRET = "<PASSWORD_VALUE>"
    $ $Env:ARM_SUBSCRIPTION_ID = "<SUBSCRIPTION_ID>"
    $ $Env:ARM_TENANT_ID = "<TENANT_VALUE>"


# Write configuration for terraform
Create a folder called learn-terraform-azure.

    New-Item -Path "c:\" -Name "terraform-with-azure" -ItemType "directory"

Create a new file called main.tf and paste the configuration below.

# Configure the Azure provider
                    terraform {
                    required_providers {
                        azurerm = {
                        source  = "hashicorp/azurerm"
                        version = "~> 3.0.2"
                        }
                    }

                    required_version = ">= 1.1.0"
                    }

                    provider "azurerm" {
                    features {}
                    }

                    resource "azurerm_resource_group" "rg" {
                    name     = "myTFResourceGroup"
                    location = "westus2"
                    }

### In Above main.tf have three Blocks 
 1. Terraform :- Terraform settings, including the required providers Terraform will use to provision your infrastructure. 
2. Provider :- A provider is a plugin that Terraform uses to create and manage your resources
3. Resource := A resource might be a physical component such as a server, or it can be a logical resource such as a Heroku application

# Initialize your Terraform configuration
Initialize your learn-terraform-azure directory in your terminal

    terraform init

# Format and validate the configuration
We recommend using consistent formatting in all of your configuration files. The terraform fmt command automatically updates configurations in the current directory for readability and consistency.

    terraform fmt

Validate your configuration. The example configuration provided above is valid, so Terraform will return a success message

    terraform validate


# Apply your Terraform Configuration

Run the terraform apply command to apply your configuration
below comamnd will promt for your approval enter the value "yes"

    terraform apply

# Inspect your state
When you apply your configuration, Terraform writes data into a file called terraform.tfstate. This file contains the IDs and properties of the resources Terraform created so that it can manage or destroy those resources going forward

### Inspect the current state using terraform show.

    terraform show

To review the information in your state file, use the state command. If you have a long state file, you can see a list of the resources you created with Terraform by using the list subcommand

    terraform state list
