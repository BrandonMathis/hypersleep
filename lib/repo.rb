class Repo
  attr_reader :octokit_repo

  def initialize(octokit_repo)
    @octokit_repo = octokit_repo
  end

  def suspended?
    SuspendedRepo.where(
      owner: octokit_repo.owner.login,
      name: octokit_repo.name
    ).present?
  end

  def method_missing(method)
    octokit_repo.send(method)
  end
end
