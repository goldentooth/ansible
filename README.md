# GoldenTooth/Cluster

Basic setup for my [Pi bramble/cluster](https://github.com/goldentooth/).

This is normally used via a dedicated [Bash script](https://github.com/goldentooth/bash), whose subcommands are mostly Ansible roles defined within this repository, e.g. `goldentooth set_bash_prompt allyrion` uses the role `goldentooth.set_bash_prompt` to customize the Bash prompt for Allyrion.

## TODO:

- Other Pi stuff:
  - disable the swapfile; Kubernetes doesn't like this.
  - setup unattended upgrades
