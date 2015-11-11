class ReposController < ApplicationController
  def index
    if current_user
      Octokit.auto_paginate = true
      @repos = client.org_repos('smashingboxes', type: :private)
    end
  end

  def suspend
    repo = Repo.where(
      user: current_user,
      owner: params[:owner],
      name: params[:name]
    ).first_or_create(suspended: true)
    repo.clone
    redirect_to repos_path
  end

  private
  def client
    client = Octokit::Client.new(access_token: current_user.github_token)
  end
end
