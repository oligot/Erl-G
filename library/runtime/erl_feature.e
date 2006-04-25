indexing

	description	: "Objects that represent an Eiffel feature"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_FEATURE

feature -- Access

	name: STRING is
			-- Name of feature
		deferred
		ensure
			first_name_not_void: Result /= Void
		end

	type: ERL_TYPE is
			-- Type this feature belongs to
		deferred
		ensure
			type_not_void: Result /= Void
		end

	formal_arguments: ERL_LIST [ERL_ARGUMENT] is
			-- Formal arguments of this feature
		deferred
		ensure
			formal_arguments_not_void: Result /= Void
			formal_arguments_dont_contain_void: not Result.has (Void)
		end
	
	empty_arguments: TUPLE is
			-- Tuple conforming to the one expected by this routine
			-- with all items set to their default value
		deferred
		ensure
			arguments_exist: Result /= Void
		end

feature -- Status report

	valid_operands (a_target: ANY; a_arguments: TUPLE): BOOLEAN is
			-- Are `a_target' and `a_operands' valid operands?
		require
			a_target_not_void: a_target /= Void
			a_arguments_not_void: a_arguments /= Void
		deferred
		end

end
