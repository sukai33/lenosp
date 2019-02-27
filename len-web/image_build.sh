#!/bin/bash
#删除原有lenosp镜像
docker rmi len-web:1.0-SNAPSHOT
docker rmi swr.cn-north-1.myhuaweicloud.com/lenosp/len-web:$1
#将parent、model、utils、common基础工程打包，上传到maven本地仓库
mvn -f ../len-core/pom.xml install
mvn -f ../len-sys/pom.xml install
mvn -f ../len-blog/pom.xml install
mvn -f ../len-activiti/pom.xml install
mvn -f ../len-web/pom.xml install
#使用maven插件构建docker镜像
mvn -f pom_docker.xml clean package -DskipTests docker:build
#修改镜像的组织名，以便推送到个人组织内，注意这里xc-edu-01是新添加的组织名
docker tag len-web:1.0-SNAPSHOT swr.cn-north-1.myhuaweicloud.com/lenosp/len-web:$1
#执行docker push 将本地服务器上的镜像推送到云平台镜像仓库
docker push swr.cn-north-1.myhuaweicloud.com/lenosp/len-web:$1