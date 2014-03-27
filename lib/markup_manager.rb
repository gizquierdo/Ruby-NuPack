require_relative 'markup_material'
require_relative 'markups' #contains the static data for the singleton
# Implements the singleton pattern
class MarkupManager
	attr_reader :flat_markup, :labour_markup, :material_markup_hash
	
	def initialize() #:notnew:
		init_flat_markup
		init_labour_markup
		init_materials
	end
	
	# Given the base price, the method applies the flat markup and returns
	# the result
	# * *Params*:
	#   - +base_price+:: +Numeric+ Base price
	# * *Returns*:
	#   - +retVal+:: +Numeric+ Result of applyng the markup loaded
	# * *Raises* :
	#   - +ArgumentError+:: if base_price is nil or negative
	#
	def apply_flat_markup_to(base_price)
		raise ArgumentError,"Base Price - Expecting a positive number: #{base_price.inspect}" unless (base_price.is_a?(Numeric) && base_price >= 0)
		
		retVal = 0
		if !@flat_markup.nil? && @flat_markup.is_a?(Numeric)
			retVal = (base_price * @flat_markup)/100.0
		end
		
		return retVal
	end
	
	# Given a price, and how many workers are needed, the method applies the labour markup and returns the result
	# * *Params*:
	#   - +price+:: +Numeric+ Base price (In this case it is base + flat markup)
	#   - +quantity+:: +Integer+ Must be > 0 
	# * *Returns*:
	#   - +retVal+:: +Numeric+ How much it costs to have _quantity_ workers
	# * *Raises* :
	#   - +ArgumentError+:: if any parameter is nil or negative
	#
	def apply_labour_markup_to(price, quantity)
		raise ArgumentError,"Price - Expecting a positive number: #{price.inspect}" unless ((price.is_a?(Numeric)) && price >= 0)		
		raise ArgumentError,"Quantity - Expecting a positive integer: #{quantity.inspect}" unless (quantity.is_a?(Integer) && quantity > 0)
			
		retVal = 0
		if !@labour_markup.nil? && @labour_markup.is_a?(Numeric)
			retVal =  (price * (@labour_markup * quantity))/100.0
		end
		
		return retVal
	end
	
	# Given a price, and the tagged materials, the method applies the markup for each material
	# * *Params*:
	#   - +price+:: +Numeric+ 
	#   - +materials_array+:: +Array+ Materials we have tagged to the estimate
	# * *Returns*:
	#   - +materials_markups+:: +Hash+ Per material, how much it costs
	# * *Raises* :
	#   - +ArgumentError+:: if any parameter is nil or negative
	#
	def apply_materials_markup_to(price,materials_array)	
		raise ArgumentError,"Price - Expecting a positive number: #{price.inspect}" unless (price.is_a?(Numeric) && price >= 0)
		raise ArgumentError,"Materials - Expecting an Array: #{materials_array.inspect}" unless (materials_array.is_a?(Array) || materials_array.nil?)
		
		materials_markups = Hash.new
		materials_array.each do |mat|
			if (mat.is_a?(String) && !mat.nil?)
				markup_cost = calculate_material_cost(price,mat)
				materials_markups[mat] = (!markup_cost.nil?) ? markup_cost : 0
			end
		end		
		return materials_markups
	end
	
	# Given a price, and a specific material, apply the markup and return the price
	#
	# * *Params* :
	#   - +price+:: +Numeric+, price to apply the markup to
	#   - +material+:: +String+, price to apply the markup to
	# * *Returns* :
	#   - +retVal+:: +Numeric+ = price * markup /100. Will be 0 if material doesn't exist
	# * *Raises* :
	#   - +ArgumentError+:: if any parameter is nil or negative
	#
	def calculate_material_cost(price,mat_name)
		raise ArgumentError,"Price - Expecting a positive number: #{price.inspect}" unless (price.is_a?(Numeric) && price >= 0)		
		raise ArgumentError,"Material - Expecting a string: #{mat_name.inspect}" unless (mat_name.is_a?(String))

		retVal = 0
		if MarkupManager.material?(mat_name,@material_markup_hash)
			retVal = (price * @material_markup_hash[mat_name.upcase].markup)/100.0
		end

		return retVal
	end
	
	# Checks the hash of materials comparing the names (uppercase) to
	# find whether it already exists or not
	# * *Params* :
	#   - +material+:: +String+, material name to look for.
	#   - +material_hash+:: +Hash+ place to look in
	# * *Returns* :
	#   - bool which tells us if the material is present or not.
	# * *Raises* :
	#   - +ArgumentError+:: if material is nil or not a string
	#
	def self.material?(material,material_hash)
		raise ArgumentError,"Material - Expecting a string: #{material.inspect}" unless (material.is_a?(String))
		raise ArgumentError,"material_hash - Expecting a hash: #{material_hash.inspect}" unless (material_hash.is_a?(Hash))
		
		material_hash.each_pair do |k, v| 
			if k.upcase == material.upcase
				return true
			end
		end
		return false
	end
	
	# Stringify this singleton!
	def to_s
		return "Flat markkup: " + @flat_markup.to_s + " Labour markup: " + @labour_markup.to_s + " Materials: " + @material_markup_hash.to_s
	end
	
	private
	# Read the static data into flat_markup
	# * *Raises* :
	#   - +ArgumentError+:: if the static markup is nil or negative
	#
	def init_flat_markup()
		if !Markups.flat_markup.nil?
			raise ArgumentError,"Flat markup - Expecting a positive number: #{Markups.flat_markup.inspect}" unless (Markups.flat_markup.is_a?(Numeric) && Markups.flat_markup >= 0)
			
			@flat_markup = Markups.flat_markup
		else
			@flat_markup = 0
		end		
	end
	
	# Read the static data into labour_markup
	# * *Raises* :
	#   - +ArgumentError+:: if the static markup is nil or negative
	#
	def init_labour_markup()
		if !Markups.labour_markup.nil?
			raise ArgumentError,"Labour markup - Expecting a positive number: #{Markups.labour_markup.inspect}" unless (Markups.labour_markup.is_a?(Numeric) && Markups.labour_markup >= 0)
			
			@labour_markup = Markups.labour_markup
		else
			@labour_markup = 0
		end
	end
	
	# Read the static data into material_markup_hash
	# * *Raises* :
	#   - +ArgumentError+:: if the static data is nil or negative
	#
	def init_materials()
		@material_markup_hash = Hash.new
		if !Markups.materials_markup.nil?
			raise ArgumentError,"Materials Markup - Expecting a Hash: #{Markups.materials_markup.inspect}" unless (Markups.materials_markup.is_a?(Hash))
			
			Markups.materials_markup.each_pair do |k, v| 
				markup = 0
				if k.is_a?(String) && v.is_a?(Array) && v.count > 0 && v[0].is_a?(Numeric)
					markup = v[0]
					if v[1].is_a?(Array)
						v[1].each do |mat|
							add_material_to_hash(markup, mat, k,true) #override everytime
						end
					end
				end
				add_material_to_hash(markup,k,nil,true)
			end
		end
	end
	
	# Adds a material with the given markup and parent to the hash. 
	# If material already is in, and override is true, then both markup and material parent are overwritten
	# All keys are added in uppercase
	# * *Params* :
	#   - +material_markup+:: +Numeric+ Markup of the total project cost for this material 
	#   - +material+:: +String+ Material name
	#   - +material_parent+:: +String+ Parent name of this material (may be nil)
	# * *Raises* :
	#   - +ArgumentError+:: if any parameter is not valid
	#
	def add_material_to_hash(material_markup,material,material_parent = nil,override=nil)
		raise ArgumentError,"Markup - Expecting a number from 0-100, you entered: #{material_markup.inspect}" unless (material_markup.is_a?(Numeric) && material_markup >=0 && material_markup <=100)
		raise ArgumentError,"Material - Expecting a string: #{material.inspect}" unless (material.is_a?(String))
		raise ArgumentError,"Material Parent - Expecting a string: #{material_parent.inspect}" unless (material_parent.is_a?(String) || material_parent.nil?)
		
		if MarkupManager.material?(material,@material_markup_hash)
			if override
				@material_markup_hash[material.upcase].markup = material_markup
				@material_markup_hash[material.upcase].material_parent = material_parent
			end
		else
			@material_markup_hash[material.upcase] = MarkupMaterial.new(material_markup,material, material_parent)
		end
	end
	
	#Singleton behaviour:
	@@instance = MarkupManager.new #The singleton object
	
	# Just returns the singleton instance to itself.
	def self.instance
		return @@instance
	end
	
	#Make the new method private so class can't be instantiated again
	private_class_method :new
end