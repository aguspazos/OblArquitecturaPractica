class CalculateEstimatedPricesJob < ApplicationJob
    queue_as :default
    
    def perform(*args)
        user = User.new
        user.name = "Norberto"
        user.save!
        sleep 2
    end 
end