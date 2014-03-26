class MarkupBase
	attr_reader :markup
	
	#constuctor
	def initialize(markup)
		raise ArgumentError,"Markup - Expecting a number from 0-100, you entered: #{markup.inspect}" unless (markup.is_a?(Numeric) && markup >=0 && markup <=100)
		@markup = markup
	end
	
	def apply_markup_to(base_price)
		if !base_price.nil?
			raise ArgumentError,"Base Price - Expecting a positive number: #{base_price.inspect}" unless (base_price.is_a?(Numeric) && base_price >= 0)
			
			return ((base_price * @markup)/100.0).round(2)
		end
	end
	
	def to_s
		@markup.to_s + '%'
	end
end

if __FILE__ == $0
	mb = MarkupBase.new(5)
	puts mb.to_s
	puts mb.apply_markup_to(1).to_s
end
