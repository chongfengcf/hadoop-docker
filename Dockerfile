FROM ubuntu:18.04

MAINTAINER sxdsjy <https://github.com/chongfengcf/>


RUN apt-get update && apt-get install -y locales nano openssh-server wget&& rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

#配置ssh服务器
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

#免密登陆
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

#创建apps文件夹
RUN mkdir -p /root/apps
WORKDIR /root/apps
RUN mkdir -p /root/apps/hdfs/namenode
RUN mkdir -p /root/apps/hdfs/datanode

#配置环境变量
ENV JAVA_HOME=/root/apps/jdk8u222-b10
ENV HADOOP_HOME=/root/apps/hadoop-3.1.2
ENV PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

#复制安装包并解压
RUN wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10/OpenJDK8U-jdk_x64_linux_hotspot_8u222b10.tar.gz
RUN wget https://www-us.apache.org/dist/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz

RUN tar -xzvf OpenJDK8U-jdk_x64_linux_hotspot_8u222b10.tar.gz && \
    rm OpenJDK8U-jdk_x64_linux_hotspot_8u222b10.tar.gz

Run tar -xzvf hadoop-3.1.2.tar.gz && \
    rm hadoop-3.1.2.tar.gz

#复制配置文件
COPY config/* /tmp/
RUN mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/workers $HADOOP_HOME/etc/hadoop/workers && \
    mv /tmp/start-dfs.sh $HADOOP_HOME/sbin/start-dfs.sh && \
    mv /tmp/stop-dfs.sh $HADOOP_HOME/sbin/stop-dfs.sh && \
    mv /tmp/start-yarn.sh $HADOOP_HOME/sbin/start-yarn.sh && \
    mv /tmp/stop-yarn.sh $HADOOP_HOME/sbin/stop-yarn.sh

#增加可执行权限
RUN chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x $HADOOP_HOME/sbin/stop-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/stop-yarn.sh

#格式化namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

#每次打开容器自启动ssh服务
CMD [ "sh", "-c", "service ssh start; bash"]