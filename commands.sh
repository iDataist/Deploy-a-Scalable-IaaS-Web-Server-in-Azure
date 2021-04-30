# policy
az group create \
--location westus2 \
--name rg

az policy definition create \
--name require-a-tag-on-vm \
--rules tagging-policy.json

az policy assignment create \
--policy require-a-tag-on-vm \
--display-name tagging-policy \
--name tagging-policy \
--resource-group rg

az policy assignment list -g rg

# packer
az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
az account show --query "{ subscription_id: id }"

export BUILD_SUBSCRIPTION_ID=5bb35c36-233e-4b7e-afd9-a2b795899fb9
export BUILD_TENANT_ID=10e19cba-5b4d-42f0-a5b1-0e066efe7fe1
export BUILD_CLIENT_ID=27eec4e2-4735-42ac-bc65-7e7782f18835
export BUILD_CLIENT_SECRET=Lso7x-InVHvxioB4LrjhKCnDf7R0JjzXwG

packer build server.json
az image list
az image delete -g rg -n Ubuntu18.04

# terraform
# image_resource_id = "/subscriptions/5bb35c36-233e-4b7e-afd9-a2b795899fb9/resourceGroups/rg/providers/Microsoft.Compute/images/Ubuntu18.04"
terraform init
terraform plan -out vm.json
terraform apply "vm.json"
terraform show
terraform destroy
terraform show
