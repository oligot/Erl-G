indexing

	description	: "GERL implementation for ERL_ROUTINE"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_ROUTINE_IMP

inherit

	ERL_ROUTINE

	ERL_FEATURE_IMP
	
	INTERNAL
		export {NONE} all end

feature -- Access

	formal_arguments: ERL_LIST [ERL_ARGUMENT]

	empty_arguments: TUPLE is
		do
			Result ?= new_instance_of (dynamic_type_from_string (argument_tuple_name))
		end

feature -- Status Report

	valid_operands (a_target: ANY; a_arguments: TUPLE): BOOLEAN is
			-- Are `a_target' and `a_operands' valid operands?
		do
			Result := operands (a_target, a_arguments) /= Void
		ensure then
			definition: Result = (operands (a_target, a_arguments) /= Void)
			valid_for_agent: Result implies routine.valid_operands (operands (a_target, a_arguments))
		end

feature -- Basic Operations

	apply (a_target: ANY; a_arguments: TUPLE)is
			-- Call routine with operands `operands'.
		do
			routine.call (operands (a_target, a_arguments))
		end

feature {NONE} -- Implementation

	routine: ROUTINE [ANY, TUPLE] is
			-- Routine
		deferred
		end

	operands (a_target: ANY; an_arguments: TUPLE): TUPLE is
			-- Tuple containing `a_target' and the items of `a_arguments' or
			-- `Void' if there is a type mismatch
		require
			a_target_not_void: a_target /= Void
			an_arguments_not_void: an_arguments /= Void
			an_arguments_count_valid: an_arguments.count = formal_arguments.count
		local
			i: INTEGER
		do
			Result := routine.operands.twin
			if 
				not Result.valid_type_for_index (a_target, 1)
			then
				Result := Void
			else
				Result.put (a_target, 1)
				from
					i := 1
				until
					i > an_arguments.count or Result = Void
				loop
					if Result.valid_type_for_index (an_arguments.item (i), i + 1) then
						Result.put (an_arguments.item (i), i + 1)
						i := i + 1
					else
						Result := Void
					end
				end
			end
		ensure
			operands_count_valid: Result /= Void implies Result.count = an_arguments.count + 1
			target_set: Result /= Void implies Result.item (1) = a_target
		end
		
	argument_tuple_name: STRING is
			-- Type name of argument tuple
		local
			i: INTEGER
		do
			if argument_tuple_name_cache = Void then
				create argument_tuple_name_cache.make (30)
				argument_tuple_name_cache.append_string ("TUPLE")
				if formal_arguments.count > 0 then
					argument_tuple_name_cache.append_string (" [")
					from
						i := 1
					until
						i > formal_arguments.count
					loop
						argument_tuple_name_cache.append_string (formal_arguments.item (i).type.name)
						i := i + 1
						if i <= formal_arguments.count then
							argument_tuple_name_cache.append_string (", ")
						end
					end
					argument_tuple_name_cache.append_string ("]")
				end
			end
			Result := argument_tuple_name_cache
		ensure
			name_not_void: Result /= Void
			name_not_empty: Result.count > 0
		end
	
	argument_tuple_name_cache: STRING

invariant

	routine_not_void: routine /= Void
	routine_argument_match: routine.empty_operands.count = formal_arguments.count + 1

end
