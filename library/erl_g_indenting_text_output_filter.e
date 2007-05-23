indexing
	description	: "Outputstream filter that allows for dynamic indentation"
	author		: "Andreas Leitner"
	date		: "$Date$"
	revision	: "1.0.0"

class ERL_G_INDENTING_TEXT_OUTPUT_FILTER

inherit

	KI_TEXT_OUTPUT_STREAM
		redefine
			is_open_write,
			eol,
			name,
			put_character,
			put_new_line,
			put_string,
			flush,
			close
		end

	KL_SHARED_STREAMS
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_output_stream: like output_stream) is
			-- Create a new filter, using `a_output_stream' as output stream.
		require
			a_output_stream_not_void: a_output_stream /= Void
		do
			output_stream := a_output_stream
		ensure
			output_stream_set: output_stream = a_output_stream
		end

feature -- Status report

	is_open_write: BOOLEAN is
			-- Can items be written to output stream?
		do
			Result := output_stream.is_open_write
		end

feature -- Access

	output_stream: KI_TEXT_OUTPUT_STREAM
			-- Output output stream

	indent_level: INTEGER

	eol: STRING is
			-- Line separator
		do
			Result := output_stream.eol
		end

	name: STRING is
			-- Name of output stream
		do
			Result := output_stream.name
		end

feature -- Level Change

	increase_indent_level is
			-- Increase level of indentation by 1.
		do
			indent_level := indent_level + 1
		ensure
			indent_level_increased: indent_level = old indent_level + 1
		end

	decrease_indent_level is
			-- Decrease level of indentation by 1.
		require
			indent_level_big_enough: indent_level > 0
		do
			indent_level := indent_level - 1
		ensure
			indent_level_decreased: indent_level = old indent_level - 1
		end

feature -- Output

	put_character (v: CHARACTER) is
			-- Write `v' to output stream.
		do
			if not indentation_printed then
				print_indentation
			end
			output_stream.put_character (v)
		end

	put_new_line is
			-- Write a line separator to output stream.
		do
			Precursor
			indentation_printed := False
		end

	put_string (a_string: STRING) is
			-- Write `a_string' to output stream.
		do
			if not indentation_printed then
				print_indentation
			end
			output_stream.put_string (a_string)
		end

feature -- Basic operations

	flush is
			-- Flush buffered data to disk.
		do
			output_stream.flush
		end

	close is
			-- Try to close output stream if it is closable. Set
			-- `is_open_write' to false if operation was successful.
		do
			output_stream.close
		end

feature -- Setting

	set_output_stream (a_output_stream: like output_stream) is
			-- Set `output_stream' to `a_output_stream'.
		require
			a_output_stream_not_void: a_output_stream /= Void
			a_output_stream_is_open_write: a_output_stream.is_open_write
		do
			output_stream := a_output_stream
		ensure
			output_stream_set: output_stream = a_output_stream
		end

	set_null_output_stream is
			-- Set `output_stream' to `null_output_stream'.
		do
			output_stream := null_output_stream
		ensure
			output_stream_set: output_stream = null_output_stream
		end

feature {NONE} -- Implementation

	print_indentation is
			-- Print currentl level of indentation to `output_stream'.
		require
			not_printed: not indentation_printed
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > indent_level
			loop
				output_stream.put_character ('%T')
				i := i + 1
			end
			indentation_printed := True
		ensure
			printed: indentation_printed
		end

	indentation_printed: BOOLEAN
			-- Was indentation already printed for this line?

invariant

	indent_level_not_negative: indent_level >= 0
	output_stream_not_void: output_stream /= Void

end
