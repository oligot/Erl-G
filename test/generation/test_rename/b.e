class TEST_RENAME_B

inherit
	TEST_RENAME_A
		rename
			c as d
		redefine
			d,
			default_create
		end

feature

	default_create is
		do
			create d
		end


	d: TEST_RENAME_D

end
