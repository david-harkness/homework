require "rubygems"
require "sequel"

DB = Sequel.sqlite # memory only

DB.create_table :users do
  primary_key :id, autoincrement: true
  String :name
end

DB.create_table :organizations do
  primary_key :id, autoincrement: true
  String :name
  String :type
  Integer :org_id
  Integer :root_id
end

DB.create_table :user_organizations do
  primary_key :id, autoincrement: true
  String :role
  foreign_key :organization_id, :organizations
  foreign_key :user_id, :users
end



Dir.glob('lib/models/*.rb').each {|r| require_relative "#../../../#{r}"}

