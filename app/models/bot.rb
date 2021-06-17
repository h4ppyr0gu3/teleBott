class Bot < ApplicationRecord
	has_many :groups
	has_many :histories
end
