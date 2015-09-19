Ansible playbook to deploy CiviCRM developer dependencies in an Aegir environment
=================================================================================

This is very specific playbook if you happen to:

* have CiviCRM developers using your servers
* use Aegir 3 (http://www.aegirproject.org/)
* use Debian Jessie 8.x

This playbook will deploy civix, git-scan, composer, bower, as well as to ensure
that npm is installed, git and bzip2. It also deploys some PHP settings.

You do not need this playbook if you are only using CiviCRM. Most of the tools
installed are related to developing extensions, core development, running tests,
etc.

The usual warning applies: I am not an Ansible expert and I use this for my
personal purposes. The playbook is shared in the hope that it can be useful.
Feedback/suggestions/patches welcomed. Use at your own risk.

For more information, see:
https://github.com/mlutfy/ansible-bidon
