# LinkerNetworks Training Environment Builder

## Build

```
docker build --tag linkernetworks/pytorch:0.4.1-cuda9-cudnn7-runtime \
             --build-arg BASE_IMAGE=pytorch/pytorch:0.4.1-cuda9-cudnn7-runtime \
             --build-arg PYTHON=python \
             .
```
