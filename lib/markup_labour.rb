require_relative 'markup_base'

#Assume that bodies can only be integers, there is no partial time allocated to projects.
class MarkupLabour < MarkupBase
	#constuctor
	def initialize(markup)
		super(markup)
	end
	
	def apply_markup_to(base_price,quantity)
		raise ArgumentError,"Base Price - Expecting a positive number: #{base_price.inspect}" unless (base_price.is_a?(Numeric) && base_price >= 0)		
		raise ArgumentError,"Quantity - Expecting a positive integer: #{quantity.inspect}" unless (quantity.is_a?(Integer) && quantity > 0)
		
		return ((base_price * (@markup * quantity))/100.0).round(2)
	end
end

if __FILE__ == $0
	ml = MarkupLabour.new(0)
	puts ml.to_s
	puts ml.apply_markup_to(100,5)
end
