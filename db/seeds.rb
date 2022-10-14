data = [
  { name: "Liam", age: 23, gender: :male },
  { name: "Olivia", age: 21, gender: :female },
  { name: "Noah", age: 30, gender: :male },
  { name: "Emma", age: 20, gender: :female },
  { name: "Oliver", age: 29, gender: :male },
  { name: "Charlotte", age: 21, gender: :female },
  { name: "Elijah", age: 18, gender: :male },
  { name: "Amelia", age: 13, gender: :female },
  { name: "James", age: 18, gender: :male },
  { name: "Ava", age: 17, gender: :female },
  { name: "William", age: 29, gender: :male },
  { name: "Sophia", age: 55, gender: :female },
  { name: "Benjamin", age: 8, gender: :male },
  { name: "Isabella", age: 90, gender: :female },
  { name: "Lucas", age: 77, gender: :male },
  { name: "Mia", age: 30, gender: :female },
  { name: "Henry", age: 15, gender: :male },
  { name: "Evelyn", age: 20, gender: :female },
  { name: "Theodore", age: 36, gender: :male },
]

user_attributes = data.each.with_index.map do |user, i|
  {
    "email": "#{user[:name].downcase}@example.com",
    "phone_number": "555123555#{i}",
    "password": "12341234#{i}",
    "full_name": "#{user[:name]} Smith",
    "key": SecureRandom.hex,
    "account_key": SecureRandom.hex,
    "metadata": "#{user[:gender]}, age #{user[:age]}",
  }
end

User.create(user_attributes)

