require_relative '../lib/markup_material'
require 'minitest/autorun'
 
class TestMarkupMaterial < MiniTest::Unit::TestCase 
	def test_markup_material_can_be_created_2_param
		assert_instance_of(MarkupMaterial,MarkupMaterial.new(1, 'Food'))
	end
	
 	def test_markup_material_string
		assert_equal('Food: 13%', MarkupMaterial.new(13,'Food').to_s )
	end
 
	def test_markup_material_bad_construct
		assert_raises( ArgumentError ) { MarkupMaterial.new('a','m') }
		assert_raises( ArgumentError ) { MarkupMaterial.new(1,1) }
		assert_raises( ArgumentError ) { MarkupMaterial.new(nil,nil) }
		assert_raises( ArgumentError ) { MarkupMaterial.new() }
		assert_raises( ArgumentError ) { MarkupMaterial.new(1) }
		assert_raises( ArgumentError ) { MarkupMaterial.new('m') }
	end	
end