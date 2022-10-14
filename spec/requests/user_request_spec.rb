
require 'rails_helper'

require 'sidekiq/testing'

RSpec.describe "Users", type: :request do
  def asert_user_object_format(user_item)
    expected_columns = %i(email phone_number full_name key account_key metadata).freeze
    expect(expected_columns - user_item.keys).to be_empty
  end

  def asert_ordered_by_creation_datetime(user_items)
    actual_order = user_items.pluck(:created_at)
    expected_order = actual_order.sort.reverse

    expect(actual_order.size.times.all? { |i| actual_order[i] == expected_order[i] }).to be_truthy
  end

  describe "#index" do
    let(:result) { JSON.parse(response.body, symbolize_names: true) }

    context 'when fetching users without query paramenters' do
      it 'returns all the users order by creation datetime' do
        create_list(:user, 3)
        get v1_users_path

        expect(result).to have_key(:users)
        expect(result[:users]).to be_present
        expect(result[:users].size).to eq(3)

        first_user = result[:users].first
        asert_user_object_format(first_user)
        asert_ordered_by_creation_datetime(result[:users])
      end
    end

    context 'when fetching users with query paramenters' do
      it 'returns only users matching the query parameters' do
        create(:user, full_name: "Carl Smith", email: "this_is_my_search_target@email.com", metadata: nil)
        create(:user, full_name: "Jhon this_is_my_search_target", email: "jhon@email.com", metadata: nil)
        create(:user, full_name: "Brittany Noah", email: "brittany@email.com", metadata: "some data, this_is_my_search_target, another information")
        create(:user, full_name: "Not targed user")

        get v1_users_path(query: "this_is_my_search_target")

        expect(result).to have_key(:users)
        expect(result[:users]).to be_present
        expect(result[:users].size).to eq(3)

        first_user = result[:users].first
        asert_user_object_format(first_user)
        asert_ordered_by_creation_datetime(result[:users])
      end
    end

    context 'with malformed query parameters' do
      it 'fails and returns the error feedback' do
        get v1_users_path(query: { wrong: :format })

        expect(response).to have_http_status(:unprocessable_entity)
        expect(result[:errors]).to be_present
      end
    end
  end

  describe "#create" do
    let(:result) { JSON.parse(response.body, symbolize_names: true) }

    let(:valid_attributes) do
      {
        email: "user5@example.com",
        phone_number: "55512355555",
        full_name: "Joe Smith",
        password: "123123",
        metadata: "male, age 32, unemployed, college-educated"
      }
    end

    context 'when creating user with valid attributes' do
      it 'creates the user successfuly' do
        post v1_users_path, params: valid_attributes

        expect(response).to have_http_status(:created)
        asert_user_object_format(result)
      end

      it 'auto generates user key' do
        post v1_users_path, params: valid_attributes

        expect(result[:key]).to be_present
      end

      it 'generates account key asynchronously' do
        Sidekiq::Testing.inline! do
          allow(AccountKeyAsigner).to receive(:perform)
          post v1_users_path, params: valid_attributes

          expect(AccountKeyAsigner).to have_received(:perform)
        end
      end

      it 'stores the salt password' do
        post v1_users_path, params: valid_attributes

        created_user = User.last
        expect(created_user.password_digest).to be_present
        expect(created_user.password_digest).not_to eql(valid_attributes[:password])
        expect(created_user.authenticate(valid_attributes[:password])).to be_present
      end
    end

    context 'when creating user with duplicated valid attributes' do
      it 'fails and returns the error messages' do
        create :user, valid_attributes
        post v1_users_path, params: valid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(result[:errors]).to be_present
        expect(result[:errors].class).to eq(Array)
      end
    end
  end
end
