module AccountKeyGenerator
  def self.perform(email, key)
    raw_key = email + key

    Digest::SHA1.hexdigest(raw_key)
  end
end