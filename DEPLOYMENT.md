Deployment
==========

The contents of this repository are deployed to the following VM:
https://whimsy-test.apache.org/.

The new VM is based on Ubuntu 14.04 (the current Whimsy is based on Ubuntu
12.04), and is more completely managed by Puppet.  The puppet definition is
contained in the following two files:

 * https://github.com/apache/infrastructure-puppet/blob/deployment/data/nodes/whimsy-vm2.apache.org.yaml

 * https://github.com/apache/infrastructure-puppet/blob/deployment/modules/whimsy_server/manifests/init.pp

Instructions:

 * https://github.com/rubys/puppet-kitchen#readme

 * https://github.com/apache/infrastructure-puppet/blob/deployment/modules/vhosts_whimsy/README.md

Workflow:

 * https://cwiki.apache.org/confluence/display/INFRA/Git+workflow+for+infrastructure-puppet+repo