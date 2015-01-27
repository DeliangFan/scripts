#!/bin/bash

# --------------------------------------------------------------------------
# Filename:	controller_log_setting.sh
# Date:     	2014/10/22
# Author: 	Deliang Fan
# Discription:	This script allows you to setting the log level of openstack
#               to debug in controller node. In addition, it configures log
#               setting in logratate and crontab for the sake of better 
#		management of logs. 
#---------------------------------------------------------------------------

# make log dir and log file
LOG_PATHS="/var/log/glance/ /var/log/keystone/"

for path in $LOG_PATHS
do
    component=`echo $path | awk -F '/' '{print $4}'`
    user=$component
    group=$component
    rm -rf $path
    mkdir -p  $path
    touch $path$component.log
    chown -R $user:$group $path
done

rm -rf /var/log/nova/api.log-* 
rm -rf /var/log/nova/scheduler.log-*
rm -rf /var/log/nova/conductor.log-*
rm -rf /var/log/nova/consoleauth.log-*

rm -rf /var/log/nova/cert*
rm -rf /var/log/nova/compute*
rm -rf /var/log/nova/network*
rm -rf /var/log/nova/console*

# configure /etc/$component/$component.conf about log infomation
CONFIGURE_FILES="/etc/nova/nova.conf /etc/glance/glance-api.conf /etc/glance/glance-registry.conf /etc/keystone/keystone.conf"

for file in $CONFIGURE_FILES
do
    component=`echo $file | awk -F '/' '{print $3}'`
	configured=`cat $file |grep "debug=True"`

    if [ -z "$configured" ]
    then
        sed -i "3idebug=True" $file
    fi

    if [[ ! $file =~ "nova" ]];then
        sed -i "3ilog_file=\/var\/log\/$component\/$component.log" $file
    fi
done

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
/var/log/glance/*.log {
    rotate 10
    missingok
    compress
    size 40M
    prerotate
    if [ -d $OPENSTACK_LOGROTATE_DIR ]; then \\
        run-parts $OPENSTACK_LOGROTATE_DIR ; \\
    fi; \\
    endscript
}
/var/log/keystone/*.log {
    rotate 10
    missingok
    compress
    size 40M
    prerotate
    if [ -d $OPENSTACK_LOGROTATE_DIR ]; then \\
        run-parts $OPENSTACK_LOGROTATE_DIR ; \\
    fi; \\
    endscript
}
/var/log/nova/api.log {
    rotate 10
    missingok
    compress
    size 40M
    prerotate
    if [ -d $OPENSTACK_LOGROTATE_DIR ]; then \\
        run-parts $OPENSTACK_LOGROTATE_DIR ; \\
    fi; \\
    endscript
}
/var/log/nova/scheduler.log {
    rotate 3
    missingok
    compress
    size 40M
    prerotate
    if [ -d $OPENSTACK_LOGROTATE_DIR ]; then \\
        run-parts $OPENSTACK_LOGROTATE_DIR ; \\
    fi; \\
    endscript
}
/var/log/nova/conductor.log {
    rotate 50
    missingok
    compress
    size 40M
    prerotate
    if [ -d $OPENSTACK_LOGROTATE_DIR ]; then \\
        run-parts $OPENSTACK_LOGROTATE_DIR ; \\
    fi; \\
    endscript
}
/var/log/nova/consoleauth.log {
    rotate 3
    missingok
    compress
    size 40M
    prerotate
    if [ -d $OPENSTACK_LOGROTATE_DIR ]; then \\
        run-parts $OPENSTACK_LOGROTATE_DIR ; \\
    fi; \\
    endscript
}
/var/log/nova/novncproxy.log {
    rotate 3
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

# service restart, first stop all service
INIT_DIR=/etc/init.d/
SERVICES=`ls $INIT_DIR |grep openstack`
START_SERVICES="openstack-keystone openstack-glance-api openstack-glance-registry openstack-nova-api openstack-nova-scheduler"
START_SERVICES=$START_SERVICES" openstack-nova-conductor openstack-nova-consoleauth openstack-nova-novncproxy"

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
