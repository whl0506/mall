#!/usr/bin/env bash
docker_registry='192.168.116.133:5000'
app_name='mall-search'
app_version='1.0-SNAPSHOT'

docker stop ${app_name}
echo '----stop container----'
docker rm  ${app_name}
echo '----rm container----'
docker rmi `docker images | grep none | awk '{print $3}'`
echo '----rm none images----'
docker run -p 8081:8081 --name ${app_name} \
--net=host \
--restart=always \
-e TZ="Asia/Shanghai" \
-v /etc/localtime:/etc/localtime \
-v /mydata/app/${app_name}/logs:/var/logs/${app_name} \
-d ${docker_registry}/${app_name}:${app_version}
echo '----start container----'
