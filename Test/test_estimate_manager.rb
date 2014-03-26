require_relative '../lib/estimate_manager'
require 'minitest/autorun'

class TestEstimateManager < MiniTest::Unit::TestCase 
	def test_estimate_manager_calculations
		assert_equal(1591.58,EstimateManager.get_new_estimate_final_price(1299.99,3,["food"]))
		
		assert_raises( ArgumentError ) { Estimate.new(-100,1) }
		assert_raises( ArgumentError ) { Estimate.new('a',1) }
		assert_raises( ArgumentError ) { Estimate.new(100,-1) }		
		assert_raises( ArgumentError ) { Estimate.new(100,'a') }	
		assert_raises( ArgumentError ) { Estimate.new(100,1.1) }		
		assert_raises( ArgumentError ) { Estimate.new(100,1,'a') }
		assert_raises( ArgumentError ) { Estimate.new() }
		assert_raises( ArgumentError ) { Estimate.new(100) }
	end
end