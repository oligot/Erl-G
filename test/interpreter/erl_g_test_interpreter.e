indexing

	description:

		"Black box tests for interpreter"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_INTERPRETER

inherit

	TS_TEST_CASE

	KL_SHARED_FILE_SYSTEM
		export {NONE} all end

	KL_SHARED_EXECUTION_ENVIRONMENT
		export {NONE} all end

feature -- Test

	test_1 is
			-- Run 'interpreter_example'.
		do
			assert_interpreter ("test run 1", input_1_filename, output_1_filename)
		end

	test_2 is
			-- Run 'interpreter_example'.
		do
			assert_interpreter ("test run 2", input_2_filename, output_2_filename)
		end

	test_3 is
			-- Run 'interpreter_example'.
		do
			assert_interpreter ("test run 3", input_3_filename, output_3_filename)
		end

	test_4 is
			-- Run 'interpreter_example'.
		do
			assert_interpreter ("test run 4", input_4_filename, output_4_filename)
		end

	test_5 is
			-- Run 'interpreter_example'.
		do
			assert_interpreter ("test run 5", input_5_filename, output_5_filename)
		end

	test_6 is
			-- Run 'interpreter_example'.
		do
			assert_interpreter ("test run 6", input_6_filename, output_6_filename)
		end

	test_7 is
			-- Run 'interpreter_example'.
		do
			assert_interpreter ("test run 7", input_7_filename, output_7_filename)
		end

	test_8 is
			-- Run 'interpreter_example'.
		do
			assert_interpreter ("test run 8", input_8_filename, output_8_filename)
		end

	test_9 is
			-- Run 'interpreter_example'.
		do
			assert_interpreter ("test run 9", input_9_filename, output_9_filename)
		end

feature -- Access

	program_name: STRING is "interpreter_example"
			-- Program name

feature {NONE} -- Filenames

	program_dirname: STRING is
			-- Name of program source directory
		once
			Result := file_system.nested_pathname ("${ERL_G}", <<"test", "interpreter", program_name>>)
			Result := Execution_environment.interpreted_string (Result)
		end

	program_exe: STRING is
			-- Name of program executable filename
		do
			Result := file_system.pathname (program_dirname, program_name + file_system.exe_extension)
		ensure
			program_exe_not_void: Result /= Void
			program_exe_not_empty: Result.count > 0
		end

	melt_dirname: STRING is
			-- Name of directory where melt file is stored
		do
			Result := program_dirname
		ensure
			melt_dir_not_void: Result /= Void
			melt_dir_not_empty: Result.count > 0
		end

	data_dirname: STRING is
			-- Name of directory containing expected output files
		once
			Result := file_system.pathname (program_dirname, "data")
			Result := Execution_environment.interpreted_string (Result)
		ensure
			data_dirname_not_void: Result /= Void
			data_dirname_not_empty: Result.count > 0
		end

	input_1_filename: STRING is
			-- Name of first test input file
		once
			Result := file_system.pathname (data_dirname, "test_input_1")
		ensure
			testinput1_filename_not_void: Result /= Void
			testinput1_filename_not_empty: Result.count > 0
		end

	output_1_filename: STRING is
			-- Name of first test expected output file
		once
			Result := file_system.pathname (data_dirname, "test_output_1")
		ensure
			testoutput1_filename_not_void: Result /= Void
			testoutput1_filename_not_empty: Result.count > 0
		end

	input_2_filename: STRING is
			-- Name of second test input file
		once
			Result := file_system.pathname (data_dirname, "test_input_2")
		ensure
			testinput2_filename_not_void: Result /= Void
			testinput2_filename_not_empty: Result.count > 0
		end

	output_2_filename: STRING is
			-- Name of second test expected output file
		once
			Result := file_system.pathname (data_dirname, "test_output_2")
		ensure
			testoutput2_filename_not_void: Result /= Void
			testoutput2_filename_not_empty: Result.count > 0
		end

	input_3_filename: STRING is
			-- Name of third test input file
		once
			Result := file_system.pathname (data_dirname, "test_input_3")
		ensure
			testinput3_filename_not_void: Result /= Void
			testinput3_filename_not_empty: Result.count > 0
		end

	output_3_filename: STRING is
			-- Name of third test expected output file
		once
			Result := file_system.pathname (data_dirname, "test_output_3")
		ensure
			testoutput3_filename_not_void: Result /= Void
			testoutput3_filename_not_empty: Result.count > 0
		end

	input_4_filename: STRING is
			-- Name of fourth test input file
		once
			Result := file_system.pathname (data_dirname, "test_input_4")
		ensure
			testinput4_filename_not_void: Result /= Void
			testinput4_filename_not_empty: Result.count > 0
		end

	output_4_filename: STRING is
			-- Name of fourth test expected output file
		once
			Result := file_system.pathname (data_dirname, "test_output_4")
		ensure
			testoutput4_filename_not_void: Result /= Void
			testoutput4_filename_not_empty: Result.count > 0
		end

	input_5_filename: STRING is
			-- Name of fifth test input file
		once
			Result := file_system.pathname (data_dirname, "test_input_5")
		ensure
			testinput5_filename_not_void: Result /= Void
			testinput5_filename_not_empty: Result.count > 0
		end

	output_5_filename: STRING is
			-- Name of fifth test expected output file
		once
			Result := file_system.pathname (data_dirname, "test_output_5")
		ensure
			testoutput5_filename_not_void: Result /= Void
			testoutput5_filename_not_empty: Result.count > 0
		end

	input_6_filename: STRING is
			-- Name of sixth test input file
		once
			Result := file_system.pathname (data_dirname, "test_input_6")
		ensure
			testinput6_filename_not_void: Result /= Void
			testinput6_filename_not_empty: Result.count > 0
		end

	output_6_filename: STRING is
			-- Name of sixth test expected output file
		once
			Result := file_system.pathname (data_dirname, "test_output_6")
		ensure
			testoutput6_filename_not_void: Result /= Void
			testoutput6_filename_not_empty: Result.count > 0
		end

	input_7_filename: STRING is
			-- Name of seventh test input file
		once
			Result := file_system.pathname (data_dirname, "test_input_7")
		ensure
			testinput7_filename_not_void: Result /= Void
			testinput7_filename_not_empty: Result.count > 0
		end

	output_7_filename: STRING is
			-- Name of seventh test expected output file
		once
			Result := file_system.pathname (data_dirname, "test_output_7")
		ensure
			testoutput7_filename_not_void: Result /= Void
			testoutput7_filename_not_empty: Result.count > 0
		end

	input_8_filename: STRING is
			-- Name of eighth test input file
		once
			Result := file_system.pathname (data_dirname, "test_input_8")
		ensure
			testinput8_filename_not_void: Result /= Void
			testinput8_filename_not_empty: Result.count > 0
		end

	output_8_filename: STRING is
			-- Name of eighth test expected output file
		once
			Result := file_system.pathname (data_dirname, "test_output_8")
		ensure
			testoutput8_filename_not_void: Result /= Void
			testoutput8_filename_not_empty: Result.count > 0
		end

	input_9_filename: STRING is
			-- Name of ninth test input file
		once
			Result := file_system.pathname (data_dirname, "test_input_9")
		ensure
			testinput9_filename_not_void: Result /= Void
			testinput9_filename_not_empty: Result.count > 0
		end

	output_9_filename: STRING is
			-- Name of ninth test expected output file
		once
			Result := file_system.pathname (data_dirname, "test_output_9")
		ensure
			testoutput9_filename_not_void: Result /= Void
			testoutput9_filename_not_empty: Result.count > 0
		end

feature {NONE} -- Assertions routines

	assert_interpreter (a_tag: STRING; an_input_filename: STRING; an_output_filename: STRING) is
			-- Assert `a_condition'.
		require
			a_tag_not_void: a_tag /= Void
			an_input_filename_not_void: an_input_filename /= Void
			an_output_filename_not_void: an_output_filename /= Void
		do
			execution_environment.set_variable_value ("MELT_PATH", melt_dirname)
			assert_execute (program_exe + " > interpreter_output.txt < " + an_input_filename)
			assert_files_equal (a_tag, "interpreter_output.txt", an_output_filename)
		end

end
