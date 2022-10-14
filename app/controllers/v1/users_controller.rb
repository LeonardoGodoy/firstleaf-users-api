module V1
  class UsersController < ApplicationController
    include SimpleQueryParameters
    include HumanizeActiveRecordErrors

    before_action :validate_simple_query_format, only: :index

    def index
      query = params[:query] || []

      users = User.all
      users = users.single_search(query) if query.present?

      render json: { users: users.order(created_at: :desc) }, status: :ok
    end

    def create
      user = User.new(user_attributes)
      user.key = SecureRandom.hex

      if user.valid? && user.save
        ::AssignAccountKeyJob.perform_async(user.id)

        attributes_to_display = %w(email phone_number full_name key account_key metadata).freeze
        render json: user.attributes.slice(*attributes_to_display), status: :created
      else
        render json: { errors: humanized_errors(user) }, status: :unprocessable_entity
      end
    end

    private

    def user_attributes
      params.permit(%i(email phone_number full_name password metadata))
    end
  end
end