# ==This class will hold the hierarchy of material categories/markups
class MarkupMaterial 
	
	# +markup+:: +Numeric+
	# +material_name+:: +String+
	# +material_parent+:: +String+ (may be nil)
	attr_reader :markup, :material_name, :material_parent
	
	# Initialize method for MarkupMaterial
	# Params:
	# +markup+:: +Numeric+ markup of the total project cost for this material 
	# +material_name+:: +String+ material name
	# +material_parent+:: +String+ Parent name of this material (may be nil)
	def initialize(markup, material_name, material_parent = nil)
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

if __FILE__ == $0
	mm = MarkupMaterial.new(7.5,"drugs", "Pharmaceuticals")
	puts mm.pretty
	puts mm.apply_markup_to(100).to_s
end