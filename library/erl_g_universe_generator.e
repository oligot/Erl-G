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

create

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
			output_stream.put_line ("%Twarning: %"Generated class. Do not edit.%"")
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
			output_stream.put_line ("%TERL_UNIVERSE")
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

	generate_access_features is
			-- Generate features under the feature clause named "Access".
		do
			output_stream.put_line ("feature -- Access")
			output_stream.put_new_line
			generate_class_by_name_feature
			output_stream.put_new_line
		end

	generate_implementation_features is
			-- Generate features under the feature clause named "Implementation".
		do
			output_stream.put_line ("feature {NONE} -- Implementation")
			output_stream.put_new_line
			generate_class_i_features
		end

	generate_class_by_name_feature is
			-- Generate feature `class_by_name'. It makes classes accessible by
			-- their name.
		local
			printer: ERL_G_LOOKUP_PRINTER
			cs: DS_HASH_TABLE_CURSOR [ET_CLASS, ET_CLASS_NAME]
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			name: STRING
		do
			create list.make (reflection_generator.universe.classes.count + reflection_generator.universe.basic_classes.count)
			from
				cs := reflection_generator.universe.classes.new_cursor
				cs.start
			until
				cs.off
			loop
				if
					cs.item.implementation_checked and then
					not cs.item.has_implementation_error
				then
					name := ("class_").twin
					name.append_string (reflection_generator.universe.eiffel_class (cs.item.name).name.name.as_lower)
					create pair.make (name, cs.key.name)
					list.put_last (pair)
				end
				cs.forth
			end
			from
				cs := reflection_generator.universe.basic_classes.new_cursor
				cs.start
			until
				cs.off
			loop
				if
					cs.item.implementation_checked and then
					not cs.item.has_implementation_error
				then
					name := ("class_").twin
					name.append_string (reflection_generator.universe.eiffel_class (cs.item.name).name.name.as_lower)
					create pair.make (name, cs.key.name)
					list.put_last (pair)
				end
				cs.forth
			end

			create printer.make (output_stream)
			printer.print_item_by_name_query ("class_by_name", "ERL_CLASS", list)
		end

	generate_class_i_features is
			-- Generate `class_i' features.
		local
			cs: DS_HASH_TABLE_CURSOR [ET_CLASS, ET_CLASS_NAME]
		do
			from
				cs := reflection_generator.universe.classes.new_cursor
				cs.start
			until
				cs.off
			loop
				if
					cs.item.implementation_checked and then
					not cs.item.has_implementation_error and
					not is_alias_class (cs.key, reflection_generator.universe)
				then
					output_stream.put_character ('%T')
					output_stream.put_string ("class_")
					output_stream.put_string (cs.item.name.name.as_lower)
					output_stream.put_line (": ERL_CLASS is")
					output_stream.put_line ("%T%Tonce")
					output_stream.put_string ("%T%T%Tcreate {")
					output_stream.put_string (reflection_generator.meta_class_name (cs.item))
					output_stream.put_line ("} Result.make")
					output_stream.put_line ("%T%Tensure")
					output_stream.put_line ("%T%T%Ttype_not_void: Result /= Void")
					output_stream.put_line ("%T%Tend")
					output_stream.put_new_line
				end
				cs.forth
			end
		end

feature {NONE} -- Implementation

	output_stream: KI_TEXT_OUTPUT_STREAM
			-- Output stream for code generation

	reflection_generator: ERL_G_GENERATOR
			-- Reflection generator for this universe

invariant

	output_stream_not_void: output_stream /= Void
	reflection_generator_not_void: reflection_generator /= Void

end
