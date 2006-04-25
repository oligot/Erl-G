indexing

	description:

		"Test features for checking lexical validity of class ITP_REQUEST_PARSER"

	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_LEXICAL_VALIDITY

inherit
	ERL_G_TEST_REQUEST_PARSER
	
feature -- Lexical validity tests

	test_valid_identifier is
		do
			assert ("valid identifier 1", is_valid_identifier ("a_foo"))
			assert ("valid identifier 2", is_valid_identifier ("an_argument"))
			assert ("valid identifier 3", is_valid_identifier ("abc"))
			assert ("valid identifier 4", is_valid_identifier ("n1"))
			assert ("valid identifier 5", is_valid_identifier ("index_a_1"))
			assert ("valid identifier 6", is_valid_identifier ("index_a_1_"))
			assert ("valid identifier 7", is_valid_identifier ("index_a_1xyz"))
			assert ("valid identifier 8", is_valid_identifier ("create"))
			assert ("valid identifier 9", not is_valid_identifier (""))
			
			assert ("valid identifier 10 (TO DO)", not is_valid_identifier ("1abc"))
			assert ("valid identifier 11 (TO DO)", not is_valid_identifier ("[xzy"))
			assert ("valid identifier 12 (TO DO)", not is_valid_identifier ("a(b"))
			assert ("valid identifier 13 (TO DO)", not is_valid_identifier ("foo.bar"))
			assert ("valid identifier 14 (TO DO)", not is_valid_identifier ("_a"))
		end
		
	test_valid_entity_name is
		do
			assert ("valid variable 1", is_valid_entity_name ("a_foo"))
			assert ("valid variable 2", is_valid_entity_name ("an_argument"))
			assert ("valid variable 3", is_valid_entity_name ("abc"))
			assert ("valid variable 4", is_valid_entity_name ("n1"))
			assert ("valid variable 5", is_valid_entity_name ("index_a_1"))
			assert ("valid variable 6", is_valid_entity_name ("index_a_1_"))
			assert ("valid variable 7", is_valid_entity_name ("index_a_1xyz"))
			assert ("valid variable 8", not is_valid_entity_name (""))
			
			assert ("valid variable 9 (TO DO)", not is_valid_entity_name ("_a"))
			assert ("valid variable 10 (TO DO)", not is_valid_entity_name ("1abc"))
			assert ("valid variable 11 (TO DO)", not is_valid_entity_name ("[xzy"))
			assert ("valid variable 12 (TO DO)", not is_valid_entity_name ("a(b"))
			assert ("valid variable 13 (TO DO)", not is_valid_entity_name ("foo.bar"))
			assert ("valid variable 14 (TO DO)", not is_valid_entity_name ("create"))
		end
		
	test_valid_type_name is
		do
			assert ("valid type name 1", is_valid_type_name ("MY_CLASS"))
			assert ("valid type name 2", is_valid_type_name ("MY_CLASS2"))
			assert ("valid type name 3", is_valid_type_name ("MY_CLASS[INTEGER]"))
			assert ("valid type name 4", is_valid_type_name ("MY_CLASS [LIST [STRING]]"))
			assert ("valid type name 5", is_valid_type_name ("MY_CLASS [LIST [STRING], ANY]"))
			assert ("valid type name 6", not is_valid_type_name (""))
			
			assert ("valid type name 7 (TO DO)", not is_valid_type_name ("MY_CLASS [LIST [STRING]"))
			assert ("valid type name 8 (TO DO)", not is_valid_type_name ("MY_CLASS [LIST STRING]]"))
			assert ("valid type name 9 (TO DO)", not is_valid_type_name ("MY_CLASS [LIST STRING]"))
			assert ("valid type name 10 (TO DO)", not is_valid_type_name ("MY_CLASS [[LIST [STRING]]]"))
			assert ("valid type name 11 (TO DO)", not is_valid_type_name ("1a"))
			assert ("valid type name 12 (TO DO)", not is_valid_type_name ("_a"))
			assert ("valid type name 14 (TO DO)", not is_valid_type_name (" "))
			assert ("valid type name 15 (TO DO)", not is_valid_type_name ("[MY_CLASS [LIST [STRING]]"))
		end

end
