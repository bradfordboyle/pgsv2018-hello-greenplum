# Single Node Demo

## Terraform a GCP Compute Instance

```sh
export GOOGLE_APPLICATION_CREDENTIALS="./terraform-account.json"
export TF_VAR_project_id="data-sandbox-bboyle"

terraform init google
terraform apply google

# TODO use a dynamic inventory
jq -r '.modules[0].outputs."ip-address".value' \
    terraform.tfstate > playbook-greenplum-singlenode/development
```

## Setup w/ Ansible

```sh
ansible-playbook -i playbook-greenplum-singlenode/development playbook-greenplum-singlenode/site.yml
```

## Use Greenplum

```sh
source /opt/gpdb/greenplum_path.sh
gpssh-exkeys -f hostlist_singlenode
gpinitsystem -a -c gpinitsystem_singlenode

createdb gpadmin
```

## Tear it Down

```sh
terraform destroy google
```
