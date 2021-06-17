class Group < ApplicationRecord
	belongs_to :bots, optional: true
end
