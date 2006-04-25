indexing

	description	: "Objects that represent an Eiffel routine"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_ROUTINE

inherit

	ERL_FEATURE

feature -- Basic operations

	apply (a_target: ANY; a_arguments: TUPLE)is
			-- Call routine with target `a_target' and operands `operands'.
		require
			a_target_exists: a_target /= Void
			a_arguments_exist: a_arguments /= Void
			a_arguments_valid: valid_operands (a_target, a_arguments)
		deferred
		end

end
