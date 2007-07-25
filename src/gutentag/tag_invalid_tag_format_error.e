indexing

	description:

		"Error: Illegal tag format"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class TAG_INVALID_TAG_FORMAT_ERROR

inherit

	UT_ERROR
	TAG_SHARED_TAG_FORMAT_NAMES
		export {NONE} all end

creation

	make

feature {NONE} -- Initialization

	make (a_format: STRING) is
			-- Create a new error reporting that tag format
			-- `a_format' is invalid.
		require
			a_format_not_void: a_format /= Void
		do
			create parameters.make (1, 3)
			parameters.put (a_format, 1)
			parameters.put (formats.emacs_name, 2)
			parameters.put (formats.vi_name, 3)
		end

feature -- Access

	default_template: STRING is "$0: '$1' is not a valid tag format. (Use either '$2' or '$3')"
			-- Default template used to built the error message

	code: STRING is "UT0004"
			-- Error code

invariant

	-- dollar0: $0 = program name
	-- dollar1: $1 = tag format name

end
