## volume-to-droplet-mount

#### Purpose

This Terraform deployment will set up **n** number of Droplets, the same number of block storage volumes, then attach, format, and mount each block device. Provisioning will be handled by Terraform and configuration will be done with Ansible.

#### Prerequisites

* You'll need to install [Terraform](https://www.terraform.io/downloads.html) which will be used to handle Droplet provisioning.
* In order to apply configuration changes to the newly provisioned Droplets, [Ansible](http://docs.ansible.com/ansible/intro_installation.html) needs to be installed.
* Ansible's inventory will be handled by Terraform, so you'll need [terraform-inventory](https://github.com/adammck/terraform-inventory).
* We're going to need a DigitalOcean API key. The steps to generate a DigitalOcean API key can be found [here](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2#how-to-generate-a-personal-access-token).

#### Configuring

Let's get Terraform ready to deploy. We're going to be using **terraform.tfvars** to store values required such as API key, project name, SSH data, the number of nodes you want, etc. The sample file **terraform.tfvars.sample** has been supplied, just remember to remove the appended _.sample_. Once you have your all of the variables set, Terraform should be able to authenticate and deploy your Droplets.

Next we need to get Ansible set up by heading over to **group\_vars/all**. You can rename **vars.sample** to just **vars** and open it for editing. This is where you'll configure your mount directory, and directory owner, and block device.

Okay, now everything should be set up and you're ready to start provisioning and configuring your Droplets.

#### Deploying

We'll start by using Terraform. Make sure you head back to the repository home. You can run a quick check and create an execution plan by running `terraform plan`.

If everything looks correct, use `terraform apply` to build the Droplets and block storage volumes. This should take about a minute or two depending on how many nodes you're spinning up. Once it finishes up, wait about 30 seconds for the cloud-config commands that were passed in to complete.

We're ready to begin configuring the Droplets. Execute the Ansible playbook to configure your Droplets by running the following

    ansible-playbook -i /usr/local/bin/terraform-inventory site.yml

This playbook will run the *blockstore_config* role. You should see a steady output which will state the role and step at which Ansible is currently running. If there are any errors, you can easily trace it back to the correct role and section of the task.

#### Follow-up steps

At this point, you will have **n** Droplets with the same amount of block storage devices attached, formatted, and mounted. If you already have Droplets provisioned, you can import them into Terraform, as well as create an image from it and use the image ID to spin up additional nodes. Any additional configuration can simple by done by creating a simple Ansible role, or modifying the existing one.
