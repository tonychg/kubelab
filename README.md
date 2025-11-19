# Kubelab

Simple kubernetes local stack using kind and some kustomize.

## Setup

```bash
direnv allow
make start
```

## How to update manifests

```bash
make apply
```

You can then test everything is working
```bash
curl --verbose --header "Host: www.example.com" http://127.0.0.1
```
