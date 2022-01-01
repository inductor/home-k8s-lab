#!/usr/bin/env bash -eu
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo "Checking if kubectl and helm command exist..."
sleep 1
if ! command -v kubectl &> /dev/null
then
    echo "kubectl could not be found."
    exit 1
fi
echo "kubectl exists."
if ! command -v helm &> /dev/null
then
    echo "helm could not be found."
    exit 1
fi
echo "helm exists."
if kubectl version > /dev/null 2>&1; then
    echo "kubeconfig is valid."
else
    echo "kubeconfig is invalid."
    exit 1
fi

KUBE_CONTExT=`kubectl config current-context`

if kubectl get applications ; then
    echo "ArgoCD found. Install proceeding."
else
    read -p "ArgoCD not found on your cluster. Would you like to install it? (y/n)" yn
    case $yn in
        [Yy]* ) helm install argocd --create-namespace -n argocd argo/argo-cd; helm ls -n argocd;;
        [Nn]* ) echo "Setup has been cancelled!"; exit 1;;
        * ) echo "Please answer yes or no.";;
    esac
fi

while true; do
    read -p "The current context is \"$KUBE_CONTExT\". Would you like to proceed? (y/n)" yn
    case $yn in
        [Yy]* ) kubectl apply -f $SCRIPTPATH/projects/projects.yaml; kubectl apply -f $SCRIPTPATH/root-apps.yaml; echo "The cluster setup has succesfully done!"; break;;
        [Nn]* ) echo "Setup has been cancelled!"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
