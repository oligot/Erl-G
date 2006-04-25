indexing

	description:

		"Test features of Erl-G on class HASH_TABLE [ANY, STRING]"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/09/01 12:51:09 $"
	revision: "$Revision: 1.1 $"

deferred class ERL_G_TEST_ARRAYED_LIST_INTEGER

inherit

	TS_TEST_CASE
	
	ERL_SHARED_UNIVERSE
		export {NONE} all end
		

feature -- Test reflection on generated system

	test_type_information is
			-- Check that type information is retrieved correctly.
		local
			al_type: ERL_TYPE
			creation_procedure: ERL_CREATION_PROCEDURE
		do
			al_type := universe.type_by_name ("ARRAYED_LIST [INTEGER]")
			
				-- Check type exists in universe.
			assert_not_equal ("ARRAYED_LIST [INTEGER] type found", Void, al_type)
			
				-- Check type characteristics and counts.
			assert ("type not expanded", not al_type.is_expanded)
			assert ("type not basic", not al_type.is_basic_type)
			assert_equal ("correct creation procedure count", 3, al_type.creation_procedure_count)
			
				-- Check creation procedures retrieved correctly.
			creation_procedure := al_type.creation_procedure_by_name ("make")
			assert_not_equal ("make detected", Void, creation_procedure)
			assert_equal ("array_make not available", Void, al_type.creation_procedure_by_name ("array_make"))
			
				-- Check features retrieved correctly.
			assert_not_equal ("item feature exists", Void, al_type.feature_by_name ("item"))
			assert_not_equal ("i_th feature exists", Void, al_type.feature_by_name ("i_th"))
			assert_not_equal ("has feature exists", Void, al_type.feature_by_name ("has"))
			assert_not_equal ("count feature exists", Void, al_type.feature_by_name ("count"))
			assert_not_equal ("full feature exists", Void, al_type.feature_by_name ("full"))
			
				-- Check queries retrieved correctly.
			assert_not_equal ("after query exists", Void, al_type.query_by_name ("after"))
			assert_not_equal ("valid_index query exists", Void, al_type.query_by_name ("valid_index"))
			assert_not_equal ("has query exists", Void, al_type.query_by_name ("has"))
			
				-- Check functions retrieved correctly.
			assert_not_equal ("first function exists", Void, al_type.function_by_name ("first"))
			assert_not_equal ("prunable function exists", Void, al_type.function_by_name ("prunable"))
			
				-- Check procedures retrieved correctly.
			assert_not_equal ("start procedure exists", Void, al_type.procedure_by_name ("start"))
			assert_not_equal ("move procedure exists", Void, al_type.procedure_by_name ("move"))
		end
		
	test_creation_procedure is
			-- Check that creation procedure works correctly.
		local
			al_type: ERL_TYPE
			al_object: ANY
			make_creation_procedure: ERL_CREATION_PROCEDURE
		do
			al_type := universe.type_by_name ("ARRAYED_LIST [INTEGER]")
			assert_not_equal ("ARRAYED_LIST [INTEGER] type found", Void, al_type)
			
			assert_equal ("ARRAYED_LIST has no default_create", Void, al_type.creation_procedure_by_name ("default_create"))
			
			make_creation_procedure := al_type.creation_procedure_by_name ("make")
			assert_not_equal ("ARRAYED_LIST.make found", Void, make_creation_procedure)

				-- Check formal arguments.
			assert_equal ("correct formal argument count", 1, make_creation_procedure.formal_arguments.count)
			assert_equal ("correct formal argument name", "n", make_creation_procedure.formal_arguments.item (1).name)
			assert_equal ("correct formal argument type", "INTEGER", make_creation_procedure.formal_arguments.item (1).type.name)

				-- Check type.
			assert_equal ("correct type of produced objects", "ARRAYED_LIST [INTEGER]", make_creation_procedure.type.name)
			
				-- Check applying and last result.
			make_creation_procedure.apply ([0])
			al_object := make_creation_procedure.last_result
			assert_not_equal ("arrayed_list created 1", Void, al_object)
			assert_equal ("created object has correct type", al_type, universe.type_by_object (al_object))
			
			make_creation_procedure.apply ([100])
			al_object := make_creation_procedure.last_result
			assert_not_equal ("arrayed_list created 2", Void, al_object)
		end
		
	test_attributes is
			-- Check that attributes work correctly.
		local
			al_type: ERL_TYPE
			an_al: ARRAYED_LIST [INTEGER]
			make_creation_procedure: ERL_CREATION_PROCEDURE
			count_attribute, index_attribute: ERL_ATTRIBUTE
			an_int_ref: INTEGER_REF
		do
			al_type := universe.type_by_name ("ARRAYED_LIST [INTEGER]")
			assert_not_equal ("ARRAYED_LIST [INTEGER] type found", Void, al_type)
			
			make_creation_procedure := al_type.creation_procedure_by_name ("make")
			assert_not_equal ("ARRAYED_LIST.make found", Void, make_creation_procedure)
			make_creation_procedure.apply ([0])
			an_al ?= make_creation_procedure.last_result
			assert_not_equal ("correct creation", Void, an_al)
			
			an_al.extend (1)
			an_al.extend (2)
			
			index_attribute := al_type.attribute_by_name ("index")
			assert_not_equal ("index attribute found", Void, index_attribute)
			assert ("index attribute not constant", not index_attribute.is_constant)
			assert_equal ("correct result type for index attribute", index_attribute.result_type, universe.type_by_name ("INTEGER"))
			assert_equal ("no arguments for index attribute", 0, index_attribute.formal_arguments.count)
			assert ("valid operands for index attribute", index_attribute.valid_operands (an_al, []))
			an_al.go_i_th (2)
			index_attribute.retrieve_value (an_al, [])
			an_int_ref ?= index_attribute.last_result
			assert_not_equal ("correct type of index attribute", Void, an_int_ref)
			assert_equal ("correct index", 2, an_int_ref.item)
			
			count_attribute := al_type.attribute_by_name ("count")
			assert_not_equal ("count attribute found", Void, count_attribute)
			assert ("count attribute not constant", not count_attribute.is_constant)
			assert_equal ("correct result type for count attribute", count_attribute.result_type, universe.type_by_name ("INTEGER"))
			assert_equal ("no arguments for count attribute", 0, count_attribute.formal_arguments.count)
			assert ("valid operands for count attribute", count_attribute.valid_operands (an_al, []))
			count_attribute.retrieve_value (an_al, [])
			an_int_ref ?= count_attribute.last_result
			assert_not_equal ("correct type of count attribute", Void, an_int_ref)
			assert_equal ("correct count", 2, an_int_ref.item)
		end
		
	test_queries is
			-- Check that queries work correctly.
		local
			al_type: ERL_TYPE
			make_creation_procedure: ERL_CREATION_PROCEDURE
			item_query, has_query: ERL_QUERY
			an_al: ARRAYED_LIST [INTEGER]
			an_int_ref: INTEGER_REF
			a_bool_ref: BOOLEAN_REF
		do
			al_type := universe.type_by_name ("ARRAYED_LIST [INTEGER]")
			assert_not_equal ("ARRAYED_LIST [INTEGER] type found", Void, al_type)
			
			make_creation_procedure := al_type.creation_procedure_by_name ("make")
			assert_not_equal ("ARRAYED_LIST.make found", Void, make_creation_procedure)
			make_creation_procedure.apply ([0])
			an_al ?= make_creation_procedure.last_result
			assert_not_equal ("correct creation", Void, an_al)
			
			an_al.extend (1)
			an_al.extend (2)
			an_al.start
			
			item_query := al_type.query_by_name ("item")
			assert_not_equal ("item query found", Void, item_query)
			assert_equal ("correct result type for item query", universe.type_by_name ("INTEGER"), item_query.result_type)
			assert_equal ("no arguments for item query", 0, item_query.formal_arguments.count)
			item_query.retrieve_value (an_al, [])
			an_int_ref ?= item_query.last_result
			assert_not_equal ("correct type of item query", Void, an_int_ref)
			assert_equal ("correct value of item query", 1, an_int_ref.item)
			
			has_query := al_type.query_by_name ("has")
			assert_not_equal ("has query found", Void, has_query)
			assert_equal ("correct result type for has query", universe.type_by_name ("BOOLEAN"), has_query.result_type)
			assert_equal ("one argument for has query", 1, has_query.formal_arguments.count)
			assert ("valid operands for has query", has_query.valid_operands (an_al, [5]))
			assert ("invalid operands for has query", not has_query.valid_operands (an_al, ["a_string"]))
			has_query.retrieve_value (an_al, [1])
			a_bool_ref ?= has_query.last_result
			assert_not_equal ("correct type of has query", Void, a_bool_ref)
			assert_equal ("correct value for has query", True, a_bool_ref.item)
		end
		
	test_functions is
			-- Check that functions work correctly.
		local
			al_type: ERL_TYPE
			an_al: ARRAYED_LIST [INTEGER]
			first_function, valid_index_function: ERL_FUNCTION
			a_bool_ref: BOOLEAN_REF
			an_int_ref: INTEGER_REF
			make_creation_procedure: ERL_CREATION_PROCEDURE
		do
			al_type := universe.type_by_name ("ARRAYED_LIST [INTEGER]")
			assert_not_equal ("ARRAYED_LIST [INTEGER] type found", Void, al_type)
			
			make_creation_procedure := al_type.creation_procedure_by_name ("make")
			assert_not_equal ("ARRAYED_LIST.make found", Void, make_creation_procedure)
			make_creation_procedure.apply ([0])
			an_al ?= make_creation_procedure.last_result
			assert_not_equal ("correct creation", Void, an_al)
			
			an_al.extend (1)
			an_al.extend (2)
			an_al.extend (3)
			
			first_function := al_type.function_by_name ("first")
			assert_not_equal ("first function found", Void, first_function)
			assert_equal ("correct result type for first function", universe.type_by_name ("INTEGER"), first_function.result_type)
			assert_equal ("no arguments for first function", 0, first_function.formal_arguments.count)
			first_function.retrieve_value (an_al, [])
			an_int_ref ?= first_function.last_result
			assert_not_equal ("correct return type of first function", Void, an_int_ref)
			assert_equal ("correct return value of first function", 1, an_int_ref.item)
			
			valid_index_function := al_type.function_by_name ("valid_index")
			assert_not_equal ("valid_index function found", Void, valid_index_function)
			assert_equal ("correct result type for valid_index function", universe.type_by_name ("BOOLEAN"), valid_index_function.result_type)
			assert_equal ("one argument for valid_index function", 1, valid_index_function.formal_arguments.count)
			assert ("valid operands for valid_index function", valid_index_function.valid_operands (an_al, [0]))
			assert ("invalid operands for valid_index function", not valid_index_function.valid_operands (an_al, ["a_string"]))
			valid_index_function.retrieve_value (an_al, [4])
			a_bool_ref ?= valid_index_function.last_result
			assert_not_equal ("correct return type of valid_index function", Void, a_bool_ref)
			assert_equal ("correct return value of valid_index function", False, a_bool_ref.item)
		end
		
	test_procedures is
			-- Check that procedures work correctly.
		local
			al_type: ERL_TYPE
			an_al: ARRAYED_LIST [INTEGER]
			start_procedure, force_procedure, wipe_out_procedure, replace_procedure: ERL_PROCEDURE
			make_creation_procedure: ERL_CREATION_PROCEDURE
			an_int_ref: INTEGER_REF
		do
			al_type := universe.type_by_name ("ARRAYED_LIST [INTEGER]")
			assert_not_equal ("ARRAYED_LIST [INTEGER] type found", Void, al_type)
			
			make_creation_procedure := al_type.creation_procedure_by_name ("make")
			assert_not_equal ("ARRAYED_LIST.make found", Void, make_creation_procedure)
			make_creation_procedure.apply ([0])
			an_al ?= make_creation_procedure.last_result
			assert_not_equal ("correct creation", Void, an_al)
			
			an_al.extend (1)
			an_al.extend (2)
			an_al.extend (3)
			
			start_procedure := al_type.procedure_by_name ("start")
			assert_not_equal ("start procedure found", Void, start_procedure)
			start_procedure.apply (an_al, [])
			an_int_ref ?= an_al.index
			assert_not_equal ("correct return type of index query", Void, an_int_ref)
			assert_equal ("correct start 1", 1, an_int_ref.item)
			
			force_procedure := al_type.procedure_by_name ("force")
			assert_not_equal ("force procedure found", Void, force_procedure)
			assert_equal ("one argument for force procedure", 1, force_procedure.formal_arguments.count)
			assert ("valid operands for force procedure", force_procedure.valid_operands (an_al, [4]))
			assert ("invalid operands for force procedure", not force_procedure.valid_operands (an_al, [al_type]))
			force_procedure.apply (an_al, [4])
			assert ("correct force 1", an_al.has (4))
			force_procedure.apply (an_al, [5])
			assert ("correct put 2", an_al.has (5))
			
			replace_procedure := al_type.procedure_by_name ("replace")
			assert_not_equal ("replace procedure found", Void, replace_procedure)
			replace_procedure.apply (an_al, [6])
			assert ("correct replace part 1", an_al.has (6))
			assert ("correct replace part 2", not an_al.has (1))
			
			wipe_out_procedure := al_type.procedure_by_name ("wipe_out")
			assert_not_equal ("wipe_out procedure found", Void, wipe_out_procedure)
			wipe_out_procedure.apply (an_al, [])
			assert_equal ("correct wipe_out", 0, an_al.count)			
		end

	test_not_exported_fields is
			-- Check that not exported fields are not visible.
		local
			a_feature: ERL_FEATURE
			al_type: ERL_TYPE
		do
			al_type := universe.type_by_name ("ARRAYED_LIST [INTEGER]")
			assert_not_equal ("ARRAYED_LIST [INTEGER] type found", Void, al_type)
			
			a_feature := al_type.feature_by_name ("Max_occupation")
			assert_equal ("Max_occupation feature not available", Void, a_feature)
			
			a_feature := al_type.feature_by_name ("set_content")
			assert_equal ("set_content feature not available", Void, a_feature)
			
			a_feature := al_type.feature_by_name ("position")
			assert_equal ("position feature not available", Void, a_feature)
		end
		
end
