indexing

	description    : "Dummy Universe to make compiler happy if no generated universe class exists."
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_UNIVERSE_IMP

inherit

	ERL_UNIVERSE

create

	make

feature {NONE} -- Implementation

	class_by_name (a_name: STRING): ERL_CLASS is
		do
			-- Empty
		end

end
