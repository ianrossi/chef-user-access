user-access Cookbook
===================
This cookbook is essentially a wrapper for Fletcher Nichol's "user" cookbook and the sudo cookbook. It allows you to use attributes to specify the users and sudoers to be managed. The main goal of this cookbook is to make user access more accessible in Chef code. Chef Server allows us, with an attribute-driven infrastructure, to
- Define users and groups in data bags
- Define user access in attributes

Pull requests and feedback are welcome.

For info on how to create the "users" data bag, please see the "user" cookbook documentation: https://github.com/fnichol/chef-user

Requirements
------------
Cookbooks required are: 
- user (found at https://github.com/fnichol/chef-user.git)
- group (found at https://github.com/bbg-cookbooks/chef-group.git)
- sudo (from Opscode)

Requires the following node attributes to be set (see Usage section). If they are not set, Chef will take no action, and it will not fail.

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
    <td>A list of users to be created on the node. User details for each user listed will be pulled from the "users" data bag on the Chef Server.</td>
    <td><tt>empty</tt></td>
  </tr>
  <tr>
    <td><tt>node.default['groups']</tt></td>
    <td>Array</td>
    <td>Optional. A list of groups to be created on the node. If a user's data bag item has them assigned to a group, then a group will automatically be created without needing to use this attribute. Group details will be pulled from the "groups" data bag on the Chef Server. Alternatively, groups to be created on a node can be explicitly listed here, if necessary.</td>
    <td><tt>empty</tt></td>
  </tr>
  <tr>
    <td><tt>node.default['sudoers']</tt></td>
    <td>Array</td>
    <td>A list of sudoers. Items in the list can be either a user or a group. Each item in the array is titled with the user or group name and then key/value pairs determine the sudoer options for each sudoer. The same values you would use in the sudo LWRP can be used here. See example below.
    </td>
  </tr>
  <tr>
    <td><tt>node.default[:authorization][:sudo][:include_sudoers_d]</tt></td>
    <td>Boolean</td>
    <td>Whether or not sudoer fragments are used (separate sudoer files in a sudoers.d directory)
    <td><tt>true</tt></td>
    </td>
  </tr>
</table>

Usage
-----
#### user-access::default

Set the above attributes on the node and then include `user-access` in your node's `run_list`. Here is an example role.

```json
{
  "name": "my-role",
  "description": "My example role",
  "chef_type": "role",
  "default_attributes": { 
    "users": [
      "jsmith",
      "jdoe"
    ],
    "sudoers": {
      "sysadmins": {
        "group": "sysadmins",
        "commands": [
          "/bin/cp",
          "/bin/chmod",
          "/bin/chown"
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
      "jsmith": {
        "commands": [
          "/bin/cp",
          "/bin/chmod",
          "/etc/init.d/..."
        ],
        "host": "ALL",
        "nopasswd": false
      }
    },
  },
  "run_list": [
    "role[base]",
    "recipe[user-access]"
  ]
}

```

If you are including this recipe in another cookbook, you can set these same attributes from within that cookbook. This way the users, groups and sudoers associated with that cookbook will all be visible in one place.

Authors
-------------------
Author: Ian D. Rossi