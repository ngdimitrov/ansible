# Ansible

We need to Python on all servers for to work Ansible. Also Ansible use SSH tunnel to connection to server because of this, can say it security connection.

`-k` `-K`(for BECOME) or `--ask-pass` `--ask-become-pass` if want ot use verification based on password (ansible example -m ping -u root --ask-pass)

#ad-hoc - `ansible example -a "free -h" -u ansible`
Introduction to ad hoc commands - https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html
An Ansible ad hoc command uses the /usr/bin/ansible command-line tool to automate a single task on one or more managed nodes. ad hoc commands are quick and easy, but they are not reusable. So why learn about ad hoc commands? ad hoc commands demonstrate the simplicity and power of Ansible. The concepts you learn here will port over directly to the playbook language.
Use cases for ad hoc tasks -
ad hoc tasks can be used to reboot servers, copy files, manage packages and users, and much more. You can use any Ansible module in an ad hoc task. ad hoc tasks, like playbooks, use a declarative model, calculating and executing the actions required to reach a specified final state. They achieve a form of idempotence by checking the current state before they begin and doing nothing unless the current state is different from the specified final state.

#Vagrant Guide - https://docs.ansible.com/ansible/latest/scenario_guides/guide_vagrant.html   https://developer.hashicorp.com/vagrant/docs 
Vagrant is a tool to manage virtual machine environments, and allows you to configure and use reproducible work environments on top of various virtualization and cloud platforms. It also has integration with Ansible as a provisioner for these virtual machines, and the two tools work together well.

!!! When we use the Ansible module - it can track all system changes. Because it's recommended the use of Ansible modules, they are maintained by big teams and are better and more secure. First example!
- name: Ensure NTP is installed.
  apt: name:ntp state=present
    or 
- command: apt install ntp
   or
- shell: |
    if ! rpm -qa | grep qw ntp; then
      apt install ntp
      fi

