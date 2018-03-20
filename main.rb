#!/usr/bin/env ruby

require 'aws-sdk'

if ENV.values_at('AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY').compact.size < 2
  raise RuntimeError, "Please set both AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY first.  See README.md for details."
end

client = Aws::EC2::Client.new(region: 'us-west-2')

instances = client.describe_instances(
  filters: [
    { name: 'tag:autostopper', values: ['true'] }
  ]
)

StopCommand = Struct.new(:id, :launch_time, keyword_init: true)
NoopCommand = Class.new.new

instances_to_stop = instances.reservations.map do |reservation|
  reservation.instances.map do |instance|
    if "running" == instance.state.name
      StopCommand.new(id: instance.instance_id, launch_time: instance.launch_time)
    else
      NoopCommand
    end
  end
end.flatten.reject { |cmd| NoopCommand == cmd }

if instances_to_stop.size > 0
  puts "Stopping #{instances_to_stop.count} instances:"
  puts instances_to_stop
  client.stop_instances({
    instance_ids: instances_to_stop.map(&:id)
  })
else
  puts "Couldn't find any running instances"
end
