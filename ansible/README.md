## In inventory/hosts

- If deploy locally (for development, using Vagrant)
  - Replace the **ansible_port** value to the value of the ssh port of virtual machine
  (use `$ vagrant ssh-config` to show ssh configuration)

- If deploy to EC2 instance
  - Replace the **ansible_host** value to the value of "web_instance_ip" output
    from Terraform
