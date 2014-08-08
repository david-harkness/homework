class Organization < ActiveRecord::Base
  def grab_candidates(sort_by)
    candidates_lazy = candidates.where(:is_deleted => false).where(:is_completed => true)

    if sort_by == "Candidates Newest -> Oldest"
      candidates_lazy.order(created_at: :desc)
    elsif sort_by == "Candidates Oldest -> Newest"
      candidates_lazy.order(created_at: :asc)
    elsif sort_by == "Candidates A -> Z"
      candidates_lazy.order(last_name: :asc)
    elsif sort_by == "Candidates Z -> A"
      candidates_lazy.order(last_name: :desc)
    end
    candidates_lazy.all
  end

end