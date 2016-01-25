class Stasis::Worker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(owner, name, token)
    chamber = Stasis::Chamber.new(
      owner: owner,
      token: token,
      name: name
    )
    chamber.suspend_subject
  end
end
