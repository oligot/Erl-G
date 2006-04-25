indexing

	description	: "Objects that represent an Eiffel attribute"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_ATTRIBUTE

inherit

	ERL_QUERY

feature -- Status report

	is_constant: BOOLEAN is
			-- Can value of attribute be changed at runtime?
		deferred
		end

feature -- Element change

	replace (a_target: ANY; a_value: ANY) is
			-- Replace value of this attribute to `a_value'.
		require
			writable: not is_constant
			target_not_void: a_target /= Void
			valid_target: valid_operands (a_target, [])
			a_value_exists: a_value /= Void
		deferred
		end

end
