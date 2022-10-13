module V1
  class UsersController < ApplicationController
    include QuerySimpleHashParameters

    before_action only: :index do
      validate_query_parameters!(%w(email full_name metadata))
    end

    def index
      query = params[:query] || []

      users = V1::SearchUsers.search(query: query)

      render json: { users: users.order(created_at: :desc) }, status: :ok
    end
  end
end