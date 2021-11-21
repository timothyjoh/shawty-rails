# frozen_string_literal: true

# Base Abstract of ActiveRecord
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
