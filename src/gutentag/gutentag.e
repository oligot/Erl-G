indexing

	description:

		"'gutentag' emacs/vi tags for Eiffel systems"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class GUTENTAG

inherit

	ANY

	TAG_SHARED_TAG_FORMAT_NAMES
		export {NONE} all end

	KL_SHARED_EXCEPTIONS
		export {NONE} all end

	KL_SHARED_ARGUMENTS
		export {NONE} all end

	UC_SHARED_STRING_EQUALITY_TESTER
		export {NONE} all end

	KL_SHARED_EXECUTION_ENVIRONMENT
		export {NONE} all end

	EIFFEL_ENV
		export {NONE} all end

creation

	execute

feature -- Execution

	execute is
			-- Start 'gutentag' execution.
		local
			a_filename: STRING
			a_file: KL_TEXT_INPUT_FILE
			a_lace_parser: ET_LACE_PARSER
			a_lace_error_handler: ET_LACE_ERROR_HANDLER
			an_xace_parser: ET_XACE_UNIVERSE_PARSER
			an_xace_error_handler: ET_XACE_DEFAULT_ERROR_HANDLER
			an_xace_variables: DS_HASH_TABLE [STRING, STRING]
			a_ecf_parser: ET_ECF_PARSER
			a_splitter: ST_SPLITTER
			a_cursor: DS_LIST_CURSOR [STRING]
			a_definition: STRING
			an_index: INTEGER
			gobo_eiffel: STRING
			a_universe: ET_UNIVERSE
			i, nb: INTEGER
			arg: STRING
		do
			Arguments.set_program_name ("gutentag")
			create error_handler.make_standard
			nb := Arguments.argument_count
			tag_format := formats.emacs_code
			from i := 1 until i > nb loop
				arg := Arguments.argument (i)
				if arg.is_equal ("-V") or arg.is_equal ("--version") then
					error_handler.report_version_number
					Exceptions.die (0)
				elseif arg.is_equal ("-h") or arg.is_equal ("-?") or arg.is_equal ("--help") then
					error_handler.report_usage_message
					Exceptions.die (0)
				elseif arg.count > 9 and then arg.substring (1, 9).is_equal ("--define=") then
					defined_variables := arg.substring (10, arg.count)
				elseif arg.count > 9 and then arg.substring (1, 9).is_equal ("--target=") then
					ecf_target := arg.substring (10, arg.count)
				elseif arg.count > 9 and then arg.substring (1, 9).is_equal ("--output=") then
					output_filename := arg.substring (10, arg.count)
				elseif arg.count > 9 and then arg.substring (1, 9).is_equal ("--format=") then
					arg := arg.substring (10, arg.count)
					if not formats.is_valid_name (arg) then
						error_handler.report_invalid_tag_format_error (arg)
						Exceptions.die (1)
					end
					tag_format := formats.format_codes.item (arg)
				elseif arg.is_equal ("--verbose") then
					is_verbose := True
				elseif arg.is_equal ("--no_output") then
					no_output := True
				elseif arg.is_equal ("--void") then
					void_feature := True
				elseif arg.is_equal ("--reference") then
					reference_keyword := True
				elseif i = nb then
					a_filename := arg
				else
					error_handler.report_usage_message
					Exceptions.die (1)
				end
				i := i + 1
			end
			if output_filename = Void then
				if tag_format = formats.emacs_code then
					output_filename := default_emacs_output_filename
				elseif tag_format = formats.vi_code then
					output_filename := default_vi_output_filename
				else
						check
							dead_end: False
						end
				end
			end
			if a_filename = Void then
				a_filename := default_input_filename
			end
			create a_file.make (a_filename)
			a_file.open_read
			if a_file.is_open_read then
				nb := a_filename.count
				if nb > 5 and then a_filename.substring (nb - 4, nb).is_equal (".xace") then
					create an_xace_error_handler.make_standard
					create an_xace_variables.make_map (100)
					an_xace_variables.set_key_equality_tester (string_equality_tester)
					gobo_eiffel := Execution_environment.variable_value ("GOBO_EIFFEL")
					if gobo_eiffel /= Void then
						an_xace_variables.force_last (gobo_eiffel, "GOBO_EIFFEL")
					end
					if defined_variables /= Void then
						create a_splitter.make
						a_cursor := a_splitter.split (defined_variables).new_cursor
						from a_cursor.start until a_cursor.after loop
							a_definition := a_cursor.item
							if a_definition.count > 0 then
								an_index := a_definition.index_of ('=', 1)
								if an_index = 0 then
										an_xace_variables.force_last ("", a_definition)
								elseif an_index = a_definition.count then
									an_xace_variables.force_last ("", a_definition.substring (1, an_index - 1))
									elseif an_index /= 1 then
										an_xace_variables.force_last (a_definition.substring (an_index + 1 ,a_definition.count), a_definition.substring (1, an_index - 1))
								end
							end
							a_cursor.forth
						end
					end
					create an_xace_parser.make_with_variables (an_xace_variables, an_xace_error_handler)
					an_xace_parser.parse_file (a_file)
					a_file.close
					if not an_xace_error_handler.has_error then
						a_universe := an_xace_parser.last_universe
					end
				elseif nb > 4 and then a_filename.substring (nb - 3, nb).is_equal (".ecf") then
					check_environment_variable
					set_precompile (False)
					create a_ecf_parser.make_standard
					if ecf_target /= Void then
						a_ecf_parser.set_target (ecf_target)
					end
					a_ecf_parser.load (a_filename)
					if not a_ecf_parser.is_error then
						a_universe := a_ecf_parser.last_universe
					end
				else
					create a_lace_error_handler.make_standard
					create a_lace_parser.make (a_lace_error_handler)
					a_lace_parser.parse_file (a_file)
					a_file.close
					if not a_lace_parser.syntax_error then
						a_universe := a_lace_parser.last_universe
					end
				end
				if a_universe /= Void then
					process_universe (a_universe)
				end
			else
				error_handler.report_cannot_read_error (a_filename)
				Exceptions.die (1)
			end
		end

feature -- Status report

	defined_variables: STRING
	is_verbose: BOOLEAN
	no_output: BOOLEAN
	void_feature: BOOLEAN
	reference_keyword: BOOLEAN
	output_filename: STRING
	tag_format: INTEGER
	ecf_target: STRING
			-- Command-line options

feature -- Access

	error_handler: TAG_ERROR_HANDLER
			-- Error handler

feature {NONE} -- Processing

	process_universe (a_universe: ET_UNIVERSE) is
			-- Process `a_universe'.
		require
			a_universe_not_void: a_universe /= Void
		local
			an_ast_factory: ET_DECORATED_AST_FACTORY
			a_null_error_handler: ET_NULL_ERROR_HANDLER
			a_generator: TAG_GENERATOR
			an_output_file: KL_TEXT_OUTPUT_FILE
		do
			create an_ast_factory.make
			an_ast_factory.set_keep_all_breaks (True)
			a_universe.set_ast_factory (an_ast_factory)
			if no_output then
				create a_null_error_handler.make_standard
				a_universe.set_error_handler (a_null_error_handler)
			end

			a_universe.error_handler.set_ise
			if not is_verbose then
				a_universe.error_handler.set_info_null
			end

			a_universe.set_use_assign_keyword (True)
			a_universe.set_use_attribute_keyword (False)
			a_universe.set_use_convert_keyword (True)
			a_universe.set_use_create_keyword (True)
			a_universe.set_use_recast_keyword (True)
			a_universe.set_use_reference_keyword (reference_keyword)
			if void_feature then
				a_universe.set_use_void_keyword (False)
			else
				a_universe.set_use_void_keyword (True)
			end
			a_universe.activate_processors
			a_universe.parse_all
			a_universe.compile_degree_5
			if tag_format = formats.emacs_code then
				create {TAG_EMACS_GENERATOR} a_generator.make (a_universe, error_handler)
			elseif tag_format = formats.vi_code then
				create {TAG_VI_GENERATOR} a_generator.make (a_universe, error_handler)
			else
					check
						dead_end: False
					end
			end
			create an_output_file.make (output_filename)
			an_output_file.open_write
			if not an_output_file.is_open_write then
				error_handler.report_cannot_write_error (output_filename)
				Exceptions.die (1)
			end
			a_generator.generate (an_output_file)
			an_output_file.close
		end

feature {NONE} -- Constants

	default_input_filename: STRING is "system.xace"
	default_emacs_output_filename: STRING is "TAGS"
	default_vi_output_filename: STRING is "tags"

	application_name: STRING is "ec"
			-- Esutdio application name; needed to find right registry key
			-- (EIFFEL_ENV)

invariant

	error_handler_not_void: error_handler /= Void

end
