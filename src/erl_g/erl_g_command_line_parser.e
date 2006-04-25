indexing

	description:

		"Erl-G command line parser"

	copyright: "Copyright (c) 2004-2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_G_COMMAND_LINE_PARSER

inherit

	KL_SHARED_EXCEPTIONS
	KL_SHARED_ARGUMENTS
	GEXACE_COMMAND_LINE_PARSER

feature -- Status report

	error_handler: ERL_G_ERROR_HANDLER
			-- Error handler

	output_dirname: STRING
			-- Name of output directory

	defined_variables: STRING
			-- Defined variables

	ace_filename: STRING
			-- Name of ace file of input system

	type_names: DS_LINKED_LIST [STRING]
			-- Type names requested to be reflectable by user; note that
			-- dependent types will be made reflectable automatically as
			-- well.

	void_feature: BOOLEAN
			-- Shall "Void" be treated as a feature? If `False' "Void"
			-- will be treated as a keyword instead.
	
	default_types: BOOLEAN
			-- Should default types from the target systems be reflectable
			-- by default? Otherwise only the types explicltly listed
			-- will be reflectable.

feature -- Parsing

	process_arguments is
			-- Process arguments
		require
			error_hanlder_not_void: error_handler /= Void
		do
			if match_long_option ("help") then
				error_handler.enable_verbose
				error_handler.report_usage_message
				error_handler.disable_verbose
				Exceptions.die (0)
			end
			if match_long_option ("version") then
				error_handler.enable_verbose
				error_handler.report_version_message
				error_handler.disable_verbose
				Exceptions.die (0)
			end
			if match_long_option ("verbose") then
				error_handler.enable_verbose
				consume_option
			end

			if match_long_option ("void") then
				void_feature := True
				consume_option
			end

			if match_long_option ("default-types") then
				default_types := True
				consume_option
			end

			if match_long_option ("define") then
				if not is_next_option_long_option or not has_next_option_value then
					error_handler.report_missing_command_line_parameter_value_error ("--define")
					error_handler.report_usage_error
					Exceptions.die (1)
				else
					defined_variables := next_option_value
				end
				consume_option
			end

			if match_long_option ("output-dir") then
				if not is_next_option_long_option or not has_next_option_value then
					error_handler.report_missing_command_line_parameter_value_error ("--output-dir")
					error_handler.report_usage_error
					Exceptions.die (1)
				else
					output_dirname := next_option_value
				end
				consume_option
			end

			if next_option_position <= Arguments.argument_count then
				ace_filename := Arguments.argument (next_option_position)
				next_option_position := next_option_position + 1
			else
				error_handler.report_missing_ace_filename_error
				error_handler.report_usage_error
				Exceptions.die (1)
			end

			from
				create type_names.make
			until
				next_option_position > Arguments.argument_count
			loop
				type_names.force_last (Arguments.argument (next_option_position))
				next_option_position := next_option_position + 1
			end

		end
		
end
