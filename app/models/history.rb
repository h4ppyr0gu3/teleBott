class History < ApplicationRecord
	belongs_to :bots, optional: true
end
