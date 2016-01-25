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

  def id
    suspended_repo.id
  end

  def suspended_repo
    SuspendedRepo.find_by(
      owner: octokit_repo.owner.login,
      name: octokit_repo.name
    )
  end

  def finished_processing?
    suspended_repo.s3_key.present?
  end

  def method_missing(method)
    octokit_repo.send(method)
  end
end
