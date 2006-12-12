indexing
	description: "[
		Objects representing variables.
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ITP_VARIABLE

inherit

	ITP_EXPRESSION

	HASHABLE

create

	make

feature {NONE} -- Initialization

	make (a_name: like name) is
			-- Create new variable.
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		do
			name := a_name
		ensure
			name_set: name = a_name
		end

feature -- Access

	name: STRING
			-- Name of variable

	hash_code: INTEGER is
		do
			Result := name.hash_code
		end

feature -- Processing

	process (a_processor: ITP_EXPRESSION_PROCESSOR) is
		do
			a_processor.process_variable (Current)
		end

end
