require_relative 'markup_material'
require_relative 'markup_manager'

class Estimate
	attr_reader :base_price, :flat_charge, :labour_quantity, :labour_charged, :materials_charged_hash
	
	# Setter method for base_price. This also re-calculates the charges for labour
	# and materials
	# * *Params*:
	#   - +value+:: +Numeric+ base_price of the project
	# * *Raises* :
	#   - +ArgumentError+:: if value is nil or negative
	#
	def base_price=(value)
		raise ArgumentError,"Base Price - Expecting a positive number: #{value.inspect}" unless (value.is_a?(Numeric) && value >= 0)
		
		@base_price = value
		@flat_charge = MarkupManager.instance.apply_flat_markup_to(@base_price)
		
		base_plus_flat = @base_price + flat_charge
		
		@labour_charged = !labour_quantity.nil? ? MarkupManager.instance.apply_labour_markup_to(base_plus_flat, labour_quantity) : 0
		
		recalc_materials_charges
	end
	
	# Setter method for labour_quantity. This also re-calculates the charges for labour
	# * *Params*:
	#   - +value+:: +Integer+ number of workers needed for the project
	# * *Raises* :
	#   - +ArgumentError+:: if value is nil or negative
	#
	def labour_quantity=(value)
		raise ArgumentError,"Number of workers - Expecting a positive integer: #{value.inspect}" unless (value.is_a?(Integer) && value > 0)
		
		@labour_quantity = value
		base_plus_flat = @base_price + @flat_charge		
		@labour_charged = MarkupManager.instance.apply_labour_markup_to(base_plus_flat, @labour_quantity)
	end
	
	# Initialize method for Estimate
	# * *Params*:
	#   - +base_price+:: +Numeric+, base price of the estimate 
	#   - +labour_quantity+:: +Integer+ How many people need to be involved
	#   - +materials_array+:: +Array+ Materials tagged to the estimate(may be nil)
	# * *Raises* :
	#   - +ArgumentError+:: if any parameter is nil or negative
	#
	def initialize(base_price,labour_quantity, materials_array = nil) #:notnew:
		raise ArgumentError,"Base Price - Expecting a positive number: #{base_price.inspect}" unless (base_price.is_a?(Numeric) && base_price >= 0)
		raise ArgumentError,"Number of workers - Expecting a positive integer: #{labour_quantity.inspect}" unless (labour_quantity.is_a?(Integer) && labour_quantity > 0)
		raise ArgumentError,"Materials - Expecting an Array: #{materials_array.inspect}" unless (materials_array.nil? || materials_array.is_a?(Array))
		
		@base_price = base_price
		@flat_charge = MarkupManager.instance.apply_flat_markup_to(@base_price)
		
		base_plus_flat = @base_price + @flat_charge
		
		@labour_quantity = labour_quantity
		@labour_charged = MarkupManager.instance.apply_labour_markup_to(base_plus_flat, labour_quantity)

		@materials_charged_hash = !materials_array.nil? ? MarkupManager.instance.apply_materials_markup_to(base_plus_flat, materials_array) : Hash.new
	end
	
	# Add material to the estimate
	# * *Params*:
	#   - +material+:: +String+ name of the material to add
	# * *Raises* :
	#   - +ArgumentError+:: if material is not a string
	#
	def add_material(material)
		raise ArgumentError,"Material - Expecting a string: #{material.inspect}" unless (material.is_a?(String))
		base_plus_flat = @base_price + @flat_charge
		if(!MarkupManager.material?(material,@materials_charged_hash))
			price = MarkupManager.instance.calculate_material_cost(base_plus_flat,material)
			@materials_charged_hash[material] = price
		end
	end
	
	# Clears all the materials selected
	def clear_materials
		@materials_charged_hash = Hash.new
	end
	
	# Recalculate material charges for this estimate
	def recalc_materials_charges
		base_plus_flat = @base_price + @flat_charge
		@materials_charged_hash.keys.each do |key|
			@materials_charged_hash[key] = MarkupManager.instance.calculate_material_cost(base_plus_flat, key)
		end
	end
	
	
	# Calculate the final for Estimate
	# * *Returns* :
	#   - +final_price+:: +Numeric+ final price to give to the client.
	#
	def get_final_price
		final_price = @materials_charged_hash.reduce(0) { |sum, (key,val)| sum + (val.nil? ? 0 : val) }
		final_price += (@base_price + @flat_charge + @labour_charged)
		return final_price.round(2)
	end
	
	# Get a friendly 'stringyfied' version of the estimate
	def to_s
		materials_hash_to_s = "" 
		if !@materials_price_hash.nil?
			@materials_price_hash.each_pair do |k, v| 
					materials_hash_to_s += k + " - " + v.to_s
			end
		end
		
		return "Base Price: " + @base_price.to_s + ", Flat charge: " + @flat_charge.to_s + ", Charged " + @labour_charged.to_s + " for " + @labour_quantity.to_s + " workers. Materials " + materials_hash_to_s + " TOTAL: " + get_final_price.to_s + " Date given: " + date_estimate_given.to_s + " by " + employee_ID + " for " + @company
	end
end