indexing

	description:

		"Universal class for pseudo kernel"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ANY

feature {NONE} -- Initialization

	default_create is
			-- Process instances of classes with no creation clause.
			-- (Default: do nothing.)
		do
		end
	
feature -- Basic operations

	copy (other: like Current) is
			-- Update current object using fields of object attached
			-- to `other', so as to yield equal objects.
		do
			
		end

end
