require 'rails_helper'

describe Stasis::Chamber do
  subject { Stasis::Chamber.new(owner: 'someone', name: 'some_repo', token: 'xxxxxxxx') }

  before do
    allow(subject).to receive(:clone_repo_from_github).and_return( `mkdir -p tmp/someone/some_repo > /dev/null 2>&1`)
  end

  describe '#activate' do
    it 'persists a repo' do
      expect{
        subject.suspend_subject
      }.to change{ Repo.count }.by(1)
    end

    it 'will upload the directory to s3' do
      expect(subject).to receive(:upload_repo_to_s3)
      subject.suspend_subject
    end
  end
end
