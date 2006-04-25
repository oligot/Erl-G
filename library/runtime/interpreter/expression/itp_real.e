indexing
	description: "[
		Objects representing REAL constants.
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ITP_REAL

inherit

	ITP_CONSTANT

create

	make

feature {NONE} -- Initialization

	make (a_value: like value) is
			-- Create new constant.
		do
			value := a_value
		end

feature -- Access

	value: REAL
		-- Value

	type_name: STRING is "REAL"

feature -- Processing

	process (a_processor: ITP_EXPRESSION_PROCESSOR) is
		do
			a_processor.process_real (Current)
		end

end