require_relative 'markup_material'
require_relative 'markup_manager'

class Estimate
	attr_reader :base_price, :flat_charge, :labour_quantity, :labour_charged, :materials_charged_hash, :date_estimate_given, :employee_ID, :company
	
	# Initialize method for Estimate
	# * *Params*:
	#   - +base_price+:: +Numeric+, base price of the estimate 
	#   - +labour_quantity+:: +Integer+ How many people need to be involved
	#   - +materials_array+:: +Array+ Materials tagged to the estimate(may be nil)
	#   - +date_estimate_given+:: +DateTime+ Date when the estimate was given(may be nil)
	#   - +employee_ID+:: +String+ Employee who created the estimate(may be nil) - It will default to 'Auto'
	#   - +company+:: +String+ Company the estimate is for
	# * *Raises* :
	#   - +ArgumentError+ -> if any parameter is nil or negative
	#
	def initialize(base_price,labour_quantity, materials_array = nil, date_estimate_given = nil, employee_ID = nil, company = nil) #:notnew:
		raise ArgumentError,"Base Price - Expecting a positive number: #{base_price.inspect}" unless (base_price.is_a?(Numeric) && base_price >= 0)
		raise ArgumentError,"Number of workers - Expecting a positive integer: #{labour_quantity.inspect}" unless (labour_quantity.is_a?(Integer) && labour_quantity > 0)
		raise ArgumentError,"Materials - Expecting an Array: #{materials_array.inspect}" unless (materials_array.nil? || materials_array.is_a?(Array))
		
		@base_price = base_price
		@flat_charge = MarkupManager.instance.apply_flat_markup_to(base_price)
		
		base_plus_flat = base_price + flat_charge
		
		@labour_quantity = labour_quantity
		@labour_charged = MarkupManager.instance.apply_labour_markup_to(base_plus_flat, labour_quantity)
		
		@materials_charged_hash = MarkupManager.instance.apply_materials_markup_to(base_plus_flat, materials_array)
		
		@date_estimate_given = date_estimate_given.nil? ? Time.now.strftime("%d/%m/%Y %H:%M") : date_estimate_given
		@employee_ID = employee_ID.nil? ? 'auto' : employee_ID
		@company = company.nil? ? "" : company
	end
	
	# Initialize method for Estimate
	# * *Returns* :
	#   - +final_price+:: +Numeric+ final price to give to the client.
	#
	def get_final_price
		final_price = @materials_charged_hash.reduce(0) { |sum, (key,val)| sum + (val.nil? ? 0 : val) }
		final_price += (@base_price + @flat_charge + @labour_charged)
		return final_price.round(2)
	end
		
	# Get a friendly version of the estimate
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

if __FILE__ == $0
	arr = Array.new
	arr << "food"
	est = Estimate.new(100,2,arr)
	puts est.to_s	
end