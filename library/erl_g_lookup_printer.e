indexing
	description	: "Generates code that allows to access to elements by name and index"
	author		: "Andreas Leitner"
	date		: "$Date$"
	revision	: "1.0.0"

class ERL_G_LOOKUP_PRINTER

inherit

	KL_SHARED_STREAMS
		export {NONE} all end

	UT_CHARACTER_FORMATTER
		export {NONE} all end

create

	make

feature {NONE} -- Initialization

	make (a_output_stream: like output_stream) is
			-- Create a new printer, using `a_output_stream' as output output stream.
		require
			a_output_stream_not_void: a_output_stream /= Void
			a_output_stream_is_open_write: a_output_stream.is_open_write
		do
			output_stream := a_output_stream
		ensure
			output_stream_set: output_stream = a_output_stream
		end

feature -- Printing

	print_item_by_name_query (a_query_name: STRING;
								an_item_type_name: STRING;
								an_element_list: DS_LINEAR [DS_PAIR [STRING, STRING]]) is
			-- Generate a query that allows to access the elements by its
			-- key. The function will be called `a_query_name'. The elements
			-- entity names will be taken from the first item of the items
			-- of `an_element_list'. The element keys will be taked
			-- from the second item of that tuple. The element
			-- type (and thus the result type of the printed query) is
			-- `an_item_type_name'. Note that no precondition or postcondition
			-- will be generated. It is assumed the generated query redefines
			-- a routine that already has the right contract.
		require
			a_query_name_not_void: a_query_name /= Void
			a_query_name_not_empty: not a_query_name.is_empty
			an_item_type_name_not_void: an_item_type_name /= Void
			an_item_type_name_not_empty: not an_item_type_name.is_empty
			an_element_list_not_void: an_element_list /= Void
			an_element_list_does_not_have_void: not an_element_list.has (Void)
		do
			output_stream.put_string (a_query_name)
			output_stream.put_string (" (a_name: STRING): ")
			output_stream.put_string (an_item_type_name)
			output_stream.put_line (" is")
			output_stream.indent
			output_stream.put_line ("local")
			output_stream.indent
			output_stream.put_line ("i: INTEGER")
			output_stream.put_line ("c: CHARACTER")
			output_stream.dedent
			output_stream.put_line ("do")
			output_stream.indent
			print_item_by_name_switch_block ("a_name", an_element_list)
			output_stream.dedent
			output_stream.put_line ("end")
			output_stream.dedent
		end

	print_item_by_name_switch_block (a_key_name: STRING;
									 an_element_list: DS_LINEAR [DS_PAIR [STRING, STRING]]) is
			-- Generate a if/elseif swtichblock that allows to access the
			-- elements by its key. TODO: The generated code could be
			-- further optimized to inspect on characters.
		require
			a_key_name_not_void: a_key_name /= Void
			an_element_list_not_void: an_element_list /= Void
			an_element_list_does_not_have_void: not an_element_list.has (Void)
		local
			trie: ERL_G_TRIE [STRING, CHARACTER]
			cs: DS_LINEAR_CURSOR [DS_PAIR [STRING, STRING]]
		do
			from
				cs := an_element_list.new_cursor
				cs.start
				create trie.make
			until
				cs.off
			loop
				trie.put (cs.item.first, string_to_indexable (cs.item.second))
				cs.forth
			end
			output_stream.put_line ("i := 1")
			print_switch_for_trie_node (a_key_name, trie.root_node)
		end

	print_switch_for_trie_node (a_key_name: STRING; a_node: ERL_G_TRIE_NODE [STRING, CHARACTER]) is
			-- Print switch block for `a_node'.
		require
			a_key_name_not_void: a_key_name /= Void
			a_node_not_void: a_node /= Void
		local
			cs: DS_LINEAR_CURSOR [ERL_G_TRIE_NODE [STRING, CHARACTER]]
		do
				-- Check if there is a match at the current level
			if a_node.has_item then
				if a_node.parent = Void then
					output_stream.put_string ("if ")
					output_stream.put_string (a_key_name)
					output_stream.put_line (" = Void then")
				else
					output_stream.put_string ("if ")
					output_stream.put_string (a_key_name)
					output_stream.put_line (".count = i - 1 then")
				end
				output_stream.indent
				output_stream.put_string ("Result := ")
				output_stream.put_line (a_node.item)
				output_stream.dedent
				output_stream.put_line ("end")
			end
				-- Check if there is a match in the children
			if a_node.parent = Void then
				output_stream.put_string ("if ")
				output_stream.put_string (a_key_name)
				output_stream.put_line (" /= Void then ")
				output_stream.indent
			end
			if a_node.is_degenerate and not a_node.is_leaf then
					-- Tree is degenerate with only one item at the very end.
					-- We can replace all remaining steps with one substring comparison.
				output_stream.put_string ("if ")
				output_stream.put_string (a_key_name)
				output_stream.put_string (".substring (")
				output_stream.put_integer (a_node.level + 1)
				output_stream.put_string (", ")
				output_stream.put_string (a_key_name)
				output_stream.put_string (".count).is_equal (%"")
				output_stream.put_string (indexable_to_string (a_node.leaf_node.node_prefix).substring (a_node.level + 1, a_node.leaf_node.node_prefix.count))
				output_stream.put_line ("%") then")
				output_stream.indent
				output_stream.put_string ("Result := ")
				output_stream.put_line (a_node.leaf_node.item)
				output_stream.dedent
				output_stream.put_line ("end")
			elseif a_node.is_part_degenerate then
					-- Sequence of nodes with only one child.
					-- We can skip a few levels using substring comparison.
				output_stream.put_string ("if ")
				output_stream.put_string (a_key_name)
				output_stream.put_string (".count >= ")
				output_stream.put_integer (a_node.level + a_node.part_degenerate_count)
				output_stream.put_string (" and then ")
				output_stream.put_string (a_key_name)
				output_stream.put_string (".substring (")
				output_stream.put_integer (a_node.level + 1)
				output_stream.put_string (", ")
				output_stream.put_integer (a_node.level + a_node.part_degenerate_count)
				output_stream.put_string (").is_equal (%"")
				output_stream.put_string (indexable_to_string (a_node.part_degenerate_end_node.node_prefix).substring (a_node.level + 1, a_node.level + a_node.part_degenerate_count))
				output_stream.put_line ("%") then")
				output_stream.indent
				output_stream.put_string ("i := i + ")
				output_stream.put_integer (a_node.part_degenerate_count)
				output_stream.put_new_line
				print_switch_for_trie_node (a_key_name, a_node.part_degenerate_end_node)
				output_stream.dedent
				output_stream.put_line ("end")
			elseif a_node.children.count > 0 then
					-- Normal case several items to match left in the tree.
					-- We use inspect to match only one character.
				output_stream.put_string ("if ")
				output_stream.put_string (a_key_name)
				output_stream.put_line (".count >= i then")
				output_stream.indent
				output_stream.put_string ("c := ")
				output_stream.put_string (a_key_name)
				output_stream.put_line (".item (i)")
				output_stream.put_line ("i := i + 1")
				output_stream.put_line ("inspect c")
				from
					cs := a_node.children.new_cursor
					cs.start
				until
					cs.off
				loop
					output_stream.put_string ("when ")
					put_quoted_eiffel_character (output_stream, cs.item.key_item)
					output_stream.put_line (" then")
					output_stream.indent
					print_switch_for_trie_node (a_key_name, cs.item)
					output_stream.dedent
					cs.forth
				end
				output_stream.put_line ("else")
				output_stream.indent
				output_stream.put_line ("-- Do nothing.")
				output_stream.dedent
				output_stream.put_line ("end")
				output_stream.dedent
				output_stream.put_line ("end")
			end
			if a_node.parent = Void then
				output_stream.dedent
				output_stream.put_line ("end")
			end
		end

	print_item_by_index_query (a_query_name: STRING;
								an_item_type_name: STRING;
								an_element_list: DS_LINEAR [STRING]) is
			-- Generate a query that allows to access the elements by index.
			-- The function will be called `a_query_name'. The element names
			-- will be taken from the list. The element type (and thus
			-- the result type of the printed query) is `an_item_type_name'.
			-- Note that no precondition or postcondition
			-- will be generated. It is assumed the generated query redefines
			-- a routine that already has the right contract.
		require
			a_query_name_not_void: a_query_name /= Void
			a_query_name_not_empty: not a_query_name.is_empty
			an_item_type_name_not_void: an_item_type_name /= Void
			an_item_type_name_not_empty: not an_item_type_name.is_empty
			an_element_list_not_void: an_element_list /= Void
			an_element_list_does_not_have_void: not an_element_list.has (Void)
		local
			i: INTEGER
			cs: DS_LINEAR_CURSOR [STRING]
		do
			output_stream.put_string (a_query_name)
			output_stream.put_string (" (an_index: INTEGER): ")
			output_stream.put_string (an_item_type_name)
			output_stream.put_line (" is")
			output_stream.indent
			output_stream.put_line ("do")
			if an_element_list.count > 0 then
				output_stream.indent
				output_stream.put_line ("inspect an_index")
					from
						i := 1
						cs := an_element_list.new_cursor
						cs.start
					until
						i > an_element_list.count
					loop
						output_stream.put_string ("when ")
						output_stream.put_integer (i)
						output_stream.put_line (" then")
						output_stream.indent
						output_stream.put_string ("Result := ")
						output_stream.put_line (cs.item)
						output_stream.put_new_line
						output_stream.dedent
						i := i + 1
						cs.forth
					end
				output_stream.dedent
				output_stream.put_line ("else")
				output_stream.indent
				output_stream.put_line ("check")
				output_stream.indent
				output_stream.put_line ("dead_end: False")
				output_stream.dedent
				output_stream.put_line ("end")
				output_stream.dedent
				output_stream.put_line ("end")
			else
				output_stream.put_line ("check")
				output_stream.indent
				output_stream.put_line ("dead_end: False")
				output_stream.dedent
				output_stream.put_line ("end")
				output_stream.dedent
			end
			output_stream.dedent
			output_stream.put_line ("end")
			output_stream.dedent
		end

feature {NONE} -- Implementation

	output_stream: ERL_G_INDENTING_TEXT_OUTPUT_FILTER
			-- Output output stream

	string_to_indexable (a_string: STRING): DS_INDEXABLE [CHARACTER] is
			-- Chracters of `a_string' in a new indexable
		require
			a_string_not_void: a_string /= Void
		local
			i: INTEGER
			l: DS_ARRAYED_LIST [CHARACTER]
		do
			create l.make (a_string.count)
			from
				i := 1
			until
				i > a_string.count
			loop
				l.force_last (a_string.item (i))
				i := i + 1
			end
			Result := l
		ensure
			linear_not_void: Result /= Void
			count_correct: Result.count = a_string.count
		end

	indexable_to_string (a_indexable: DS_INDEXABLE [CHARACTER]): STRING is
			-- Items of `a_indexable' in a new string
		require
			a_indexable_not_void: a_indexable /= Void
		local
			i: INTEGER
		do
			create Result.make (a_indexable.count)
			from
				i := 1
			until
				i > a_indexable.count
			loop
				Result.append_character (a_indexable.item (i))
				i := i + 1
			end
		ensure
			string_not_void: Result /= Void
			count_correct: Result.count = a_indexable.count
		end


invariant

	output_stream_not_void: output_stream /= Void
	output_stream_is_open_write: output_stream.is_open_write

end
