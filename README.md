Ruby-NuPack
===========

Some remarks:

- The calculator implements a singleton pattern that holds the static data (markup information)
- When the singleton is created, it is loaded with the information from markups.rb, which only contains static data and class variable/methods.
- The singleton expects the static data to be of the form:
	* Numeric flat markup
	* Numeric labour markup
	* Hash for materials, the key is the topmost parent or industry (For example, "Food", and the value is an array of up to 2 elements (it can have more items, but only the first 2 will be taken into account) the first element is the markup for the entire category, and the second element is an array of all the subcategories. i.e: @@materials_markup["Food"] = [13, ["rice", "milk"]])
	
- In the Estimate class there are 3 extra attributes: date_estimate_given, employee_ID, company. These are just to give an idea of what could be the next step for the calculator, i.e: storing all the estimates per companies, getting reports based on number of estimates given vs ordered by employee, etc. 

- The most straightforward point of entry is through estimate_manager