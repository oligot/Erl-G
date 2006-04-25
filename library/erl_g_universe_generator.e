indexing

	description:

		"Generates the universe class for an Eiffel reflection library"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_G_UNIVERSE_GENERATOR

inherit

	ERL_G_TYPE_ROUTINES
		export {NONE} all end

	KL_SHARED_STREAMS
		export {NONE} all end
		
	KL_IMPORTED_INTEGER_ROUTINES
		export {NONE} all end

creation

	make

feature {NONE} -- Initialization

	make (a_reflection_generator: like reflection_generator) is
			-- Create new reflection type generator.
		require
			a_reflection_generator_not_void: a_reflection_generator /= Void
		do
			reflection_generator := a_reflection_generator
			output_stream := null_output_stream
		ensure
			reflection_generator_set: reflection_generator = a_reflection_generator
		end

feature -- Status report

	has_fatal_error: BOOLEAN
			-- Has a fatal error occurred while generating?

feature -- Generation

	generate (a_file: KI_TEXT_OUTPUT_STREAM) is
			-- Generate reflection universe class.
			-- Sets `has_fatal_error' to `True' if generation cannot be completed.
		require
			a_file_not_void: a_file /= Void
			a_file_open_write: a_file.is_open_write
		do
			output_stream := a_file
			generate_indexing
			generate_class_clause
			generate_inheritance_clause
			generate_create_clause
			generate_status_report_features
			generate_access_features
			generate_implementation_features
			output_stream.put_string ("end")
			output_stream.put_new_line
		end

feature {NONE} -- Implementation

	generate_indexing is
			-- Generate indexing clause for reflection class.
		do
			output_stream.put_line ("indexing")
			output_stream.put_line ("%Tnote: %"Generated class. Do not edit.%"")
			output_stream.put_new_line
		end

	generate_class_clause is
			-- Generate class clause for reflection class.
		do
			output_stream.put_line ("class ERL_UNIVERSE_IMP")
			output_stream.put_new_line
		end


	generate_inheritance_clause is
			-- Generate inheritance clause for reflection class.
		do
			output_stream.put_line ("inherit")
			output_stream.put_new_line
			output_stream.put_line ("%TERL_ABSTRACT_UNIVERSE_IMP")
			output_stream.put_new_line
		end

	generate_create_clause is
			-- Generate creation clause for reflection class.
		do
			output_stream.put_string ("create")
			output_stream.put_new_line
			output_stream.put_new_line
			output_stream.put_string ("%Tmake")
			output_stream.put_new_line
			output_stream.put_new_line
		end

	generate_status_report_features is
			-- Generate features under the feature clause named "Status report".
		do
			output_stream.put_line ("feature -- Status report")
			output_stream.put_new_line
			generate_type_count_feature
			output_stream.put_new_line
		end

	generate_access_features is
			-- Generate features under the feature clause named "Access".
		do
			output_stream.put_line ("feature -- Access")
			output_stream.put_new_line
			generate_type_by_index_feature
			output_stream.put_new_line
			generate_type_by_name_feature
			output_stream.put_new_line
		end

	generate_implementation_features is
			-- Generate features under the feature clause named "Implementation".
		do
			output_stream.put_line ("feature {NONE} -- Implementation")
			output_stream.put_new_line
			generate_type_i_features
		end

	generate_type_count_feature is
			-- Generate feature `type_count'.
		do
			output_stream.put_string ("%Ttype_count: INTEGER is ")
			output_stream.put_line (reflection_generator.class_name_list.count.out)
		end

	generate_type_by_index_feature is
			-- Generate feature `type'. It makes types accessible by 
			-- index.
		local
			printer: ERL_G_LOOKUP_PRINTER
			cs: DS_LINEAR_CURSOR [DS_PAIR [ET_BASE_TYPE, STRING]]
			list: DS_ARRAYED_LIST [STRING]
			i: INTEGER
			name: STRING
		do
			from
				cs := reflection_generator.class_name_list.new_cursor
				cs.start
				create list.make (reflection_generator.class_name_list.count)
				i := 1
			until
				cs.off
			loop
				name := ("type_").twin
				INTEGER_.append_decimal_integer (i, name)
				list.put_last (name)
				cs.forth
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_index_query ("type", "ERL_TYPE", list)
		end

	generate_type_by_name_feature is
			-- Generate feature `type_by_name'. It makes types accessible by 
			-- their name.
		local
			printer: ERL_G_LOOKUP_PRINTER
			cs: DS_LINEAR_CURSOR [DS_PAIR [ET_BASE_TYPE, STRING]]
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			i: INTEGER
			name: STRING
		do
			from
				cs := reflection_generator.class_name_list.new_cursor
				cs.start
				create list.make (reflection_generator.class_name_list.count)
				i := 1
			until
				cs.off
			loop
				name := ("type_").twin
				INTEGER_.append_decimal_integer (i, name)
				create pair.make (name, cs.item.first.to_text)
				list.put_last (pair)
				cs.forth
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_name_query ("type_by_name", "ERL_TYPE", list)
		end

	generate_type_i_features is
			-- Generate `type_i' features.
		local
			cs: DS_LINEAR_CURSOR [DS_PAIR [ET_BASE_TYPE, STRING]]
			i: INTEGER
		do
			from
				cs := reflection_generator.class_name_list.new_cursor
				cs.start
				i := 1
			until
				cs.off
			loop
				output_stream.put_character ('%T')
				print_name_by_index (output_stream, i)
				output_stream.put_line (": ERL_TYPE is")
				output_stream.put_line ("%T%Tonce")
				output_stream.put_string ("%T%T%Tcreate {")
				output_stream.put_string (cs.item.second)
				output_stream.put_line ("} Result.make")
				output_stream.put_line ("%T%Tensure")
				output_stream.put_line ("%T%T%Ttype_not_void: Result /= Void")
				output_stream.put_line ("%T%Tend")
				output_stream.put_new_line
				i := i + 1
				cs.forth
			end
		end

feature {NONE} -- Implementation

	output_stream: KI_TEXT_OUTPUT_STREAM
			-- Output stream for code generation

	reflection_generator: ERL_G_GENERATOR
			-- Reflection generator for this universe

	print_name_by_index (an_output_stream: like output_stream; an_index: INTEGER) is
			-- Prints the name of the `an_index'-th type object to 
			-- `an_output_stream'.
		require
			an_output_stream_not_void: an_output_stream /= Void
			an_output_stream_is_open_write: an_output_stream.is_open_write
		do
			an_output_stream.put_string ("type_")
			an_output_stream.put_integer (an_index)
		end
		
invariant

	output_stream_not_void: output_stream /= Void
	reflection_generator_not_void: reflection_generator /= Void

end
