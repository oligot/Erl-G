indexing

	description:

		"Shared tag file format names"

	copyright: "Copyright (c) 2005, Andreas Leitner"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class TAG_SHARED_TAG_FORMAT_NAMES

feature -- Access

	formats: TAG_FORMAT_NAMES is
			-- Format names
		once
			create Result
		ensure
			formats_not_void: Result /= Void
		end

end
