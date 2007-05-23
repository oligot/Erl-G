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

	make (a_output_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Create a new printer, using `a_output_stream' as output output stream.
		require
			a_output_stream_not_void: a_output_stream /= Void
			a_output_stream_is_open_write: a_output_stream.is_open_write
		do
			create output_stream.make (a_output_stream)
		end

feature -- Setting

	set_output_stream (a_output_stream: like output_stream) is
			-- Set `output_stream' to `a_output_stream'.
		require
			a_output_stream_not_void: a_output_stream /= Void
			a_output_stream_is_open_write: a_output_stream.is_open_write
		do
			output_stream.set_output_stream (a_output_stream)
		end

	set_null_output_stream is
			-- Set `output_stream' to `null_output_stream'.
		do
			output_stream.set_null_output_stream
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
			output_stream.increase_indent_level
			output_stream.put_string (a_query_name)
			output_stream.put_string (" (a_name: STRING): ")
			output_stream.put_string (an_item_type_name)
			output_stream.put_line (" is")
			output_stream.increase_indent_level
			output_stream.put_line ("local")
			output_stream.increase_indent_level
			output_stream.put_line ("i: INTEGER")
			output_stream.put_line ("c: CHARACTER")
			output_stream.decrease_indent_level
			output_stream.put_line ("do")
			output_stream.increase_indent_level
			print_item_by_name_switch_block ("a_name", an_element_list)
			output_stream.decrease_indent_level
			output_stream.put_line ("end")
			output_stream.decrease_indent_level
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
			trie: ERL_G_TRIE [STRING]
			cs: DS_LINEAR_CURSOR [DS_PAIR [STRING, STRING]]
		do
			from
				cs := an_element_list.new_cursor
				cs.start
				create trie.make
			until
				cs.off
			loop
				trie.put (cs.item.first, cs.item.second)
				cs.forth
			end
			output_stream.put_line ("i := 1")
			output_stream.increase_indent_level
			print_switch_for_trie_node (a_key_name, trie.root_node)
			output_stream.decrease_indent_level
		end

	print_switch_for_trie_node (a_key_name: STRING; a_node: ERL_G_TRIE_NODE [STRING]) is
			-- Print switch block for `a_node'.
		require
			a_key_name_not_void: a_key_name /= Void
			a_node_not_void: a_node /= Void
		local
			cs: DS_LINEAR_CURSOR [ERL_G_TRIE_NODE [STRING]]
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
				output_stream.increase_indent_level
				output_stream.put_string ("Result := ")
				output_stream.put_line (a_node.value)
				output_stream.decrease_indent_level
				output_stream.put_line ("end")
			end
				-- Check if there is a match in the children
			if a_node.children.count > 0 then
				output_stream.put_string ("if ")
				output_stream.put_string (a_key_name)
				output_stream.put_line (".count >= i then")
				output_stream.increase_indent_level
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
					put_quoted_eiffel_character (output_stream, cs.item.key)
					output_stream.put_line (" then")
					output_stream.increase_indent_level
					print_switch_for_trie_node (a_key_name, cs.item)
					output_stream.decrease_indent_level
					cs.forth
				end
				output_stream.put_line ("else")
				output_stream.increase_indent_level
				output_stream.put_line ("-- Do nothing.")
				output_stream.decrease_indent_level
				output_stream.put_line ("end")
				output_stream.decrease_indent_level
				output_stream.put_line ("end")
			end
		end

	print_item_by_name_switch_block_slow (a_key_name: STRING;
												an_element_list: DS_LINEAR [DS_PAIR [STRING, STRING]]) is
			-- Generate a if/elseif swtichblock that allows to access the
			-- elements by its key.
		require
			a_key_name_not_void: a_key_name /= Void
			an_element_list_not_void: an_element_list /= Void
			an_element_list_does_not_have_void: not an_element_list.has (Void)
		local
			cs: DS_LINEAR_CURSOR [DS_PAIR [STRING, STRING]]
			i: INTEGER
		do
			from
				cs := an_element_list.new_cursor
				cs.start
				i := 1
			until
				cs.off
			loop
				if i > nested_if_count then
					output_stream.put_line ("%T%T%Tend")
					output_stream.put_string ("%T%T%Tif ")
					i := 1
				elseif cs.is_first then
					output_stream.put_string ("%T%T%Tif ")
				else
					output_stream.put_string ("%T%T%Telseif ")
				end

				output_stream.put_string (a_key_name)

				if cs.item.second = Void then
					output_stream.put_string (" = Void ")
				else
					output_stream.put_string (".is_equal (%"")
					output_stream.put_string (cs.item.second)
					output_stream.put_string ("%")")
				end
				output_stream.put_line (" then")
				output_stream.put_string ("%T%T%T%TResult := ")
				output_stream.put_line (cs.item.first)
				i := i + 1
				cs.forth
			end
			if an_element_list.count > 0 then
				output_stream.put_line ("%T%T%Tend")
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
			-- TODO: replace '%T's with calls to indention-routines in output_stream.
			output_stream.put_character ('%T')
			output_stream.put_string (a_query_name)
			output_stream.put_string (" (an_index: INTEGER): ")
			output_stream.put_string (an_item_type_name)
			output_stream.put_line (" is")
			output_stream.put_line ("%T%Tdo")
			if an_element_list.count > 0 then
				output_stream.put_line ("%T%T%Tinspect an_index")
					from
						i := 1
						cs := an_element_list.new_cursor
						cs.start
					until
						i > an_element_list.count
					loop
						output_stream.put_string ("%T%T%Twhen ")
						output_stream.put_integer (i)
						output_stream.put_line (" then")
						output_stream.put_string ("%T%T%T%TResult := ")
						output_stream.put_line (cs.item)
						output_stream.put_new_line
						i := i + 1
						cs.forth
					end
				output_stream.put_line ("%T%T%Telse")
				output_stream.put_line ("%T%T%T%Tcheck")
				output_stream.put_line ("%T%T%T%T%Tdead_end: False")
				output_stream.put_line ("%T%T%T%Tend")
				output_stream.put_line ("%T%T%Tend")
			else
				output_stream.put_line ("%T%T%Tcheck")
				output_stream.put_line ("%T%T%T%Tdead_end: False")
				output_stream.put_line ("%T%T%Tend")
			end
			output_stream.put_line ("%T%Tend")
		end

feature {NONE} -- Implementation

	nested_if_count: INTEGER is 100
			-- Maximal number of nested ifs;
			-- Some C compilers do not like to many nested "if"
			-- instructions.

	output_stream: ERL_G_INDENTING_TEXT_OUTPUT_FILTER
			-- Output output stream

invariant

	output_stream_not_void: output_stream /= Void
	output_stream_is_open_write: output_stream.is_open_write

end
