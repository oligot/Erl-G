indexing
	description: "Objects that declare default_create in their `create' clause"
	author: "Ilinca Ciupa"
	date: "$31.08.2005$"
	revision: "$1.0$"

class DEFAULT_CREATABLE_2

create

	default_create

feature -- Status

	an_int: INTEGER
		-- An integer attribute
		
	a_ref: ANY
		-- A reference type attribute

end

