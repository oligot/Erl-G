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
			an_int: ITP_INTEGER
		do
			set_input ("123")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			an_int ?= last_expression
			assert ("correct type", an_int /= Void)
			assert_equal ("correct value", 123, an_int.value)
		end
		
	test_parse_integer_constant_2 is
		local
			an_int: ITP_INTEGER
		do
			set_input ("-5")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			an_int ?= last_expression
			assert ("correct type", an_int /= Void)
			assert_equal ("correct value", -5, an_int.value)
		end
		
	test_parse_integer_constant_3 is
		local
			an_int: ITP_INTEGER
		do
			set_input ("- 11")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			an_int ?= last_expression
			assert ("correct type", an_int /= Void)
			assert_equal ("correct value", -11, an_int.value)
		end
		
	test_parse_integer_8_constant is
		local
			an_int_8: ITP_INTEGER_8
		do
			set_input ("{INTEGER_8}- 11")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			an_int_8 ?= last_expression
			assert ("correct type", an_int_8 /= Void)
			assert_equal ("correct value", {INTEGER_8} -11, an_int_8.value)
		end
		
	test_parse_double_constant_1 is
		local
			a_double: ITP_DOUBLE
		do
			set_input ("1.02")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_double ?= last_expression
			assert ("correct type", a_double /= Void)
			assert_equal ("correct value", 1.02, a_double.value)
		end
		
	test_parse_double_constant_2 is
		local
			a_double: ITP_DOUBLE
		do
			set_input ("-12.3")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_double ?= last_expression
			assert ("correct type", a_double /= Void)
			assert_equal ("correct value", -12.3, a_double.value)
		end
		
	test_parse_double_constant_3 is
		local
			a_double: ITP_DOUBLE
		do
			set_input ("- 12.3")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_double ?= last_expression
			assert ("correct type", a_double /= Void)
			assert_equal ("correct value", -12.3, a_double.value)
		end
		
	test_parse_double_constant_4 is
		local
			a_double: ITP_DOUBLE
		do
			set_input (".345")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_double ?= last_expression
			assert ("correct type", a_double /= Void)
			assert_equal ("correct value", .345, a_double.value)
		end
		
	test_parse_double_constant_5 is
		local
			a_double: ITP_DOUBLE
		do
			set_input ("1.")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_double ?= last_expression
			assert ("correct type", a_double /= Void)
			assert_equal ("correct value", 1., a_double.value)
		end
		
	test_parse_real_constant is
		local
			a_real: ITP_REAL
		do
			set_input ("{REAL} 1.23456")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_real ?= last_expression
			assert ("correct type", a_real /= Void)
			assert_equal ("correct value", {REAL} 1.23456, a_real.value)
		end
		
	test_parse_natural_64_constant is
		local
			a_natural: ITP_NATURAL_64
		do
			set_input ("{NATURAL_64} 123456789")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_natural ?= last_expression
			assert ("correct type", a_natural /= Void)
			assert_equal ("correct value", {NATURAL_64} 123456789, a_natural.value)
		end
		
	test_parse_boolean_constant_1 is
		local
			a_bool: ITP_BOOLEAN
		do
			set_input ("True")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_bool ?= last_expression
			assert ("correct type", a_bool /= Void)
			assert_equal ("correct value", True, a_bool.value)
		end
		
	test_parse_boolean_constant_2 is
		local
			a_bool: ITP_BOOLEAN
		do
			set_input ("False")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_bool ?= last_expression
			assert ("correct type", a_bool /= Void)
			assert_equal ("correct value", False, a_bool.value)
		end
		
	test_parse_character_constant_1 is
		local
			a_char: ITP_CHARACTER
		do
			set_input ("'a'")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_char ?= last_expression
			assert ("correct type", a_char /= Void)
			assert_equal ("correct value", 'a', a_char.value)
		end
		
	test_parse_character_constant_2 is
		local
			a_char: ITP_CHARACTER
		do
			set_input ("'%N'")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_char ?= last_expression
			assert ("correct type", a_char /= Void)
			assert_equal ("correct value", '%N', a_char.value)
		end
		
	test_parse_character_constant_3 is
		local
			a_char: ITP_CHARACTER
		do
			set_input ("%'%%%%%'")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_char ?= last_expression
			assert ("correct type", a_char /= Void)
			assert_equal ("correct value", '%%', a_char.value)
		end
		
	test_parse_character_constant_4 is
		do
			set_input ("'abc'")
			parse_expression
			assert_equal ("error occurred", True, has_error)
		end
		
	test_parse_void_constant is
		local
			a_reference: ITP_REFERENCE
		do
			set_input ("Void")
			parse_expression
			assert_equal ("no error occurred", False, has_error)
			a_reference ?= last_expression
			assert ("correct type", a_reference /= Void)
			assert ("correct value", a_reference.value = Void)
		end


end
