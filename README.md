Ruby-NuPack
===========

- The calculator implements a singleton pattern that holds the static data (markup information)
- When the singleton is created, it is loaded with the information from markups.rb, which only contains static data and class variable/methods.
- The singleton expects the static data to be of the form:
	* Numeric flat markup
	* Numeric labour markup
	* Hash for materials, the key is the topmost parent or industry (For example, "Food", and the value is an array of up to 2 elements (it can have more items, but only the first 2 will be taken into account) the first element is the markup for the entire category, and the second element is an array of all the subcategories. i.e: @@materials_markup["Food"] = [13, ["rice", "milk"]])
	
- The most straightforward point of entry is through estimate_manager. As it stands, the class only instantiates the Estimate class and returns the final price. In the real world, it should be expanded so you only create one estimate per request, and then just call the different methods in the Estimate class to modify the values, until the customer is satisfied. Then the estimate should be persisted or disposed as per business requirements.
