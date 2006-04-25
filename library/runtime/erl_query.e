indexing

	description	: "Objects that represent an Eiffel query"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_QUERY

inherit

	ERL_FEATURE

feature -- Access

	result_type: ERL_TYPE is
			-- Result type of query
		deferred
		ensure
			result_type_not_void: Result /= Void
		end

	last_result: ANY is
			-- Result of last query execution
		deferred
		end

feature -- Basic Operations

	retrieve_value (a_target: ANY; a_arguments: TUPLE)is
			-- Retrieve query result and store it in `last_result'.
		require
			a_target_not_void: a_target /= Void
			a_arguments_not_void: a_arguments /= Void
			valid_operands: valid_operands (a_target, a_arguments)
		deferred
		end

end
