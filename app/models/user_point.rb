class UserPoint < ApplicationRecord

  belongs_to :user

  delegate :phone, to: :user, allow_nil: true
end
