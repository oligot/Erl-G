indexing

	description:

		"Test features for parsing invoke and assign requests of class ITP_REQUEST_PARSER"

	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_INVOKE_AND_ASSIGN_REQUEST_PARSING

inherit
	ERL_G_TEST_REQUEST_PARSER
	
feature -- Tests for invoke and assign requests

	test_invoke_and_assign_request_1 is
		do
			set_input ("a_var := foo.feat_name")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke and assign request triggered", invoke_and_assign_request_code, last_request)
			assert_equal ("correct left-hand variable name", "a_var", last_left_hand_variable_name)
			assert_equal ("correct target variable name", "foo", last_target_variable_name)
			assert_equal ("correct feature name", "feat_name", last_feature_name)
			assert_equal ("no arguments", 0, last_argument_list.count)
		end
		
	test_invoke_and_assign_request_2 is
		local
			a_char: ITP_CHARACTER
		do
			set_input ("f1 := my_var.my_feature ('a')")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke and assign request triggered", invoke_and_assign_request_code, last_request)
			assert_equal ("correct left-hand variable name", "f1", last_left_hand_variable_name)
			assert_equal ("correct target variable name", "my_var", last_target_variable_name)
			assert_equal ("correct feature name", "my_feature", last_feature_name)
			assert_equal ("one argument", 1, last_argument_list.count)
			a_char ?= last_argument_list.item (1)
			assert ("correct argument type", a_char /= Void)
			assert_equal ("correct argument value", 'a', a_char.value)
		end
		
	test_invoke_and_assign_request_3 is
		local
			a_double: ITP_DOUBLE
			an_int_8: ITP_INTEGER_8
		do
			set_input ("f1 := my_var.my_feature (1.2, {INTEGER_8} 10)")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke and assign request triggered", invoke_and_assign_request_code, last_request)
			assert_equal ("correct left-hand variable name", "f1", last_left_hand_variable_name)
			assert_equal ("correct target variable name", "my_var", last_target_variable_name)
			assert_equal ("correct feature name", "my_feature", last_feature_name)
			assert_equal ("two arguments", 2, last_argument_list.count)
			a_double ?= last_argument_list.item (1)
			assert ("correct argument 1 type", a_double /= Void)
			assert_equal ("correct argument 1 value", 1.2, a_double.value)
			an_int_8 ?= last_argument_list.item (2)
			assert ("correct argument 2 type", an_int_8 /= Void)
			assert_equal ("correct argument 2 value", {INTEGER_8} 10, an_int_8.value)
		end
		
	test_invoke_and_assign_request_4 is
		do
			set_input ("x := a .b")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke and assign request triggered", invoke_and_assign_request_code, last_request)
			assert_equal ("correct left-hand variable name", "x", last_left_hand_variable_name)
			assert_equal ("correct target variable name", "a", last_target_variable_name)
			assert_equal ("correct feature name", "b", last_feature_name)
			assert_equal ("no arguments", 0, last_argument_list.count)
		end
		
	test_invoke_and_assign_request_5 is
		do
			set_input ("x := a. b")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke and assign request triggered", invoke_and_assign_request_code, last_request)
			assert_equal ("correct left-hand variable name", "x", last_left_hand_variable_name)
			assert_equal ("correct target variable name", "a", last_target_variable_name)
			assert_equal ("correct feature name", "b", last_feature_name)
			assert_equal ("no arguments", 0, last_argument_list.count)
		end
		
	test_invoke_and_assign_request_6 is
		do
			set_input ("x := a . b")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke and assign request triggered", invoke_and_assign_request_code, last_request)
			assert_equal ("correct left-hand variable name", "x", last_left_hand_variable_name)
			assert_equal ("correct target variable name", "a", last_target_variable_name)
			assert_equal ("correct feature name", "b", last_feature_name)
			assert_equal ("no arguments", 0, last_argument_list.count)
		end
		
	test_invoke_and_assign_request_7 is
		do
			set_input (" := a_var.a_feat")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
		
	test_invoke_and_assign_request_8 is
		do
			set_input ("a_var := a_var.a_feat ()")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
		
	test_invoke_and_assign_request_9 is
		do
			set_input ("1 := a_var.a_feat")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
		
	test_invoke_and_assign_request_10 is
		do
			set_input ("a_var := a_feat (1)")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
		
	test_invoke_and_assign_request_11 is
		do
			set_input ("a_var := a_var a_feat (1)")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
		
	test_invoke_and_assign_request_12 is
		do
			set_input ("a_var := .a_feat")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
		
	test_invoke_and_assign_request_13 is
		do
			set_input ("a_var := a_var.a_feat (1, )")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
		
	test_invoke_and_assign_request_14 is
		do
			set_input ("x := y.f (3*])")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
end
