require_relative '../lib/markup_base'
require 'minitest/autorun'

class TestMarkupBase < MiniTest::Unit::TestCase 
	def test_markup_base_can_be_created_1_param
		assert_instance_of(MarkupBase,MarkupBase.new(1))
	end
	
	def test_markup_base_string
		assert_equal('5%', MarkupBase.new(5).to_s )
	end
 
	def test_markup_base_bad_construct
		assert_raises( ArgumentError ) { MarkupBase.new('a') }
		assert_raises( ArgumentError ) { MarkupBase.new(-1) }
		assert_raises( ArgumentError ) { MarkupBase.new(101) }
		assert_raises( ArgumentError ) { MarkupBase.new(Hash.new) } 
		assert_raises( ArgumentError ) { MarkupBase.new() }
	end
  
  
	def test_markup_base_calculations
		assert_equal(5, MarkupBase.new(5).apply_markup_to(100))
		assert_raises( ArgumentError ) { MarkupBase.new(5).apply_markup_to(-1) }
	end	
end