indexing
	description:

		"Node elements for ERL_G_TRIE"

	copyright: "Copyright (c) 2007, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"


class
	ERL_G_TRIE_NODE [G]

create
	make,
	make_root

feature {NONE} -- Initialization

	make (a_parent: like Current; a_key: CHARACTER) is
			-- Create new empty node with parent `a_parent' and key `a_key'.
		require
			a_parent_not_void: a_parent /= Void
		do
			parent := a_parent
			level := a_parent.level + 1
			key := a_key
			create children.make_default
		end

	make_root is
			-- Create new empty root.
		do
			level := 0
			create children.make_default
		ensure
			parent_is_void: parent = Void
			level_is_zero: level = 0
		end

feature -- Status report

	is_valid_item (an_item: STRING): BOOLEAN is
			-- Is `an_item' a valid item to put in this node or its one of its children?
		require
			an_item_not_void: an_item /= Void
		do
			Result := (an_item.count >= level) and then ((level > 0) implies an_item.substring (1, level).is_equal (node_prefix))
		end

feature -- Access

	parent: ERL_G_TRIE_NODE [G]
		-- Parent node (Void if root node)

	level: INTEGER
			-- Nesting level of node in trie. (Root node has level 0.)

	key: CHARACTER
		-- Key of this node

	node_prefix: STRING
		-- Prefix of this node
		local
			node: like Current
		do
			create Result.make (level)
			append_prefix_to_string (Result)
		end

	has_item: BOOLEAN
		-- Does current node have an item?

	value: G
			-- Value of current item (if any)

	children: DS_ARRAYED_LIST [like Current]

feature -- Element change

	put (a_value: G; an_item: STRING) is
			-- Put `an_item' (associated with `a_value') in trie.
		require
			an_item_not_void: an_item /= Void
			an_item_valid: is_valid_item (an_item)
		local
			cs: DS_LINEAR_CURSOR [ERL_G_TRIE_NODE [G]]
			chr: CHARACTER
			child: ERL_G_TRIE_NODE [G]
		do
			if an_item.count = level then
					-- Insert item right here.
				has_item := True
				value := a_value
			else
				from
					cs := children.new_cursor
					cs.start
					chr := an_item.item (level + 1)
				until
					cs.off or child /= Void
				loop
					if cs.item.key = chr then
						child := cs.item
					end
					cs.forth
				end
				if child = Void then
					create child.make (Current, chr)
					children.force_last (child)
				end
				child.put (a_value, an_item)
			end
		end

feature {ERL_G_TRIE_NODE} -- Implementation

	append_prefix_to_string (a_string: STRING) is
			-- Apprend prefix to `a_string'.
		require
			a_string_not_void: a_string /= Void
		do
			if parent /= Void then
				parent.append_prefix_to_string (a_string)
				a_string.append_character (key)
			end
		ensure
			size_correct: a_string.count = old a_string.count + level
		end

invariant

	children_not_void: children /= Void
	children_does_not_have_void: not children.has (Void)
	level_not_negative: level >= 0
	root_node_is_level_0: (parent = Void) = (level = 0)

end
