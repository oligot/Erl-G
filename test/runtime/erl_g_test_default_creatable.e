indexing

	description:

		"Test features of Erl-G on class DEFAULT_CREATABLE"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$30.08.2005$"
	revision: "$1.0$"

deferred class ERL_G_TEST_DEFAULT_CREATABLE

inherit

	TS_TEST_CASE

	ERL_SHARED_UNIVERSE
		export {NONE} all end

feature -- Test reflection on generated system

	test_default_creation is
			-- Test that default creation works for a class that does not have a `create' clause.
		local
			default_creatable_type: ERL_TYPE
			default_creatable_object: ANY
			default_create_creation_procedure: ERL_CREATION_PROCEDURE
			an_int_attribute, a_ref_attribute: ERL_ATTRIBUTE
			an_int_ref: INTEGER_REF
		do
			default_creatable_type := universe.type_by_name ("DEFAULT_CREATABLE")
			assert_not_equal ("DEFAULT_CREATABLE type found", Void, default_creatable_type)

				-- Check that type has one creation procedure.
			assert_equal ("one creation procedure", 1, default_creatable_type.creation_procedure_count)

			default_create_creation_procedure := default_creatable_type.default_creation_procedure
			assert_not_equal ("DEFAULT_CREATABLE.default_create found", Void, default_create_creation_procedure)

				-- Check formal arguments.
			assert_equal ("no formal arguments", 0, default_create_creation_procedure.formal_arguments.count)

				-- Check type.
			assert_equal ("correct type of produced objects", "DEFAULT_CREATABLE", default_create_creation_procedure.type.name)

				-- Check applying and last result.
			default_create_creation_procedure.apply ([])
			default_creatable_object := default_create_creation_procedure.last_result
			assert_not_equal ("New DEFAULT_CREATABLE object created", Void, default_creatable_object)
			assert_equal ("created object has correct type", default_creatable_type, universe.type_by_object (default_creatable_object))

				-- Check that its attributes were initialized to default values.
			an_int_attribute := default_creatable_type.attribute_by_name ("an_int")
			assert_not_equal ("an_int attribute found", Void, an_int_attribute)
			assert_equal ("correct result type for an_int attribute", an_int_attribute.result_type, universe.type_by_name ("INTEGER"))
			assert_equal ("no arguments for an_int attribute", 0, an_int_attribute.formal_arguments.count)
			an_int_attribute.retrieve_value (default_creatable_object, [])
			an_int_ref ?= an_int_attribute.last_result
			assert_not_equal ("correct type of an_int attribute", Void, an_int_ref)
			assert_equal ("correct an_int", 0, an_int_ref.item)
			a_ref_attribute := default_creatable_type.attribute_by_name ("a_ref")
			assert_not_equal ("a_ref attribute found", Void, a_ref_attribute)
			assert_equal ("correct result type for a_ref attribute", a_ref_attribute.result_type, universe.type_by_name ("ANY"))
			assert_equal ("no arguments for a_ref attribute", 0, a_ref_attribute.formal_arguments.count)
			a_ref_attribute.retrieve_value (default_creatable_object, [])
			assert_equal ("correct a_ref", Void, a_ref_attribute.last_result)
		end

	test_default_creation_2 is
			-- Test that default creation works for a class that declares `default_create' in its `create' clause.
		local
			default_creatable_type: ERL_TYPE
			default_creatable_object_1, default_creatable_object_2: ANY
			default_create_creation_procedure_1, default_create_creation_procedure_2: ERL_CREATION_PROCEDURE
			an_int_attribute, a_ref_attribute: ERL_ATTRIBUTE
			an_int_ref: INTEGER_REF
		do
			default_creatable_type := universe.type_by_name ("DEFAULT_CREATABLE_2")
			assert_not_equal ("DEFAULT_CREATABLE_2 type found", Void, default_creatable_type)

				-- Check that type has two creation procedures.
			assert_equal ("two creation procedures", 2, default_creatable_type.creation_procedure_count)

			default_create_creation_procedure_1 := default_creatable_type.default_creation_procedure
			assert_not_equal ("DEFAULT_CREATABLE_2.default_create found as default creation procedure", Void, default_create_creation_procedure_1)

			default_create_creation_procedure_2 := default_creatable_type.creation_procedure_by_name ("default_create")
			assert_not_equal ("DEFAULT_CREATABLE_2.default_create found by name", Void, default_create_creation_procedure_2)

				-- Check formal arguments.
			assert_equal ("no formal arguments 1", 0, default_create_creation_procedure_1.formal_arguments.count)
			assert_equal ("no formal arguments 2", 0, default_create_creation_procedure_2.formal_arguments.count)

				-- Check type.
			assert_equal ("correct type of produced objects 1", "DEFAULT_CREATABLE_2", default_create_creation_procedure_1.type.name)
			assert_equal ("correct type of produced objects 2", "DEFAULT_CREATABLE_2", default_create_creation_procedure_2.type.name)

				-- Check applying and last result.
			default_create_creation_procedure_1.apply ([])
			default_creatable_object_1 := default_create_creation_procedure_1.last_result
			assert_not_equal ("New DEFAULT_CREATABLE_2 object created 1", Void, default_creatable_object_1)
			assert_equal ("created object has correct type", default_creatable_type, universe.type_by_object (default_creatable_object_1))
			default_create_creation_procedure_2.apply ([])
			default_creatable_object_2 := default_create_creation_procedure_2.last_result
			assert_not_equal ("New DEFAULT_CREATABLE_2 object created 2", Void, default_creatable_object_2)
			assert_equal ("created object has correct type", default_creatable_type, universe.type_by_object (default_creatable_object_2))

				-- Check that its attributes were initialized to default values.
			an_int_attribute := default_creatable_type.attribute_by_name ("an_int")
			assert_not_equal ("an_int attribute found", Void, an_int_attribute)
			assert_equal ("correct result type for an_int attribute", an_int_attribute.result_type, universe.type_by_name ("INTEGER"))
			assert_equal ("no arguments for an_int attribute", 0, an_int_attribute.formal_arguments.count)
			an_int_attribute.retrieve_value (default_creatable_object_1, [])
			an_int_ref ?= an_int_attribute.last_result
			assert_not_equal ("correct type of an_int attribute", Void, an_int_ref)
			assert_equal ("correct an_int", 0, an_int_ref.item)
			an_int_attribute.retrieve_value (default_creatable_object_2, [])
			an_int_ref ?= an_int_attribute.last_result
			assert_not_equal ("correct type of an_int attribute", Void, an_int_ref)
			assert_equal ("correct an_int", 0, an_int_ref.item)
			a_ref_attribute := default_creatable_type.attribute_by_name ("a_ref")
			assert_not_equal ("a_ref attribute found", Void, a_ref_attribute)
			assert_equal ("correct result type for a_ref attribute", a_ref_attribute.result_type, universe.type_by_name ("ANY"))
			assert_equal ("no arguments for a_ref attribute", 0, a_ref_attribute.formal_arguments.count)
			a_ref_attribute.retrieve_value (default_creatable_object_1, [])
			assert_equal ("correct a_ref", Void, a_ref_attribute.last_result)
			a_ref_attribute.retrieve_value (default_creatable_object_2, [])
			assert_equal ("correct a_ref", Void, a_ref_attribute.last_result)
		end

	test_default_creation_3 is
			-- Test that default creation doesn't work for a class that declares `default_create' in its `create' clause
			-- but exports it to NONE.
		local
			default_creatable_type: ERL_TYPE
		do
			default_creatable_type := universe.type_by_name ("DEFAULT_CREATABLE_3")
			assert_not_equal ("DEFAULT_CREATABLE_3 type found", Void, default_creatable_type)

			assert_equal ("no creation procedures", 0, default_creatable_type.creation_procedure_count)
			assert_equal ("no default creation procedures", Void, default_creatable_type.default_creation_procedure)
		end

end
