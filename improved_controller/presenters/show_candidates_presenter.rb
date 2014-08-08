class ShowCandidatesPresenter
  attr_reader :open_jobs, :job_contacts

  def initialize(open_jobs, job_contacts, candidates)
    @open_jobs    = open_jobs
    @job_contacts = job_contacts
    @candidates   = candidates
  end

  def self.user_contacts_only(user, sort_by)
    job_contacts = JobContact.all(:user_id => current_user.id)
    jobs          = []
    candidates    = []
    return if job_contacts.empty?
    job_ids = job_contacts.map {|x| x.job_id}

    # TODO: this still needs more refactoring
    Job.find_non_deleted_by_ids(job_ids).each do |job|
      next if job.blank?
      candidate_jobs = CandidateJob.all(:job_id => job.id)
      next if candidate_jobs.empty?

      candidate_jobs.each do |cj|
        candidate = cj.candidate
        if candidate.belongs_to_organization(current_user.organization_id)
          found = false
          unless candidates.blank?
            candidates.each do |cand| #TODO: Maybe use a .any?
              found = true if cand.email_address == candidate.email_address
            end
          end
          candidates << candidate if !found
        end

        # WARNING: ?this seems like it would get overriden everytime jobs loop runs
        candidates = sort_candidates(candidates, sort_by)

      end

    end
    return [job_contacts, candidates]
  end

  def self.assemble_contacts(user, sort_by)
    return user_contacts_only(user, sort_by) unless user.has_permission?('view_candidates')
    return [user.organization.grab_candidates(sort_by), nil] # TODO: should return a hash, or set this up as an object using instance vars, not a class method
  end


  def sort_candidates(candidates, sort_by)
    if sort_by == "Candidates Newest -> Oldest"
      candidates = candidates.sort_by { |c| c.created_at }
    elsif sort_by == "Candidates Oldest -> Newest"
      candidates = candidates.sort_by { |c| c.created_at }.reverse
    elsif sort_by == "Candidates A -> Z"
      candidates = candidates.sort_by { |c| c.created_at }.sort! { |a, b| a.last_name <=> b.last_name }
    elsif sort_by == "Candidates Z -> A"
      candidates = candidates.sort_by { |c| c.created_at }.sort! { |a, b| a.last_name <=> b.last_name }.reverse
    end
  end

end