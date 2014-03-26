# Holds all the static information regarding the different markups.
module Markups
	@@flat_markup = 5.0
	@@labour_markup = 1.2
	
	@@materials_markup = Hash.new
	@@materials_markup["Food"] = [13]
	@@materials_markup["Pharmaceuticals"] = [7.5, ["drugs"]]
	@@materials_markup["Electronics"] = [2]
	
	def self.flat_markup
		return @@flat_markup
	end
	
	def self.labour_markup
		return @@labour_markup
	end
	
	def self.materials_markup
		return @@materials_markup
	end
end