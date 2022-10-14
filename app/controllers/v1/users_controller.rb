module V1
  class UsersController < BaseController
    include SimpleQueryParameters
    include HumanizeActiveRecordErrors

    before_action :validate_simple_query_format, only: :index

    def index
      query = params[:query]

      @users = User.all.order(created_at: :desc)
      @users = @users.single_search(query) if query.present?
    end

    def create
      user = User.new(user_attributes)
      user.key = SecureRandom.hex

      if user.valid? && user.save
        ::AssignAccountKeyJob.perform_async(user.id)

        render user, status: :created
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