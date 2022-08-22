#Untar the complete hadoop-2.7.1 package and move to the common directory and give the respective permissions
wget -c https://archive.apache.org/dist/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz -p ~/install/
mv ~/Downloads/hadoop-2.7.1/hadoop-2.7.1.tar.gz ~/install/
cd /home/hduser/install/
echo hduser | sudo -S rm -rf hadoop-2.7.1 /usr/local/hadoop
echo hduser | sudo -S rm -rf hadoop-2.7.1 /usr/local/hadoop_store
tar xvzf hadoop-2.7.1.tar.gz
echo hduser | sudo -S mv hadoop-2.7.1 /usr/local/hadoop
echo hduser | sudo -S chown -R hduser:hadoop /usr/local/hadoop

#Create the following Directories for hadoop temporary files, namenode metadata, datanode data and secondary namenode metadata
echo hduser | sudo -S mkdir -p /usr/local/hadoop_store/tmp
echo hduser | sudo -S mkdir -p /usr/local/hadoop_store/hdfs/namenode
echo hduser | sudo -S mkdir -p /usr/local/hadoop_store/hdfs/datanode
echo hduser | sudo -S mkdir -p /usr/local/hadoop_store/hdfs/secondarynamenode
echo hduser | sudo -S chown -R hduser:hadoop /usr/local/hadoop_store

#copy mapred-site.xml file
cp /usr/local/hadoop/etc/hadoop/mapred-site.xml.template /usr/local/hadoop/etc/hadoop/mapred-site.xml

rm -rf /home/hduser/tmpconfig
mkdir -p /home/hduser/tmpconfig

#update mapred-site.xml file
cp /usr/local/hadoop/etc/hadoop/*-site.xml /home/hduser/tmpconfig
content="<configuration>\n<property>\n<name>mapreduce.framework.name</name>\n<value>yarn</value>\n</property>"
C=$(echo $content | sed 's/\//\\\//g')
sed -i "s/<configuration>/${C}/"g /home/hduser/tmpconfig/mapred-site.xml

#update core-site.xml file
content="<configuration>\n<property>\n<name>hadoop.tmp.dir</name>\n<value>/usr/local/hadoop_store/tmp</value>\n<description>A base for other temporary directories.</description>\n</property>\n<property>\n<name>fs.default.name</name>\n<value>hdfs://localhost:54310</value>\n<description>The name of the default file system. A URI whose scheme and authority determine the FileSystem implementation. The uri's scheme determines the config property fs.SCHEME.impl) naming the FileSystem implementation class. The uri's authority is used to determine the host, port, etc. for a filesystem.</description>\n</property>"
C=$(echo $content | sed 's/\//\\\//g')
sed -i "s/<configuration>/${C}/"g /home/hduser/tmpconfig/core-site.xml


#update hdfs-site.xml file
content="<configuration>\n<property>\n<name>dfs.replication</name>\n<value>1</value>\n<description>Default block replication. The actual number of replications can be specified when the file is created. The default is used if replication is not specified in create time.</description>\n</property>\n<property>\n<name>dfs.namenode.name.dir</name>\n<value>file:/usr/local/hadoop_store/hdfs/namenode</value>\n</property>\n<property>\n<name>dfs.datanode.data.dir</name>\n<value>file:/usr/local/hadoop_store/hdfs/datanode</value>\n</property>\n<property>\n<name>dfs.namenode.checkpoint.dir</name>\n<value>file:/usr/local/hadoop_store/hdfs/secondarynamenode</value>\n</property>\n<property>\n<name>dfs.namenode.checkpoint.period</name>\n<value>3600</value>\n</property>"
C=$(echo $content | sed 's/\//\\\//g')
sed -i "s/<configuration>/${C}/"g /home/hduser/tmpconfig/hdfs-site.xml

#update yarn-site.xml file
content="<configuration>\n<property>\n<name>yarn.nodemanager.aux-services</name>\n<value>mapreduce_shuffle</value>\n</property>\n<property>\n<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>\n<value>org.apache.hadoop.mapred.ShuffleHandler</value>\n</property>"
C=$(echo $content | sed 's/\//\\\//g')
sed -i "s/<configuration>/${C}/"g /home/hduser/tmpconfig/yarn-site.xml

cp  /home/hduser/tmpconfig/*-site.xml /usr/local/hadoop/etc/hadoop/

rm -r /home/hduser/tmpconfig/*-site.xml

echo "*****************Configuration file updated.. Start to format namenode"

hadoop namenode -format

echo "*****************Hadoop Installation completed****************"

start-all.sh

echo "**********HDFS service started***************************"

hadoop fs -mkdir -p /user/hduser
hadoop fs -chown -R hduser:hadoop /user/hduser

echo "**********hdfs homepath for hduser created*******************"

echo "************Starting Sqoop Installation ******************"

cd /home/hduser/install/

rm -rf /home/hduser/install/sqoop-1.4.6.bin__hadoop-2.0.4-alpha

echo hduser | sudo -S rm -rf /usr/local/sqoop

wget -c https://archive.apache.org/dist/sqoop/1.4.6/sqoop-1.4.6.bin__hadoop-2.0.4-alpha.tar.gz -p ~/install/

tar xzf /home/hduser/install/sqoop-1.4.6.bin__hadoop-2.0.4-alpha.tar.gz

echo hduser | sudo -S mv sqoop-1.4.6.bin__hadoop-2.0.4-alpha /usr/local/sqoop

cp -p /home/hduser/install/mysql-connector-java.jar /usr/local/sqoop/




