class ReposController < ApplicationController
  def index
    if current_user
      Octokit.auto_paginate = true
      octokit_repos = client.repos(nil, type: :private).sort_by{ |r| r.pushed_at.to_time }
      @repos = octokit_repos.map { |r| Repo.new(r) }
    end
  end

  def suspend
    chamber = Stasis::Chamber.new(
      owner: params[:owner],
      name: params[:name],
      token: current_user.github_token
    )
    chamber.schedule_for_suspension unless chamber.suspended?
    redirect_to repos_path
  end

  def download
    redirect_to SuspendedRepo.find(params[:id]).url
  end

  private
  def client
    client = Octokit::Client.new(access_token: current_user.github_token)
  end
end
