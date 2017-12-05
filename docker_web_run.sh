#!/bin/bash
#文件的换行模式要选UNIX风格的LF,不然脚本执行会出错!
#如果读不到环境变量RUN_CONTEXT，默认设为dev
if [ -z $RUN_CONTEXT ]; then
    RUN_CONTEXT='dev'
    echo "export RUN_CONTEXT=${RUN_CONTEXT}" >> ${HOME}/.bashrc
fi

#使设置的环境变量即时生效
source ~/.bashrc

if [ "$RUN_CONTEXT" = "prod" ]; then
    echo "root:POloXM1980!@&" | chpasswd
    #设置ssh密码,密码为环境变量ROOT_PASSWD的值,如果环境变量ROOT_PASSWD没有设,则指定一个默认密码
    if [ $ROOT_PASSWD ]; then
        echo "root:$ROOT_PASSWD" | chpasswd
    fi
    #启动sshd
    /usr/sbin/sshd
    #启动rsyslog
    /etc/init.d/rsyslog start
    #启动cron
    /etc/init.d/cron start
     #执行assets:precompile
    RAILS_ENV=production bundle exec rake assets:precompile
    #执行db:migrate
    RAILS_ENV=production bundle exec rake db:migrate

    whenever -i --set environment=production

    #启动rails
    passenger start
else
    echo "unknown RUN_CONTEXT:${RUN_CONTEXT}"
fi





