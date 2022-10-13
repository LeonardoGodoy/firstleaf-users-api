module V1
  module SearchUsers
    def self.search(query: , scope: User.all)
      return scope if query.blank?

      if query[:email].present?
        scope = scope.where('users.email ILIKE ?', "%#{query[:email]}%")
      end

      if query[:full_name].present?
        scope = scope.where('users.full_name ILIKE ?', "%#{query[:full_name]}%")
      end

      if query[:metadata].present?
        scope = scope.where('users.metadata ILIKE ?', "%#{query[:metadata]}%")
      end

      scope
    end
  end
end