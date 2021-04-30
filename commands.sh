az group create --location westus2 --name rg

az policy definition create \
--name require-a-tag-on-vm \
--rules tagging-policy.json

az policy assignment create \
--policy require-a-tag-on-vm \
--display-name tagging-policy \
--name tagging-policy \
--resource-group rg

az policy assignment list -g rg

terraform plan -out vm.json
terraform apply "vm.json"
terraform show
terraform destroy
terraform show

az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
az account show --query "{ subscription_id: id }"

export BUILD_SUBSCRIPTION_ID=5bb35c36-233e-4b7e-afd9-a2b795899fb9
export BUILD_TENANT_ID=10e19cba-5b4d-42f0-a5b1-0e066efe7fe1
export BUILD_CLIENT_ID=1602080b-a9ab-4a0e-8442-bbf19b4fbd27
export BUILD_CLIENT_SECRET=fVDai19jQPl60L_xX-8bWeBek7Kdd72mx6

packer build server.json
az image list
az image delete -g packer-rg -n myPackerImage