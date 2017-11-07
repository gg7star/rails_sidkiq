require 'sidekiq-scheduler'

class ResourceWorker
	include Sidekiq::Worker
  #sidekiq_options queue: "high"

	def perform
		puts "=========== ResourceWorker ============="
	
    users = User.all
    users.each do |user|
    	user.wood += 3
    	user.save
    	puts "=================== #{user.wood} ==================="
  	end

	end
end
