indexing

	description:

		"Test features for parsing assign requests of class ITP_REQUEST_PARSER"

	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_ASSIGN_REQUEST_PARSING

inherit
	ERL_G_TEST_REQUEST_PARSER

feature -- Tests for assign requests

	test_assign_request_1 is
		do
			set_input ("bar := foo")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("assign request triggered", assign_request_code, last_request)
			assert_equal ("correct left-hand variable name", "bar", last_left_hand_variable_name)
			assert_not_equal ("correct expression type", Void, last_expression)
		end

	test_assign_request_2 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("bar := 2")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("assign request triggered", assign_request_code, last_request)
			assert_equal ("correct left-hand variable name", "bar", last_left_hand_variable_name)
			a_const ?= last_expression
			assert_equal ("correct expression", 2, a_const.value)
		end

	test_assign_request_3 is
		do
			set_input (" := a_var")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

	test_assign_request_4 is
		do
			set_input ("a_var := ")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

	test_assign_request_5 is
		do
			set_input ("1 := a_var")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

	test_assign_request_6 is
		do
			set_input ("Void := 1")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

	test_assign_request_7 is
		do
			set_input ("a_var = 1")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

	test_assign_request_8 is
		do
			set_input ("a_var : 1")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

	test_assign_request_9 is
		do
			set_input ("a_function (3) := a_var")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

	test_assign_request_10 is
		do
			set_input ("a_var := a_function (1)")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end

end
