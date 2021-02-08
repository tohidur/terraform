### Ansible
https://github.com/nbering/terraform-provider-ansible
https://github.com/nbering/terraform-inventory/

- inventory_hostname - for ansible to identify hostname
- groups - of hosts the instance will belong to
- ansible_ssh_common_args - to tell Ansible to use SSH proxy
- privkey.pem - `terraform output private_key > privkey.pem`

**Dynamic Inventory Script**
Directly reading from terraform state
`ansible db -m debug -a "var=hostvars[inventory_hostname]" -i /etc/ansible/terraform.py | less`

```shell
export ANSIBLE_TF_DIR="/opt/terraform/aws_basic/"
export ANSIBLE_PLAYBOOK_DIR="/opt/ansible_plays/"
cd $ANSIBLE_TF_DIR
terraform apply -auto-approve -var envorinment=DEV -var application=APP001
terraform output private_key > privkey.pem
chmod 600 privkey.pem
cd $ANSIBLE_PLAYBOOK_DIR
ansible-playbook aws_basic.yml -i /etc/ansible/terraform.py
unset ANSIBLE_TF_DIR
unset ANSIBLE_PLAYBOOK_DIR
```