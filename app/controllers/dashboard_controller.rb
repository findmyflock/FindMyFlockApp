class DashboardController < ApplicationController

  def index
    if current_user.nil?
      redirect_to new_user_path
    elsif current_user.skills.empty?
      redirect_to edit_user_path(current_user)
    else
      @jobs = Job.all
      @my_matched_jobs = matched_jobs
      @favorited = current_user.favorites.map(&:job)
      @applied = current_user.applications.map(&:job)
    end
  end


  def matched_jobs

    if current_user.value_list.empty?
      value_matched_jobs = Job.all
    else
      value_matched_jobs = Job.all.tagged_with(current_user.value_list, :on => :values)
    end

    if current_user.location_list.empty?
      location_matched_jobs = value_matched_jobs
    else
      location_matched_jobs = value_matched_jobs.tagged_with(current_user.location_list, :any => true)
    end

    not_sponsored_jobs = []

    @jobs.each do |job|
      if job.provide_sponsorship? == false
        not_sponsored_jobs << job
      end
    end

    if current_user.have_sponsorship? == true
      sponsorship_matched_jobs = location_matched_jobs
    else
      sponsorship_matched_jobs = (location_matched_jobs - not_sponsored_jobs)
    end

    skill_matched_jobs = []
    array_of_user_skills = current_user.skill_list.map(&:downcase)
    array_of_job_skills =[]

    sponsorship_matched_jobs.each do |job|
      array_of_job_skills = job.cached_skill_list.split(', ').map(&:downcase) unless job.cached_skill_list.nil?
      if (array_of_job_skills - array_of_user_skills).empty?
        skill_matched_jobs << job
      end
    end

    if current_user.min_salary.nil?
      return skill_matched_jobs
    else
      jobs = skill_matched_jobs
      matched_jobs = []
      jobs.each do |job|
        if job.max_salary > current_user.min_salary
          matched_jobs <<  job
        end
      end
    end
  return matched_jobs
end
end
