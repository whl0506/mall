#!/usr/bin/env bash
app_name='mall-admin'

#将打包好的jar项目，移到/opt/data/build目录
#/var/jenkins_home/workspace/SpringBoot_AutoTest/target/jenkins-0.0.1-SNAPSHOT.jar构建好的jar路径
mv /var/jenkins_home/workspace/${app_name}/${app_name}/target/${app_name}-1.0-SNAPSHOT.jar /opt/data/build
#切换目录到/opt/data/build
cd /opt/data/build
#执行构建Dockerfile命令
docker build /var/jenkins_home/workspace/${app_name}/${app_name}/ -t ${app_name}

docker stop ${app_name}
echo '----stop container----'
docker rm ${app_name}
echo '----rm container----'
docker rmi `docker images | grep none | awk '{print $3}'`
echo '----rm none images----'
docker run -p 8080:8080 --name ${app_name} \
--link mysql:db \
--link redis:redis \
-e TZ="Asia/Shanghai" \
-v /etc/localtime:/etc/localtime \
-v /mydata/app/${app_name}/logs:/var/logs \
-d ${app_name}
echo '----start container----'