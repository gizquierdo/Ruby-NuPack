require_relative '../lib/estimate'
require 'minitest/autorun'

class TestEstimate < MiniTest::Unit::TestCase 
	def test_estimate_can_be_instantiated
		assert_instance_of(Estimate,Estimate.new(100,1))
		assert_instance_of(Estimate,Estimate.new(100,1,["Paper","Food"],Time.now,"test_employee"))
		assert_instance_of(Estimate,Estimate.new(100,1,["Paper","Food"],nil,"test_employee"))
		assert_instance_of(Estimate,Estimate.new(100,1,["Paper","Food"],nil,nil))
		assert_instance_of(Estimate,Estimate.new(100,1,nil,nil,nil))
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
		assert_raises( ArgumentError ) { Estimate.new(100,1,nil,nil,nil,nil,nil) }
	end
	
	def test_verify_calculations	
		date = Time.now
		est = Estimate.new(100,1,["Pharmaceuticals","Food","Paper"],date,"test_employee")
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
		assert_equal(date,est.date_estimate_given)
		assert_equal("test_employee",est.employee_ID)
	end	
	
	def test_verify_sample_calculations		
		est = Estimate.new(1299.99,3,["food"])
		assert_equal(1591.58,est.get_final_price)
		
		est = Estimate.new(5432,1,["drugs"])
		assert_equal(6199.81,est.get_final_price)
		
		est = Estimate.new(12456.95,4,["books"])
		assert_equal(13707.63,est.get_final_price)
	end
end