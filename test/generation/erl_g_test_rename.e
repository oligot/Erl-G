indexing

	description:

		"Test whether renamed features are reflected properly"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2007, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_RENAME

inherit

	TS_TEST_CASE

	ERL_SHARED_UNIVERSE
		export {NONE} all end

feature -- Execution

	test_redefined_renamed_attribute is
			-- Test whether an attribute that has been renamed and
			-- covariantly redefined is properly reflected.
		local
			r: ERL_CLASS
			a: ANY
		do
			r := universe.class_by_name ("B")
			r.invoke_creation_procedure ("", Void, <<>>)
			a := r.last_result
			r.invoke_query ("d", a, <<>>)
			assert_strings_equal ("type correct", "D", r.last_result.generating_type)
		end

end
