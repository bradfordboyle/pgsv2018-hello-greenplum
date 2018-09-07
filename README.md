# Single Node Demo

## Terraform a GCP Compute Instance

For this demo, we are using `terraform` to provisiong a Google Cloud Platform Compute Instance.
If you plan to use these terraform files, substitute appropriate values for `GOOGLE_APPLICATION_CREDENTIALS` and `TF_VAR_project_id`.

```sh
export GOOGLE_APPLICATION_CREDENTIALS="./terraform-account.json"
export TF_VAR_project_id="data-sandbox-bboyle"

terraform init google
terraform apply google

# TODO use a dynamic inventory
jq -r '.modules[0].outputs."ip-address".value' \
    terraform.tfstate >! playbook-greenplum-singlenode/development
```

## Setup w/ Ansible

If you followed the previous section then you should be ready to run the following command.
If you did not use `terraform` to provision your server, be sure to add its IP address to "playbook-greenplum-singlenode/development".
This demo assumes a base operating system of Ubuntu 16.04.

```sh
ansible-playbook -i playbook-greenplum-singlenode/development playbook-greenplum-singlenode/site.yml
```

This playbook takes care of

- updating software
- installing the Greenplum OSS PPA
- creating a gpadmin user
- configuring Greenplum
- initializing & starting Greenplum

The sequnece of taks is minimal and should not be used for a production system.

## Use Greenplum

```sh
source /opt/gpdb/greenplum_path.sh

createdb world
nohup gpfdist > gpfdist.log
psql world
```

```sql
\i /home/gpadmin/world.sql


-- just count all cities
EXPLAIN
SELECT COUNT(*) AS cities
  FROM city;


-- join cities and countries
EXPLAIN
SELECT COUNT(*) AS cities
  FROM city ci, country co
 WHERE ci.countrycode = co.code;


-- populate external file with city data (export data)
COPY city TO '/home/gpadmin/city.csv' WITH csv;



-- read from external file, using the file:// protocol
SELECT *
  FROM city_read_file;

SELECT COUNT(*) AS cities
  FROM city_read_file;


-- read from external file, using the gpfdist:// protocol
SELECT *
  FROM city_read_gpfdist;

SELECT COUNT(*) AS cities
  FROM city_read_gpfdist;
```

## Tear it Down

```sh
terraform destroy google
```
