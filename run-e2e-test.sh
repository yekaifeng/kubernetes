#!/bin/bash -x

if [ $# != 0 ]
then
  echo "run e2e test"
  exit 1
fi

cwd=$(pwd)
version=$1
export GOPATH=$cwd/gopath
export GOBIN=$GOPATH/bin
export GOROOT=/opt/go18/go


rm -rf $GOBIN
rm -rf $GOPATH/src
mkdir -p $GOBIN
mkdir -p $GOPATH/src
go env
env
echo $PATH

echo "copying source ..."
cp -rfL ./vendor/* $GOPATH/src/
mkdir -p $GOPATH/src/k8s.io/kubernetes
cp -rf ./api $GOPATH/src/k8s.io/kubernetes
cp -rf ./build $GOPATH/src/k8s.io/kubernetes
cp -rf ./cluster $GOPATH/src/k8s.io/kubernetes
cp -rf ./cmd $GOPATH/src/k8s.io/kubernetes
cp -rf ./federation $GOPATH/src/k8s.io/kubernetes
cp -rf ./hack $GOPATH/src/k8s.io/kubernetes
cp -rf ./hooks $GOPATH/src/k8s.io/kubernetes
cp -rf ./pkg $GOPATH/src/k8s.io/kubernetes
cp -rf ./plugin $GOPATH/src/k8s.io/kubernetes
cp -rf ./staging $GOPATH/src/k8s.io/kubernetes
cp -rf ./third_party $GOPATH/src/k8s.io/kubernetes
cp -rf ./hack $GOPATH/src/k8s.io/kubernetes
cp -rf ./test $GOPATH/src/k8s.io/kubernetes
cp -rf ./vendor $GOPATH/src/k8s.io/kubernetes
cp -rf ./examples $GOPATH/src/k8s.io/kubernetes
cp -rf ./translations $GOPATH/src/k8s.io/kubernetes
cp -rf ./BUILD* $GOPATH/src/k8s.io/kubernetes
cp -rf ./Makefile* $GOPATH/src/k8s.io/kubernetes
cp -rf ./WORKSPACE $GOPATH/src/k8s.io/kubernetes
cp -rf ./Vagrantfile $GOPATH/src/k8s.io/kubernetes
cp -rf /opt/go18/gopath/src/k8s.io/test-infra $GOPATH/src/k8s.io/test-infra

# create version info
echo "change to kubernetes dir..."
cd $GOPATH/src/k8s.io/kubernetes
cd vendor/k8s.io/
ln -s -f ../../staging/src/k8s.io/client-go client-go
cd $GOPATH/src/k8s.io/kubernetes

echo "generate bindata.go"
$GOROOT/bin/go install github.com/jteeuwen/go-bindata/go-bindata
./hack/generate-bindata.sh

echo "make e2e"
make WHAT='test/e2e/e2e.test'
make ginkgo

echo "make env"
export KUBECTL_PATH=/usr/bin/kubectl
export KUBERNETES_PROVIDER=local
export KUBECONFIG=~/.kube/config
export KUBE_MASTER_IP=10.100.84.32:8080
export KUBE_MASTER=http://gx-yun-084032.vclound.com
#export KUBE_MASTER_URL="https://${KUBE_MASTER_IP}"
#export KUBECONFIG="${ABSOLUTE_ROOT}/test/kubemark/resources/kubeconfig.kubemark"
#export E2E_MIN_STARTUP_PODS=0

echo "mark physical node as cordon"
kubectl cordon gx-yun-084033.vclound.com
kubectl cordon gx-yun-084034.vclound.com
kubectl cordon gx-yun-084035.vclound.com

echo "start running performance test"
$GOROOT/bin/go install -v github.com/onsi/ginkgo/ginkgo
#$GOROOT/bin/go run hack/e2e.go --provider=kubemark -v -test --test_args="--host=http://gx-yun-084032.vclound.com:8080 --ginkgo.focus=\[Feature:Performance\]" >> /home/jenkins/workspace/kenneth/vip-kubernetes/logs/performance.log
$GOROOT/bin/go run hack/e2e.go -get=false -- -v -test --test_args="--host=http://gx-yun-084032.vclound.com:8080 --ginkgo.focus=\[Feature:Performance\]" >> /home/jenkins/workspace/kenneth/vip-kubernetes/logs/performance.log

echo "mark physical node as uncordon"
kubectl uncordon gx-yun-084033.vclound.com
kubectl uncordon gx-yun-084034.vclound.com
kubectl uncordon gx-yun-084035.vclound.com
echo "completed !!"

