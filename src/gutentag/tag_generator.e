indexing

	description:

		"Abstract tags file generators"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class TAG_GENERATOR

inherit

	KL_SHARED_STREAMS
		export {NONE} all end

feature {NONE} -- Initialization

	make (a_universe: like universe; an_error_handler: like error_handler) is
			-- Create a new Emacs TAG file generator.
		require
			a_universe_not_void: a_universe /= Void
			an_error_handler_not_void: an_error_handler /= Void
		do
			universe := a_universe
			current_file := null_output_stream
			error_handler := an_error_handler
		ensure
			universe_set: universe = a_universe
			error_handler_set: error_handler = an_error_handler
		end

feature -- Status report

	has_fatal_error: BOOLEAN
			-- Has a fatal error occurred when generating `current_system'?

feature -- Access

	universe: ET_UNIVERSE
			-- Surrounding universe

	error_handler: TAG_ERROR_HANDLER
			-- Error handler

feature -- Generation

	generate (a_file: KI_TEXT_OUTPUT_STREAM) is
			-- Generate tags for `current_system' in to `a_file'.
		require
			a_file_not_void: a_file /= Void
			a_file_open_write: a_file.is_open_write
		local
			old_file: KI_TEXT_OUTPUT_STREAM
			cs: DS_HASH_TABLE_CURSOR [ET_MASTER_CLASS, ET_CLASS_NAME]
		do
			old_file := current_file
			current_file := a_file
			from
				cs := universe.master_classes.new_cursor
				cs.start
			until
				cs.off
			loop
				if cs.item.actual_class.filename /= Void then
					generate_class (cs.item.actual_class)
				end
				cs.forth
			end
			current_file := old_file
		end

feature {NONE} -- Generation

	generate_class (a_class: ET_CLASS) is
			-- Generate tags for class `a_class'.
		require
			a_class_not_void: a_class /= Void
			a_class_has_filename: a_class.filename /= Void
			a_class_mark_not_void: a_class.position /= Void
		deferred
		end

feature {NONE} -- Access

	current_file: KI_TEXT_OUTPUT_STREAM
			-- Output file

invariant

	universe_not_void: universe /= Void
	current_file_not_void: current_file /= Void
	current_file_open_write: current_file.is_open_write
	error_handler_not_void: error_handler /= Void

end
