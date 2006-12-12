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

feature -- Parsing


	process_arguments is
		local
			parser: AP_PARSER
			version_option: AP_FLAG
			verbose_option: AP_FLAG
			void_option: AP_FLAG
			define_option: AP_STRING_OPTION
			output_dir_option: AP_STRING_OPTION
			ise_option: AP_FLAG
			ecma_option: AP_FLAG
			cs: DS_LINEAR_CURSOR [STRING]
		do
			create parser.make
			parser.set_application_description ("erl_g makes arbitrary Eiffel systems reflectable. It is used as a preprocessor.")
			parser.set_parameters_description ("ace_filename type-name+")

			create version_option.make ('V', "version")
			version_option.set_description ("Output version information and exit")
			parser.options.force_last (version_option)

			create verbose_option.make ('v', "verbose")
			verbose_option.set_description ("Be verbose.")
			parser.options.force_last (verbose_option)

			create void_option.make ('o', "void")
			void_option.set_description ("Consider 'void' a keyword.")
			parser.options.force_last (void_option)

			create define_option.make ('d', "define")
			verbose_option.set_description ("Define variable assignments for xace files")
			parser.options.force_last (define_option)

			create output_dir_option.make ('o', "output-dir")
			output_dir_option.set_description ("Output directory for reflection library")
			parser.options.force_last (output_dir_option)

			create ise_option.make ('i', "ise")
			ise_option.set_description ("Follow Eiffel as implemented in the latest version of EiffelStudio")
			parser.options.force_last (ise_option)

			create ecma_option.make ('e', "ecma")
			ecma_option.set_description ("Follow Eiffel as defined in the latest ECMA Eiffel standard")
			parser.options.force_last (ecma_option)

			parser.parse_arguments

			if version_option.was_found then
				error_handler.enable_verbose
				error_handler.report_version_message
				error_handler.disable_verbose
				Exceptions.die (0)
			end

			if verbose_option.was_found then
				error_handler.enable_verbose
			end

			if void_option.was_found then
				void_feature := True
			end

			if define_option.was_found then
				defined_variables := define_option.parameter
			end

			if output_dir_option.was_found then
				output_dirname := output_dir_option.parameter
			end

			if parser.parameters.count = 0 then
				error_handler.report_missing_ace_filename_error
				-- TODO: Display usage_instruction (currently not exported, find better way to do it.)
				-- error_handler.report_info_message (parser.help_option.usage_instruction (parser))
				Exceptions.die (1)
			else
				ace_filename := parser.parameters.first
				from
					create type_names.make
					cs := parser.parameters.new_cursor
					cs.start
					cs.forth
				until
					cs.off
				loop
					type_names.force_last (cs.item)
					cs.forth
				end
			end
		end

end
