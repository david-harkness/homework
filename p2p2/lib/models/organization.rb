class Organization < Sequel::Model
  one_to_many :user_organizations, :key => :organization_id
  one_to_many :users, :through => :user_organizations

  def grant(role, user)
    UserOrganization.new(role:role, user_id:user.id, organization_id:self.id).save
  end

  def has_parent?
    return false if type == 'root'
    true
  end

  def parent # check if is already root, then if org, lastly assume its a leaf node
    return nil unless has_parent?
    return Organization[self.root_id] if type == 'organization'
    Organization[self.org_id]
  end

  def what_is_my_role?(user)
    user_org = UserOrganization.first(user_id:user.id, organization_id:self.id) # Find my own role
    return nil if user_org && user_org.role == 'denied' # If denied, don't go any further
    return user_org.role if user_org
    return self.parent.what_is_my_role?(user) if self.has_parent? # Check my parent, and maybe grand parent
    nil
  end

  # Check current org and all parents for role. Stop when found
  def user_has_role?(role, user)
    user_org = UserOrganization.first(user_id:user.id, organization_id:self.id) # Find my own role
    return (user_org.role == role) if user_org # I have a role, return if it matches or not
    return self.parent.user_has_role?(role, user) if self.has_parent? # Check my parent, and maybe grand parent
    false
  end
end

#require './config/configure'; u = User.new.save; o = Organization.new.save
# uo = UserOrganization.new(user_id: u.id, organization_id: o.id, role:'admin')
# o.user_organizations << uo