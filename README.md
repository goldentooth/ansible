# Ansible

Configuration management for my [Pi bramble/cluster](https://github.com/goldentooth/).

This is normally used via a dedicated [Bash script](https://github.com/goldentooth/bash), whose subcommands are mostly Ansible roles defined within this repository, e.g. `goldentooth set_bash_prompt allyrion` uses the role `goldentooth.set_bash_prompt` to customize the Bash prompt for Allyrion.

Most of this is done in Ansible with dedicated roles. Some AWS infrastructure is configured via Terraform.

For blow-by-blow coverage of me beating my head against this project, check out the [Clog (Changelog)](https://clog.goldentooth.net/).
