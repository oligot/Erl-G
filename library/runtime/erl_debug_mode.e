indexing

	description: "[
		Test Wizard:
		Objects which control the interaction between EiffelStudio and its generated applications.
		Use ERL_SHARED_DEBUG_MODE to access this object as a singleton.
		]"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_DEBUG_MODE

create {ERL_SHARED_DEBUG_MODE}

	make

feature {NONE} -- Initialization

	make is
			-- Create new debug mode object.
		do
		end

feature -- Status

	is_enabled: BOOLEAN is
			-- Is debug mode enabled?
		external "C [macro <erl_debug_mode_macros.h>]: EIF_BOOLEAN"
		alias
			"is_debug_mode_enabled"
		end

feature -- Status Setting

	disable is
			-- Disable debug mode.
		external "C [macro <erl_debug_mode_macros.h>]"
		alias
			"disable_debug_mode"
		end

	enable is
			-- Enable debug mode.
		external "C [macro <erl_debug_mode_macros.h>]"
		alias
			"enable_debug_mode"
		end

end
