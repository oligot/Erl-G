
indexing

	description:

		"Common ancesstor for classes testing functionality of the request parser."

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_G_TEST_REQUEST_PARSER

inherit

	TS_TEST_CASE
		redefine
			initialize,
			set_up
		end
	
	ITP_REQUEST_PARSER
		rename
			make as make_parser
		end
		
feature

	initialize is
		do
			make_parser
			last_request := no_request_code
		end

feature -- Access

	last_request: INTEGER
			-- Type of last request;
			-- See `*_request_code' constants for possible values.
	
	last_type_name: STRING
			-- Last type name reported during a request

	last_target_variable_name: STRING
			-- Last target variable name reported during a request
			
	last_left_hand_variable_name: STRING
			-- Last left hand variable name reported during a request

	last_creation_procedure_name: STRING
			-- Last creation procedure name reported during a request
			
	last_feature_name: STRING
			-- Last feature name reported during a request

feature -- Request codes

	no_request_code: INTEGER is unique
			-- Psuedo request code, indicating that no request happened

	create_request_code: INTEGER is unique
			-- Request code for the "create" request
	
	invoke_request_code: INTEGER is unique
			-- Request code for the "invoke" request
		
	invoke_and_assign_request_code: INTEGER is unique
			-- Request code for the "invoke_and_assign" request

	assign_request_code: INTEGER is unique
			-- Request code for the "assign" request

	type_request_code: INTEGER is unique
			-- Request code for the "type" request

	quit_request_code: INTEGER is unique
			-- Request code for the "quit" request

feature -- Execution

	set_up is
			-- Setup for a test.
		do
			last_request := no_request_code
			last_type_name := Void
			last_target_variable_name := Void
			last_creation_procedure_name := Void
			last_argument_list.wipe_out
			last_expression := Void
		end

feature -- Report handlers

	report_create_request (a_type_name: STRING;
							a_target_variable_name: STRING;
							a_creation_procedure_name: STRING;
							an_argument_list: ERL_LIST [ITP_EXPRESSION]) is
		do
			last_request := create_request_code
			last_type_name := a_type_name
			last_target_variable_name := a_target_variable_name
			last_creation_procedure_name := a_creation_procedure_name
			last_argument_list := an_argument_list
		end


	report_invoke_request (a_target_variable_name: STRING;
							a_feature_name: STRING;
							an_argument_list: ERL_LIST [ITP_EXPRESSION]) is
		do
			last_request := invoke_request_code
			last_target_variable_name := a_target_variable_name
			last_feature_name := a_feature_name
			last_argument_list := an_argument_list
		end

	report_invoke_and_assign_request (a_left_hand_variable_name: STRING;
										a_target_variable_name: STRING;
										a_feature_name: STRING;
										an_argument_list: ERL_LIST [ITP_EXPRESSION]) is
		do
			last_request := invoke_and_assign_request_code
			last_left_hand_variable_name := a_left_hand_variable_name
			last_target_variable_name := a_target_variable_name
			last_feature_name := a_feature_name
			last_argument_list := an_argument_list
		end

	report_assign_request (a_left_hand_variable_name: STRING;
							an_expression: ITP_EXPRESSION) is
		do
			last_request := assign_request_code
			last_left_hand_variable_name := a_left_hand_variable_name
			last_expression := an_expression
		end
	
	report_type_request (a_variable_name: STRING) is
		do
			last_request := type_request_code
			last_left_hand_variable_name := a_variable_name
		end

	report_quit_request is
		do
			last_request := quit_request_code
		end

feature {NONE} -- Error Reporting

	report_error (a_reason: STRING) is
		do
			-- Do nothing.
		end

invariant

	valid_last_request: last_request = no_request_code or
						last_request = create_request_code or
						last_request = invoke_request_code or
						last_request = invoke_and_assign_request_code or
						last_request = assign_request_code or
						last_request = quit_request_code

end
