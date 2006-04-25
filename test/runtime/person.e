indexing

	description:

		"Objects holding information about persons"

	copyright: "Copyright (c) 2004-2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class PERSON

create

	make

feature -- Execution

	make (a_name: like name; an_age: like age) is
			-- Create new person with name `a_name' and age `an_age'.
		require
			a_name_not_void: a_name /= Void
			an_age_positive: an_age >= 0
		do
			name := a_name
			age := an_age
		ensure
			name_set: name = a_name
			age_set: age = an_age
		end

feature -- Access

	name: STRING
			-- First and last name

	age: INTEGER
			-- Age in years

feature -- Change

	set_name (a_name: like name) is
			-- Set `name' to `a_name'.
		require
			a_name_not_void: a_name /= Void
		do
			name := a_name
		ensure
			name_set: name = a_name
		end

	set_age (an_age: like age) is
			-- Set `age' to `an_age'.
		require
			an_age_positive: an_age >= 0
		do
			age := an_age
		ensure
			age_set: age = an_age
		end
		
	set_to_me is
			-- Set attributes to make person represent me.
		do
			name := "Andreas Leitner"
			age := 28
		end
		
feature -- Status report

	is_of_age: BOOLEAN is
			-- Is this person over 18 years old?
		do
			Result := (age >= 18)
		ensure
			definition: Result = (age >= 18)
		end

invariant

	name_not_void: name /= Void
	age_positive: age >= 0

end
