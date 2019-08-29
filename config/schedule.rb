# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

case @environment
when 'staging'
  set :output, {:error => '/var/www/html/joindev-attribe/log/cron.log', :standard => '/var/www/html/joindev-attribe/log/cron.log'}
when 'production'
  set :output, {:error => '/var/www/html/test/qulabro/log/cron.log', :standard => '/var/www/html/test/qulabro/log/cron.log'}
else
  set :output, {:error => '/Users/mohsin/rails/attribe-meetups/log/cron.log', :standard => '/Users/mohsin/rails/attribe-meetups/log/cron.log'}
end

# set :output, "/path/to/my/cron_log.log"

case @environment
when 'staging'
  set :environment, 'staging'
when 'production'
  set :environment, 'production'
else
  set :environment, 'development'
end

every 1.minute do
  rake "delayed_job:process_and_exit"
end

#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
