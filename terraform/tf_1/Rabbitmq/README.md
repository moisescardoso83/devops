# Rabbitmq Configuration

### Doc
https://artifacthub.io/packages/helm/bitnami/rabbitmq


### Como instalar
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install rabbitmq bitnami/rabbitmq -n rabbitmq --create-namespace


### Criação de usuario
User creation:
rabbitmqctl add_vhost /
rabbitmqctl add_user "user" "Abcdefg123456789"
rabbitmqctl set_permissions -p / user ".*" ".*" ".*"
rabbitmqctl list_users
