#!/bin/bash -x

if [ $# != 1 ]
then
  echo "usage:   build-binary.sh version"
  echo "example: ./build-binary.sh 1.6.5"
  echo "this script require these environment: go, tar, bzip2"
  echo "final product is the binary file in bin directory"
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

# copy go deps into src dir
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

# create version info
sed -i '/gitVersion/'d $GOPATH/src/k8s.io/kubernetes/pkg/version/base.go
sed -i "/gitCommit/i\        gitVersion   string = \"${version}\"" $GOPATH/src/k8s.io/kubernetes/pkg/version/base.go
#sed -i "51i        gitVersion   string = \"${version}\"" $GOPATH/src/k8s.io/kubernetes/pkg/version/base.go

# go build
echo "building source..."
cd $GOPATH/src/k8s.io/kubernetes

#$GOROOT/bin/go install -v ./cmd/kube-proxy
$GOROOT/bin/go install -v ./cmd/kube-apiserver
$GOROOT/bin/go install -v ./cmd/kube-controller-manager
#$GOROOT/bin/go install -v ./cmd/cloud-controller-manager
#$GOROOT/bin/go install -v ./cmd/kubelet
#$GOROOT/bin/go install -v ./cmd/kubeadm
#$GOROOT/bin/go install -v ./cmd/hyperkube
#$GOROOT/bin/go install -v ./vendor/k8s.io/kube-aggregator
$GOROOT/bin/go install -v ./plugin/cmd/kube-scheduler
#$GOROOT/bin/go install -v ./cmd/kube-proxy
$GOROOT/bin/go install -v ./cmd/kubelet

echo "binary:$GOBIN"
ls -lah $GOBIN
echo "completed !!"