#  https://github.com/nbering/terraform-provider-ansible
#  https://github.com/nbering/terraform-inventory/

# inventory_hostname - for ansible to identify hostname
# groups - of hosts the instance will belong to
# ansible_ssh_common_args - to tell Ansible to use SSH proxy
# privkey.pem - `terraform output private_key > privkey.pem`

resource "ansible_host" "BASTIONHOSTA" {
    inventory_hostname = "${aws_instance.BASTIONHOSTA.public_dns}"
    groups = ["security"]
    vars {
        ansible_user = "ubuntu"
        ansible_ssh_private_key_file="/opt/terraform/aws_basic/privkey.pem"
        ansible_python_interpreter="/usr/bin/python3"
    }
}

resource "ansible_host" "BASTIONHOSTB" {
  inventory_hostname = "${aws_instance.BASTIONHOSTB.public_dns}"
  groups = ["security"]
  vars
  {
      ansible_user = "ubuntu"
      ansible_ssh_private_key_file="/opt/terraform/aws_basic/privkey.pem"
      ansible_python_interpreter="/usr/bin/python3"
  }
}

resource "ansible_host" "WEB001" {
  inventory_hostname = "${aws_instance.WEBA.private_dns}"
  groups = ["web"]
  vars
  {
      ansible_user = "ubuntu"
      ansible_ssh_private_key_file="/opt/terraform/aws_basic/privkey.pem"
      ansible_python_interpreter="/usr/bin/python3"
      ansible_ssh_common_args= " -o ProxyCommand=\"ssh -i /opt/terraform/aws_basic/privkey.pem -W %h:%p -q ubuntu@${aws_instance.BASTIONHOSTA.public_dns}\""
      proxy = "${aws_instance.BASTIONHOSTA.private_ip}"
  }
}

resource "ansible_host" "WEB002" {
  inventory_hostname = "${aws_instance.WEBB.private_dns}"
  groups = ["web"]
  vars
  {
      ansible_user = "ubuntu"
      ansible_ssh_private_key_file="/opt/terraform/aws_basic/privkey.pem"
      ansible_python_interpreter="/usr/bin/python3"
      ansible_ssh_common_args= " -o ProxyCommand=\"ssh -i /opt/terraform/aws_basic/privkey.pem -W %h:%p -q ubuntu@${aws_instance.BASTIONHOSTB.public_dns}\""
      proxy = "${aws_instance.BASTIONHOSTB.private_ip}"
  }
}

resource "ansible_host" "SQL001" {
  inventory_hostname = "${aws_instance.SQLA.private_dns}"
  groups = ["db"]
  vars
  {
      ansible_user = "ubuntu"
      ansible_ssh_common_args= " -o ProxyCommand=\"ssh -i /opt/terraform/aws_basic/privkey.pem -W %h:%p -q ubuntu@${aws_instance.BASTIONHOSTA.public_dns}\""
      ansible_ssh_private_key_file="/opt/terraform/aws_basic/privkey.pem"
      ansible_python_interpreter="/usr/bin/python3"
      proxy = "${aws_instance.BASTIONHOSTA.private_ip}"
  }
}

resource "ansible_host" "SQL002" {
  inventory_hostname = "${aws_instance.SQLB.private_dns}"
  groups = ["db"]
  vars
  {
      ansible_user = "ubuntu"
      ansible_ssh_common_args= " -o ProxyCommand=\"ssh -i /opt/terraform/aws_basic/privkey.pem -W %h:%p -q ubuntu@${aws_instance.BASTIONHOSTB.public_dns}\""
      ansible_ssh_private_key_file="/opt/terraform/aws_basic/privkey.pem"
      ansible_python_interpreter="/usr/bin/python3"
      proxy = "${aws_instance.BASTIONHOSTB.private_ip}"
  }
}