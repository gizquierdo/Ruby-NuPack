require_relative '../lib/markup_manager'
require 'minitest/autorun'

class TestMarkupManager < MiniTest::Unit::TestCase 	
	def test_markup_manager_cannot_instantiate
		assert_raises( NoMethodError ) { MarkupManager.new() }
	end
	
	def test_markup_manager_can_get_singleton_obj
		assert_instance_of(MarkupManager, MarkupManager.instance)
	end
	
	def test_markup_manager_variable_types
		assert_instance_of(Float, MarkupManager.instance.flat_markup)
		assert_instance_of(Float, MarkupManager.instance.labour_markup)
		assert_instance_of(Hash, MarkupManager.instance.material_markup_hash)
	end
	
	def test_markup_manager_access
		
		assert_raises( NoMethodError ) { MarkupManager.instance.flat_markup=1 }
		assert_raises( NoMethodError ) { MarkupManager.instance.labour_markup=1 }
		assert_raises( NoMethodError ) { MarkupManager.instance.material_markup_hash=Hash.new }
		assert_raises( NoMethodError ) { MarkupManager.instance.add_material_to_hash(1,'a','a',false) }
	end
		
	def test_markup_manager_bad_input
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_flat_markup_to('a')}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_flat_markup_to(-1)}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_flat_markup_to()}
		
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_labour_markup_to('a',1)}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_labour_markup_to(-1,1)}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_labour_markup_to(1,-1)}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_labour_markup_to(1,'a')}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_labour_markup_to()}
		
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_materials_markup_to('a',["Paper"])}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_materials_markup_to(-1,["Paper"])}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_materials_markup_to(1)}
		
		assert_raises( ArgumentError ) { MarkupManager.instance.calculate_material_cost(-1,"Food")}
		assert_raises( ArgumentError ) { MarkupManager.instance.calculate_material_cost('a',"Food")}
		assert_raises( ArgumentError ) { MarkupManager.instance.calculate_material_cost(1,1)}
		assert_raises( ArgumentError ) { MarkupManager.instance.calculate_material_cost(1,nil)}
		
		assert_raises( ArgumentError ) { MarkupManager.material?()}
		assert_raises( ArgumentError ) { MarkupManager.material?(1)}
		assert_raises( ArgumentError ) { MarkupManager.material?('a',nil)}
		assert_raises( ArgumentError ) { MarkupManager.material?(1,Hash.new)}
	end
	
	def test_markup_manager_ret_vals
		assert_equal(true, MarkupManager.material?("Food",MarkupManager.instance.material_markup_hash))
		assert_equal(false, MarkupManager.material?("adfgsdfg",MarkupManager.instance.material_markup_hash))
		assert_instance_of(Float,MarkupManager.instance.apply_flat_markup_to(1))
		assert_equal(0,MarkupManager.instance.apply_flat_markup_to(0))
		assert_instance_of(Float,MarkupManager.instance.apply_labour_markup_to(1,1))		
		assert_equal(0,MarkupManager.instance.apply_labour_markup_to(0,1))
		assert_instance_of(Hash,MarkupManager.instance.apply_materials_markup_to(1,["Food"]))
		assert_instance_of(Hash,MarkupManager.instance.apply_materials_markup_to(1,[]))		
		assert_instance_of(Float,MarkupManager.instance.calculate_material_cost(100,"Food"))
		assert_equal(0,MarkupManager.instance.calculate_material_cost(100,"Blah"))
	end
	
	def test_markup_manager_singleton
		arrMat = ["Food", "drugs","Pharmaceuticals", "Electronics"]
	
		assert_equal(5, MarkupManager.instance.apply_flat_markup_to(100))
		assert_equal(1.2, MarkupManager.instance.apply_labour_markup_to(100,1))
		
		assert_equal(13,MarkupManager.instance.calculate_material_cost(100,"Food"))
		h = Hash.new
		h["Food"] = 13
		res = MarkupManager.instance.apply_materials_markup_to(100,["Food"])
		assert_equal(h,res)
	end
end