indexing

	description	: "Shared access to GERL universe singleton"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_SHARED_UNIVERSE

feature -- Access

	universe: ERL_UNIVERSE is
			-- Universe singleton
		once
			create {ERL_UNIVERSE_IMP} Result.make
		ensure
			universe_not_void: Result /= Void
		end

end
