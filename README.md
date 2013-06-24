vmc-access Cookbook
===================
The goal is to organize and centralize user management. Chef Server allows us, with an attribute-driven infrastructure, to
- Define users and groups in a central location (data bags on the Chef Server) and
- Define access to types of servers in role files

Requirements
------------
Cookbooks required are: 
- group (found at https://github.com/bbg-cookbooks/chef-group.git)
- user (found at https://github.com/fnichol/chef-user.git)
- sudo (from Opscode)

Requires the following node attributes to be set: (see Usage section)
- node[:users]
- node[:sudoers]
- node[:groups]

Attributes
----------
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>node.default['users']</tt></td>
    <td>Array</td>
    <td>A list of users to be created on the node. User details will be pulled from the "users" data bag on the Chef Server.</td>
    <td><tt>empty</tt></td>
  </tr>
  <tr>
    <td><tt>node.default['groups']</tt></td>
    <td>Array</td>
    <td>Optional. (Groups will be created if users are assigned to a group in the users data bag item.) A list of groups to be created on the node. Group details will be pulled from the "groups" data bag on the Chef Server.</td>
    <td><tt>empty</tt></td>
  </tr>
  <tr>
    <td><tt>node.default['sudoers']</tt></td>
    <td>Array</td>
    <td>A list of sudoers. Items in the list can be either a user or a group. Each item in the array is titled with the user or group name and then key/value pairs determine the sudoer options for each sudoer. See example below. The key/value pairs for now are: <br>
      - commands: an array of system commands allowed for the sudoer <br>
      - nopasswd: boolean, whether to invoke a passwd for the sudoer
    </td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### vmc-access::default

Set the above attributes on the node and then include `vmc-access` in your node's `run_list`. Here is the "double-kestrel" role as an example.

```json

{
  "name": "double-kestrel",
  "description": "A node that runs both buffer and persist queues for Reptar",
  "chef_type": "role",
  "default_attributes": { 
    "users": [
      "buffer",
      "nagios"
    ],
    "sudoers": {
      "visible": {
        "group": "visible",
        "commands": [
          "/bin/cp",
          "/bin/chmod",
          "/bin/chown",
          "/etc/init.d/kestrel.sh"
        ],
        "host": "ALL",
        "nopasswd": false
      },
      "nagios": {
        "commands": [
          "/usr/bin/omreport",
          "/usr/lib64/nagios/plugins/"
        ],
        "host": "ALL",
        "nopasswd": true
      },
      "vmc": {
        "commands": [
          "/bin/cp",
          "/bin/chmod",
          "/etc/init.d/logger2",
          "/etc/init.d/kestrel.sh",
          "/etc/init.d/storm-nimbus",
          "/etc/init.d/storm-ui",
          "/etc/init.d/storm-supervisor"
        ],
        "host": "ALL",
        "nopasswd": false
      }
    },
    "kestrel": {
      "app_name": "kestrel",    
      "admin_port": "2223",
      "stage": "buffer-prod",
      "memcacheListenPort": "22133",
      "textListenPort": "2222",
      "thriftListenPort": "2229",
      "jvm_min_heap": "3072m",
      "jvm_max_heap": "3072m",
      "jvm_new_heap": "576m",
      "maxMemSize": "512.megabytes",
      "max_open_transactions": "25000",
      "graphite_host": "graphite-stage",
      "graphite_prefix": "buffer-staging",
      "graphite_period": "1.minute",
      "graphite_port": "2003",
      "maxJourSize": "1.gigabyte"
    },
    "kestrel2": {
      "app_name": "kestrel",
      "admin_port": "3223",
      "stage": "persist-prod",
      "memcacheListenPort": "32133",
      "textListenPort": "3222",
      "thriftListenPort": "3229",
      "jvm_min_heap": "3072m",
      "jvm_max_heap": "3072m",
      "jvm_new_heap": "576m",
      "maxMemSize": "512.megabytes",
      "max_open_transactions": "25000",
      "graphite_host": "graphite-stage",
      "graphite_prefix": "buffer-staging",
      "graphite_period": "1.minute",
      "graphite_port": "2003",
      "maxJourSize": "1.gigabyte"
    }
  },
  "run_list": [
    "role[base]",
    "recipe[vmc-access]",  
    "recipe[vmc-kestrel::double-kestrel]"
  ]
}

```

Authors
-------------------
Author: Ian D. Rossi
