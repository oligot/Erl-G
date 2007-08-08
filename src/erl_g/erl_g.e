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

	EIFFEL_ENV
		export {NONE} all end

create

	execute

feature -- Execution

	execute is
			-- Start 'erl_g' execution.
		local
			a_ecf_parser: ET_ECF_PARSER
			a_universe: ET_UNIVERSE
		do
			check_environment_variable
			set_precompile (False)
			Arguments.set_program_name ("erl_g")
			create error_handler.make
			output_dirname := "reflection_library"
			process_arguments

			create a_ecf_parser.make_standard
			if target /= Void then
				a_ecf_parser.set_target (target)
			end
			a_ecf_parser.set_workbench_build (is_workbench_mode)
			a_ecf_parser.set_compiler_version (ise_latest)
			a_ecf_parser.load (ecf_filename)
			if a_ecf_parser.is_error then
				-- Note that the actual error message is reported via the error handler of
				-- `a_ecf_parser'.
				Exceptions.die (3)
			else
				process_universe (a_ecf_parser.last_universe)
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

			a_universe.set_use_assign_keyword (True)
			a_universe.set_use_attribute_keyword (False)
			a_universe.set_use_convert_keyword (True)
			a_universe.set_use_create_keyword (True)
			a_universe.set_use_recast_keyword (False)
			a_universe.set_use_reference_keyword (True)
			a_universe.set_ise_version (ise_latest)
			a_universe.set_use_void_keyword (True)
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

	application_name: STRING is "ec"
			-- Name of estudio application in order to
			-- find right keys (EIFFEL_ENV)


end
