indexing

	description	: "Singeleton access to ERL_DEBUG_MODE"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_SHARED_DEBUG_MODE

feature -- Access

	debug_mode: ERL_DEBUG_MODE is
			-- Debug mode singleton
		once
			create Result.make
		ensure
			debug_mode_not_void: debug_mode /= Void
		end

end
