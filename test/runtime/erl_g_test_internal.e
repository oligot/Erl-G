indexing

	description:

		"Test features of Erl-G on class INTERNAL"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_INTERNAL

inherit

	TS_TEST_CASE

	ERL_SHARED_UNIVERSE
		export {NONE} all end


feature -- Test reflection on generated system

	test_type_information is
			-- Check that type information is retrieved correctly.
		local
			internal_type: ERL_TYPE
		do
			internal_type := universe.type_by_name ("INTERNAL")
			assert_not_equal ("INTERNAL type found", Void, internal_type)

				-- Check type characteristics and counts.
			assert ("type not expanded", not internal_type.is_expanded)
			assert ("type not basic", not internal_type.is_basic_type)

				-- Check features retrieved correctly.
			assert_not_equal ("is_instance_of feature exists", Void, internal_type.feature_by_name ("is_instance_of"))
			assert_not_equal ("dynamic_type_from_string feature exists", Void, internal_type.feature_by_name ("dynamic_type_from_string"))
			assert_not_equal ("is_special feature exists", Void, internal_type.feature_by_name ("is_special"))
			assert_not_equal ("Boolean_type feature exists", Void, internal_type.feature_by_name ("Boolean_type"))
			assert_not_equal ("field feature exists", Void, internal_type.feature_by_name ("field"))
			assert_not_equal ("mark feature exists", Void, internal_type.feature_by_name ("mark"))

				-- Check queries retrieved correctly.
			assert_not_equal ("type_conforms_to query exists", Void, internal_type.query_by_name ("type_conforms_to"))
			assert_not_equal ("is_tuple_type query exists", Void, internal_type.query_by_name ("is_tuple_type"))
			assert_not_equal ("Natural_8_type query exists", Void, internal_type.query_by_name ("natural_8_type"))

				-- Check functions retrieved correctly.
			assert_not_equal ("class_name_of_type function exists", Void, internal_type.function_by_name ("class_name_of_type"))
			assert_not_equal ("generic_count function exists", Void, internal_type.function_by_name ("generic_count"))

				-- Check procedures retrieved correctly.
			assert_not_equal ("set_double_field procedure exists", Void, internal_type.procedure_by_name ("set_double_field"))
			assert_not_equal ("mark procedure exists", Void, internal_type.procedure_by_name ("mark"))
		end

	test_queries is
			-- Check that queries work correctly.
		local
			internal_type: ERL_TYPE
			reference_type_query, class_name_query: ERL_QUERY
			an_internal: INTERNAL
			a_string: STRING
			an_int_ref: INTEGER_REF
		do
			internal_type := universe.type_by_name ("INTERNAL")
			assert_not_equal ("INTERNAL type found", Void, internal_type)
			create an_internal

				-- Check a constant query.
			reference_type_query := internal_type.query_by_name ("Reference_type")
			assert_not_equal ("Reference_type query found", Void, reference_type_query)
			assert_equal ("correct result type for Reference_type query", universe.type_by_name ("INTEGER"), reference_type_query.result_type)
			reference_type_query.retrieve_value (an_internal, [])
			an_int_ref ?= reference_type_query.last_result
			if an_int_ref /= Void then -- Is this correct?
				assert_equal ("correct value for Reference_type query", 1, an_int_ref.item)
			end

				-- Check a function query.
			class_name_query := internal_type.query_by_name ("class_name")
			assert_not_equal ("class_name query found", Void, class_name_query)
			assert_equal ("correct result type for class_name query", universe.type_by_name ("STRING"), class_name_query.result_type)
			class_name_query.retrieve_value (an_internal, [an_int_ref])
			a_string ?= class_name_query.last_result
			assert_equal ("correct value for class_name query", "INTEGER_REF", a_string)
		end

	test_functions is
			-- Check that functions work correctly.
		local
			internal_type: ERL_TYPE
			generic_count_function, is_tuple_function: ERL_FUNCTION
			a_list: LINKED_LIST [ANY]
			an_int_ref: INTEGER_REF
			a_bool_ref: BOOLEAN_REF
			an_internal: INTERNAL
		do
			internal_type := universe.type_by_name ("INTERNAL")
			assert_not_equal ("INTERNAL type found", Void, internal_type)
			create an_internal

			generic_count_function := internal_type.function_by_name ("generic_count")
			assert_not_equal ("generic_count function found", Void, generic_count_function)
			assert_equal ("correct result type for generic_count function", universe.type_by_name ("INTEGER"), generic_count_function.result_type)
			create a_list.make
			generic_count_function.retrieve_value (an_internal, [a_list])
			an_int_ref ?= generic_count_function.last_result
			if an_int_ref /= Void then
				assert_equal ("correct value for generic_count function", 1, an_int_ref.item)
			end

			is_tuple_function := internal_type.function_by_name ("is_tuple")
			assert_not_equal ("is_tuple function found", Void, is_tuple_function)
			assert_equal ("correct result type for is_tuple function", universe.type_by_name ("BOOLEAN"), is_tuple_function.result_type)
			is_tuple_function.retrieve_value (an_internal, [a_list])
			a_bool_ref ?= is_tuple_function.last_result
			if a_bool_ref /= Void then
				assert_equal ("correct value for is_tuple function", False, a_bool_ref.item)
			end
		end

	test_procedures is
			-- Check that procedures work correctly.
		local
			internal_type, integer_ref_type: ERL_TYPE
			an_internal: INTERNAL
			set_integer_field_procedure: ERL_PROCEDURE
			an_int_ref, an_int_ref_2: INTEGER_REF
			item_attribute: ERL_ATTRIBUTE
		do
			internal_type := universe.type_by_name ("INTERNAL")
			assert_not_equal ("INTERNAL type found", Void, internal_type)
			integer_ref_type := universe.type_by_name ("INTEGER_REF")
			assert_not_equal ("INTEGER_REF type found", Void, integer_ref_type)
			create an_internal

			create an_int_ref
			set_integer_field_procedure := internal_type.procedure_by_name ("set_integer_field")
			assert_not_equal ("set_integer_field procedure found", Void, set_integer_field_procedure)
			set_integer_field_procedure.apply (an_internal, [1, an_int_ref, 10])
			item_attribute := integer_ref_type.attribute_by_name ("item")
			assert_not_equal ("item attribute found", Void, item_attribute)
			item_attribute.retrieve_value (an_int_ref, [])
			an_int_ref_2 ?= item_attribute.last_result
			assert_not_equal ("correct type of item attribute of INTEGER_REF", Void, an_int_ref_2)
			assert_equal ("correct applying of set_integer_field procedure", 10, an_int_ref_2.item)
		end
end
