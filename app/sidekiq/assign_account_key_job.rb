class AssignAccountKeyJob
  include Sidekiq::Job

  # Sidekiq will retry failures with an exponential backoff using the formula
  # (retry_count ** 4) + 15 + (rand(10) * (retry_count + 1))
  # (i.e. 15, 16, 31, 96, 271, ... seconds + a random amount of time).

  sidekiq_options retry: 3

  def perform(user_id)
    user = User.find(user_id)

    return if user.blank?

    AccountKeyAsigner.perform(user)
  end
end
