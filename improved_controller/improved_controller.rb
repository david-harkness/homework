class ImprovedController < ApplicationController
  before_filter :set_sort, :only => :show_candidates

  def show_candidates
    open_jobs                = Job.all_open_new(current_user.organization)
    job_contacts, candidates = ShowCandidatePresenter.assemble_contacts(current_user, @sort_by)
    @jobs                    = ShowCandidatesPresenter.new(open_jobs, job_contacts, candidates)
    render :layout => false
  end

  private

  def set_sort
    @sort_by = params[:sort]
    @sort_by = "All Candidates" if @sort_by.blank?
  end
end
