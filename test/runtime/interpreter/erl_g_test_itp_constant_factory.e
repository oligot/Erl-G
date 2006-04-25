indexing

	description:

		"Test features of class ITP_CONSTANT_FACTORY"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/09/15 12:08:12 $"
	revision: "$Revision: 1.1 $"

deferred class ERL_G_TEST_ITP_CONSTANT_FACTORY

inherit

	TS_TEST_CASE
	
	ERL_SHARED_UNIVERSE
		export {NONE} all end
		
feature -- Test cases

	test_constant_creation is
			-- Test routine `new_constant' of class ITP_CONSTANT_FACTORY.
		local
			cf: ITP_CONSTANT_FACTORY
			a_type: ERL_TYPE
			a_bool_ref: BOOLEAN_REF
			a_double_ref: DOUBLE_REF
			an_int_ref: INTEGER_REF
			a_nat_ref: NATURAL_8_REF
			a_pointer_ref: POINTER_REF
			a_real_ref: REAL_REF
			s: STRING
			a_ct: ITP_CONSTANT
			a_itp_bool: ITP_BOOLEAN
			a_itp_double: ITP_DOUBLE
			a_itp_int: ITP_INTEGER
			a_itp_nat_8: ITP_NATURAL_8
			a_itp_pointer: ITP_POINTER
			a_itp_real: ITP_REAL
			a_itp_ref: ITP_REFERENCE
			p: POINTER
		do
			cf := (create {ITP_SHARED_CONSTANT_FACTORY}).constant_factory
			
				-- Test creation of boolean constants.
			a_type := universe.type_by_name ("BOOLEAN")
			assert_not_equal ("BOOLEAN type found", Void, a_type)
			create a_bool_ref
			a_bool_ref.set_item (True)
			a_ct := cf.new_constant (a_bool_ref, a_type)
			assert_not_equal ("boolean constant created", Void, a_ct)
			a_itp_bool ?= a_ct
			assert_not_equal ("correct boolean constant type", Void, a_itp_bool)
			assert_equal ("correct boolean constant value", True, a_itp_bool.value)
			
				-- Test creation of double constants.
			a_type := universe.type_by_name ("DOUBLE")
			assert_not_equal ("DOUBLE type found", Void, a_type)
			create a_double_ref
			a_double_ref.set_item (1.2345)
			a_ct := cf.new_constant (a_double_ref, a_type)
			assert_not_equal ("double constant created", Void, a_ct)
			a_itp_double ?= a_ct
			assert_not_equal ("correct double constant type", Void, a_itp_double)
			assert_equal ("correct double constant value", 1.2345, a_itp_double.value)
			
				-- Test creation of integer constants.
			a_type := universe.type_by_name ("INTEGER")
			assert_not_equal ("INTEGER type found", Void, a_type)
			create an_int_ref
			an_int_ref.set_item (100)
			a_ct := cf.new_constant (an_int_ref, a_type)
			assert_not_equal ("integer constant created", Void, a_ct)
			a_itp_int ?= a_ct
			assert_not_equal ("correct integer constant type", Void, a_itp_int)
			assert_equal ("correct integer constant value", 100, a_itp_int.value)
			
				-- Test creation of natural_8 constants.
			a_type := universe.type_by_name ("NATURAL_8")
			assert_not_equal ("NATURAL_8 type found", Void, a_type)
			create a_nat_ref
			a_nat_ref.set_item (7)
			a_ct := cf.new_constant (a_nat_ref, a_type)
			assert_not_equal ("natural_8 constant created", Void, a_ct)
			a_itp_nat_8 ?= a_ct
			assert_not_equal ("correct natural_8 constant type", Void, a_itp_nat_8)
			assert_equal ("correct natural_8 constant value", {NATURAL_8} 7, a_itp_nat_8.value)
			
				-- Test creation of pointer constants.
			a_type := universe.type_by_name ("POINTER")
			assert_not_equal ("POINTER type found", Void, a_type)
			create a_pointer_ref
			create p
			a_pointer_ref.set_item (p)
			a_ct := cf.new_constant (a_pointer_ref, a_type)
			assert_not_equal ("pointer constant created", Void, a_ct)
			a_itp_pointer ?= a_ct
			assert_not_equal ("correct pointer constant type", Void, a_itp_pointer)
			assert_equal ("correct pointer constant value", p, a_itp_pointer.value)
			
				-- Test creation of real constants.
			a_type := universe.type_by_name ("REAL")
			assert_not_equal ("REAL type found", Void, a_type)
			create a_real_ref
			a_real_ref.set_item (-4.056)
			a_ct := cf.new_constant (a_real_ref, a_type)
			assert_not_equal ("real constant created", Void, a_ct)
			a_itp_real ?= a_ct
			assert_not_equal ("correct real constant type", Void, a_itp_real)
			assert_equal ("correct real constant value", {REAL} -4.056, a_itp_real.value)
			
				-- Test creation of reference constants.
			a_type := universe.type_by_name ("STRING")
			assert_not_equal ("STRING type found", Void, a_type)
			s := "abc"
			a_ct := cf.new_constant (s, a_type)
			assert_not_equal ("string constant created", Void, a_ct)
			a_itp_ref ?= a_ct
			assert_not_equal ("correct reference constant type", Void, a_itp_ref)
			assert_equal ("correct real constant value", "abc", a_itp_ref.value)
		end

end
