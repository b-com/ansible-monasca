# ansible-monasca
This project contains an Ansible playbook you can use to deploy quickly the [Monasca](https://wiki.openstack.org/wiki/Monasca) solution on a unique server (except to Monasca Agent which will be deployed on monitored servers), for OpenStack.

This **monasca.yml** playbook references several Ansible roles which are not part of this project. You will have to upload each role from a dedicated Github repository before running this playbook.


## Requirements
* You must use ansible >=1.9.2 to run this playbook.
* An OpenStack platform deployed (with Horizon UI)
* Upload Ansible Monasca roles archives:

  | role                          | Github URL                                                        |
  -------------------------------|--------------------------------------------------------------------|
  | ansible-zookeeper             | https://github.com/hpcloud-mon/ansible-zookeeper/archive/master.zip|
  | ansible-kafka                 | https://github.com/b-com/ansible-kafka/archive/master.zip|
  | ansible-influxdb              | https://github.com/b-com/ansible-influxdb/archive/master.zip|
  | ansible-monasca-schema        | https://github.com/b-com/ansible-monasca-schema/archive/master.zip|
  | ansible-storm                 | https://github.com/hpcloud-mon/ansible-storm/archive/master.zip|
  | ansible-monasca-api           | https://github.com/b-com/ansible-monasca-api/archive/master.zip|
  | ansible-monasca-persister     | https://github.com/hpcloud-mon/ansible-monasca-persister/archive/master.zip|
  | ansible-monasca-thresh        | https://github.com/hpcloud-mon/ansible-monasca-thresh/archive/master.zip|
  | ansible-monasca-notification  | https://github.com/hpcloud-mon/ansible-monasca-notification/archive/master.zip|
  | ansible-monasca-agent         | https://github.com/b-com/ansible-monasca-agent/archive/master.zip|
  | ansible-monasca-kesytone      | https://github.com/b-com/ansible-monasca-kesytone/archive/master.zip|
  | ansible-monasca-ui            | https://github.com/b-com/ansible-monasca-ui/archive/master.zip|

  You can upload each Ansible role like this:
  ~~~~
  # cd ./roles
  # wget <role_url> 
  # unzip master.zip
  # mv <role_name>-master <role_name>
  ~~~~


## Create your *inventory* file

We provide a template file named **inventory.tmpl** you can use it to deploy Monasca within your infrastructure.
~~~~
# cp ./inventory.tmpl inventory
~~~~
In this inventory template file, we define 3 group names: **monasca-api**, **monasca-agent** and **monasca-ui**:
* monasca-api: group on which we will deploy Monasca API and Monasca backend component (kafka, zookeeper, influxdb, ...)
* monasca-agent: group on which we will deploy a Monasca Agent to collect host's monitoring metrics.
* monasca-ui: group on which the Horizon Monasca plugin and Grafana will be deployed


A classic configuration could be:
* We deploy the Monasca API on a dedicated server
* We deploy the Monasca UI on the OpenStack controller node (hosting Horizon app)
* We deploy Monasca Agent on all nodes

~~~~
[monasca_api]
monasca-host.b-com.com ansible_ssh_user=ubuntu

[monasca_api:vars]
monasca_api_host=monasca-host.b-com.com
keystone_host=crtl.openstack.b-com.com

[monasca_ui]
crtl.openstack.b-com.com ansible_ssh_user=ubuntu

[monasca_agent]
monasca-host1.b-com.com ansible_ssh_user=ubuntu
crtl.openstack.b-com.com ansible_ssh_user=ubuntu
compute1.openstack.b-com.com ansible_ssh_user=ubuntu
compute2.openstack.b-com.com ansible_ssh_user=ubuntu

[monasca_agent:vars]
keystone_host=crtl.openstack.b-com.com
~~~~



## Define your SSH Key
Ansible will connect to your hosts through a SSH session, so your hosts must have a SSH daemon running.
In your inventory file, set the SSH username you want to use, and use SSH key to connect to our hosts.
For more information, please have a look to [Ansible](http://docs.ansible.com/ansible/intro_inventory.html#list-of-behavioral-inventory-parameters) documentation.


## Update the common variables
The template file **common.yml.tmpl** contains list of common variables used by the different uploaded Ansible roles.
You have copy  and update it.

~~~~
# cp ./common.yml.tmpl common.yml
~~~~


## Run the playbook

To deploy your Monasca solution, you have just to run this command:
~~~~
# ansible-playbook -i inventory monasca.yml 
~~~~

## To get more ....
Yahoo Inc. has developed a tool to manage Apache Kafka named [Kafka Manager](https://github.com/yahoo/kafka-manager). A [docker container](https://hub.docker.com/r/sheepkiller/kafka-manager/) is available as well. You can run it by this way:

```
# docker run --net=host -d  -p 9000:9000 -e ZK_HOSTS="monasca-host.b-com.com:2181" -e APPLICATION_SECRET=letmein sheepkiller/kafka-manager

```

Open your favorite Internet browser on this URL: *http://127.0.0.1:9000*, and you will access to your Monasca Kafka monitoring UI.
