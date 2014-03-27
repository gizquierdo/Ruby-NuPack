require_relative '../lib/estimate'
require 'minitest/autorun'

class TestEstimate < MiniTest::Unit::TestCase 
	def test_estimate_can_be_instantiated
		assert_instance_of(Estimate,Estimate.new(100,1))
		assert_instance_of(Estimate,Estimate.new(100,1,["Paper","Food"]))
		assert_instance_of(Estimate,Estimate.new(100,1,nil))
	end
	
	def test_estimate_bad_input
		assert_raises( ArgumentError ) { Estimate.new(-100,1) }
		assert_raises( ArgumentError ) { Estimate.new('a',1) }
		assert_raises( ArgumentError ) { Estimate.new(100,-1) }		
		assert_raises( ArgumentError ) { Estimate.new(100,'a') }	
		assert_raises( ArgumentError ) { Estimate.new(100,1.1) }		
		assert_raises( ArgumentError ) { Estimate.new(100,1,'a') }
		assert_raises( ArgumentError ) { Estimate.new() }
		assert_raises( ArgumentError ) { Estimate.new(100) }
		assert_raises( ArgumentError ) { Estimate.new(100,1,nil,nil) }
		assert_raises( ArgumentError ) { Estimate.new(1,1).base_price='a'}
		assert_raises( ArgumentError ) { Estimate.new(1,1).labour_quantity='a'}
		assert_raises( ArgumentError ) { Estimate.new(1,1).labour_quantity=-1}
	end
	
	def test_estimate_variables_access
		estimate = Estimate.new(1,1,["Wire","drugs"])
		assert_raises( NoMethodError ) { estimate.flat_charge=2 }
		assert_raises( NoMethodError ) { estimate.materials_charged_hash=nil }
		
		estimate.base_price = 100
		assert_equal(100,estimate.base_price)

		estimate.labour_quantity = 5
		assert_equal(5,estimate.labour_quantity)
		
		estimate.add_material("Food") #I wonder what kind of product this test is making?
		
		puts estimate.materials_charged_hash
		testHash = Hash.new
		testHash["Wire"] = 0
		testHash["drugs"] = 7.875
		testHash["Food"] = 13.65
		
		assert_equal(testHash,estimate.materials_charged_hash)
	end
	
	def test_estimate_verify_calculations	
		est = Estimate.new(100,1,["Pharmaceuticals","Food","Paper"])
		assert_equal(100,est.base_price)
		assert_equal(5,est.flat_charge) #assume we're using the defaults
		assert_equal(1,est.labour_quantity)
		assert_equal(1.26,est.labour_charged)
		hash = Hash.new
		hash["Pharmaceuticals"] = 7.875
		hash["Food"] = 13.65
		hash["Paper"] = 0
		assert_equal(hash,est.materials_charged_hash)
		total = 100 + 5 + 1.26 + 13.65 + 7.875
		assert_equal(total.round(2),est.get_final_price)
	end	
	
	def test_estimate_verify_sample_calculations
		assert_equal(1591.58,Estimate.new(1299.99,3,["food"]).get_final_price)
		
		assert_equal(6199.81,Estimate.new(5432,1,["drugs"]).get_final_price)
		
		assert_equal(13707.63,Estimate.new(12456.95,4,["books"]).get_final_price)
		
		est = Estimate.new(1,1)
		est.base_price = 1299.99
		est.labour_quantity = 3
		est.add_material("food")
		assert_equal(1591.58,est.get_final_price)
	end
end