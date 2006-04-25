indexing

	description:

		"Test features of Erl-G on class INTEGER"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Ilinca Ciupa and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_INTEGER

inherit

	TS_TEST_CASE

	ERL_SHARED_UNIVERSE
		export {NONE} all end

feature -- Test reflection on generated system

	test_type_information is
			-- Check that type information is retrieved correctly.
		local
			integer_type: ERL_TYPE
		do
			integer_type := universe.type_by_name ("INTEGER")

				-- Check type characteristics and counts.
			assert ("expanded type", integer_type.is_expanded)
			assert ("basic type", integer_type.is_basic_type)
			assert_equal ("correct creation procedure count", 0, integer_type.creation_procedure_count)
		end

end
