indexing

	description:

		"Hello world example for Erl-G"

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
			person_class: ERL_CLASS
			person_object: ANY
		do
			print ("Creating a new object of type PERSON...%N")
			person_class := universe.class_by_name ("PERSON")
			person_class.invoke_creation_procedure ("", Void, <<"Anca Dobos", 25>>)
			person_object := person_class.last_result
			print ("Person object: ")
			print (person_object)
			print ("%N")

			print ("Querying the person's name...%N")
			person_class.invoke_query ("name", person_object, <<>>)
			print ("Name: ")
			print (person_class.last_result)
			print ("%N")

			print ("Querying the person's age...%N")
			person_class.invoke_query ("age" ,person_object, <<>>)
			print ("Age: ")
			print (person_class.last_result)
			print ("%N")

			print ("Invoking procedure `display'...%N")
			person_class.invoke_feature ("display", person_object, <<>>)
		end

end
