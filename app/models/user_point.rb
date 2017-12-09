class UserPoint < ApplicationRecord

  belongs_to :user

  delegate :phone, to: :user, allow_nil: true

  def format_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
