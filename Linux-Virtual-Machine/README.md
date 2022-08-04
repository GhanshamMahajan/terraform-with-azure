Article tested with the following Terraform and Terraform provider versions

    Terraform v1.1.0
    AzureRM Provider v.2.65

This github code shows you how to create a complete Linux environment and supporting resources with Terraform. Those resources include a virtual network, subnet, public IP address, and more.

To Build the VM we have to create below resources

* Create a Resource Group
* Create a virtual network
* Create a subnet
* Create a network security group and SSH inbound rule
* Assign NSG to Subnet
* Create network interface
* Create a public IP address
* Create Availability Set
* Create a storage account for boot diagnostics
* Create SSH key
* Create a virtual machine

# Prerequisites

* <b>Azure subscription</b>: If you don't have an Azure subscription, create a free account before you begin.
* <b>Configure Terraform</b>: If you haven't already done so, configure Terraform using one of the following options:

    * [Configure Terraform in Windows with PowerShell](https://github.com/GhanshamMahajan/terraform-with-azure/blob/main/README.md)
    
# Implement the Terraform code

1. Create a directory in which to test the sample Terraform code and make it the current directory.

2. Create a file named providers.tf and insert the provided.tf file code:

3. Create a file named main.tf and insert the main.tf file code:

4. Create a file named variables.tf and insert the file code:

5. Create a file named output.tf and insert the file code:

# Initialize Terraform

Run [terraform init](https://www.terraform.io/docs/commands/init.html) to initialize the Terraform deployment. This command downloads the Azure modules required to manage your Azure resources.

    terraform init

# Create a Terraform execution plan

Run [terraform plan](https://www.terraform.io/docs/commands/plan.html) to create an execution plan.

<b>Key points</b>:

* The terraform plan command creates an execution plan, but doesn't execute it. Instead, it determines what actions are necessary to create the configuration specified in your configuration files. This pattern allows you to verify whether the execution plan matches your expectations before making any changes to actual resources.

* The optional -out parameter allows you to specify an output file for the plan. Using the -out parameter ensures that the plan you reviewed is exactly what is applied.

* To read more about persisting execution plans and security, see the [security warning section](https://www.terraform.io/docs/commands/plan.html#security-warning)

# Apply a Terraform execution plan

Run [terraform apply](https://www.terraform.io/docs/commands/apply.html) to apply the execution plan to your cloud infrastructure.

    terraform apply main.tfplan

<b>Key points</b>:

* The terraform apply command above assumes you previously ran terraform plan -out main.tfplan.

* If you specified a different filename for the -out parameter, use that same filename in the call to terraform apply.

* If you didn't use the -out parameter, simply call terraform apply without any parameters.


# Verify the results

To use SSH to connect to the virtual machine, do the following steps:

1. Run [terraform output](https://www.terraform.io/cli/commands/output) to get the SSH private key and save it to a file.

        terraform output -raw tls_private_key > id_rsa

2. Run terraform output to get the virtual machine public IP address.

        terraform output public_ip_address

3. Use SSH to connect to the virtual machine.

        ssh -i id_rsa azureuser@<public_ip_address>

