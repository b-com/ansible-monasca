#!/bin/bash

declare -a role_archives

role_archives[0]='https://github.com/hpcloud-mon/ansible-zookeeper/archive/master.zip'
role_archives[1]='https://github.com/b-com/ansible-kafka/archive/master.zip'
role_archives[2]='https://github.com/b-com/ansible-influxdb/archive/master.zip'
role_archives[3]='https://github.com/b-com/ansible-monasca-schema/archive/master.zip'
role_archives[4]='https://github.com/hpcloud-mon/ansible-storm/archive/master.zip'
role_archives[5]='https://github.com/b-com/ansible-monasca-api/archive/master.zip'
role_archives[6]='https://github.com/hpcloud-mon/ansible-monasca-persister/archive/master.zip'
role_archives[7]='https://github.com/hpcloud-mon/ansible-monasca-thresh/archive/master.zip'
role_archives[8]='https://github.com/hpcloud-mon/ansible-monasca-notification/archive/master.zip'
role_archives[9]='https://github.com/b-com/ansible-monasca-agent/archive/master.zip'
role_archives[10]='https://github.com/b-com/ansible-monasca-keystone/archive/master.zip'
role_archives[11]='https://github.com/b-com/ansible-monasca-ui/archive/master.zip'
role_archives[12]='https://github.com/hpcloud-mon/ansible-percona/archive/master.zip'

for role in ${role_archives[@]}; do
	role_name=`echo ${role} | cut -d'/' -f5`
	echo 'upload ' ${role_name} 'archive'
	wget ${role}
	unzip 'master.zip'
	mv ${role_name}-master ${role_name}
	rm 'master.zip'
done