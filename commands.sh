# policy
az group create \
--location westus2 \
--name 20210430group

az policy definition create \
--name require-a-tag-on-vm \
--rules tagging-policy.json

az policy assignment create \
--policy require-a-tag-on-vm \
--display-name tagging-policy \
--name tagging-policy \
--resource-group 20210430group

az policy assignment list -g 20210430group

# packer
az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
az account show --query "{ subscription_id: id }"

export BUILD_SUBSCRIPTION_ID=5bb35c36-233e-4b7e-afd9-a2b795899fb9
export BUILD_TENANT_ID=10e19cba-5b4d-42f0-a5b1-0e066efe7fe1
export BUILD_CLIENT_ID=7c48bb82-7d2b-4682-8415-6436bfc00933
export BUILD_CLIENT_SECRET=Q03qG8ShBmIt-KVatTEP_SMOhB80V5WN3.

packer build server.json 
az image list
az image delete -g 20210430group -n Ubuntu18.04

# terraform
# image_resource_id = "/subscriptions/5bb35c36-233e-4b7e-afd9-a2b795899fb9/resourceGroups/20210430group/providers/Microsoft.Compute/images/Ubuntu18.04"
terraform init
terraform plan -out vm.json
terraform apply "vm.json"
terraform show
terraform destroy
terraform show
