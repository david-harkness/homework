class User < Sequel::Model
  many_to_one :user_organizations

end