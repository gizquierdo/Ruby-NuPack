require_relative 'markup_base'
require_relative 'markup_labour'
require_relative 'markup_material'
require_relative 'markup_manager'

class Estimate
	attr_reader :base_price, :flat_charge, :labour_quantity, :labour_charged, :materials_charged_hash, :total_price, :date_estimate_given, :employee_ID
	
	def initialize(base_price,labour_quantity, materials_array = nil, date_estimate_given = nil, employee_ID = nil)
		raise ArgumentError,"Base Price - Expecting a positive number: #{base_price.inspect}" unless (base_price.is_a?(Numeric) && base_price >= 0)
		raise ArgumentError,"Number of workers - Expecting a positive integer: #{labour_quantity.inspect}" unless (labour_quantity.is_a?(Integer) && labour_quantity > 0)
		raise ArgumentError,"Materials - Expecting an Array: #{materials_array.inspect}" unless (materials_array.nil? || materials_array.is_a?(Array))
		
		@base_price = base_price
		@flat_charge = MarkupManager.instance.apply_flat_markup(base_price)
		
		base_plus_flat = base_price + flat_charge
		
		@labour_quantity = labour_quantity
		@labour_charged = MarkupManager.instance.apply_labour_markup(base_plus_flat, labour_quantity)
		
		@materials_charged_hash = MarkupManager.instance.apply_materials_markup(base_plus_flat, materials_array)
		total_mat_markup = materials_charged_hash.reduce(0) { |sum, (key,val)| sum + (val.nil? ? 0 : val) }
		
		@total_price = (@base_price + @flat_charge + @labour_charged + total_mat_markup).round(2)			
		
		@date_estimate_given = date_estimate_given.nil? ? Time.now.strftime("%d/%m/%Y %H:%M") : date_estimate_given
		@employee_ID = employee_ID.nil? ? 'auto' : employee_ID
	end
	
	#This function will return a json object
	def get_price_breakdown_string
		return "Base Price: " + @base_price.to_s + " Flat charge: " + @flat_charge.to_s + " Charged " + @labour_charged.to_s + " for " + @labour_quantity.to_s + " workers. Materials " +  materials_hash_to_s + " TOTAL: " + total_price.to_s
	end
	
	def materials_hash_to_s
		retval = 0
		if !@materials_price_hash.nil?
			@materials_price_hash.each_pair do |k, v| 
					retval += k + " - " + v.to_s
			end
		end
		return retval.to_s
	end
	
	def to_s
		get_price_breakdown_string + " Date given: " + date_estimate_given.to_s + " by " + employee_ID
	end
end

if __FILE__ == $0
	arr = Array.new
	arr << "food"
	est = Estimate.new(100,2,arr)
	est.to_s	
end