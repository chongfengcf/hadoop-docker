# 使用docker容器构建Hadoop集群

## 使用到的软件
[docker](https://www.docker.com/get-started)  
[Ubuntu 18.04](https://ubuntu.com/)  
[Adoptopenjdk 8u222b10](https://adoptopenjdk.net/)  
[Hadoop 3.1.2](https://hadoop.apache.org/)

## STEP1 如何正确的创建容器
有两种方式可以帮助你快速的部署hadoop集群
### 第一种方式 直接下载镜像
1. 下载并安装docker
2. 下载本项目到本地
> git clone https://github.com/chongfengcf/hadoop-docker.git
3. 进入项目文件夹
> cd hadoop-docker
4. 自动拉取并创建镜像
> docker-compose up -d

### 第二种方式 自行编译镜像
1. 下载并安装docker
2. 下载本项目到本地
> git clone https://github.com/chongfengcf/hadoop-docker.git
3. 进入项目文件夹
> cd hadoop-docker
4. 开始编译镜像
> docker build --rm -t chongfengcf/hadoop-docker .
5. 依照镜像创建三个容器
> docker run -itd --net=hadoop -p 9870:9870 -p 8088:8088 -p 19888:19888 --name hadoop01 --hostname hadoop01 chongfengcf/hadoop-docker

> docker run -itd --net=hadoop --name hadoop02 --hostname hadoop02 chongfengcf/hadoop-docker

> docker run -itd --net=hadoop --name hadoop03 --hostname hadoop03 chongfengcf/hadoop-docker

## STEP2 如何正确的启动HADOOP集群
1. 进入Hadoop01的容器
> docker exec -it hadoop01 bash
2. 启动hdfs
> start-dfs.sh
3. 启动yarn
> start-yarn.sh
4. 测试
> hadoop jar /root/apps/hadoop-3.1.2/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.2.jar pi 6 1000
5. 在浏览器访问hadoop  
localhost:9870  
localhost:8088  
