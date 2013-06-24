# Set these so the cookbook can be used without a role
node.default[:groups] = []
node.default[:users] = []
node.default[:sudoers] = []

# Set this since its required by the sudo cookbook
node.default[:authorization][:sudo][:include_sudoers_d] = true
