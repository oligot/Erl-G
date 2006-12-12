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
			special_class: ERL_CLASS
		do
			special_class := universe.class_by_name ("SPECIAL")

				-- Check class exists in universe.
			assert_not_equal ("SPECIAL type found", Void, special_class)

				-- Check class characteristics.
			assert ("class not expanded", not special_class.is_expanded)
			assert ("class not basic", not special_class.is_basic_class)

			-- Check creation procedures retrieved correctly.
			assert ("SPECIAL [INTEFGER_32] type is instantiatable", special_class.is_instantiatable ("[INTEGER_32]"))
			assert ("SPECIAL [INTEGER_32] has `make' as creation procedure", special_class.is_valid_creation_procedure_name ("[INTEGER_32]", "make"))
			assert ("SPECIAL [INTEGER_32] has `make_from_native_array' as creation procedure", special_class.is_valid_creation_procedure_name ("[INTEGER_32]", "make_from_native_array"))

				-- Check features retrieved correctly.
			assert ("item feature exists", special_class.is_valid_feature_name ("item"))
			assert ("native_array feature exists", special_class.is_valid_feature_name ("native_array"))
			assert ("count feature exists", special_class.is_valid_feature_name ("count"))
			assert ("all_default feature exists", special_class.is_valid_feature_name ("all_default"))
			assert ("fill_with feature exists", special_class.is_valid_feature_name ("fill_with"))
			assert ("put feature exists", special_class.is_valid_feature_name ("put"))

				-- Check queries retrieved correctly.
			assert ("same_items query exists", special_class.is_valid_query_name ("same_items"))
			assert ("valid_index query exists", special_class.is_valid_query_name ("valid_index"))
			assert ("item_address query exists", special_class.is_valid_query_name ("item_address"))
			assert ("upper query exists", special_class.is_valid_query_name ("upper"))

		end

	test_creation_procedure is
			-- Check that creation procedure works correctly.
		local
			special_class: ERL_CLASS
			special_object: ANY
		do
			special_class := universe.class_by_name ("SPECIAL")
			assert_not_equal ("Class SPECIAL found", Void, special_class)

			assert_false ("SPECIAL has no default_create", special_class.is_valid_creation_procedure_name ("[INTEGER_32]", "default_create"))

			assert ("SPECIAL.make found", special_class.is_valid_creation_procedure_name ("[INTEGER_32]", "make"))

			-- Check formal arguments.
			assert ("valid SPECIAL.make arguments", special_class.valid_creation_procedure_arguments ("[INTEGER_32]", "make", <<0>>))

			-- Check applying and last result.
			special_class.invoke_creation_procedure ("[INTEGER_32]", "make", <<0>>)
			special_object := special_class.last_result
			assert_not_equal ("special created 1", Void, special_object)
			assert_equal ("created object has correct class", universe.class_by_object (special_object), special_class)
			assert_equal ("created object has correct type", "SPECIAL [INTEGER_32]", special_object.generating_type)

			special_class.invoke_creation_procedure ("[INTEGER_32]", "make", <<100>>)
			special_object := special_class.last_result
			assert_not_equal ("special created 2", Void, special_object)
		end

	test_queries_bug_in_ise is
			-- Check that queries work correctly.
		local
			special_class: ERL_CLASS
			a_special: SPECIAL [INTEGER_32]
		do
			special_class := universe.class_by_name ("SPECIAL")
			assert_not_equal ("SPECIAL type found", Void, special_class)

			special_class.invoke_creation_procedure ("[INTEGER_32]", "make", <<5>>)
			a_special ?= special_class.last_result

			a_special.put (1, 0)
			a_special.put (2, 1)
			a_special.put (3, 2)

			special_class.invoke_query ("item", a_special, <<0>>)
			assert_equal ("[bug in ise] correct item", 1, special_class.last_result)
			special_class.invoke_query ("item", a_special, <<1>>)
			assert_equal ("[bug in ise] correct item", 2, special_class.last_result)
			special_class.invoke_query ("item", a_special, <<2>>)
			assert_equal ("[bug in ise] correct item", 3, special_class.last_result)
		end

end
