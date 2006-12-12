indexing

	description:

		"Test features for parsing constants of class ITP_REQUEST_PARSER"

	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_CONSTANT_PARSING

inherit
	ERL_G_TEST_REQUEST_PARSER

feature -- Tests for parsing constants

	test_parse_integer_constant_1 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("123")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", 123, a_const.value)
		end

	test_parse_integer_constant_2 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("-5")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", -5, a_const.value)
		end

	test_parse_integer_constant_3 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("- 11")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", -11, a_const.value)
		end

	test_parse_integer_8_constant is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("{INTEGER_8}- 11")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", {INTEGER_8} -11, a_const.value)
		end

	test_parse_double_constant_1 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("1.02")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", 1.02, a_const.value)
		end

	test_parse_double_constant_2 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("-12.3")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", -12.3, a_const.value)
		end

	test_parse_double_constant_3 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("- 12.3")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", -12.3, a_const.value)
		end

	test_parse_double_constant_4 is
		local
			a_const: ITP_CONSTANT
		do
			set_input (".345")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", .345, a_const.value)
		end

	test_parse_double_constant_5 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("1.")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", 1., a_const.value)
		end

	test_parse_real_constant is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("{REAL} 1.23456")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", {REAL} 1.23456, a_const.value)
		end

	test_parse_natural_64_constant is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("{NATURAL_64} 123456789")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", {NATURAL_64} 123456789, a_const.value)
		end

	test_parse_boolean_constant_1 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("True")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", True, a_const.value)
		end

	test_parse_boolean_constant_2 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("False")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", False, a_const.value)
		end

	test_parse_character_constant_1 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("'a'")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", 'a', a_const.value)
		end

	test_parse_character_constant_2 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("'%N'")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", '%N', a_const.value)
		end

	test_parse_character_constant_3 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("%'%%%%%'")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", '%%', a_const.value)
		end

	test_parse_character_constant_4 is
		do
			set_input ("'abc'")
			parse_expression
			assert_equal ("error occurred", True, has_error)
		end

	test_parse_character_constant_5 is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("'%/161/'")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert_equal ("correct value", '%/161/', a_const.value)
		end

	test_parse_void_constant is
		local
			a_const: ITP_CONSTANT
		do
			set_input ("Void")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_const ?= last_expression
			assert ("correct type", a_const /= Void)
			assert ("correct value", a_const.value = Void)
		end


end
