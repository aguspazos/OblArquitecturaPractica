class CalculatePrice < ApplicationJob
    queue_as :default
    
    def perform(*args)
        puts "Croooon"

    end
end