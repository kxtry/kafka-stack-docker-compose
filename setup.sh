path_current=`pwd`
path_script=$(cd "$(dirname "$0")"; pwd)
mode=$1
external_ip=$2
if [ -f $path_script/docker-compose.yml ]; then
  echo "continue before remove the docker-compose.yml file"
  exit 2
fi
case "$mode" in
   '1')
      template='zk-single-kafka-single.yml.template'
      ;;
   '2')
      template='zk-single-kafka-multiple.yml.template'
      ;;
   '3')
      template='zk-multiple-kafka-single.yml.template'
      ;;
   '4')
      template='zk-multiple-kafka-multiple.yml.template'
      ;;
     *)
      basename=`basename "$0"`
      echo "Usage: $basename  {1|2|3|3|4} {ip} [ param options ]"
      echo "  {1 ip}: zk-single-kafka-single.yml.template ==> docker-compose.yml"
      echo "  {2 ip}: zk-single-kafka-multiple.yml.template ==> docker-compose.yml"
      echo "  {3 ip}: zk-multiple-kafka-single.yml.template ==> docker-compose.yml"
      echo "  {4 ip}: zk-multiple-kafka-multiple.yml.template ==> docker-compose.yml"
      exit 1
      ;;
esac
echo ${external_ip} |grep "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$" > /dev/null
if [ $? = 1 ]; then
   echo "external_ip[${external_ip}] value is bad or empty"
   echo "must input external ip which can be connected by client."
   exit 1
fi
/bin/cp -rf $path_script/${template} $path_script/docker-compose.yml && echo "$path_script/docker-compose.yml" | xargs /bin/sed -i "s#\${DOCKER_HOST_IP:-127.0.0.1}#${external_ip}#g"

