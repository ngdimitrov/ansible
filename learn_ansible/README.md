# Ansible!![Mac-Dev-Playbook-Logo](https://github.com/ngdimitrov/ansible/assets/73880661/985b31f5-a98b-44cf-b437-588b80e556eb)



We need to Python on all servers for to work Ansible. Also Ansible use SSH tunnel to connection to server because of this, can say it security connection.

`-k` `-K`(for BECOME) or `--ask-pass` `--ask-become-pass` if want ot use verification based on password (ansible example -m ping -u root --ask-pass)

### ad-hoc - `ansible example -a "free -h" -u ansible`
Introduction to ad hoc commands - https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html
An Ansible ad hoc command uses the /usr/bin/ansible command-line tool to automate a single task on one or more managed nodes. ad hoc commands are quick and easy, but they are not reusable. So why learn about ad hoc commands? ad hoc commands demonstrate the simplicity and power of Ansible. The concepts you learn here will port over directly to the playbook language.
Use cases for ad hoc tasks -
ad hoc tasks can be used to reboot servers, copy files, manage packages and users, and much more. You can use any Ansible module in an ad hoc task. ad hoc tasks, like playbooks, use a declarative model, calculating and executing the actions required to reach a specified final state. They achieve a form of idempotence by checking the current state before they begin and doing nothing unless the current state is different from the specified final state.

- You can see the hostnames on your servers group `ansible multi -i inventory -a "hostname"`
- How much space is available `ansible multi -i inventory -a "df -h"`
- Output on ad-hoc commands always is "CHANGED", because, we don't use the Ansible module and so Ansible doesn't know we don't make a change.
- Аnything that Ansible automatically finds about the server. `ansible -i inventory db -m setup`
- When we use the `-b` `--become` run like a SUDO user.   `ansible multi -b -m apt -a "name=ntp state=present"`
- Use for documentation `ansible-doc service` 
- Manage systemD `ansible -i inventory multi -b -m systemd -a "name=ntp state=started enable=yes"`(about Ubuntu witout enable=yes) DOC -  https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html
-  With `--limit "10.0.0.113"` you can limit result `ansible -i inventory app -a "free -m" --limit "*.113"`
# Usefull Commands
-  Check syntax `ansible-playbook  main.yml --syntax-check`
-  Force and continuing after fail task ` ansible-playbook -i inventory apache.yml --force `
#### Vault in ansible `ansible-vault` 
- You can use the vault variable and store all the blanks in another file, making hacking your password file more complicated.
-  You can encrypt file with ansible module `ansible-vault encrypt vars/apy_key.yml` But with this command you cann run playbook(will ask you for pass) `ansible-playbook main.yml --ask-vault-pass`Also you can save password in hide file and take from file with command `ansible-playbook main.yml --vault-password-file ~/.ansible/api-key-pass.txt` 
-  Ansible decrypt - `ansible-vault decrypt vars/apy_key.yml`
-  Edit encrypt file without decrypt with `ansible-vault edit vars/apy_key.yml` and add password
-  Chanche password on the encrypt file `ansible-vault rekey vars/apy_key.yml`
#### Ansible molecule
 -  INSTALL.rst contains instructions on what additional software or setup steps you will need to take in order to allow Molecule to successfully interface with the driver.
 -  molecule.yml is the central configuration entrypoint for Molecule. With this file, you can configure each tool that Molecule will employ when testing your role.
 -  converge.yml is the playbook file that contains the call for your role. Molecule will invoke this playbook with ansible-playbook and run it against an instance created by the driver.
 -  verify.yml is the Ansible file used for testing as Ansible is the default verifier. This allows you to write specific tests against the state of the container after your role has finished executing. Other verifier tools are available Note that testinfra was the default verifier prior to molecule version 3.
#### 9 Basic Security Measures
###### Linux server security
1. Use secure and encrypted communicarion
2. Disable root login and use sudo
3. Remove unused software,open only required ports
4. Use the principle of least privilege
5. Update the OS and installed software
6. Use a properly-configured firewall
7. Make sure log files are populated and rotated
8. Monitor logins and block suspect IP addresses
9. Use SELinux (Security-Enhanced- Linux)


-  Add role from Ansible Galaxy `ansible-galaxy role init test-galaxy` `ansible-galaxy collection install geerlingguy.mac` 
-  Download role `ansible-galaxy install -r requirements.yml`  requirments file - ` roles:  - name: elliotweiser.osx-command-line-tools  version: 2.3.0   - name: geerlingguy.homebrew  version: 4.0.0 `
-  Yamllint is yaml validator. command - ` yamllint .` `yamllint my-file.yml`
-  Check sysntax and config files with ansible-lint `ansible-lint filename.yaml`

#### apt manage module - https://docs.ansible.com/archive/ansible/2.3/apt_module.html

# Playbooks
- `become=true` You can put true, yes, 1 or 0, no, false
- `ignore_errors: true` If want ignore fail this task
- `changed_when:` and `failed_when:` this is custom conditions for change or not change output
- `tags: - api - echo ` (but yml format) add tags in the tasks and you can run only them with this command `ansible-playbook main.yml --tags=api` 
- ` tasks: - import_tasks: /path/to/file/apache.yml` 
-  `pre_task: `  - can use for pretasks in playbooks
-  Ansible config settings - https://docs.ansible.com/ansible/latest/reference_appendices/config.html

##### Vagrant Guide - https://docs.ansible.com/ansible/latest/scenario_guides/guide_vagrant.html   https://developer.hashicorp.com/vagrant/docs 
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
   
