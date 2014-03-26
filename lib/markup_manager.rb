require_relative 'markup_base'
require_relative 'markup_labour'
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
	
	def apply_flat_markup(base_price)
		raise ArgumentError,"Base Price - Expecting a positive number: #{base_price.inspect}" unless (base_price.is_a?(Numeric) && base_price >= 0)
		
		return (!@flat_markup.nil?) ? @flat_markup.apply_markup_to(base_price) : 0
	end
	
	def apply_labour_markup(base_price, quantity)
		raise ArgumentError,"Base Price - Expecting a positive number: #{base_price.inspect}" unless ((base_price.is_a?(Numeric)) && base_price >= 0)		
		raise ArgumentError,"Quantity - Expecting a positive integer: #{quantity.inspect}" unless (quantity.is_a?(Integer) && quantity > 0)
		
		return (!@labour_markup.nil?) ? @labour_markup.apply_markup_to(base_price, quantity) : 0
	end
	
	#returns a hash
	def apply_materials_markup(base_price,materials_array)
		raise ArgumentError,"Base Price - Expecting a positive number: #{base_price.inspect}" unless (base_price.is_a?(Numeric) && base_price >= 0)
		
		raise ArgumentError,"Materials - Expecting an Array: #{materials_array.inspect}" unless (materials_array.is_a?(Array) || materials_array.nil?)
		
		materials_markups = Hash.new
		if !materials_array.nil?
			materials_array.each do |mat|
				if (mat.is_a?(String) && !mat.nil?)
					markup_cost = calculate_material_cost(mat,base_price)
					materials_markups[mat] = (!markup_cost.nil?) ? markup_cost : 0
				end
			end
		end
		return materials_markups
	end
	
	def calculate_material_cost(material, base_price)
		raise ArgumentError,"Base Price - Expecting a positive number: #{base_price.inspect}" unless (base_price.is_a?(Numeric) && base_price >= 0)
		
		raise ArgumentError,"Material - Expecting a string: #{material.inspect}" unless (material.is_a?(String))
	
		m = material_markup_array.find {|s| s.material_name.upcase == material.upcase }
		return !m.nil? ? m.apply_markup_to(base_price) : nil
	end
	
	def to_s
		puts @flat_markup
		puts @labour_markup
		puts @material_markup_array
	end
	
	def set_new_markups(flat_markup_price = nil, labour_markup_price = nil, materials_price_hash = nil)		
		raise ArgumentError,"Expecting a number: #{flat_markup_price.inspect}" unless (flat_markup_price.nil? || flat_markup_price.is_a?(Numeric))
		raise ArgumentError,"Expecting a number: #{labour_markup_price.inspect}" unless (labour_markup_price.nil? || labour_markup_price.is_a?(Numeric))
		raise ArgumentError,"Expecting a Hash: #{materials_price_hash.inspect}" unless (materials_price_hash.nil? || materials_price_hash.is_a?(Hash))
		
		if(!@modified)
			@@mutex.synchronize {
				init_flat_markup(flat_markup_price)
				init_labour_markup(labour_markup_price)
				init_materials(materials_price_hash)
				
				@modified = true;
			}
		end			
	end
	
	private
	def init_flat_markup(flat_markup_price = nil)
		if !flat_markup_price.nil?
			raise ArgumentError,"Flat markup - Expecting a positive number: #{flat_markup_price.inspect}" unless (flat_markup_price.is_a?(Numeric) && flat_markup_price >= 0)
		else
			if !Markups.flat_markup.nil?
				raise ArgumentError,"Flat markup - Expecting a positive number: #{Markups.flat_markup.inspect}" unless (Markups.flat_markup.is_a?(Numeric)  && Markups.flat_markup >= 0)
				
				flat_markup_price = Markups.flat_markup
			else
				flat_markup_price = 0
			end
		end		
		
		@flat_markup = MarkupBase.new(flat_markup_price)
	end
	
	def init_labour_markup(labour_markup_price = nil)
		if !labour_markup_price.nil?
			raise ArgumentError,"Labour markup - Expecting a positive number: #{labour_markup_price.inspect}" unless (labour_markup_price.is_a?(Numeric) && labour_markup_price >= 0)
		else
			if !Markups.labour_markup.nil?
				raise ArgumentError,"Labour markup - Expecting a positive number: #{Markups.labour_markup.inspect}" unless (Markups.labour_markup.is_a?(Numeric) && Markups.labour_markup >= 0)
				
				labour_markup_price = Markups.labour_markup
			else
				labour_markup_price = 0
			end
		end
		
		@labour_markup = MarkupLabour.new(labour_markup_price)
	end
	
	def init_materials(materials_price_hash = nil)
		@material_markup_array = Array.new
		if !materials_price_hash.nil?
			raise ArgumentError,"Materials Markup - Expecting a Hash: #{materials_price_hash.inspect}" unless (materials_price_hash.is_a?(Hash))
			
			materials_price_hash.each_pair do |k, v| 
				if k.is_a?(String)
					@material_markup_array << MarkupMaterial.new(v,k)
				end
			end
		else
			if !Markups.materials_markup.nil?
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
			# @material_markup_array = Array.new
			# @material_markup_array << MarkupMaterial.new(7.5,"Pharmaceuticals")
			# @material_markup_array << MarkupMaterial.new(13, "Food")
			# @material_markup_array << MarkupMaterial.new(2, "Electronics")
		end
	end
	
	#Singleton behaviour:
	@modified = false #This variable will let the user of the class set the markups once.
	@@mutex = Mutex.new #semaphore used to make sure there are no race conditions on setting the @modified variable
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