class UserOrganization < Sequel::Model
  many_to_one :organization
  many_to_one :user
end