# GoldenTooth/Cluster

Basic setup for my [Pi bramble/cluster](https://github.com/goldentooth/).

This is normally used via a dedicated [Bash script](https://github.com/goldentooth/bash),
whose subcommands are mostly Ansible roles defined within this repository, e.g.
`goldentooth set_bash_prompt allyrion` uses the role `goldentooth.set_bash_prompt`
to customize the Bash prompt for Allyrion.

## TODO:

The main things needed to reach functional completeness are operations that
would normally be performed directly on the Kubernetes cluster, e.g. with
`kubectl`. I'll no doubt do them several times manually, and I _want_ to do
them several times manually, but as I transition from basic operations into
deeper and longer-term aspects of Kubernetes, I'll want to migrate most of
them into IaC.

- Kubernetes stuff:
  - Essential namespaces
  - RBAC
  - Storage options
  - Helm installation
  - MetalLB installation
  - ArgoCD installation
