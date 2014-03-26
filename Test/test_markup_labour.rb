require_relative '../lib/markup_labour'
require 'minitest/autorun'
 
class TestMarkupLabour < MiniTest::Unit::TestCase 
	def test_markup_labour_can_be_instantiated
		assert_instance_of(MarkupLabour,MarkupLabour.new(1))
	end
	
	def test_markup_labour_calculations
		assert_equal(5, MarkupLabour.new(1).apply_markup_to(100,5) )
	end	
	
	def test_markup_labour_inputs
		assert_raises( ArgumentError ) { MarkupLabour.new(5).apply_markup_to(-1,1) }
		assert_raises( ArgumentError ) { MarkupLabour.new(5).apply_markup_to(1,-1) }
		assert_raises( ArgumentError ) { MarkupLabour.new(10).apply_markup_to() }
	end	
end