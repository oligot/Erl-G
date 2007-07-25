indexing

	description:

		"Emacs tags file generators"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class TAG_EMACS_GENERATOR

inherit

	TAG_GENERATOR
		rename
			make as make_generator
		end

creation

	make

feature {NONE} -- Initialization

	make (a_universe: like universe; an_error_handler: like error_handler) is
			-- Create a new Emacs TAG file generator.
		require
			a_universe_not_void: a_universe /= Void
			an_error_handler_not_void: an_error_handler /= Void
		do
			make_generator (a_universe, an_error_handler)
			create current_lines.make (1000)
		ensure
			universe_set: universe = a_universe
			error_handler_set: error_handler = an_error_handler
		end

feature {NONE} -- Generation

	generate_class (a_class: ET_CLASS) is
			-- Generate tags for class `a_class'.
		local
			i: INTEGER
			features: ET_FEATURE_LIST
			a_buffer: STRING
			a_stream: KL_STRING_OUTPUT_STREAM
			line_number: INTEGER
			column_number: INTEGER
			class_file: KL_TEXT_INPUT_FILE
		do
			create class_file.make (a_class.filename)
			class_file.open_read
			if class_file.is_open_read then
				cache_lines_of_stream (class_file)
				class_file.close
				create a_buffer.make (5000)
				create a_stream.make (a_buffer)
				line_number := a_class.class_keyword.position.line
				if line_number > 0 then
					-- In the TAGS file line numbers are zero based
					line_number := line_number - 1
				end
				column_number := a_class.class_keyword.position.column
				if column_number > 0 then
					-- In the TAGS file column numbers are zero based
					column_number := column_number - 1
				end
				if is_valid_line (line_number) then
					a_stream.put_string (line (line_number))
					a_stream.put_character ((127).to_character)
					a_stream.put_string (a_class.name.name)
					a_stream.put_character ((1).to_character)
					a_stream.put_integer (line_number)
					a_stream.put_character (',')
					a_stream.put_integer (column_number)
					a_stream.put_new_line
				end
				from
					features := a_class.queries
					i := 1
				until
					i > features.count
				loop
					generate_feature (a_class, features.item (i), a_stream)
					i := i + 1
				end
				from
					features := a_class.procedures
					i := 1
				until
					i > features.count
				loop
					generate_feature (a_class, features.item (i), a_stream)
					i := i + 1
				end
				current_file.put_character ('%F')
				current_file.put_new_line
				current_file.put_string (a_class.filename)
				current_file.put_character (',')
				current_file.put_integer (a_buffer.count) -- TODO: fixme
				current_file.put_new_line
				current_file.put_string (a_buffer)
			else
				error_handler.report_cannot_read_error (a_class.filename)
			end
		end

	generate_feature (a_class: ET_CLASS; a_feature: ET_FEATURE; a_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Generate tags for feature `a_feature' from clas `a_class'
			-- into stream `a_stream'.
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
			a_stream_not_void: a_stream /= Void
			a_stream_open_write: a_stream.is_open_write
		local
			line_number: INTEGER
			column_number: INTEGER
		do
			line_number := a_feature.position.line
			if line_number > 0 then
				-- In the TAGS file line numbers are zero based
				line_number := line_number - 1
			end
			column_number := a_feature.position.column
			if column_number > 0 then
				-- In the TAGS file column numbers are zero based
				column_number := column_number - 1
			end

			if is_valid_line (line_number) then
				a_stream.put_string (line (line_number))
				a_stream.put_character ((127).to_character)
				a_stream.put_string (a_feature.name.name)
				a_stream.put_character ((1).to_character)
				a_stream.put_integer (line_number)
				a_stream.put_character (',')
				a_stream.put_integer (column_number)
				a_stream.put_new_line

				a_stream.put_string (line (line_number))
				a_stream.put_character ((127).to_character)
				a_stream.put_string (a_class.name.name)
				a_stream.put_character ('.')
				a_stream.put_string (a_feature.name.name)
				a_stream.put_character ((1).to_character)
				a_stream.put_integer (line_number)
				a_stream.put_character (',')
				a_stream.put_integer (column_number)
				a_stream.put_new_line
			end
		end

feature {NONE} -- Line cache

	current_lines: DS_ARRAYED_LIST [STRING]
			-- Lines of current class file

	cache_lines_of_stream (a_stream: KI_TEXT_INPUT_STREAM) is
			-- Cache the lines of `a_stream' in `current_lines'.
		require
			a_stream_not_void: a_stream /= Void
			a_stream_is_open_read: a_stream.is_open_read
		do
			from
				current_lines.wipe_out
			until
				a_stream.end_of_input
			loop
				a_stream.read_line
				current_lines.force_last (a_stream.last_string.string)
			end
		end

	is_valid_line (a_line_number: INTEGER): BOOLEAN is
			-- Is `a_line_number' a valid line number of the currently cached class file?
			-- Line numbers are zero based.
		require
			positive_line_number: a_line_number >= 0
		do
			Result := 1 <= (a_line_number + 1) and (a_line_number + 1) <= current_lines.count
		end

	line (a_line_number: INTEGER): STRING is
			-- Line `a_line_number' from currently cached class file
			-- Line numbers are zero based.
		require
			positive_line_number: a_line_number >= 0
		do
			Result := current_lines.item (a_line_number + 1)
		end

invariant

	current_lines_not_void: current_lines /= Void

end
