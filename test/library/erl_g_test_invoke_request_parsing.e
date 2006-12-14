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
			a_var: ITP_VARIABLE
		do
			set_input ("a_var.feat_name (arg1)")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke request triggered", invoke_request_code, last_request)
			assert_equal ("correct target variable name", "a_var", last_target_variable_name)
			assert_equal ("correct feature name", "feat_name", last_feature_name)
			assert_equal ("one argument", 1, last_argument_list.count)
			a_var ?= last_argument_list.item (1)
			assert_not_equal ("argument not void", Void, a_var)
			assert_equal ("correct argument", "arg1", a_var.name)
		end

	test_invoke_request_3 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("z1.a_feature (True, Void)")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke request triggered", invoke_request_code, last_request)
			assert_equal ("correct target variable name", "z1", last_target_variable_name)
			assert_equal ("correct feature name", "a_feature", last_feature_name)
			assert_equal ("two arguments", 2, last_argument_list.count)
			a_const ?= last_argument_list.item (1)
			assert_not_equal ("argument 1 not void", Void, a_const)
			assert_equal ("correct argument 1", True, a_const.value)
			a_const ?= last_argument_list.item (2)
			assert_not_equal ("argument 2 not void", Void, a_const)
			assert_equal ("correct argument 2", Void, a_const.value)
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

	test_invoke_request_8 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("v_2.character_justify ({CHARACTER_8}'%%/161/', 5)")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke request triggered", invoke_request_code, last_request)
			assert_equal ("correct target variable name", "v_2", last_target_variable_name)
			assert_equal ("correct feature name", "character_justify", last_feature_name)
			assert_equal ("two arguments", 2, last_argument_list.count)
			a_const ?= last_argument_list.item (1)
			assert_not_equal ("argument 1 not void", Void, a_const)
			assert_equal ("correct argument 1", '%/161/', a_const.value)
			a_const ?= last_argument_list.item (2)
			assert_not_equal ("argument 2 not void", Void, a_const)
			assert_equal ("correct argument 2", 5, a_const.value)
		end

	test_invoke_request_9 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("a3.character_justify ({CHARACTER_8}'%%/61/', 4)")
			parse
			assert_equal ("no error occurred", False, has_error)
			assert_equal ("invoke request triggered", invoke_request_code, last_request)
			assert_equal ("correct target variable name", "a3", last_target_variable_name)
			assert_equal ("correct feature name", "character_justify", last_feature_name)
			assert_equal ("two arguments", 2, last_argument_list.count)
			a_const ?= last_argument_list.item (1)
			assert_not_equal ("argument 1 not void", Void, a_const)
			assert_equal ("correct argument 1", '%/61/', a_const.value)
			a_const ?= last_argument_list.item (2)
			assert_not_equal ("argument 2 not void", Void, a_const)
			assert_equal ("correct argument 2", 4, a_const.value)
		end

end
