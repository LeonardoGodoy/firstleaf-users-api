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

  context '.single_search' do
    it 'returns users containing the searched term on the email, full_name or metadata' do
      create(:user, full_name: 'Carl Smith', email: 'this_is_my_search_target@email.com', metadata: nil)
      create(:user, full_name: 'Jhon this_is_my_search_target', email: 'jhon@email.com', metadata: nil)
      create(:user, full_name: 'Brittany Noah', email: 'brittany@email.com', metadata: 'some data, this_is_my_search_target, another information')
      user_not_expected = create(:user, full_name: 'Not targed user')

      users = User.single_search('this_is_my_search_target')

      expect(users.size).to eq(3)
      expect(users).not_to include(user_not_expected)
    end
  end
end
