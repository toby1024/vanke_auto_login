# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
set :environment, @environment
set :output, 'log/cron_log.log'
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


# 每天10：00自动登录一次
every '0 10 * * *' do
  runner "User.auto_login"
end

every '0 15 * * *' do
  runner "User.auto_login"
end

every '0 20 * * *' do
  runner "User.auto_login"
end


every 1.day do
  runner "User.auto_check"
end