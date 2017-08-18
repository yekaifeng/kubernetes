#!/bin/bash -x

echo "run generate probuf"

cwd=$(pwd)
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
cp -rf ./hack $GOPATH/src/k8s.io/kubernetes
cp -rf ./test $GOPATH/src/k8s.io/kubernetes
cp -rf ./vendor $GOPATH/src/k8s.io/kubernetes
cp -rf ./examples $GOPATH/src/k8s.io/kubernetes
cp -rf ./translations $GOPATH/src/k8s.io/kubernetes
cp -rf ./BUILD* $GOPATH/src/k8s.io/kubernetes
cp -rf ./Makefile* $GOPATH/src/k8s.io/kubernetes
cp -rf ./WORKSPACE $GOPATH/src/k8s.io/kubernetes
cp -rf ./Vagrantfile $GOPATH/src/k8s.io/kubernetes


# change dir
echo "change to kubernetes dir..."
cd $GOPATH/src/k8s.io/kubernetes

./hack/update-generated-protobuf.sh

echo "completed !!"
