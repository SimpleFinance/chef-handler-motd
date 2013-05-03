# ChefMOTD handler
Update your MOTD after a Chef run with various data

# Prerequisites
Mostly, just having MOTD configured. We use Estately's [motd](https://github.com/estately/cookbooks/tree/master/motd) cookbook

# Usage
Either just pull the handler file into a files directory of one of your
cookbooks, or download as a Rubygem and source it that way.

```ruby
# Option 1
cookbook_file "#{node[:chef_handler][:handler_path]}/chef-handler-motd.rb" do
  source 'chef-handler-motd.rb'
  mode 00600
end

chef_handler 'ChefMOTD' do
  source "#{node[:chef_handler][:handler_path]}/chef-handler-motd.rb"
  action :enable
end

# Option 2
chef_gem 'chef-handler-motd' do
  action :install
end

chef_handler 'ChefMOTD' do
  source ::File.join(Gem.all_load_paths.grep(/chef-handler-motd/).first,
                     'chef-handler-motd.rb')
  action :enable
end
```

### Arguments
* `priority` - Determines where the Chef data is displayed in MOTD (default 05)

# Author
Ops at Simple <ops@simple.com>

# License
Apache License, Version 2.0

