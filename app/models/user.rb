class User < ApplicationRecord
  has_secure_password validations: false

  validates :email, uniqueness: true, length: { maximum: 200 }, presence: { message: 'is missing' }
  validates :phone_number, uniqueness: true, length: { maximum: 200 }, presence: { message: 'is missing' }
  validates :full_name, length: { maximum: 200 }
  validates :password, length: { maximum: 100 }
  validates :password, presence: { message: 'is missing' }, on: :create
  validates :key, uniqueness: true, length: { maximum: 100 }, presence: { message: 'is missing' }
  validates :account_key, uniqueness: true, length: { maximum: 100 }, allow_blank: true
  validates :metadata, length: { maximum: 2000 }

  scope :single_search, ->(query) do
    query_statement = <<-SQL.freeze
        users.email ILIKE :q
      OR users.full_name ILIKE :q
      OR users.metadata ILIKE :q
    SQL

    where(query_statement, q: "%#{query}%")
  end
end
