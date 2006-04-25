indexing
	description: "Second client class of liveness test 3"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class CLIENT_B_3 [G]

inherit

	ANY
		redefine
			default_create
		end

feature

	default_create is
		do
			create client_c
		end

	client_c: CLIENT_C_3 [G, G]

end
