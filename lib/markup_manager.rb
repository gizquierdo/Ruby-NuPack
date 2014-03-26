require_relative 'markup_material'
require_relative 'markups' #contains the static data for the singleton

class MarkupManager
	attr_reader :flat_markup, :labour_markup, :material_markup_array
	
	def initialize()
		init_flat_markup
		init_labour_markup
		init_materials
	end
	
	def get_possible_materials
		raise "The array is nil! Try initializing the singleton." unless (!material_markup_array.nil?)
		
		@material_markup_array.map{|m| m.material_name}
	end
	
	def apply_flat_markup_to(base_price)
		raise ArgumentError,"Base Price - Expecting a positive number: #{base_price.inspect}" unless (base_price.is_a?(Numeric) && base_price >= 0)
		
		if !@flat_markup.nil? && @flat_markup.is_a?(Numeric)
			return (base_price * @flat_markup)/100.0
		else
			return 0;
		end
	end
	
	def apply_labour_markup_to(price, quantity)
		raise ArgumentError,"Price - Expecting a positive number: #{price.inspect}" unless ((price.is_a?(Numeric)) && price >= 0)		
		raise ArgumentError,"Quantity - Expecting a positive integer: #{quantity.inspect}" unless (quantity.is_a?(Integer) && quantity > 0)
		
		if !@labour_markup.nil? && @labour_markup.is_a?(Numeric)
			return  (price * (@labour_markup * quantity))/100.0
		else
			return 0;
		end
	end
	
	#returns a hash
	def apply_materials_markup_to(price,materials_array)
		raise ArgumentError,"Price - Expecting a positive number: #{price.inspect}" unless (price.is_a?(Numeric) && price >= 0)
		
		raise ArgumentError,"Materials - Expecting an Array: #{materials_array.inspect}" unless (materials_array.is_a?(Array) || materials_array.nil?)
		
		materials_markups = Hash.new
		if !materials_array.nil?
			materials_array.each do |mat|
				if (mat.is_a?(String) && !mat.nil?)
					markup_cost = calculate_material_cost(price,mat)
					materials_markups[mat] = (!markup_cost.nil?) ? markup_cost : 0
				end
			end
		end
		return materials_markups
	end
	
	def calculate_material_cost(price,material)
		raise ArgumentError,"Price - Expecting a positive number: #{price.inspect}" unless (price.is_a?(Numeric) && price >= 0)
		
		raise ArgumentError,"Material - Expecting a string: #{material.inspect}" unless (material.is_a?(String))
	
		m = material_markup_array.find {|s| s.material_name.upcase == material.upcase }
		
		if !m.nil?
			return (price * m.markup)/100.0
		else
			return 0;
		end
	end
	
	def to_s
		puts @flat_markup
		puts @labour_markup
		puts @material_markup_array
	end
	
	private
	def init_flat_markup()
		if !Markups.flat_markup.nil?
			raise ArgumentError,"Flat markup - Expecting a positive number: #{Markups.flat_markup.inspect}" unless (Markups.flat_markup.is_a?(Numeric)  && Markups.flat_markup >= 0)
			
			@flat_markup = Markups.flat_markup
		else
			@flat_markup = 0
		end		
	end
	
	def init_labour_markup()
		if !Markups.labour_markup.nil?
			raise ArgumentError,"Labour markup - Expecting a positive number: #{Markups.labour_markup.inspect}" unless (Markups.labour_markup.is_a?(Numeric) && Markups.labour_markup >= 0)
			
			@labour_markup = Markups.labour_markup
		else
			@labour_markup = 0
		end
	end
	
	def init_materials()
		@material_markup_array = Array.new
		if !Markups.materials_markup.nil?
			raise ArgumentError,"Materials Markup - Expecting a Hash: #{Markups.materials_markup.inspect}" unless (Markups.materials_markup.is_a?(Hash))
			
			Markups.materials_markup.each_pair do |k, v| 
				markup = 0
				if k.is_a?(String) && v.is_a?(Array) && v.count > 0 && v[0].is_a?(Numeric)
					markup = v[0]
					if v[1].is_a?(Array)
						v[1].each do |mat|
							@material_markup_array << MarkupMaterial.new(markup,mat, k)
						end
					end
				end
				@material_markup_array << MarkupMaterial.new(markup,k,nil)
			end
		end
	end
	
	#Singleton behaviour:
	@@instance = MarkupManager.new #The singleton object.
		
	def self.instance
		return @@instance
	end
	
	private_class_method :new
end


if __FILE__ == $0
	mm = MarkupManager.instance
	puts mm.material_markup_array
	#puts mm.calculate_material_cost("mmm",100).inspect
	
	# h = Hash.new
	# h["Food"] = 13
	# res = MarkupManager.instance.apply_materials_markup(100,["Food"])
	# puts res
end