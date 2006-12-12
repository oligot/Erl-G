indexing

	description:

		"Example using expanded types with Erl-G"

	copyright: "Copyright (c) 2004-2006, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class EXPANDED_DEMO

inherit

	ERL_SHARED_UNIVERSE
		export {NONE} all end

create

	execute

feature -- Execution

	execute is
		local
			c: ERL_CLASS
			b: BOOLEAN
		do
			c := universe.class_by_name ("STRING_8")
			b := c.is_valid_query_name ("capacity")
		end

	execute3 is
		local
			ll_int: LINKED_LIST [INTEGER]
			ll_any: LINKED_LIST [ANY]
			t_ll_any: TUPLE [LINKED_LIST [ANY]]
			t_ll_int: TUPLE [LINKED_LIST [INTEGER]]
		do
			create ll_int.make
--			ll_any := ll_int
--			t_ll_any := [ll_int]
			create t_ll_any
			check
				t_ll_any.valid_type_for_index (ll_int, 1)
			end
		end


	execute4 is
		do
			string
			linked_list_1
			linked_list_2
			linked_list_3
		end

	linked_list_1 is
			-- Start 'hello_world' execution.
		local
			ll_class: ERL_CLASS
			a: ANY
			ll: LINKED_LIST [ANY]
		do
			ll_class := universe.class_by_name ("LINKED_LIST")
				check
					ll_class_not_void: ll_class /= Void
				end
			ll_class.invoke_creation_procedure ("[ANY]", "make", <<>>)
			a := ll_class.last_result
			check
				a_not_void: a /= Void
				a_valid_type: a.generating_type.is_equal ("LINKED_LIST [ANY]")
			end
			ll_class.invoke_feature ("force", a, <<Void>>)
			ll ?= a
			check
				valid_count: ll.count = 1
				valid_item: ll.first = Void
			end
		end

	linked_list_2 is
			-- Start 'hello_world' execution.
		local
			ll_class: ERL_CLASS
			a: ANY
			s: STRING
			ll: LINKED_LIST [STRING]
		do
			ll_class := universe.class_by_name ("LINKED_LIST")
				check
					ll_class_not_void: ll_class /= Void
				end
			ll_class.invoke_creation_procedure ("[STRING_8]", "make", <<>>)
			a := ll_class.last_result
			check
				a_not_void: a /= Void
				a_valid_type: a.generating_type.is_equal ("LINKED_LIST [STRING_8]")
			end
			s := "foo"
			ll_class.invoke_feature ("force", a, <<s>>)
			ll ?= a
			check
				valid_count: ll.count = 1
				valid_item: ll.first = s
			end
		end

	linked_list_3 is
			-- Start 'hello_world' execution.
		local
			ll_class: ERL_CLASS
			a: ANY
			ll: LINKED_LIST [INTEGER]
		do
			ll_class := universe.class_by_name ("LINKED_LIST")
				check
					ll_class_not_void: ll_class /= Void
				end
			ll_class.invoke_creation_procedure ("[INTEGER_32]", "make", <<>>)
			a := ll_class.last_result
				check
					a_not_void: a /= Void
					a_valid_type: a.generating_type.is_equal ("LINKED_LIST [INTEGER_32]")
				end
			ll_class.invoke_feature ("force", a, <<55>>)
			ll ?= a
			check
				valid_count: ll.count = 1
				valid_item: ll.first = 55
			end

		end

	string is
			-- Start 'hello_world' execution.
		local
			string_class: ERL_CLASS
			s1, s2: STRING
		do
			string_class := universe.class_by_name ("STRING_8")
				check
					string_class_not_void: string_class /= Void
				end
			string_class.invoke_creation_procedure ("", "make", <<5>>)
			s1 ?= string_class.last_result
				check
					s1_not_void: s1 /= void
					s1_capacity_valid: s1.capacity = 5
				end
			s2 := "bar"
			string_class := universe.class_by_object (s1)
				check
					string_class_not_void: string_class /= Void
				end
			string_class.invoke_feature ("append_string", s1, <<s2>>)
			check
				s1_valid_content: s1.is_equal ("bar")
			end
		end


end
