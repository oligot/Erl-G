indexing

	description:

		"Error Handler"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class TAG_ERROR_HANDLER

inherit

	UT_ERROR_HANDLER

	TAG_VERSION
		export {NONE} all end

creation

	make_standard, make_null

feature -- Error reporting

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

	report_invalid_tag_format_error (a_format: STRING) is
			-- Report that `a_format' is not a valid tag format.
		require
			a_format_not_void: a_format /= Void
		local
			an_error: TAG_INVALID_TAG_FORMAT_ERROR
		do
			create an_error.make (a_format)
			report_error (an_error)
		end

feature -- Report messages

	report_usage_message is
			-- Report usage message.
		do
			report_info (Usage_message)
		end

	report_version_number is
			-- Report version number.
		local
			a_message: UT_VERSION_NUMBER
		do
			create a_message.make (Version_number)
			report_info (a_message)
		end

feature {NONE} -- Implementation

	Usage_message: UT_USAGE_MESSAGE is
			-- Gepp usage message.
		once
			create Result.make ("[--verbose] [--define=variables] [--void] [--reference] [--format=emacs|vi] [--output=TAGS] [filename.xace|filename.ace|filename.ecf] [--target=<ecf-target>]")
		ensure
			usage_message_not_void: Result /= Void
		end

end
