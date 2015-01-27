#!/bin/bash

# -------------------------------------------------------------------------------
# Filename:	compute_log_setting.sh
# Date:     	2014/10/22
# Author: 	Deliang Fan
# Discription:	This script allows you to setting the log level of openstack to
#               debug in compute node. In addition, it configures log setting
#               in logratate and crontab for the sake of better management of logs. 
#----------------------------------------------------------------------------------

# configure /etc/nova/nova.conf about log infomation
rm -rf /var/log/nova/sche*
rm -rf /var/log/nova/cond*
rm -rf /var/log/nova/api*
rm -rf /var/log/nova/compute.log-*
rm -rf /var/log/nova/network.log-*

configured=`cat /etc/nova/nova.conf |grep "debug=True"`
if [ -z "$configured" ]
then
    sed -i "3idebug=True" /etc/nova/nova.conf
fi

configured=`cat /etc/nova/nova.conf |grep "default_log_levels=amqplib=WARN"`
if [ -z "$configured" ]
then
    sed -i "3idefault_log_levels=amqplib=WARN,sqlalchemy=WARN,boto=WARN,suds=INFO,qpid.messaging=INFO,iso8601.iso8601=INFO" /etc/nova/nova.conf
fi


# configure /etc/logrotate.d/
rm -rf /etc/logrotate.d/openstack-*
OPENSTACK_LOGROTATE_DIR=/mnt/openstack_logrotate
mkdir -p $OPENSTACK_LOGROTATE_DIR

cat >$OPENSTACK_LOGROTATE_DIR/openstack <<EOF
/var/log/nova/compute.log{
    rotate 40
    missingok
    compress
    size 40M
    prerotate
    if [ -d $OPENSTACK_LOGROTATE_DIR ]; then \\
        run-parts $OPENSTACK_LOGROTATE_DIR ; \\
    fi; \\
    endscript
}
/var/log/nova/network.log{
    rotate 5
    missingok
    compress
    size 40M
    prerotate
    if [ -d $OPENSTACK_LOGROTATE_DIR ]; then \\
        run-parts $OPENSTACK_LOGROTATE_DIR ; \\
    fi; \\
    endscript
}
EOF
 
cat >/mnt/cron_logrotate.sh <<EOF
#!/bin/sh
/usr/sbin/logrotate $OPENSTACK_LOGROTATE_DIR/openstack >/dev/null 2>&1
EOF
 
chmod 755 /mnt/cron_logrotate.sh

configured=`cat /var/spool/cron/root |grep "/bin/bash /mnt/cron_logrotate.sh"` 
if [ -z "$configured" ]
then
cat >> /var/spool/cron/root <<EOF
*/30 * * * * /bin/bash /mnt/cron_logrotate.sh
EOF
fi
 
# first stop all service, in compute node, only compute and network will be started
SERVICES=`ls /etc/init.d/ |grep openstack`
START_SERVICES="openstack-nova-compute openstack-nova-network"
 
for openstack_service in $SERVICES
do
    service $openstack_service stop
done
 
for openstack_service in $START_SERVICES
do
    service $openstack_service start
done
 
service crond restart

echo "finish log setting!"
