indexing
	description: "Root class of liveness test 3"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ROOT_3 [G]

create

	make

feature

	make is
		do
			create client_a
			create client_b
		end

	client_a: CLIENT_A_3 [INTEGER]

	client_b: CLIENT_B_3 [G]

end
