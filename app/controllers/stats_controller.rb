class StatsController < ApplicationController
    
    def index
        @cadets = Cadet.all
         render :json => @cadets 
    end 
end
