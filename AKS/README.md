# Create a Kubernetes cluster with Azure Kubernetes Service using Terraform

Article tested with the following Terraform and Terraform provider versions:

[Terraform v1.1.7](https://releases.hashicorp.com/terraform/)
[AzureRM Provider v.2.99.0](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

Azure Kubernetes Service (AKS) manages your hosted Kubernetes environment. AKS allows you to deploy and manage containerized applications without container orchestration expertise. AKS also enables you to do many common maintenance operations without taking your app offline. These operations include provisioning, upgrading, and scaling resources on demand.

In this article, you learn how to:

* Use HCL (HashiCorp Language) to define a Kubernetes cluster
* Use Terraform and AKS to create a Kubernetes cluster
* Use the kubectl tool to test the availability of a Kubernetes cluster

# 1. Configure your environment

* <b>Azure subscription</b>: If you don't have an Azure subscription, create a free account before you begin.
* <b>Configure Terraform</b>: If you haven't already done so, configure Terraform using one of the following options:

        * [Configure Terraform in Windows with PowerShell](https://github.com/GhanshamMahajan/terraform-with-azure/blob/main/README.md)

* <b>Azure service principal</b>: If you don't have a service principal, [create a service principal](https://docs.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure#create-a-service-principal). Make note of the appId, display_name, password, and tenant.

* <b>Service principal object ID</b>: Run the following command to get the object ID of the service principal: az ad sp list --display-name "<display_name>" --query "[].{\"Object ID\":objectId}" --output table

* <b>SSH key pair</b>: Use one of the following articles:

# 2. Configure Azure storage to store Terraform state

Terraform tracks state locally via the terraform.tfstate file. This pattern works well in a single-person environment. However, in a more practical multi-person environment, you need to track state on the server using Azure storage. In this section, you learn to retrieve the necessary storage account information and create a storage container. The Terraform state information is then stored in that container.

1. Use one of the following options to create an Azure storage account:

[Create a storage account (via the Azure portal)](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal)
[Create a storage account (via Azure CLI)](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-cli)
[Create a storage account (via Azure PowerShell)](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-powershell)

2. Browse to the [Azure portal](https://portal.azure.com/).

3. Under Azure services, select Storage accounts. (If the Storage accounts option isn't visible on the main page, select More services to locate the option.)

4. On the Storage accounts page, On the Storage accounts page, select the storage account where Terraform will store the state information

5. On the Storage account page, in the left menu, in the Security + networking section, select Access keys.

https://docs.microsoft.com/en-us/azure/developer/terraform/media/create-k8s-cluster-with-tf-and-aks/access-keys-menu-option.png


6. On the Access keys page, select Show keys to display the key values.


https://docs.microsoft.com/en-us/azure/developer/terraform/media/create-k8s-cluster-with-tf-and-aks/show-keys-option.png


7. Locate the key1 key on the page and select the icon to its right to copy the key value to the clipboard.

https://docs.microsoft.com/en-us/azure/developer/terraform/media/create-k8s-cluster-with-tf-and-aks/copy-key-value.png

8. From a command line prompt, run az storage container create. This command creates a container in your Azure storage account. Replace the placeholders with the appropriate values for your Azure storage account.

        az storage container create -n tfstate --account-name <storage_account_name> --account-key <storage_account_key>

9. When the command successfully completes, it displays a JSON block with a key of "created" and a value of true. You can also run az storage container list to verify the container was successfully created.

        az storage container list --account-name <storage_account_name> --account-key <storage_account_key>

# 3. Implement the Terraform code

1. Create a directory in which to test the sample Terraform code and make it the current directory.

2. Create a file named providers.tf and insert the file code.

3. Create a file named main.tf and insert the file code:

4. Create a file named variables.tf and insert the file code:

5. Create a file named output.tf and insert the file code.

6. Create a file named terraform.tfvars and insert the file code.

        aks_service_principal_app_id = "<service_principal_app_id>"

        aks_service_principal_client_secret = "<service_principal_password>"

        aks_service_principal_object_id = "<service_principal_object_id>"

<b>Key points</b>:
* Set aks_service_principal_app_id to the service principal appId value.
* Set aks_service_principal_client_secret to the service principal password value.
* Set aks_service_principal_object_id to the service principal object ID. (The Azure CLI command for obtaining this value is in the [Configure your environment](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks#1-configure-your-environment) section.)

# 4. Initialize Terraform

Run [terraform init](https://www.terraform.io/docs/commands/init.html) to initialize the Terraform deployment. This command downloads the Azure modules required to manage your Azure resources.

        terraform init

# 5. Create a Terraform execution plan

Run [terraform plan](https://www.terraform.io/docs/commands/plan.html) to create an execution plan.

        terraform plan -out main.tfplan

<b>Key points</b>:

* The terraform plan command creates an execution plan, but doesn't execute it. Instead, it determines what actions are necessary to create the configuration specified in your configuration files. This pattern allows you to verify whether the execution plan matches your expectations before making any changes to actual resources.

* The optional -out parameter allows you to specify an output file for the plan. Using the -out parameter ensures that the plan you reviewed is exactly what is applied.

* To read more about persisting execution plans and security, see the [security warning section](https://www.terraform.io/docs/commands/plan.html#security-warning).


# 6. Apply a Terraform execution plan

Run [terraform apply](https://www.terraform.io/docs/commands/apply.html) to apply the execution plan to your cloud infrastructure.

        terraform apply main.tfplan

<b>Key points:</b>

* The terraform apply command above assumes you previously ran terraform plan -out main.tfplan.
* If you specified a different filename for the -out parameter, use that same filename in the call to terraform apply.
* If you didn't use the -out parameter, simply call terraform apply without any parameters.


# 7. Verify the results

* Get the resource group name.

        echo "$(terraform output resource_group_name)"

2. Browse to the [Azure portal](https://portal.azure.com/)

3. Under Azure services, select Resource groups and locate your new resource group to see the following resources created in this demo:

<b>Log Analytics Solution</b>: By default, the demo names this solution ContainerInsights. The portal will show the solutions workspace in parenthesis.
<b>Log Analytics Workspace</b>: By default, the demo names this workspace with a prefix of <b>TestLogAnalyticsWorkspaceName-</b> followed by a random number.
<b>Kubernetes service</b>: By default, the demo names this service <b>k8stest</b>. (A Managed Kubernetes Cluster is also known as an AKS / Azure Kubernetes Service.)

4. Get the Kubernetes configuration from the Terraform state and store it in a file that kubectl can read.

        echo "$(terraform output kube_config)" > ./azurek8s

5. Verify the previous command didn't add an ASCII EOT character.

        cat ./azurek8s

<b>*Key points</b>:

* If you see << EOT at the beginning and EOT at the end, edit the content of the file to remove these characters. Otherwise, you could receive the following error message: error: error loading config file "./azurek8s": yaml: line 2: mapping values are not allowed in this context

6. Set an environment variable so that kubectl picks up the correct config.

        export KUBECONFIG=./azurek8s

7. Verify the health of the cluster.

        kubectl get nodes

<b>Key points</b>:

* When the AKS cluster was created, monitoring was enabled to capture health metrics for both the cluster nodes and pods. These health metrics are available in the Azure portal. For more information on container health monitoring, see [Monitor Azure Kubernetes Service health](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-overview).
* Several key values were output when you applied the Terraform execution plan. For example, the host address, AKS cluster user name, and AKS cluster password are output.
* To view all of the output values, run terraform output.
* To view a specific output value, run echo "$(terraform output <output_value_name>)".

