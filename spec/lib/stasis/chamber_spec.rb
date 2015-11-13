require 'rails_helper'

describe Stasis::Chamber do
  subject { Stasis::Chamber.new(owner: 'someone', name: 'some_repo', token: 'xxxxxxxx') }

  before do
    allow(subject).to receive(:clone_repo_from_github)
  end

  describe '#activate' do
    it 'persists a repo' do
      expect{
        subject.activate
      }.to change{ Repo.count }.by(1)
    end

    it 'will upload the directory to s3'
  end
end
