indexing
	description: "[
		Objects representing DOUBLE constants.
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ITP_DOUBLE

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

	value: DOUBLE
		-- Value

	type_name: STRING is "DOUBLE"

feature -- Processing

	process (a_processor: ITP_EXPRESSION_PROCESSOR) is
		do
			a_processor.process_double (Current)
		end

end