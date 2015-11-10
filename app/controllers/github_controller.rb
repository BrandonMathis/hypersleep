class GithubController < ApplicationController
  def repos
    @repos = Octokit::Client.new(access_token: current_user.github_token).repos
  end
end
