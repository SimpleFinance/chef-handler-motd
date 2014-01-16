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
    attr_reader :priority, :keep_old_entries

    def initialize(options = defaults)
      @priority = options[:priority]
      @keep_old_entries = options[:keep_old_entries]
      @failure_message = options[:failure_message]
    end

    def report
      if run_status.success?
        Chef::Log.info 'Updating Chef info in MOTD ...'
        delete_outdated
        write_out(generate_message)
      else
        if @failure_message then write_out(failure_message) end
      end
    end

    private

    def defaults
      return {
        priority: '05', 
        keep_old_entries: false,
        failure_message: false
      }
    end

    def delete_outdated
      if @keep_old_entries then return end
      Dir.entries('/etc/update-motd.d').select do |entry|
        /chef-motd/.match(entry) && !/^#{@priority}/.match(entry)
      end.each do |del|
        Chef::Log.warn "Deleting #{del} as it does not match the current ChefMOTD priority"
        FileUtils.rm ::File.join('/etc', 'update-motd.d', del)
      end
    end

    def write_out(msg)
      file = "/etc/update-motd.d/#{@priority}-chef-motd"
      ::File.open(file, 'w') {|f| f.puts msg}
      ::File.chmod(0755, file)
    end

    def generate_message
      msg = <<-eos
#!/bin/sh
echo \"Node #{node.name} last success at #{Time.now.to_s} in #{run_status.elapsed_time} seconds\"
echo \"Updated resources on last run (total: #{run_status.updated_resources.length}):\"
      eos
      run_status.updated_resources.each do |res|
        msg += "echo \"  #{res.resource_name}[#{res.name}]\"\n"
      end
      return msg
    end

    def failure_message
      return <<-eos
#!/bin/sh
echo \"Node #{node.name} Chef run failed at #{Time.now.to_s} in #{run_status.elapsed_time} seconds\"
      eos
    end
end
