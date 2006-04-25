indexing

	description:

		"Hello world example for Gerl"

	copyright: "Copyright (c) 2004-2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class HELLO_WORLD

inherit

	ERL_SHARED_UNIVERSE
		export {NONE} all end

create

	execute

feature -- Execution

	execute is
			-- Start 'hello_world' execution.
		local
			person_type: ERL_TYPE
			make_creation_procedure: ERL_CREATION_PROCEDURE
			person_object: ANY
			name_attribute: ERL_ATTRIBUTE
			age_attribute: ERL_ATTRIBUTE
			display_procedure: ERL_PROCEDURE
		do
			print ("Creating a new object of type PERSON...%N")
			person_type := universe.type_by_name ("PERSON")
			make_creation_procedure := person_type.creation_procedure_by_name ("make")
			make_creation_procedure.apply (["Anca Dobos", 25])
			person_object := make_creation_procedure.last_result
			print ("Person object: ")
			print (person_object)
			print ("%N")

			print ("Querying the person's name...%N")
			name_attribute := person_type.attribute_by_name ("name")
			name_attribute.retrieve_value (person_object, [])
			print ("Name: ")
			print (name_attribute.last_result)
			print ("%N")

			print ("Querying the person's age...%N")
			age_attribute := person_type.attribute_by_name ("age")
			age_attribute.retrieve_value (person_object, [])
			print ("Age: ")
			print (age_attribute.last_result)
			print ("%N")

			print ("Setting name and age to new values...%N")
			name_attribute.replace (person_object, "Joe Smith")
			age_attribute.replace (person_object, 13)

			print ("Invoking procedure `display'...%N")
			display_procedure ?= person_type.procedure_by_name ("display")
			display_procedure.apply (person_object, [])
		end

end
