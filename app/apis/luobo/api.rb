module Luobo
  #PARKING_MAP(#Constants.SERVER_DOMAIN + "/api/luobo/park/map"),
  #PARKING_LIST(Constants.SERVER_DOMAIN "/api/luobo/park/list"),
  #PARKING_DETAIL(Constants.SERVER_DOMAIN + "/api/luobo/park/detail/"),
  #VERIFY_CODE( #Constants.SERVER_DOMAIN + "/api/login/verifycode"),
  #LOGIN(Constants.SERVER_DOMAIN + "/api/login");

  class API < Grape::API
    version 'v1', using: :header, vendor: 'luobo'
    format :json
    prefix :api

    helpers do
      def current_user
        @current_user ||= User.authorize!(env)
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    resource :login do
      desc "login to exchange token"
      params do
      end

      post '/' do
      end

      desc "get token"
      params do
      end

      post '/verifycode' do
      end
    end

    resource :statuses do
      desc "Update a status."
      params do
        requires :id, type: String, desc: "Status ID."
        requires :status, type: String, desc: "Your status."
      end
      put ':id' do
        authenticate!
        current_user.statuses.find(params[:id]).update({
          user: current_user,
          text: params[:status]
        })
      end
    end
  end
end
