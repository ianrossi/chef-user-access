#
# Cookbook Name:: vmc-access
# Recipe:: default
# Author:: Ian D. Rossi
#
# Create any explicitly set groups
include_recipe "group::data_bag"

# Select the users from list at node[:users] and create group/user details from users data_bag
include_recipe "user::data_bag"

# Setup sudoers from attributes
include_recipe "sudo"

unless node[:sudoers].nil?
  node[:sudoers].each do |sudoer,sudoeroptions|
    sudo sudoer do
      name sudoer
      user sudoer
      group sudoeroptions[:group]
      commands sudoeroptions[:commands]
      nopasswd sudoeroptions[:nopasswd]
    end  
  end
end
