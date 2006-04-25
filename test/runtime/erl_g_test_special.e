indexing

	description:

		"Test features of Erl-G on class SPECIAL [T]"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/09/18 09:40:16 $"
	revision: "$Revision: 1.1 $"

deferred class ERL_G_TEST_SPECIAL

inherit

	TS_TEST_CASE
	
	ERL_SHARED_UNIVERSE
		export {NONE} all end
		

feature -- Test reflection on generated system

	test_type_information is
			-- Check that type information is retrieved correctly.
		local
			special_type: ERL_TYPE
			creation_procedure: ERL_CREATION_PROCEDURE
		do
			special_type := universe.type_by_name ("SPECIAL [INTEGER]")
			
				-- Check type exists in universe.
			assert_not_equal ("SPECIAL [INTEGER] type found", Void, special_type)
			
				-- Check type characteristics and counts.
			assert ("type not expanded", not special_type.is_expanded)
			assert ("type not basic", not special_type.is_basic_type)
			assert_equal ("correct creation procedure count", 2, special_type.creation_procedure_count)
			
				-- Check creation procedures retrieved correctly.
			creation_procedure := special_type.creation_procedure_by_name ("make")
			assert_not_equal ("make detected", Void, creation_procedure)
			creation_procedure := special_type.creation_procedure_by_name ("make_from_native_array")
			assert_not_equal ("make_from_native_array detected", Void, creation_procedure)
			
				-- Check features retrieved correctly.
			assert_not_equal ("item feature exists", Void, special_type.feature_by_name ("item"))
			assert_not_equal ("native_array feature exists", Void, special_type.feature_by_name ("native_array"))
			assert_not_equal ("count feature exists", Void, special_type.feature_by_name ("count"))
			assert_not_equal ("all_default feature exists", Void, special_type.feature_by_name ("all_default"))
			
				-- Check queries retrieved correctly.
			assert_not_equal ("same_items query exists", Void, special_type.query_by_name ("same_items"))
			assert_not_equal ("valid_index query exists", Void, special_type.query_by_name ("valid_index"))
			
				-- Check functions retrieved correctly.
			assert_not_equal ("item_address function exists", Void, special_type.function_by_name ("item_address"))
			assert_not_equal ("upper function exists", Void, special_type.function_by_name ("upper"))
			
				-- Check procedures retrieved correctly.
			assert_not_equal ("fill_with procedure exists", Void, special_type.procedure_by_name ("fill_with"))
			assert_not_equal ("put procedure exists", Void, special_type.procedure_by_name ("put"))
		end
		
	test_creation_procedure is
			-- Check that creation procedure works correctly.
		local
			special_type: ERL_TYPE
			special_object: ANY
			make_creation_procedure: ERL_CREATION_PROCEDURE
		do
			special_type := universe.type_by_name ("SPECIAL [INTEGER]")
			assert_not_equal ("SPECIAL [INTEGER] type found", Void, special_type)
			
			assert_equal ("SPECIAL has no default_create", Void, special_type.creation_procedure_by_name ("default_create"))
			
			make_creation_procedure := special_type.creation_procedure_by_name ("make")
			assert_not_equal ("SPECIAL.make found", Void, make_creation_procedure)

				-- Check formal arguments.
			assert_equal ("correct formal argument count", 1, make_creation_procedure.formal_arguments.count)
			assert_equal ("correct formal argument name", "n", make_creation_procedure.formal_arguments.item (1).name)
			assert_equal ("correct formal argument type", "INTEGER", make_creation_procedure.formal_arguments.item (1).type.name)

				-- Check type.
			assert_equal ("correct type of produced objects", "SPECIAL [INTEGER]", make_creation_procedure.type.name)
			
				-- Check applying and last result.
			make_creation_procedure.apply ([0])
			special_object := make_creation_procedure.last_result
			assert_not_equal ("special created 1", Void, special_object)
			assert_equal ("created object has correct type", special_type, universe.type_by_object (special_object))
			
			make_creation_procedure.apply ([100])
			special_object := make_creation_procedure.last_result
			assert_not_equal ("special created 2", Void, special_object)
		end
		
	test_queries is
			-- Check that queries work correctly.
		local
			special_type: ERL_TYPE
			make_creation_procedure: ERL_CREATION_PROCEDURE
			item_query, capacity_query: ERL_QUERY
			a_special: SPECIAL [INTEGER]
			an_int_ref: INTEGER_REF
			a_bool_ref: BOOLEAN_REF
		do
			special_type := universe.type_by_name ("SPECIAL [INTEGER]")
			assert_not_equal ("SPECIAL [INTEGER] type found", Void, special_type)
			
			make_creation_procedure := special_type.creation_procedure_by_name ("make")
			assert_not_equal ("SPECIAL.make found", Void, make_creation_procedure)
			make_creation_procedure.apply ([5])
			a_special ?= make_creation_procedure.last_result
			assert_not_equal ("correct creation", Void, a_special)
			
			a_special.put (1, 0)
			a_special.put (2, 1)
			a_special.put (3, 2)
			
			item_query := special_type.query_by_name ("item")
			assert_not_equal ("item query found", Void, item_query)
			assert_equal ("correct result type for item query", universe.type_by_name ("INTEGER"), item_query.result_type)
			assert_equal ("one argument for item query", 1, item_query.formal_arguments.count)
			assert ("valid operands for item query", item_query.valid_operands (a_special, [1]))
			item_query.retrieve_value (a_special, [0])
			an_int_ref ?= item_query.last_result
			assert_not_equal ("correct type of item query 1", Void, an_int_ref)
			assert_equal ("correct value of item query 1", 1, an_int_ref.item)
			item_query.retrieve_value (a_special, [3])
			an_int_ref ?= item_query.last_result
			assert_not_equal ("correct type of item query 2", Void, an_int_ref)
			assert_equal ("correct value of item query 2", 0, an_int_ref.item)
			
			capacity_query := special_type.query_by_name ("capacity")
			assert_not_equal ("capacity query found", Void, capacity_query)
			assert_equal ("correct result type for capacity query", universe.type_by_name ("INTEGER"), capacity_query.result_type)
			assert_equal ("no arguments for capacity query", 0, capacity_query.formal_arguments.count)
			capacity_query.retrieve_value (a_special, [])
			an_int_ref ?= capacity_query.last_result
			assert_not_equal ("correct type of capacity query", Void, an_int_ref)
			assert_equal ("correct value for capacity query", 5, an_int_ref.item)
		end
		
	test_functions is
			-- Check that functions work correctly.
		local
			special_type: ERL_TYPE
			a_special, another_special: SPECIAL [INTEGER]
			index_of_function, count_function, resized_area_function: ERL_FUNCTION
			a_bool_ref: BOOLEAN_REF
			an_int_ref: INTEGER_REF
			make_creation_procedure: ERL_CREATION_PROCEDURE
			i: INTEGER
		do
			special_type := universe.type_by_name ("SPECIAL [INTEGER]")
			assert_not_equal ("SPECIAL [INTEGER] type found", Void, special_type)
			
			make_creation_procedure := special_type.creation_procedure_by_name ("make")
			assert_not_equal ("SPECIAL.make found", Void, make_creation_procedure)
			make_creation_procedure.apply ([5])
			a_special ?= make_creation_procedure.last_result
			assert_not_equal ("correct creation", Void, a_special)
			
			a_special.put (1, 0)
			a_special.put (2, 1)
			a_special.put (3, 2)
			
			index_of_function := special_type.function_by_name ("index_of")
			assert_not_equal ("index_of function found", Void, index_of_function)
			assert_equal ("correct result type for index_of function", universe.type_by_name ("INTEGER"), index_of_function.result_type)
			assert_equal ("two arguments for index_of function", 2, index_of_function.formal_arguments.count)
			assert ("valid operands for index_of function", index_of_function.valid_operands (a_special, [100, 1]))
			index_of_function.retrieve_value (a_special, [3, 1])
			an_int_ref ?= index_of_function.last_result
			assert_not_equal ("correct return type of index_of function", Void, an_int_ref)
			assert_equal ("correct return value of index_of function", 2, an_int_ref.item)
			
			count_function := special_type.function_by_name ("count")
			assert_not_equal ("count function found", Void, count_function)
			assert_equal ("correct result type for count function", universe.type_by_name ("INTEGER"), count_function.result_type)
			assert_equal ("no arguments for count function", 0, count_function.formal_arguments.count)
			count_function.retrieve_value (a_special, [])
			an_int_ref ?= count_function.last_result
			assert_not_equal ("correct return type of count function", Void, an_int_ref)
			assert_equal ("correct return value of count function", 5, an_int_ref.item)
			
			resized_area_function := special_type.function_by_name ("resized_area")
			assert_not_equal ("resized_area function found", Void, resized_area_function)
			assert_equal ("correct result type for resized_area function", universe.type_by_name ("SPECIAL [INTEGER]"), resized_area_function.result_type)
			assert_equal ("one argument for resized_area function", 1, resized_area_function.formal_arguments.count)
			assert ("valid operands for resized_area function", resized_area_function.valid_operands (a_special, [100]))
			resized_area_function.retrieve_value (a_special, [100])
			another_special ?= resized_area_function.last_result
			assert_not_equal ("correct return type of resized_area function", Void, another_special)
			assert_equal ("correct return value of resized_area function 0", 100, another_special.count)
			from
				i := 1
			until
				i > 3
			loop
				assert_equal ("correct return value of resized_area function " + i.out, i, another_special.item (i-1))
				i := i + 1
			end
			assert_equal ("correct return value of resized_area function 4", 0, another_special.item (4))
		end
		
	test_procedures is
			-- Check that procedures work correctly.
		local
			special_type: ERL_TYPE
			a_special: SPECIAL [INTEGER]
			put_procedure, clear_all_procedure: ERL_PROCEDURE
			make_creation_procedure: ERL_CREATION_PROCEDURE
			an_any: ANY
			an_int_ref: INTEGER_REF
		do
			special_type := universe.type_by_name ("SPECIAL [INTEGER]")
			assert_not_equal ("SPECIAL [INTEGER] type found", Void, special_type)
			
			make_creation_procedure := special_type.creation_procedure_by_name ("make")
			assert_not_equal ("SPECIAL.make found", Void, make_creation_procedure)
			make_creation_procedure.apply ([10])
			a_special ?= make_creation_procedure.last_result
			assert_not_equal ("correct creation", Void, a_special)
			
			put_procedure := special_type.procedure_by_name ("put")
			assert_not_equal ("put procedure found", Void, put_procedure)
			assert_equal ("two arguments for put procedure", 2, put_procedure.formal_arguments.count)
			assert ("valid operands for put procedure", put_procedure.valid_operands (a_special, [10, 5]))
			create an_any
			assert ("invalid operands for put procedure", not put_procedure.valid_operands (a_special, [an_any, 3]))
			put_procedure.apply (a_special, [11, 1])
			assert_equal ("correct put 1", 11, a_special.item (1))
			put_procedure.apply (a_special, [22, 2])
			assert_equal ("correct put 2", 22, a_special.item (2))
			assert_equal ("correct put 3", 11, a_special.item (1))
			assert_equal ("correct put 4", 0, a_special.item (3))
			
			
			clear_all_procedure := special_type.procedure_by_name ("clear_all")
			assert_not_equal ("clear_all procedure found", Void, clear_all_procedure)
			clear_all_procedure.apply (a_special, [])
			assert_equal ("correct clear_all 1", 0, a_special.item (0))
			assert_equal ("correct clear_all 2", 0, a_special.item (1))
		end

end
