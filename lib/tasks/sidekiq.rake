require 'sidekiq/api'

namespace :sidekiq do
  desc 'clear all jobs'
  task clear: :environment do
    Sidekiq::RetrySet.new.clear
    Sidekiq::Queue.all.each { |q| q.clear }
  end
end
