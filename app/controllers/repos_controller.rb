class ReposController < ApplicationController
  def index
    if current_user
      Octokit.auto_paginate = true
      @repos = client.org_repos('smashingboxes', type: :private)
    end
  end

  def clone
    repo = client.repo("#{params[:user]}/#{params[:name]}")
    flash[:notice] = repo.clone_url
    redirect_to repos_path
  end

  private
  def client
    client = Octokit::Client.new(access_token: current_user.github_token)
  end
end
