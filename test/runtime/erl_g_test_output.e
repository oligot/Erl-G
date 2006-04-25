indexing

	description:

		"Test features for Erl-G"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_OUTPUT

inherit

	TS_TEST_CASE
	
	ERL_SHARED_UNIVERSE
		export {NONE} all end
		

feature -- Test reflection on generated system

	test_type_information is
			-- Check that type information is retrieved correctly.
		local
			person_type: ERL_TYPE
			make_creation_procedure, creation_procedure_check: ERL_CREATION_PROCEDURE
		do
			person_type := universe.type_by_name ("PERSON")
			assert_not_equal ("PERSON type found", Void, person_type)
			
				-- Check type characteristics and counts.
			assert ("type not expanded", not person_type.is_expanded)
			assert ("type not basic", not person_type.is_basic_type)
			assert_equal ("correct creation procedure count", 1, person_type.creation_procedure_count)
			
				-- Check creation procedure retrieved correctly.
			make_creation_procedure := person_type.creation_procedure_by_name ("make")
			assert_not_equal ("PERSON.make found", Void, make_creation_procedure)
			creation_procedure_check := person_type.creation_procedure (1)
			assert_equal ("same creation procedure returned", make_creation_procedure, creation_procedure_check)
			assert_equal ("no default_create", Void, person_type.creation_procedure_by_name ("default_create"))
			
				-- Check features retrieved correctly.
			assert_not_equal ("name feature exists", Void, person_type.feature_by_name ("name"))
			assert_not_equal ("age feature exists", Void, person_type.feature_by_name ("age"))
			assert_not_equal ("set_name feature exists", Void, person_type.feature_by_name ("set_name"))
			assert_not_equal ("set_age feature exists", Void, person_type.feature_by_name ("set_age"))
			assert_not_equal ("set_to_me feature exists", Void, person_type.feature_by_name ("set_to_me"))
			assert_not_equal ("is_of_age feature exists", Void, person_type.feature_by_name ("is_of_age"))
			
				-- Check queries retrieved correctly.
			assert_not_equal ("name query exists", Void, person_type.query_by_name ("name"))
			assert_not_equal ("age query exists", Void, person_type.query_by_name ("age"))
			assert_not_equal ("is_of_age query exists", Void, person_type.query_by_name ("age"))
			
				-- Check attributes retrieved correctly.
			assert_not_equal ("name attribute exists", Void, person_type.attribute_by_name ("name"))
			assert_not_equal ("age attribute exists", Void, person_type.attribute_by_name ("age"))
			
				-- Check functions retrieved correctly.
			assert_not_equal ("is_of_age function exists", Void, person_type.function_by_name ("is_of_age"))
			
				-- Check procedures retrieved correctly.
			assert_not_equal ("set_name procedure exists", Void, person_type.procedure_by_name ("set_name"))
			assert_not_equal ("set_age procedure exists", Void, person_type.procedure_by_name ("set_age"))
			assert_not_equal ("set_to_me procedure exists", Void, person_type.procedure_by_name ("set_to_me"))
		end

	test_creation_procedure is
			-- Check that creation procedure works correctly.
		local
			person_type: ERL_TYPE
			person_object: ANY
			make_creation_procedure: ERL_CREATION_PROCEDURE
			set_to_me_procedure: ERL_PROCEDURE
			person: PERSON
		do
			person_type := universe.type_by_name ("PERSON")
			assert_not_equal ("PERSON type found", Void, person_type)
			
			make_creation_procedure := person_type.creation_procedure_by_name ("make")
			assert_not_equal ("PERSON.make found", Void, make_creation_procedure)
			
				-- Check formal arguments.
			assert_equal ("correct formal argument count", 2, make_creation_procedure.formal_arguments.count)
			assert_equal ("correct first formal argument name", "a_name", make_creation_procedure.formal_arguments.item (1).name)
			assert_equal ("correct first formal argument type", "STRING", make_creation_procedure.formal_arguments.item (1).type.name)
			assert_equal ("correct second formal argument name", "an_age", make_creation_procedure.formal_arguments.item (2).name)
			assert_equal ("correct second formal argument type", "INTEGER", make_creation_procedure.formal_arguments.item (2).type.name)
			
				-- Check type.
			assert_equal ("correct type of produced objects", "PERSON", make_creation_procedure.type.name)
			
				-- Check applying and last result.
			make_creation_procedure.apply (["Anca Dobos", 25])
			person_object := make_creation_procedure.last_result
			assert_not_equal ("person created", Void, person_object)
			assert_equal ("created object has correct type", person_type, universe.type_by_object (person_object))
			
			set_to_me_procedure := person_type.procedure_by_name ("set_to_me")
			set_to_me_procedure.apply (person_object, [])
			person ?= person_object
			assert_not_equal ("assignment attempt succeeds", Void, person)
			assert_equal ("correct name", "Andreas Leitner", person.name)
			assert_equal ("correct age", 28, person.age)
		end
		
	test_attributes is
			-- Check that attributes work correctly.
		local
			person_type: ERL_TYPE
			person_object: ANY
			make_creation_procedure: ERL_CREATION_PROCEDURE
			name_attribute, age_attribute: ERL_ATTRIBUTE
		do
			person_type := universe.type_by_name ("PERSON")
			assert_not_equal ("PERSON type found", Void, person_type)
			
			make_creation_procedure := person_type.creation_procedure_by_name ("make")
			assert_not_equal ("PERSON.make found", Void, make_creation_procedure)
			make_creation_procedure.apply (["Anca Dobos", 25])
			person_object := make_creation_procedure.last_result
			assert_not_equal ("New PERSON object created", Void, person_object)
			
			name_attribute := person_type.attribute_by_name ("name")
			assert_not_equal ("Name attribute found", Void, name_attribute)
			assert ("name attribute not constant", not name_attribute.is_constant)
			name_attribute.retrieve_value (person_object, [])
			assert_equal ("correct name 1", "Anca Dobos", name_attribute.last_result)

			age_attribute := person_type.attribute_by_name ("age")
			assert_not_equal ("Age attribute found", Void, age_attribute)
			assert ("age attribute not constant", not age_attribute.is_constant)
			age_attribute.retrieve_value (person_object, [])
			assert_equal ("correct age 1", 25, age_attribute.last_result)
			
			name_attribute.replace (person_object, "Joe Smith")
			name_attribute.retrieve_value (person_object, [])
			age_attribute.replace (person_object, 13)
			age_attribute.retrieve_value (person_object, [])
			assert_equal ("correct name 2", "Joe Smith", name_attribute.last_result)
			assert_equal ("correct age 2", 13, age_attribute.last_result)
		end
		
	test_queries is
			-- Check that queries work correctly.
		local
			person_type: ERL_TYPE
			person_object: ANY
			make_creation_procedure: ERL_CREATION_PROCEDURE
			age_query, is_of_age_query: ERL_QUERY
		do
			person_type := universe.type_by_name ("PERSON")
			assert_not_equal ("PERSON type found", Void, person_type)
			
			make_creation_procedure := person_type.creation_procedure_by_name ("make")
			assert_not_equal ("PERSON.make found", Void, make_creation_procedure)
			make_creation_procedure.apply (["Anca Dobos", 25])
			person_object := make_creation_procedure.last_result
			assert_not_equal ("New PERSON object created", Void, person_object)
			
				-- Check an attribute query.
			age_query := person_type.query_by_name ("age")
			assert_not_equal ("age query found", Void, age_query)
			assert_equal ("correct result type for age query", universe.type_by_name ("INTEGER"), age_query.result_type)
			age_query.retrieve_value (person_object, [])
			assert_equal ("correct value for age query", 25, age_query.last_result)
			
				-- Check a function query.
			is_of_age_query := person_type.query_by_name ("is_of_age")
			assert_not_equal ("is_of_age query found", Void, is_of_age_query)
			assert_equal ("correct result type for is_of_age query", universe.type_by_name ("BOOLEAN"), is_of_age_query.result_type)
			is_of_age_query.retrieve_value (person_object, [])
			assert_equal ("correct value for is_of_age query", True, is_of_age_query.last_result)
		end
		
	test_functions is
			-- Check that functions work correctly.
		local
			person_type: ERL_TYPE
			person_object: ANY
			make_creation_procedure: ERL_CREATION_PROCEDURE
			is_of_age_function: ERL_QUERY
		do
			person_type := universe.type_by_name ("PERSON")
			assert_not_equal ("PERSON type found", Void, person_type)
			
			make_creation_procedure := person_type.creation_procedure_by_name ("make")
			assert_not_equal ("PERSON.make found", Void, make_creation_procedure)
			make_creation_procedure.apply (["Anca Dobos", 25])
			person_object := make_creation_procedure.last_result
			assert_not_equal ("New PERSON object created", Void, person_object)
			
			is_of_age_function := person_type.function_by_name ("is_of_age")
			assert_not_equal ("is_of_age function found", Void, is_of_age_function)
			assert_equal ("correct result type for is_of_age function", universe.type_by_name ("BOOLEAN"), is_of_age_function.result_type)
			is_of_age_function.retrieve_value (person_object, [])
			assert_equal ("correct value for is_of_age function", True, is_of_age_function.last_result)
		end
		
	test_procedures is
			-- Check that procedures work correctly.
		local
			person_type: ERL_TYPE
			person_object: ANY
			make_creation_procedure: ERL_CREATION_PROCEDURE
			set_age_procedure, set_to_me_procedure: ERL_PROCEDURE
			name_attribute, age_attribute: ERL_ATTRIBUTE
		do
			person_type := universe.type_by_name ("PERSON")
			assert_not_equal ("PERSON type found", Void, person_type)
			
			make_creation_procedure := person_type.creation_procedure_by_name ("make")
			assert_not_equal ("PERSON.make found", Void, make_creation_procedure)
			make_creation_procedure.apply (["Anca Dobos", 25])
			person_object := make_creation_procedure.last_result
			assert_not_equal ("New PERSON object created", Void, person_object)
			
			set_age_procedure := person_type.procedure_by_name ("set_age")
			assert_not_equal ("set_age procedure found", Void, set_age_procedure)
			set_age_procedure.apply (person_object, [15])
			name_attribute := person_type.attribute_by_name ("name")
			assert_not_equal ("name attribute found", Void, name_attribute)
			name_attribute.retrieve_value (person_object, [])
			assert_equal ("correct applying of set_age procedure", "Anca Dobos", name_attribute.last_result)
			
			set_to_me_procedure := person_type.procedure_by_name ("set_to_me")
			assert_not_equal ("set_to_me procedure found", Void, set_to_me_procedure)
			set_to_me_procedure.apply (person_object, [])
			
			name_attribute.retrieve_value (person_object, [])
			age_attribute := person_type.attribute_by_name ("age")
			assert_not_equal ("age attribute found", Void, age_attribute)
			age_attribute.retrieve_value (person_object, [])
			assert_equal ("correct name after applying set_to_me procedure", "Andreas Leitner", name_attribute.last_result)
			assert_equal ("correct age after applying set_to_me procedure", 28, age_attribute.last_result)
		end
		
	test_type_conformance is
			-- Check that erl-generated classes are introspectable.
		local
			person_type, retrieved_person_type: ERL_TYPE
			person_object: ANY
--			any_type: ERL_TYPE
--			an_any: ANY
			make_creation_procedure: ERL_CREATION_PROCEDURE
		do
			person_type := universe.type_by_name ("PERSON")
			make_creation_procedure := person_type.creation_procedure_by_name ("make")
			assert_not_equal ("PERSON.make found", Void, make_creation_procedure)
			make_creation_procedure.apply (["Anca Dobos", 25])
			person_object := make_creation_procedure.last_result
			assert_not_equal ("New PERSON object created", Void, person_object)
			
			retrieved_person_type := universe.type_by_object (person_object)
			assert_not_equal ("retrieved person type not void", Void, retrieved_person_type)
			assert_equal ("type_by_object correct", "PERSON", retrieved_person_type.name)
			
				-- Calling generating_type on an object of type ANY (necessary for type_by_object)
				-- returns NONE. Manu acknowledged the bug and said they would fix it for 5.7.
				-- Commented out until then.
--			create an_any
--			any_type := universe.type_by_object (an_any)
--			assert_not_equal ("ANY type retrieved correctly by object", Void, any_type)
--			assert ("person type conforms to any type", person_type.conforms_to_type (any_type))
		end
		
end
