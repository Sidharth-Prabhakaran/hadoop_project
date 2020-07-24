  if [ `id -u` -ne 0 ]; then
    echo "You need root privileges to run this script(try sudo)"
    exit 1
fi
if [ `/usr/lib/jvm/java-1.8.0-openjdk-amd64/bin/jps |  grep "NameNode" | wc -l` -gt 0 ] ; then  
    echo "Hadoop Already running."
    exit 0
fi
echo "\n" | ssh-keygen -q -t rsa -P "" -f /root/.ssh/id_rsa
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo 'Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/opt/mdp/hbase-2.0.0/bin:/opt/mdp/hadoop-2.7.6/sbin:/opt/mdp/hadoop-2.7.6/bin:/opt/mdp/pig-0.16.0/bin:/opt/mdp/apache-hive-2.1.0-bin/bin"' > /etc/sudoers.d/exconf
echo 'Defaults env_keep += "JAVA_HOME"' >> /etc/sudoers.d/exconf
service ssh restart

hdfs namenode -format
start-dfs.sh 
start-yarn.sh 
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir /tmp
hdfs dfs -chmod g+w /user/hive/warehouse
hdfs dfs -chmod g+w /tmp

sudo wget http://mirrors.estointernet.in/apache/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz

sudo tar -xzvf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz

sudo mv sqoop-1.4.7.bin__hadoop-2.6.0 /opt/mdp/sqoop

echo "export SQOOP_HOME=/opt/mdp/sqoop" >> ~/.bashrc
echo "export PATH=$PATH:/opt/mdp/sqoop/bin" >> ~/.bashrc
source ~/.bashrc

sudo mv /opt/mdp/sqoop/conf/sqoop-env-template.sh /opt/mdp/sqoop/conf/sqoop-env.sh


echo "export HADOOP_COMMON_HOME=/opt/mdp/hadoop-2.7.6" >> /opt/mdp/sqoop/conf/sqoop-env.sh
echo "export HADOOP_MAPRED_HOME=/opt/mdp/hadoop-2.7.6" >> /opt/mdp/sqoop/conf/sqoop-env.sh
echo "export HIVE_HOME=/opt/mdp/apache-hive-2.1.0-bin" >> /opt/mdp/sqoop/conf/sqoop-env.sh


sudo wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz

sudo tar -xzvf mysql-connector-java-5.1.47.tar.gz

sudo mv mysql-connector-java-5.1.47/mysql-connector-java-5.1.47-bin.jar /opt/mdp/sqoop/lib/

echo "mysql-server mysql-server/root_password password root" |  debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" |  debconf-set-selections

apt-get update
apt-get install -y mysql-server
chown -R mysql:mysql /var/lib/mysql
usermod -d /var/lib/mysql/ mysql
service mysql start
