indexing

	description:

		"Test features of Erl-G on class NONE"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_NONE

inherit

	TS_TEST_CASE

	ERL_SHARED_UNIVERSE
		export {NONE} all end

feature -- Test reflection on generated system

	test_type_information is
			-- Check that type information is retrieved correctly.
		local
			none_type: ERL_TYPE
		do
			none_type := universe.type_by_object (Void)
			assert_equal ("type name correct", "NONE", none_type.name)
			assert_equal ("correct creation procedure count", 0, none_type.creation_procedure_count)
		end

end
