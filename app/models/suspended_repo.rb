class SuspendedRepo < ActiveRecord::Base
  def full_name
    owner + '/' + name
  end
end
