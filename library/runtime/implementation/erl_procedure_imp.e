indexing

	description	: "GERL implementation for ERL_PROCEDURE"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"



class ERL_PROCEDURE_IMP

inherit

	ERL_PROCEDURE

	ERL_ROUTINE_IMP
		rename
			routine as procedure
		redefine
			procedure
		end

create

	make

feature {NONE} -- Initializaztion

	make (a_name: like name;
			a_formal_arguments: like formal_arguments;
			a_type: like type;
			a_procedure: like procedure) is
			-- Create new procedure.
		require
			a_name_not_void: a_name /= Void
			a_formal_arguments_not_void: a_formal_arguments /= Void
			a_type_not_void: a_type /= Void
			a_procedure_not_void: a_procedure /= Void
			argument_match: a_formal_arguments.count + 1 = a_procedure.empty_operands.count 
		do
			name := a_name
			formal_arguments := a_formal_arguments
			type := a_type
			procedure := a_procedure
		ensure then
			name_set: name = a_name
			formal_arguments_set: formal_arguments = a_formal_arguments
			type_set: a_type = type
			procedure_set: procedure = a_procedure
		end

feature {NONE} -- Implementation

	procedure: PROCEDURE [ANY, TUPLE]
			-- Procedure

end
