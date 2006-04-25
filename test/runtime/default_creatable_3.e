indexing
	description: "Objects that declare default_create in their `create' clause but export it to NONE"
	author: "Ilinca Ciupa"
	date: "$31.08.2005$"
	revision: "$1.0$"

class DEFAULT_CREATABLE_3

create {NONE}

	default_create

feature -- Status

	an_int: INTEGER
		-- An integer attribute
		
	a_ref: ANY
		-- A reference type attribute

end
