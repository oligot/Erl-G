indexing

	description:

		"Abstract ancestor for test-classes that require a universe"

	library: "Erl-G Library"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_UNIVERSE_TEST_CASE

inherit

	TS_TEST_CASE
		redefine
			set_up
		end

	UT_SHARED_ISE_VERSIONS
		export {NONE} all end

	KL_SHARED_FILE_SYSTEM
		export {NONE} all end

	KL_SHARED_EXECUTION_ENVIRONMENT
		export {NONE} all end

feature -- Execution

	set_up is
			-- Parse universe if not parsed already.
		local
			a_file: KL_TEXT_INPUT_FILE
			an_xace_parser: ET_XACE_UNIVERSE_PARSER
			an_xace_error_handler: ET_XACE_DEFAULT_ERROR_HANDLER
		do
			if universe = Void then
				create error_handler.make_null
				create a_file.make (ace_filename)
				a_file.open_read
				check
					a_file_open: a_file.is_open_read
				end
				create an_xace_error_handler.make_standard
				create an_xace_parser.make (an_xace_error_handler)
				an_xace_parser.parse_file (a_file)
				a_file.close
				universe := an_xace_parser.last_universe
				check
					universe_exists: universe /= Void
				end
				universe.error_handler.set_ise
				universe.set_use_assign_keyword (True)
				universe.set_use_attribute_keyword (False)
				universe.set_use_convert_keyword (True)
				universe.set_use_create_keyword (True)
				universe.set_use_recast_keyword (False)
				universe.set_use_reference_keyword (True)
				universe.set_ise_version (ise_latest)
				universe.activate_processors
				universe.parse_all
			end
		end

feature {NONE} -- Implementation

	universe: ET_UNIVERSE
			-- Universe

	error_handler: ET_ERROR_HANDLER
			-- Error handler

feature {NONE}  -- Constants

	ace_filename: STRING is
			-- Filename of the ACE file to parse in order to generate universe
		once
			Result := file_system.nested_pathname (execution_environment.interpreted_string ("${ERL_G}"), <<"test", "common", "fake_kernel", "library.xace">>)
		ensure
			result_not_void: Result /= Void
		end

end
