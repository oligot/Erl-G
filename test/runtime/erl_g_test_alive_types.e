indexing

	description:

		"Test features of Erl-G on class HASH_TABLE [ANY, STRING]"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_ALIVE_TYPES

inherit

	TS_TEST_CASE

	ERL_SHARED_UNIVERSE
		export {NONE} all end


feature -- Test reflection on generated system

	test_1 is
			-- Test that attributes of a reflectable class are reflectable too.
		do
			assert_not_equal ("CLIENT_A_1 alive", Void, universe.type_by_name ("CLIENT_A_1"))
			assert_not_equal ("CLIENT_B_1 alive", Void, universe.type_by_name ("CLIENT_B_1"))
			assert_not_equal ("CLIENT_C_1 alive", Void, universe.type_by_name ("CLIENT_C_1"))
		end

	test_2 is
			-- Test that attributes of a reflectable class are reflectable too.
			-- The attributes are never attached.
		do
			assert_not_equal ("CLIENT_A_2 alive", Void, universe.type_by_name ("CLIENT_A_2"))
			assert_not_equal ("CLIENT_B_2 alive", Void, universe.type_by_name ("CLIENT_B_2"))
			assert_not_equal ("CLIENT_C_2 alive", Void, universe.type_by_name ("CLIENT_C_2"))
		end

	test_3 is
			-- Test that attributes of a reflectable class are reflectable too.
			-- Classes are generic.
		do
			assert_not_equal ("CLIENT_A_3 alive", Void, universe.type_by_name ("CLIENT_A_3"))
			assert_not_equal ("CLIENT_B_3 alive", Void, universe.type_by_name ("CLIENT_B_3"))
			assert_not_equal ("CLIENT_C_3 alive", Void, universe.type_by_name ("CLIENT_C_3"))
		end

end
