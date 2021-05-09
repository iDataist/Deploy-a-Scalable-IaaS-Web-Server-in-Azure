# policy
az group create \
--location westus2 \
--name 20210509group

az policy definition create \
--name tagging-policy \
--rules tagging-policy.json

az policy assignment create \
--policy tagging-policy \
--display-name tagging-policy \
--name tagging-policy \
--resource-group 20210509group

az policy assignment list -g 20210509group

# packer
az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
az account show --query "{ subscription_id: id }"

export BUILD_SUBSCRIPTION_ID=
export BUILD_TENANT_ID=
export BUILD_CLIENT_ID=
export BUILD_CLIENT_SECRET=

packer build server.json 
az image list
# az image delete -g 20210509group -n Ubuntu18.04

# terraform
terraform init
terraform plan -out plan.json
terraform apply "plan.json"
terraform show
terraform destroy
terraform show
