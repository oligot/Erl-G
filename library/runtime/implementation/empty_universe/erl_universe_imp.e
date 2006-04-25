indexing

	description    : "Dummy Universe to make compiler happy if no generated universe class exists."
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_UNIVERSE_IMP

inherit

	ERL_ABSTRACT_UNIVERSE_IMP
		redefine
			type_count,
			type
		end

create

	make

feature {NONE} -- Implementation

	type_count: INTEGER is 0

	type (an_index: INTEGER): ERL_TYPE is
		do
			-- Empty
		end

	type_by_name (a_name: STRING): ERL_TYPE is
		do
			-- Empty
		end

end
