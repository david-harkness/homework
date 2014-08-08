class Candidate < ActiveRecord::Base


  def belongs_to_organization(org_id)
    !is_deleted && candidate.is_completed && organization_id == org_id
  end

end