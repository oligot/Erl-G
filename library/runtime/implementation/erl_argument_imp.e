indexing

	description	: "GERL implementation for ERL_ARGUMENT"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_ARGUMENT_IMP

inherit

	ERL_ARGUMENT

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING; a_type: ERL_TYPE) is
			-- Create new argument with name `a_name', type `a_type'.
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
			a_type_not_void: a_type /= Void
		do
			name := a_name
			type := a_type
		ensure
			name_set: name = a_name
			type_set: type = a_type
		end

feature -- Access

	name: STRING
			-- Name of argument

	type: ERL_TYPE
			-- Type of argument

	end
