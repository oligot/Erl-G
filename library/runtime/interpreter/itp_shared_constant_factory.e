indexing

	description	: "Singeleton access to ITP_CONSTANT_FACTORY"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ITP_SHARED_CONSTANT_FACTORY

feature -- Access

	constant_factory: ITP_CONSTANT_FACTORY is
			-- Singleton access to constant factory
		once
			create Result.make
		ensure
			factory_not_void: Result /= Void
		end

end
