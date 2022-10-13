module QuerySimpleHashParameters
  extend ActiveSupport::Concern

  def validate_query_parameters!(allowed_attributes)
    query = params[:query]
    return if query.blank?

    return if query.is_a?(ActionController::Parameters) &&
      (query.keys - allowed_attributes).blank? &&
      query.values.all? { |value| value.is_a?(String) }

    render json: { errors: ['Malformed query parameters'] }, status: :unprocessable_entity
  end
end