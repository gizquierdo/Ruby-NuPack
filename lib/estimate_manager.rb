require_relative 'estimate'

# This is an interface class for Estimate
class EstimateManager	
	# Get only the final price given a variabl number of parameters
	# * *Params*:
	#   - +base_price+:: +Numeric+, base price of the estimate 
	#   - +labour_quantity+:: +Integer+ How many people need to be involved
	#   - +materials_array+:: +Array+ Materials tagged to the estimate(may be nil)
	# * *Raises* :
	#   - +ArgumentError+:: if any parameter is nil or negative
	#
	def self.get_new_estimate_final_price(base_price,labour_quantity, materials_array = nill)
		new_estimate = Estimate.new(base_price,labour_quantity, materials_array)
		raise "Something has gone wrong" unless !new_estimate.nil?		
		
		return new_estimate.get_final_price
	end
end