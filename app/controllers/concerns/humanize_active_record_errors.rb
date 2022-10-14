module HumanizeActiveRecordErrors
  extend ActiveSupport::Concern

  def humanized_errors(object)
    parsed_error_messages = object.errors.messages.each_with_object([]) do |(field, error_messages), parsed_messages|
      error_messages.each { |message| parsed_messages << "#{field} #{message}" }
    end
  end
end