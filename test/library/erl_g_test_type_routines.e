
indexing

	description:

		"Test features for ERL_G_TYPE_ROUTINES"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_TYPE_ROUTINES

inherit

	ERL_G_TYPE_ROUTINES
		export {NONE} all end

	ERL_G_UNIVERSE_TEST_CASE

feature -- Test generator

	test_base_type_1 is
			-- Test `base_type' function.
		local
			t: ET_GENERIC_CLASS_TYPE
		do
			t ?= base_type ("HASH_TABLE [ANY, STRING_8]", universe)
			assert_not_equal ("generic type", Void, t)
			assert_equal ("correct generic class name", "HASH_TABLE", t.direct_base_class (universe).name.name)
			assert_equal ("correct parameter count", 2, t.actual_parameters.count)
			assert_equal ("correct first parameter", universe.any_class , t.actual_parameters.actual_parameter (1).type.direct_base_class (universe))
			assert_equal ("correct second parameter", universe.string_class, t.actual_parameters.actual_parameter (2).type.direct_base_class (universe))
		end

	test_base_type_2 is
			-- Test `base_type' function.
		local
			t: ET_TUPLE_TYPE
		do
			t ?= base_type ("TUPLE [ANY, STRING_8]", universe)
			assert_not_equal ("generic type", Void, t)
			assert_equal ("correct generic class name", "TUPLE", t.direct_base_class (universe).name.name)
			assert_equal ("correct parameter count", 2, t.actual_parameters.count)
			assert_equal ("correct first parameter", universe.any_class , t.actual_parameters.actual_parameter (1).type.direct_base_class (universe))
			assert_equal ("correct second parameter", universe.string_class, t.actual_parameters.actual_parameter (2).type.direct_base_class (universe))
		end

end
