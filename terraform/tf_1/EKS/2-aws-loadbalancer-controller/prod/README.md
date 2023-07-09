### AWS Load Balancer Controller

This is a Helm chart for installing the AWS Load Balancer Controller on a Kubernetes cluster. You can find the documentation for the controller at https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller.

#### Installation

To install the controller, first add the EKS Helm repository:


helm repo add eks https://aws.github.io/eks-charts

Then, you can install the controller with the following command:


helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=<k8s-cluster-name> --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

Alternatively, you can install the controller from a values file:


helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --values values.yaml

#### Configuration

Before installing the controller, you will need to modify the values in the `values.yaml` file. Specifically, you should set the following values:


clusterName: eks-homol
region: us-east-1
vpcid: vpc-xxxx

#You should also set `serviceAccount.create` to `false` and provide a name for the service account:


serviceAccount.create: false
serviceAccount.name: aws-load-balancer-controller

This will ensure that the controller is installed with the correct configuration for your cluster.

