indexing

	description:

		"Test features for parsing create requests of class ITP_REQUEST_PARSER"

	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_CREATE_REQUEST_PARSING

inherit
	ERL_G_TEST_REQUEST_PARSER

feature -- Tests for create requests

	test_create_request_1 is
		do
			set_input ("create {FOO} bar.make")
			parse
			assert_equal ("no error occured", False, has_error)
			assert_equal ("create request triggered", create_request_code, last_request)
			assert_equal ("correct type name", "FOO", last_type_name)
			assert_equal ("correct target variable name", "bar", last_target_variable_name)
			assert_equal ("correct creation procedure name", "make", last_creation_procedure_name)
			assert_equal ("no arguments", 0, last_argument_list.count)
		end

	test_create_request_2 is
		do
			set_input ("create {LINKED_LIST [INTEGER]} a_list.make")
			parse
			assert_equal ("no error occured", False, has_error)
			assert_equal ("create request triggered", create_request_code, last_request)
			assert_equal ("correct type name", "LINKED_LIST [INTEGER]", last_type_name)
			assert_equal ("correct target variable name", "a_list", last_target_variable_name)
			assert_equal ("correct creation procedure name", "make", last_creation_procedure_name)
			assert_equal ("no arguments", 0, last_argument_list.count)
		end

	test_create_request_3 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("create {FOO} a_foo.make_with_size (10)")
			parse
			assert_equal ("no error occured", False, has_error)
			assert_equal ("create request triggered", create_request_code, last_request)
			assert_equal ("correct type name", "FOO", last_type_name)
			assert_equal ("correct target variable name", "a_foo", last_target_variable_name)
			assert_equal ("correct creation procedure name", "make_with_size", last_creation_procedure_name)
			assert_equal ("one argument", 1, last_argument_list.count)
			a_const ?= last_argument_list.item (1)
			assert_not_equal ("argument not void", Void, a_const)
			assert_equal ("correct argument value", 10, a_const.value)
		end

	test_create_request_4 is
		local
			a_variable: ITP_VARIABLE
		do
			set_input ("create {FOO} a_foo.make1 (10, a_var)")
			parse
			assert_equal ("no error occured", False, has_error)
			assert_equal ("create request triggered", create_request_code, last_request)
			assert_equal ("correct type name", "FOO", last_type_name)
			assert_equal ("correct target variable name", "a_foo", last_target_variable_name)
			assert_equal ("correct creation procedure name", "make1", last_creation_procedure_name)
			assert_equal ("two arguments", 2, last_argument_list.count)
			a_variable ?= last_argument_list.item (2)
			assert ("correct second argument type", a_variable /= Void)
			assert_equal ("correct argument 2", "a_var", a_variable.name)
		end

	test_create_request_5 is
		do
			set_input ("create {LIST [TUPLE [ANY, PERSON, LIST [STRING]]]} a_var.make (Void, 3.3)")
			parse
			assert_equal ("no error occured", False, has_error)
			assert_equal ("create request triggered", create_request_code, last_request)
			assert_equal ("correct type name", "LIST [TUPLE [ANY, PERSON, LIST [STRING]]]", last_type_name)
			assert_equal ("correct target variable name", "a_var", last_target_variable_name)
			assert_equal ("correct creation procedure name", "make", last_creation_procedure_name)
			assert_equal ("two arguments", 2, last_argument_list.count)
		end

	test_create_request_6 is
		do
			set_input ("create {LIST  [FOO ]} x.make_default")
			parse
			assert_equal ("no error occured", False, has_error)
			assert_equal ("create request triggered", create_request_code, last_request)
			assert_equal ("correct type name", "LIST [FOO]", last_type_name)
			assert_equal ("correct target variable name", "x", last_target_variable_name)
			assert_equal ("correct creation procedure name", "make_default", last_creation_procedure_name)
			assert_equal ("no arguments", 0, last_argument_list.count)
		end

	test_create_request_7 is
		do
			set_input ("create {TUPLE  [FOO ,  LIST  [ BAR ] ]} x.make_default")
			parse
			assert_equal ("no error occured", False, has_error)
			assert_equal ("create request triggered", create_request_code, last_request)
			assert_equal ("correct type name", "TUPLE [FOO, LIST [BAR]]", last_type_name)
			assert_equal ("correct target variable name", "x", last_target_variable_name)
			assert_equal ("correct creation procedure name", "make_default", last_creation_procedure_name)
			assert_equal ("no arguments", 0, last_argument_list.count)
		end

	test_create_request_8 is
		do
			set_input ("create {LINKED_LIST [INTEGER]} a_list")
			parse
			assert_equal ("error occured", False, has_error)
			assert_equal ("no request code", create_request_code, last_request)
		end

	test_create_request_9 is
		do
			set_input ("create {} foo.make")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

	test_create_request_10 is
		do
			set_input ("create a_string.make_empty")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

	test_create_request_11 is
		do
			set_input ("create {A} .foo.make ()")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

	test_create_request_12 is
		do
			set_input ("create")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

end
