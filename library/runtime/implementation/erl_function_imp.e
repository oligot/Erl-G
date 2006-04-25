indexing

	description	: "GERL implementation for ERL_FUNCTION"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_FUNCTION_IMP

inherit

	ERL_FUNCTION
		rename
			apply as retrieve_value
		end

	ERL_QUERY_IMP

	ERL_ROUTINE_IMP
		rename
			routine as function,
			apply as retrieve_value
		redefine
			function,
			retrieve_value
		end

	ERL_SHARED_UNIVERSE
		export {NONE} all end

create

	make

feature {NONE} -- Initialize

	make (a_name: like name;
			a_formal_arguments: like formal_arguments;
			a_type: like type;
			a_function: like function;
			a_result_type: like result_type) is
			-- Create new function.
		require
			a_name_not_void: a_name /= Void
			a_formal_arguments_not_void: a_formal_arguments /= Void
			a_type_not_void: a_type /= Void
			a_result_type_not_void: a_result_type /= Void
			a_function_not_void: a_function /= Void
			argument_match: a_formal_arguments.count + 1 = a_function.empty_operands.count
		do
			name := a_name
			formal_arguments := a_formal_arguments
			type := a_type
			function := a_function
			result_type := a_result_type
		ensure then
			name_set: name = a_name
			formal_arguments_set: formal_arguments = a_formal_arguments
			type_set: type = a_type
			function_set: function = a_function
			result_type_set: result_type = a_result_type
		end

feature -- Access

	result_type: ERL_TYPE

	last_result: ANY

feature -- Basic Operations

	retrieve_value (a_target: ANY; a_arguments: TUPLE) is
			-- Call function and store it in `last_result'.
		do
			Precursor {ERL_ROUTINE_IMP} (a_target, a_arguments)
			last_result := function.last_result
		end

feature {NONE} -- Implementation

	function: FUNCTION [ANY, TUPLE, ANY]
			-- Function

end
