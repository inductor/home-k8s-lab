#!/usr/bin/env bash -eu
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo "Checking if kubeconfig is valid..."
if kubectl version > /dev/null 2>&1; then
    echo "kubeconfig is valid"
else
    echo "kubeconfig is invalid"
    exit 1
fi

KUBE_CONTExT=`kubectl config current-context`

while true; do
    read -p "The current context is \"$KUBE_CONTExT\". Would you like to proceed? (y/n)" yn
    case $yn in
        [Yy]* ) kubectl apply -f $SCRIPTPATH/apps/projects.yaml; kubectl apply -f $SCRIPTPATH/root-apps.yaml; echo "The cluster setup has succesfully done!"; break;;
        [Nn]* ) echo "Setup has been cancelled!"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
