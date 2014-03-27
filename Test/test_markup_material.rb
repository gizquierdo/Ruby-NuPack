require_relative '../lib/markup_material'
require 'minitest/autorun'
 
class TestMarkupMaterial < MiniTest::Unit::TestCase 
	def test_markup_material_can_be_instantiated
		assert_instance_of(MarkupMaterial,MarkupMaterial.new(1, "Food"))
	end
	
 	def test_markup_material_string
		assert_equal("Food: 13%", MarkupMaterial.new(13,"Food").to_s )
	end
	
	def test_markup_material_variables_access
		new_material = MarkupMaterial.new(1,"Wire")
		assert_raises( NoMethodError ) { new_material.material_name="test" }
		
		new_material.markup = 2
		assert_equal(2,new_material.markup)
		
		new_material.material_parent = "Electronics"
		assert_equal("Electronics",new_material.material_parent)
	end
 
	def test_markup_material_bad_input
		assert_raises( ArgumentError ) { MarkupMaterial.new('a','m') }
		assert_raises( ArgumentError ) { MarkupMaterial.new(1,1) }
		assert_raises( ArgumentError ) { MarkupMaterial.new(nil,nil) }
		assert_raises( ArgumentError ) { MarkupMaterial.new() }
		assert_raises( ArgumentError ) { MarkupMaterial.new(1) }
		assert_raises( ArgumentError ) { MarkupMaterial.new('m') }
		
		assert_raises( ArgumentError ) { MarkupMaterial.new(1,'m').markup='a' }
		assert_raises( ArgumentError ) { MarkupMaterial.new(1,'m').material_parent=nil }
	end	
end