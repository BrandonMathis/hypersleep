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
    chamber.suspend_subject
    redirect_to repos_path
  end

  private
  def client
    client = Octokit::Client.new(access_token: current_user.github_token)
  end
end
