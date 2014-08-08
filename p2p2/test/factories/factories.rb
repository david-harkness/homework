FactoryGirl.define do

  to_create { |i| i.save }

  factory :organization do
    type "root"
    name "Root Organization"
    org_id nil
    root_id nil
  end

  factory :user do
    name "John Smith"
  end

  factory :user_organizations do
    role 'admin'
  end

end
