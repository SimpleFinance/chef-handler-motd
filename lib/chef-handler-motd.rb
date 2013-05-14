# lib/chef-handler-motd.rb
#
# Author: Simple Finance <ops@simple.com>
# Copyright 2013 Simple Finance Technology Corporation.
# Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Chef handler to edit MOTD with useful info after a run

require 'rubygems'
require 'chef'
require 'chef/handler'

class ChefMOTD < Chef::Handler
    attr_reader :priority

    def initialize(options = {:priority => '05'})
      @priority = options[:priority]
    end

    def report
      msg = <<-eos
#!/bin/sh
echo \"Node #{node.name} last success at #{Time.now.to_s} in #{run_status.elapsed_time} seconds\"
echo \"Updated resources on last run (total: #{run_status.updated_resources.length}):\"
      eos
      run_status.updated_resources.each do |res|
        msg += "echo \"  #{res.resource_name}[#{res.name}]\"\n"
      end
      if run_status.success?
        Chef::Log.info 'Updating Chef info in MOTD ...'
        file = "/etc/update-motd.d/#{@priority}-chef-motd"
        ::File.open(file, 'w') {|f| f.puts msg}
        ::File.chmod(0755, file)
      end
    end

end

