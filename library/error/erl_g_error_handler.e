indexing

	description:

		"Error Handler for erl_g"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_G_ERROR_HANDLER

inherit

	UT_ERROR_HANDLER
		redefine
			is_verbose,
			report_error_message
		end

create

	make

feature {NONE} -- Initialization

	make is
			-- Create a new error handler using the standard
			-- error file for error and warning reporting
			-- and ignoring info messages.
		do
			make_standard
			set_info_null
			set_warning_null
		ensure
			error_file_set: error_file = std.error
			warning_file_set: warning_file = null_output_stream
			info_file_set: info_file = null_output_stream
		end

feature -- Status report

	is_verbose: BOOLEAN is
			-- Is `info_file' set to something other than
			-- the null output stream?
		do
			Result := (info_file /= null_output_stream) and
						(warning_file /= null_output_stream)
		end

	has_error: BOOLEAN
			-- Has an error occured?

feature -- Status setting

	enable_verbose is
			-- Set `is_verbose' to True.
		do
			warning_file := std.output
			info_file := std.output
		ensure
			verbose: is_verbose
		end

	disable_verbose is
			-- Set `is_verbose' to False.
		do
			warning_file := null_output_stream
			info_file := null_output_stream
		ensure
			not_verbose: not is_verbose
		end

feature -- Reporting messages

	report_version_message is
			-- Report reversion message.
		do
			report_info (Version_message)
		end

feature -- Reporting errors

	report_missing_command_line_parameter_error (a_parameter_name: STRING) is
			-- Report that `a_parameter_name' has not been provided as a
			-- command line parameter.
		require
			a_parameter_name_not_void: a_parameter_name /= Void
			a_parameter_name_not_empty: not a_parameter_name.is_empty
		local
			an_error: ERL_G_MISSING_COMMAND_LINE_PARAMETER_ERROR
		do
			create an_error.make (a_parameter_name)
			report_error (an_error)
		end

	report_missing_command_line_parameter_value_error (a_parameter_name: STRING) is
			-- Report that the command line parameter `a_parameter_name'
			-- has not been provided with a value.
		require
			a_parameter_name_not_void: a_parameter_name /= Void
			a_parameter_name_not_empty: not a_parameter_name.is_empty
		local
			an_error: ERL_G_MISSING_COMMAND_LINE_PARAMETER_VALUE_ERROR
		do
			create an_error.make (a_parameter_name)
			report_error (an_error)
		end

	report_missing_ecf_filename_error is
			-- Report that no ecf filename has been provided.
		do
			report_error_message ("No ecf-filename has been provided. Please provide one for the system that you want to make reflectable.")
		end

	report_invalid_or_unknown_type_error (a_type_name: STRING) is
			-- Report that type named `a_type_name' is either invalid or unknown.
		require
			a_type_name_not_void: a_type_name /= Void
		local
			a_text: STRING
		do
			a_text := "Type " + a_type_name + " is either invalid or unknown."
			report_error_message (a_text)
		end

	report_cannot_read_error (a_filename: STRING) is
			-- Report that `a_filename' cannot be
			-- opened in read mode.
		require
			a_filename_not_void: a_filename /= Void
		local
			an_error: UT_CANNOT_READ_FILE_ERROR
		do
			create an_error.make (a_filename)
			report_error (an_error)
		end

	report_cannot_write_error (a_filename: STRING) is
			-- Report that `a_filename' cannot be
			-- opened in write mode.
		require
			a_filename_not_void: a_filename /= Void
		local
			an_error: UT_CANNOT_WRITE_TO_FILE_ERROR
		do
			create an_error.make (a_filename)
			report_error (an_error)
		end

	report_fatal_generation_error is
			-- Report that a fatal error during file generation happened.
		do
			report_error_message ("A fatal error happened during file generation")
		end

feature -- Reporting

	report_error_message (an_error: STRING) is
			-- Report `an_error'.
		do
			precursor (an_error)
			has_error := True
		ensure then
			has_error: has_error
		end

feature

	Version_message: UT_MESSAGE is
			-- 'Version' message
		once
			create Result.make ("erl_g version " + Version_number)
		ensure
			version_message_not_void: Version_message /= Void
		end

	Version_number: STRING is
			-- Current version number of erl_g
		once
			Result := "1.3.1"
		ensure
			version_number_not_void: Result /= Void
		end

end
