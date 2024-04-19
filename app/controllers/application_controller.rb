class ApplicationController < ActionController::Base
    def dataNotFound
        redirect_back_or_to root_path
    end
end
