indexing

	description:

		"Tag file format names"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class TAG_FORMAT_NAMES

inherit

	UC_SHARED_STRING_EQUALITY_TESTER

feature -- Status

	is_valid_name (a_name: STRING): BOOLEAN is
			-- Is `a_name' a valid format name?
		require
			a_name_not_void: a_name /= Void
		do
			Result := format_codes.has (a_name)
		end

	is_valid_code (a_code: INTEGER): BOOLEAN is
			-- Is `a_code' a valid format code?
		do
			Result := (a_code = emacs_code) or (a_code = vi_code)
		end

feature -- Format names

	emacs_name: STRING is "emacs"
	vi_name: STRING is "vi"

feature -- Format codes

	emacs_code: INTEGER is 1
	vi_code: INTEGER is 2

	format_codes: DS_HASH_TABLE [INTEGER, STRING] is
			-- Mapping format names -> format codes
		once
			create Result.make_map (2)
			Result.set_key_equality_tester (string_equality_tester)
			Result.put_new (emacs_code, emacs_name)
			Result.put_new (vi_code, vi_name)
		ensure
			format_code_not_void: Result /= Void
			no_void_format_name: not Result.has (Void)
		end

end
