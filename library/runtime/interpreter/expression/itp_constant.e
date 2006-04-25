indexing
	description: "[
		Common ancestor for objects representing constants.
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

deferred class ITP_CONSTANT

inherit
	
	ITP_EXPRESSION

feature -- Access

	type_name: STRING is
			-- Type name of constant
		deferred
		ensure
			Result_not_void: Result /= Void
			Result_not_empty: not Result.is_empty
		end

end