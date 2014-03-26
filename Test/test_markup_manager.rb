require_relative '../lib/markup_manager'
require 'minitest/autorun'

class TestMarkupManager < MiniTest::Unit::TestCase 	
	def test_markup_manager_cannot_instantiate
		assert_raises( NoMethodError ) { MarkupManager.new() }
	end
	
	def test_markup_manager_can_get_singleton_obj
		assert_instance_of(MarkupManager, MarkupManager.instance)
	end
		
	def test_markup_manager_bad_input
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_flat_markup('a')}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_flat_markup(-1)}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_flat_markup()}
		
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_labour_markup('a',1)}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_labour_markup(-1,1)}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_labour_markup(1,-1)}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_labour_markup(1,'a')}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_labour_markup()}
		
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_materials_markup('a',["Paper"])}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_materials_markup(-1,["Paper"])}
		assert_raises( ArgumentError ) { MarkupManager.instance.apply_materials_markup(1)}
		
		assert_raises( ArgumentError ) { MarkupManager.instance.calculate_material_cost("Food",-1)}
		assert_raises( ArgumentError ) { MarkupManager.instance.calculate_material_cost("Food",'a')}
		assert_raises( ArgumentError ) { MarkupManager.instance.calculate_material_cost(1,1)}
		assert_raises( ArgumentError ) { MarkupManager.instance.calculate_material_cost(nil,1)}
		
		assert_raises( ArgumentError ) { MarkupManager.instance.set_new_markups('a',nil,nil)}
		assert_raises( ArgumentError ) { MarkupManager.instance.set_new_markups(nil,'a',nil)}
		assert_raises( ArgumentError ) { MarkupManager.instance.set_new_markups(nil,nil,'a')}
	end
	
	def test_markup_manager_ret_vals
		assert_instance_of(Float,MarkupManager.instance.apply_flat_markup(1))
		assert_equal(0,MarkupManager.instance.apply_flat_markup(0))
		assert_instance_of(Float,MarkupManager.instance.apply_labour_markup(1,1))		
		assert_equal(0,MarkupManager.instance.apply_labour_markup(0,1))
		assert_instance_of(Hash,MarkupManager.instance.apply_materials_markup(1,["Food"]))
		assert_instance_of(Hash,MarkupManager.instance.apply_materials_markup(1,[]))
		
		mc = MarkupManager.instance.calculate_material_cost("Food",100)
		if !mc.nil? #this case changes because the singleton changes down in the file.
			assert_instance_of(Float,mc)	
		end
		assert_equal(nil,MarkupManager.instance.calculate_material_cost("Blah",100))
	end
	
	def test_markup_manager_singleton
		arrMat = ["Food", "drugs","Pharmaceuticals", "Electronics"]
		assert_equal(arrMat, MarkupManager.instance.get_possible_materials)
	
		assert_equal(5, MarkupManager.instance.apply_flat_markup(100))
		assert_equal(1.2, MarkupManager.instance.apply_labour_markup(100,1))
		
		assert_equal(13,MarkupManager.instance.calculate_material_cost("Food",100))
		h = Hash.new
		h["Food"] = 13
		res = MarkupManager.instance.apply_materials_markup(100,["Food"])
		assert_equal(h,res)
		
		flat = MarkupManager.instance.flat_markup
		labour = MarkupManager.instance.labour_markup
		materials = MarkupManager.instance.material_markup_array
		
		matHash = Hash.new
		matHash["Paper"] = 3
		MarkupManager.instance.set_new_markups(1,1,matHash)
		#make sure they're not equal now.
		refute_equal(MarkupManager.instance.flat_markup, flat)
		refute_equal(MarkupManager.instance.labour_markup, labour)
		refute_equal(MarkupManager.instance.material_markup_array, materials)
		
		#copy new values
		flat = MarkupManager.instance.flat_markup
		labour = MarkupManager.instance.labour_markup
		materials = MarkupManager.instance.material_markup_array
		
		matHash = Hash.new
		matHash["Paper"] = 10
		MarkupManager.instance.set_new_markups(2,2,matHash)
		
		#Make sure that we did not make any changes
		assert_equal(MarkupManager.instance.flat_markup, flat)
		assert_equal(MarkupManager.instance.labour_markup, labour)
		assert_equal(MarkupManager.instance.material_markup_array, materials)
		
	end
end