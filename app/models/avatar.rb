# frozen_string_literal: true
class Avatar < ActiveRecord::Base
  belongs_to :user
end
