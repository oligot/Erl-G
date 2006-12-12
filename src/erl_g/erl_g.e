indexing

	description:

		"'erl_g' command line tool"

	copyright: "Copyright (c) 2004-2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_G

inherit

	ERL_G_COMMAND_LINE_PARSER
		export {NONE} all end

	ERL_G_TYPE_ROUTINES
		export {NONE} all end

	KL_SHARED_STRING_EQUALITY_TESTER
		export {NONE} all end

	KL_SHARED_EXECUTION_ENVIRONMENT
		export {NONE} all end

	UT_SHARED_ISE_VERSIONS
		export {NONE} all end

create

	execute

feature -- Execution

	execute is
			-- Start 'erl_g' execution.
		local
			a_file: KL_TEXT_INPUT_FILE
			a_lace_parser: ET_LACE_PARSER
			a_lace_error_handler: ET_LACE_ERROR_HANDLER
			an_xace_parser: ET_XACE_UNIVERSE_PARSER
			an_xace_error_handler: ET_XACE_DEFAULT_ERROR_HANDLER
			an_xace_variables: DS_HASH_TABLE [STRING, STRING]
			a_universe: ET_UNIVERSE
			nb: INTEGER
		do
			Arguments.set_program_name ("erl_g")
			create error_handler.make
			output_dirname := "reflection_library"
			process_arguments

			create a_file.make (ace_filename)
			a_file.open_read
			if a_file.is_open_read then
				nb := ace_filename.count
				if nb > 5 and then ace_filename.substring (nb - 4, nb).is_equal (".xace") then
					create an_xace_error_handler.make_standard
					create an_xace_variables.make_map (100)
					an_xace_variables.set_key_equality_tester (string_equality_tester)
					if defined_variables /= Void then
						parse_defined_variables (defined_variables, an_xace_variables)
					end
					create an_xace_parser.make_with_variables (an_xace_variables, an_xace_error_handler)
					an_xace_parser.parse_file (a_file)
					a_file.close
					if not an_xace_error_handler.has_error then
						a_universe := an_xace_parser.last_universe
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
				else
					Exceptions.die (3)
				end
			else
				error_handler.report_cannot_read_error (ace_filename)
				Exceptions.die (1)
			end
		end

feature -- Parsing

	parse_defined_variables (an_input: STRING; a_table: DS_HASH_TABLE [STRING, STRING]) is
			-- Parse variable definitions in `an_input' and set the variables in `a_table' accordingly.
		require
			an_input_not_void: an_input /= Void
			a_table_not_void: a_table /= Void
		local
			a_splitter: ST_SPLITTER
			a_cursor: DS_LIST_CURSOR [STRING]
			a_definition: STRING
			an_index: INTEGER
			gobo_eiffel: STRING
		do
			gobo_eiffel := Execution_environment.variable_value ("GOBO_EIFFEL")
			if gobo_eiffel /= Void then
				a_table.force_last (gobo_eiffel, "GOBO_EIFFEL")
			end
			a_table.force_last ("True", "ERL_G_NO_IMPLEMENTATION")
			create a_splitter.make
			a_cursor := a_splitter.split (defined_variables).new_cursor
			from a_cursor.start until a_cursor.after loop
				a_definition := a_cursor.item
				if a_definition.count > 0 then
					an_index := a_definition.index_of ('=', 1)
					if an_index = 0 then
						a_table.force_last ("", a_definition)
					elseif an_index = a_definition.count then
						a_table.force_last ("", a_definition.substring (1, an_index - 1))
					elseif an_index /= 1 then
						a_table.force_last (a_definition.substring (an_index + 1 ,a_definition.count), a_definition.substring (1, an_index - 1))
					end
				end
				a_cursor.forth
			end
		end

feature {NONE} -- Processing

	process_universe (a_universe: ET_UNIVERSE) is
			-- Process `a_universe'.
		require
			a_universe_not_void: a_universe /= Void
		local
			an_ast_factory: ET_DECORATED_AST_FACTORY
		do
			create an_ast_factory.make
			an_ast_factory.set_keep_all_breaks (True)
			a_universe.set_ast_factory (an_ast_factory)

			a_universe.error_handler.set_ise
			a_universe.set_use_assign_keyword (True)
			a_universe.set_use_attribute_keyword (False)
			a_universe.set_use_convert_keyword (True)
			a_universe.set_use_create_keyword (True)
			a_universe.set_use_recast_keyword (False)
			a_universe.set_use_reference_keyword (True)
			a_universe.set_ise_version (ise_latest)
			if void_feature then
				a_universe.set_use_void_keyword (False)
			else
				a_universe.set_use_void_keyword (True)
			end
			generate_reflection_classes (a_universe)
		end

	generate_reflection_classes (a_universe: ET_UNIVERSE) is
			-- Generate reflection classes for universe `a_universe'.
		require
			a_universe_not_empty: a_universe /= Void
		local
			l_generator: ERL_G_GENERATOR
			cs: DS_LINEAR_CURSOR [STRING]
			l_base_type: ET_BASE_TYPE
		do
			create l_generator.make (a_universe)
			from
				cs := type_names.new_cursor
				cs.start
			until
				cs.off
			loop
				l_base_type := base_type (cs.item, a_universe)
				if l_base_type = Void then
					error_handler.report_invalid_or_unknown_type_error (cs.item)
				else
					l_generator.mark_type_creatable (l_base_type)
				end
				cs.forth
			end

			l_generator.generate_all (output_dirname)
		end

end
