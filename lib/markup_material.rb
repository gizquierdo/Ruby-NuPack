# This class will hold the hierarchy of material categories/markups
class MarkupMaterial 
	attr_reader :material_name,:markup, :material_parent
	
	# Setter method for markup
	# * *Params*:
	#   - +value+:: +Numeric+ markup of the total project cost for this material 
	# * *Raises* :
	#   - +ArgumentError+:: if value is nil or negative
	#
	def markup=(value)
		raise ArgumentError,"Markup - Expecting a number from 0-100, you entered: #{value.inspect}" unless (value.is_a?(Numeric) && value >=0 && value <=100)
		
		@markup = value
	end
	
	# Setter method for material_parent
	# * *Params*:
	#   - +value+:: +String+ Parent name of this material
	# * *Raises* :
	#   - +ArgumentError+:: if value is nil or negative
	#
	def material_parent=(value)
		raise ArgumentError,"Material Parent - Expecting an alphanumeric value: #{value.inspect}" unless (value.is_a?(String))
		
		@material_parent = value
	end
	
	# Initialize method for MarkupMaterial
	# * *Params*:
	#   - +markup+:: +Numeric+ markup of the total project cost for this material 
	#   - +material_name+:: +String+ material name
	#   - +material_parent+:: +String+ Parent name of this material (may be nil)
	# * *Raises* :
	#   - +ArgumentError+:: if any parameter is nil or negative
	#
	def initialize(markup, material_name, material_parent = nil) #:notnew:
		raise ArgumentError,"Markup - Expecting a number from 0-100, you entered: #{markup.inspect}" unless (markup.is_a?(Numeric) && markup >=0 && markup <=100)
		raise ArgumentError,"Material Name - Expecting an alphanumeric value: #{material_name.inspect}" unless (material_name.is_a?(String))
		raise ArgumentError,"Material Parent - Expecting an alphanumeric value: #{material_parent.inspect}" unless (material_parent.nil? || material_parent.is_a?(String))
		
		@markup = markup
		@material_name = material_name
		@material_parent = material_parent
	end
	
	# Display the object in a friendly, meaningul way.
	def to_s
		@material_name + ": " + @markup.to_s + "%" + (!@material_parent.nil? ?  (", Parent: " + material_parent) : "")
	end
end