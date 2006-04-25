indexing

	description:

		"Test features for parsing invoke requests of class ITP_REQUEST_PARSER"

	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_INVOKE_REQUEST_PARSING

inherit
	ERL_G_TEST_REQUEST_PARSER
	
feature -- Tests for invoke requests

	test_invoke_request_1 is
		do
			set_input ("a_var.feat_name")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke request triggered", invoke_request_code, last_request)
			assert_equal ("correct target variable name", "a_var", last_target_variable_name)
			assert_equal ("correct feature name", "feat_name", last_feature_name)
			assert_equal ("no arguments", 0, last_argument_list.count)
		end
		
	test_invoke_request_2 is
		local
			a_variable: ITP_VARIABLE
		do
			set_input ("a_var.feat_name (arg1)")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke request triggered", invoke_request_code, last_request)
			assert_equal ("correct target variable name", "a_var", last_target_variable_name)
			assert_equal ("correct feature name", "feat_name", last_feature_name)
			assert_equal ("one argument", 1, last_argument_list.count)
			a_variable ?= last_argument_list.item (1)
			assert ("correct argument type", a_variable /= Void)
			assert_equal ("correct argument", "arg1", a_variable.name)
		end
		
	test_invoke_request_3 is
		local
			a_bool: ITP_BOOLEAN
			a_reference: ITP_REFERENCE
		do
			set_input ("z1.a_feature (True, Void)")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke request triggered", invoke_request_code, last_request)
			assert_equal ("correct target variable name", "z1", last_target_variable_name)
			assert_equal ("correct feature name", "a_feature", last_feature_name)
			assert_equal ("two arguments", 2, last_argument_list.count)
			a_bool ?= last_argument_list.item (1)
			assert ("correct argument 1 type", a_bool /= Void)
			assert_equal ("correct argument 1", True, a_bool.value)
			a_reference ?= last_argument_list.item (2)
			assert ("correct argument 2 type", a_reference /= Void)
			assert_equal ("correct argument 2", Void, a_reference.value)
		end
		
	test_invoke_request_4 is
		do
			set_input ("z1.a_feat ()")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
		
	test_invoke_request_5 is
		do
			set_input ("a_feat (1)")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
		
	test_invoke_request_6 is
		do
			set_input (".a_feat (1)")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
		
	test_invoke_request_7 is
		do
			set_input ("1.a_feat")
			parse
			assert_equal ("error occured", True, has_error)
			assert_equal ("no request code", no_request_code, last_request)
		end
end
