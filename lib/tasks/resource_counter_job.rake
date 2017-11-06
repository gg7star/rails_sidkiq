desc "Increase or Decrease resources of all users."
task :resource_counter => :environment do
  puts "Calling resource counter"
  ResourceCounterJob.new.perform
  puts "done."
end