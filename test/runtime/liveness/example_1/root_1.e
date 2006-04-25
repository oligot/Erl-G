indexing
	description: "Root class of liveness test 1"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ROOT_1

create

	make

feature

	make is
		do
			create client_a
			create client_b
		end

	client_a: CLIENT_A_1

	client_b: CLIENT_B_1

end
