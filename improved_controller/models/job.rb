class Job < ApplicationController
  def self.find_non_deleted_by_ids
    find(job_ids, :conditions => {:is_deleted => false})
  end
end