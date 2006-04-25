indexing

	description	: "Objects that represent an Eiffel creation procedure"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_CREATION_PROCEDURE

feature -- Status report

	is_default: BOOLEAN is
			-- Is default creation procedure?
		do
			Result := name = Void
		ensure
			definition: Result = (name = Void)
		end

feature -- Access

	name: STRING is
			-- Name of creation procedure
		deferred
		end

	formal_arguments: ERL_LIST [ERL_ARGUMENT] is
			-- Formal arguments of this creation procedure
		deferred
		ensure
			formal_arguments_not_void: Result /= Void
		end

	type: ERL_TYPE is
			-- Type of objects that this creation procedure creates
		deferred
		ensure
			type_not_void: Result /= Void
		end

	last_result: ANY is
			-- Last object created
		deferred
		end

	empty_arguments: TUPLE is
			-- Tuple conforming to the one expected by this routine
			-- with all items set to their default value
		deferred
		ensure
			arguments_exist: Result /= Void
		end

feature -- Status report

	valid_arguments (a_arguments: TUPLE): BOOLEAN is
			-- Are `a_operands' valid operands?
		require
			a_arguments_exist: a_arguments /= Void
		deferred
		end

feature -- Basic operations

	apply (a_arguments: TUPLE)is
			-- Call creation routine with operands `operands'.
		require
			a_arguments_exist: a_arguments /= Void
			a_arguments_valid: valid_arguments (a_arguments)
		deferred
		ensure
			last_result_not_void: last_result /= Void
		end
		
invariant

	default_has_no_arguments: is_default implies (formal_arguments.count = 0)

end
