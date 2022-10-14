module SimpleQueryParameters
  extend ActiveSupport::Concern

  def validate_simple_query_format
    query = params[:query]
    return if query.blank?
    return if query.is_a?(String)

    render json: { errors: ['Malformed query parameters'] }, status: :unprocessable_entity
  end
end