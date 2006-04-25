indexing

	description	: "Objects that represent an Eiffel argument"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_ARGUMENT

feature -- Access

	name: STRING is
			-- Name of argument
		deferred
		ensure
    		name_not_void: Result /= Void
    		name_not_empty: not Result.is_empty
		end

	type: ERL_TYPE is
			-- Type of argument
		deferred
		end

end
