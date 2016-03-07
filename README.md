Ansible playbooks for Coop SymbioTIC
====================================

Ansible playbooks for the Coop SymbioTIC (https://www.symbiotic.coop).

We provide CiviCRM-based services for non-profits, professional associations,
unions and small-medium size companies. We are a worker's coop based in
Montreal, Quebec (Canada).

Our Ansible roles/playbooks are published in the hope that they can be useful.
Use at your own risk.

We are grateful to the Ansible community, but also to all the communities of
each project we use, such as CiviCRM, Icinga, Aegir and others, either for their
help on IRC, online documentation, etc. We hope to "push it forward" by also
contributing our experiences for others to learn from.

Feedback/suggestions welcome. Please use the Github issue queue of this project.
You can also contact us at info (at) symbiotic.coop.

Requirements
------------

The server from where you will be running Ansible must have Ansible >= 2.0.

Under Debian Jessie:

```
apt-get install -t jessie-backports ansible
```

(assuming you have configured jessie backports)

New node bootstrap
------------------

Assuming the server already runs ssh and you have either ssh root access or a
user account that can sudo root:

1- Ensure that you have the private files in /etc/ansible/files

2- Add the host to the 'production' inventory (/etc/ansible/hosts).

3- Create, if necessary, the host_vars file for that host (/etc/ansible/host_vars/example.symbiotic.coop)

4- Run the following setup:

```
ansible-playbook -l example.symbiotic.coop -u mathieu --become-user=root --ask-become-pass ./setup.yml
```

5- And finally the normal run:

```
ansible-playbook -l example.symbiotic.coop ./site.yml
```


Running a playbook
------------------

See what hosts would be affected by a playbook before you run it:

    ansible-playbook site.yml --list-hosts

Run the playbook:

    ansible-playbook site.yml

Run it on a specific node:

    ansible-playbook -l foo.example.org site.yml

Run only a specific role (each role is tagged in site.yml):

    ansible-playbook --tags=ufw site.yml

Run 10 "things" (servers?) in parallel:

    ansible-playbook site.yml -f 10
