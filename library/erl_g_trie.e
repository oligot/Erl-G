indexing
	description:

		"Objects representing a trie (also called a prefix tree) of strings and an arbitrary associated value"

	copyright: "Copyright (c) 2007, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class
	ERL_G_TRIE [G]

create
	make

feature {NONE} -- Initialization

	make is
			-- Create empty trie.
		do
			create root_node.make_root
		end

feature -- Adding elements

	put (a_value: G; an_item: STRING) is
			-- Put `an_item' (associated with `a_value') in trie.
		require
			an_item_not_void: an_item /= Void
		do
			root_node.put (a_value, an_item)
		end

feature -- Nodes

	root_node: ERL_G_TRIE_NODE [G]
			-- Root child nodes of trie

invariant

	root_node_not_void: root_node /= Void

end
