indexing
	description: "[
		Objects representing the references.
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ITP_REFERENCE

inherit
	
	ITP_CONSTANT
	
	ERL_SHARED_UNIVERSE
		export {NONE} all end
	
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
	
	value: ANY
		-- Type of constant

	type_name: STRING is
		do
			Result := universe.type_by_object (value).name
		end

feature -- Processing

	process (a_processor: ITP_EXPRESSION_PROCESSOR) is
		do
			a_processor.process_reference (Current)
		end

end