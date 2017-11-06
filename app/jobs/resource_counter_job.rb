class ResourceCounterJob < ApplicationJob
  queue_as :resource_counter

  def perform(*args)
    # Do something later
    puts "============= runing resource counter. =============="
    users = User.all
    users.each do |user|
    	user.wood += 3
    	user.save
    	puts "=================== #{user.wood} ==================="
  	end
  end
end
