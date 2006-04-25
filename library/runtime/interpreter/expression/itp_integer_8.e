indexing
	description: "[
		Objects representing INTEGER_8 constants.
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ITP_INTEGER_8

inherit
	
	ITP_CONSTANT
	
create

	make
	
feature {NONE} -- Initialization

	make (a_value: like value) is
			-- Create new constant.
		do
			value := a_value
		ensure
			value_set: value = a_value
		end
		
feature -- Access

	value: INTEGER_8
			-- Value

	type_name: STRING is "INTEGER_8"

feature -- Processing

	process (a_processor: ITP_EXPRESSION_PROCESSOR) is
		do
			a_processor.process_integer_8 (Current)
		end

end