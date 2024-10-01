# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
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
# 
every 1.day, at: '5:00 am' do
  runner "BuzzTerm.run_daily_jobs"
end

# every :sunday, at: '5:00 am' do
#   runner "BuzzTerm.run_weekly_jobs"
# end

# every '0 0 1,15 * *' do
#   runner "BuzzTerm.run_biweekly_jobs"
# end

# Learn more: http://github.com/javan/whenever