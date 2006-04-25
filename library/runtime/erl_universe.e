indexing

	description	: "Reflectable Eiffel Universe. Access it using ERL_G_SHARED_UNIVERSE."
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_UNIVERSE

feature -- Status report

	type_count: INTEGER is
			-- Number of reflectable types
		deferred
		ensure
			type_count_positive: Result >= 0
		end

feature -- Access

	type (an_index: INTEGER): ERL_TYPE is
			-- Type at index `an_index'
		require
			valid_index: an_index > 0 and an_index <= type_count
		deferred
		ensure
			type_not_void: Result /= Void
		end

	type_by_name (a_name: STRING): ERL_TYPE is
			-- Type with name `a_name', or `Void' if no such type or type is not
			-- reflectable
		require
			a_name_not_void: a_name /= Void
		deferred
		end

	type_by_object (an_object: ANY): ERL_TYPE is
			-- Type for object `an_object'
		deferred
		end

end
