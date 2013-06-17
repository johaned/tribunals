set :output, "log/cron.log"

every 1.day, at: '12:00 pm' do
  rake 'nightly:import'
end

every 1.day, at: '7:00 pm' do
  rake 'nightly:import'
end
