require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email).with_message('is missing') }
  it { should validate_presence_of(:phone_number).with_message('is missing') }
  it { should validate_presence_of(:password).with_message('is missing') }
  it { should validate_presence_of(:key).with_message('is missing') }

  it { should validate_length_of(:email).is_at_most(200) }
  it { should validate_length_of(:phone_number).is_at_most(200) }
  it { should validate_length_of(:full_name).is_at_most(200) }
  it { should validate_length_of(:password).is_at_most(100) }
  it { should validate_length_of(:key).is_at_most(100) }
  it { should validate_length_of(:account_key).is_at_most(100) }
  it { should validate_length_of(:metadata).is_at_most(2000) }

  context 'uniqueness validations' do
    subject { build(:user) }

    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:phone_number).ignoring_case_sensitivity }
    it { should validate_uniqueness_of(:key) }
    it { should validate_uniqueness_of(:account_key) }
  end
end