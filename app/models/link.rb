class Link < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  acts_as_votable
end
