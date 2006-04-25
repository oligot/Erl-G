indexing

	description:

		"Test features of Erl-G on class HASH_TABLE [ANY, STRING]"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_HASH_TABLE

inherit

	TS_TEST_CASE
	
	ERL_SHARED_UNIVERSE
		export {NONE} all end
		

feature -- Test reflection on generated system

	test_type_information is
			-- Check that type information is retrieved correctly.
		local
			hash_table_type: ERL_TYPE
			creation_procedure: ERL_CREATION_PROCEDURE
		do
			hash_table_type := universe.type_by_name ("HASH_TABLE [ANY, STRING]")
			
				-- Check type exists in universe.
			assert_not_equal ("HASH_TABLE [ANY, STRING] type found", Void, hash_table_type)
			
				-- Check type characteristics and counts.
			assert ("type not expanded", not hash_table_type.is_expanded)
			assert ("type not basic", not hash_table_type.is_basic_type)
			assert_equal ("correct creation procedure count", 1, hash_table_type.creation_procedure_count)
			
				-- Check creation procedures retrieved correctly.
			creation_procedure := hash_table_type.creation_procedure_by_name ("make")
			assert_not_equal ("make detected", Void, creation_procedure)
			
				-- Check features retrieved correctly.
			assert_not_equal ("accommodate feature exists", Void, hash_table_type.feature_by_name ("accommodate"))
			assert_not_equal ("item feature exists", Void, hash_table_type.feature_by_name ("item"))
			assert_not_equal ("has feature exists", Void, hash_table_type.feature_by_name ("has"))
			assert_not_equal ("current_keys feature exists", Void, hash_table_type.feature_by_name ("current_keys"))
			assert_not_equal ("count feature exists", Void, hash_table_type.feature_by_name ("count"))
			assert_not_equal ("full feature exists", Void, hash_table_type.feature_by_name ("full"))
			
				-- Check queries retrieved correctly.
			assert_not_equal ("after query exists", Void, hash_table_type.query_by_name ("after"))
			assert_not_equal ("valid_key query exists", Void, hash_table_type.query_by_name ("valid_key"))
			assert_not_equal ("has_item query exists", Void, hash_table_type.query_by_name ("has_item"))
			
				-- Check functions retrieved correctly.
			assert_not_equal ("current_keys function exists", Void, hash_table_type.function_by_name ("current_keys"))
			assert_not_equal ("cursor function exists", Void, hash_table_type.function_by_name ("cursor"))
			
				-- Check procedures retrieved correctly.
			assert_not_equal ("start procedure exists", Void, hash_table_type.procedure_by_name ("start"))
			assert_not_equal ("put procedure exists", Void, hash_table_type.procedure_by_name ("put"))
		end
		
	test_creation_procedure is
			-- Check that creation procedure works correctly.
		local
			hash_table_type: ERL_TYPE
			hash_table_object: ANY
			make_creation_procedure: ERL_CREATION_PROCEDURE
		do
			hash_table_type := universe.type_by_name ("HASH_TABLE [ANY, STRING]")
			assert_not_equal ("HASH_TABLE [ANY, STRING] type found", Void, hash_table_type)
			
			assert_equal ("HASH_TABLE has no default_create", Void, hash_table_type.creation_procedure_by_name ("default_create"))
			
			make_creation_procedure := hash_table_type.creation_procedure_by_name ("make")
			assert_not_equal ("HASH_TABLE.make found", Void, make_creation_procedure)

				-- Check formal arguments.
			assert_equal ("correct formal argument count", 1, make_creation_procedure.formal_arguments.count)
			assert_equal ("correct formal argument name", "n", make_creation_procedure.formal_arguments.item (1).name)
			assert_equal ("correct formal argument type", "INTEGER", make_creation_procedure.formal_arguments.item (1).type.name)

				-- Check type.
			assert_equal ("correct type of produced objects", "HASH_TABLE [ANY, STRING]", make_creation_procedure.type.name)
			
				-- Check applying and last result.
			make_creation_procedure.apply ([0])
			hash_table_object := make_creation_procedure.last_result
			assert_not_equal ("hash_table created 1", Void, hash_table_object)
			assert_equal ("created object has correct type", hash_table_type, universe.type_by_object (hash_table_object))
			
			make_creation_procedure.apply ([100])
			hash_table_object := make_creation_procedure.last_result
			assert_not_equal ("hash_table created 2", Void, hash_table_object)
		end
		
	test_attributes is
			-- Check that attributes work correctly.
		local
			hash_table_type: ERL_TYPE
			a_hash_table: HASH_TABLE [ANY, STRING]
			make_creation_procedure: ERL_CREATION_PROCEDURE
			count_attribute: ERL_ATTRIBUTE
			an_int_ref: INTEGER_REF
		do
			hash_table_type := universe.type_by_name ("HASH_TABLE [ANY, STRING]")
			assert_not_equal ("HASH_TABLE [ANY, STRING] type found", Void, hash_table_type)
			
			make_creation_procedure := hash_table_type.creation_procedure_by_name ("make")
			assert_not_equal ("HASH_TABLE.make found", Void, make_creation_procedure)
			make_creation_procedure.apply ([0])
			a_hash_table ?= make_creation_procedure.last_result
			assert_not_equal ("correct creation", Void, a_hash_table)
			
			a_hash_table.put (1, "key1")
			a_hash_table.put (2, "key2")
			
			count_attribute := hash_table_type.attribute_by_name ("count")
			assert_not_equal ("count attribute found", Void, count_attribute)
			assert ("count attribute not constant", not count_attribute.is_constant)
			assert_equal ("correct result type for count attribute", count_attribute.result_type, universe.type_by_name ("INTEGER"))
			assert_equal ("no arguments for count attribute", 0, count_attribute.formal_arguments.count)
			assert ("valid operands for count attribute", count_attribute.valid_operands (a_hash_table, []))
			count_attribute.retrieve_value (a_hash_table, [])
			an_int_ref ?= count_attribute.last_result
			assert_not_equal ("correct type of count attribute", Void, an_int_ref)
			assert_equal ("correct count 1", 2, an_int_ref.item)
		end
		
	test_queries is
			-- Check that queries work correctly.
		local
			hash_table_type: ERL_TYPE
			make_creation_procedure: ERL_CREATION_PROCEDURE
			item_query, has_query: ERL_QUERY
			a_hash_table: HASH_TABLE [ANY, STRING]
			an_int_ref: INTEGER_REF
			a_bool_ref: BOOLEAN_REF
		do
			hash_table_type := universe.type_by_name ("HASH_TABLE [ANY, STRING]")
			assert_not_equal ("HASH_TABLE [ANY, STRING] type found", Void, hash_table_type)
			
			make_creation_procedure := hash_table_type.creation_procedure_by_name ("make")
			assert_not_equal ("HASH_TABLE.make found", Void, make_creation_procedure)
			make_creation_procedure.apply ([0])
			a_hash_table ?= make_creation_procedure.last_result
			assert_not_equal ("correct creation", Void, a_hash_table)
			
			a_hash_table.put (1, "key1")
			a_hash_table.put (2, "key2")
			
			item_query := hash_table_type.query_by_name ("item")
			assert_not_equal ("item query found", Void, item_query)
			assert_equal ("correct result type for item query", universe.type_by_name ("ANY"), item_query.result_type)
			assert_equal ("one argument for item query", 1, item_query.formal_arguments.count)
			assert ("valid operands for item query", item_query.valid_operands (a_hash_table, ["a_key"]))
			item_query.retrieve_value (a_hash_table, ["key2"])
			an_int_ref ?= item_query.last_result
			assert_not_equal ("correct type of item query", Void, an_int_ref)
			assert_equal ("correct value of item query", 2, an_int_ref.item)
			
			has_query := hash_table_type.query_by_name ("has")
			assert_not_equal ("has query found", Void, has_query)
			assert_equal ("correct result type for has query", universe.type_by_name ("BOOLEAN"), has_query.result_type)
			assert_equal ("one argument for has query", 1, has_query.formal_arguments.count)
			assert ("valid operands for has query", has_query.valid_operands (a_hash_table, ["a_key"]))
			has_query.retrieve_value (a_hash_table, ["key3"])
			a_bool_ref ?= has_query.last_result
			assert_not_equal ("correct type of has query", Void, a_bool_ref)
			assert_equal ("correct value for has query", False, a_bool_ref.item)
		end
		
	test_functions is
			-- Check that functions work correctly.
		local
			hash_table_type: ERL_TYPE
			a_hash_table: HASH_TABLE [ANY, STRING]
			has_item_function, occurrences_function: ERL_FUNCTION
			a_bool_ref: BOOLEAN_REF
			an_int_ref: INTEGER_REF
			make_creation_procedure: ERL_CREATION_PROCEDURE
			a1, a2: ANY
		do
			hash_table_type := universe.type_by_name ("HASH_TABLE [ANY, STRING]")
			assert_not_equal ("HASH_TABLE [ANY, STRING] type found", Void, hash_table_type)
			
			make_creation_procedure := hash_table_type.creation_procedure_by_name ("make")
			assert_not_equal ("HASH_TABLE.make found", Void, make_creation_procedure)
			make_creation_procedure.apply ([0])
			a_hash_table ?= make_creation_procedure.last_result
			assert_not_equal ("correct creation", Void, a_hash_table)
			
			create a1
			create a2
			a_hash_table.put (a1, "key1")
			a_hash_table.put (a2, "key2")
			
			has_item_function := hash_table_type.function_by_name ("has_item")
			assert_not_equal ("has_item function found", Void, has_item_function)
			assert_equal ("correct result type for has_item function", universe.type_by_name ("BOOLEAN"), has_item_function.result_type)
			assert_equal ("one argument for has_item function", 1, has_item_function.formal_arguments.count)
			assert ("valid operands for has_item function", has_item_function.valid_operands (a_hash_table, ["an_item"]))
			has_item_function.retrieve_value (a_hash_table, [a1])
			a_bool_ref ?= has_item_function.last_result
			assert_not_equal ("correct return type of has_item function", Void, a_bool_ref)
			assert_equal ("correct return value of has_item function", True, a_bool_ref.item)
			
			a_hash_table.put (a1, "key3")
			occurrences_function := hash_table_type.function_by_name ("occurrences")
			assert_not_equal ("occurrences function found", Void, occurrences_function)
			assert_equal ("correct result type for occurrences function", universe.type_by_name ("INTEGER"), occurrences_function.result_type)
			assert_equal ("one argument for occurrences function", 1, occurrences_function.formal_arguments.count)
			assert ("valid operands for occurrences function", occurrences_function.valid_operands (a_hash_table, [0]))
			occurrences_function.retrieve_value (a_hash_table, [a1])
			an_int_ref ?= occurrences_function.last_result
			assert_not_equal ("correct return type of occurrences function", Void, an_int_ref)
			assert_equal ("correct return value of occurrences function", 2, an_int_ref.item)
		end
		
	test_procedures is
			-- Check that procedures work correctly.
		local
			hash_table_type: ERL_TYPE
			a_hash_table: HASH_TABLE [ANY, STRING]
			put_procedure, replace_procedure, start_procedure, forth_procedure: ERL_PROCEDURE
			make_creation_procedure: ERL_CREATION_PROCEDURE
			an_any: ANY
			an_int_ref: INTEGER_REF
		do
			hash_table_type := universe.type_by_name ("HASH_TABLE [ANY, STRING]")
			assert_not_equal ("HASH_TABLE [ANY, STRING] type found", Void, hash_table_type)
			
			make_creation_procedure := hash_table_type.creation_procedure_by_name ("make")
			assert_not_equal ("HASH_TABLE.make found", Void, make_creation_procedure)
			make_creation_procedure.apply ([0])
			a_hash_table ?= make_creation_procedure.last_result
			assert_not_equal ("correct creation", Void, a_hash_table)
			
			put_procedure := hash_table_type.procedure_by_name ("put")
			assert_not_equal ("put procedure found", Void, put_procedure)
			assert_equal ("two arguments for put procedure", 2, put_procedure.formal_arguments.count)
			assert ("valid operands for put procedure", put_procedure.valid_operands (a_hash_table, ["an_item", "a_key"]))
			create an_any
			assert ("invalid operands for put procedure", not put_procedure.valid_operands (a_hash_table, ["an_item", an_any]))
			put_procedure.apply (a_hash_table, [1, "key1"])
			assert ("correct put 1", a_hash_table.has ("key1"))
			put_procedure.apply (a_hash_table, [2, "key2"])
			assert ("correct put 2", a_hash_table.has ("key2"))
			
			replace_procedure := hash_table_type.procedure_by_name ("replace")
			assert_not_equal ("replace procedure found", Void, replace_procedure)
			replace_procedure.apply (a_hash_table, [11, "key1"])
			an_int_ref ?= a_hash_table.item ("key1")
			if an_int_ref /= Void then
				assert_equal ("correct replace", 11, an_int_ref.item)
			end
			
			start_procedure := hash_table_type.procedure_by_name ("start")
			assert_not_equal ("start procedure found", Void, start_procedure)
			start_procedure.apply (a_hash_table, [])
			an_int_ref ?= a_hash_table.item_for_iteration
			if an_int_ref /= Void then 
				assert_equal ("correct start 1", 11, an_int_ref.item)
			end
			assert_equal ("correct start 2", "key1", a_hash_table.key_for_iteration)
			
			forth_procedure := hash_table_type.procedure_by_name ("forth")
			assert_not_equal ("forth procedure found", Void, forth_procedure)
			forth_procedure.apply (a_hash_table, [])
			an_int_ref ?= a_hash_table.item_for_iteration
			if an_int_ref /= Void then 
				assert_equal ("correct forth 1", 2, an_int_ref)
			end
			assert_equal ("correct forth 2", "key2", a_hash_table.key_for_iteration)
		end

	test_not_exported_fields is
			-- Check that not exported fields are not visible.
		local
			a_feature: ERL_FEATURE
			hash_table_type: ERL_TYPE
		do
			hash_table_type := universe.type_by_name ("HASH_TABLE [ANY, STRING]")
			assert_not_equal ("HASH_TABLE [ANY, STRING] type found", Void, hash_table_type)
			
			a_feature := hash_table_type.feature_by_name ("Max_occupation")
			assert_equal ("Max_occupation feature not available", Void, a_feature)
			
			a_feature := hash_table_type.feature_by_name ("set_content")
			assert_equal ("set_content feature not available", Void, a_feature)
			
			a_feature := hash_table_type.feature_by_name ("position")
			assert_equal ("position feature not available", Void, a_feature)
		end
		
	test_type_conformance is
			-- Check that erl-generated classes are introspectable.
		local
			string_type, retrieved_string_type, string_handler_type, retrieved_string_handler_type: ERL_TYPE
			string_object, string_handler_object: ANY
			make_creation_procedure, make_default_creation_procedure: ERL_CREATION_PROCEDURE
		do
			string_type := universe.type_by_name ("STRING")
			make_creation_procedure := string_type.creation_procedure_by_name ("make_empty")
			assert_not_equal ("STRING.make_empty found", Void, make_creation_procedure)
			make_creation_procedure.apply ([])
			string_object := make_creation_procedure.last_result
			assert_not_equal ("New STRING object created", Void, string_object)
			
			retrieved_string_type := universe.type_by_object (string_object)
			assert_not_equal ("retrieved STRING type not void", Void, retrieved_string_type)
			assert_equal ("type_by_object correct 1", "STRING", retrieved_string_type.name)
			
			string_handler_type := universe.type_by_name ("STRING_HANDLER")
			make_default_creation_procedure := string_handler_type.default_creation_procedure
			assert_not_equal ("STRING_HANDLER.default_create found", Void, make_default_creation_procedure)
			make_default_creation_procedure.apply ([])
			string_handler_object := make_default_creation_procedure.last_result
			assert_not_equal ("New STRING_HANLDER object created", Void, string_handler_object)
			
			retrieved_string_handler_type := universe.type_by_object (string_handler_object)
			assert_not_equal ("retrieved STRING_HANDLER type not void", Void, retrieved_string_handler_type)
			assert_equal ("type_by_object correct 2", "STRING_HANDLER", retrieved_string_handler_type.name)
			
			assert ("STRING conforms to STRING_HANDLER", string_type.conforms_to_type (string_handler_type))
			assert ("retrieved STRING conforms to retrieved STRING_HANDLER", retrieved_string_type.conforms_to_type (retrieved_string_handler_type))
		end
		
end
