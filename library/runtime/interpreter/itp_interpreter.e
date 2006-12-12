indexing
	description: "[
		Interpreter for line based Eiffel like interpreter language.
		Depends on a generated Erl-G reflection library.
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ITP_INTERPRETER

inherit

	ITP_REQUEST_PARSER

	ERL_SHARED_UNIVERSE
		export {NONE} all end

	EXCEPTIONS
		export {NONE} all end

	ARGUMENTS
		export {NONE} all end

create

	execute

feature -- Processing

	execute is
			-- Execute interpreter.
		local
			nb: INTEGER
			i: INTEGER
			arg: STRING
			log_filename: STRING
		do
			make
			create store.make
			nb := argument_count
			from i := 1 until i > nb loop
				arg := argument (i)
				if arg.is_equal ("-h") or arg.is_equal ("-?") or arg.is_equal ("--help") then
					print ("usage: interpreter [-output=filename] [log_filename]%N")
					io.output.flush
					die (0)
				elseif i = nb then
					log_filename := arg
				else
					print ("usage: interpreter [-output=filename] [log_filename]%N")
					io.output.flush
					die (1)
				end
				i := i + 1
			end
			if log_filename /= Void then
				create log_file.make_open_append (log_filename)
				if not log_file.is_open_write then
					print ("error: could not open log file '" + log_filename + "'.")
					die (1)
				end
			end
			main_loop
			if log_file /= Void then
				log_file.close
			end
		rescue
			print ("error: internal error.%N")
			if log_file /= Void and then log_file.is_open_write then
				log_file.put_string ("<error type='internal'/>%N")
				log_file.put_string ("</session>%N")
				log_file.close
			end
			die (1)
		end

	main_loop is
			-- Main loop
		local
			input_line: STRING
		do
			log_message ("<session>%N")
			from
			until
				should_quit or io.input.end_of_file
			loop
				io.input.read_line
				input_line := io.input.last_string
				if input_line = Void then
					print_and_flush ("error: empty input%N")
				else
					set_input (input_line)
					parse
				end
			end
			log_message ("</session>%N")
		end

feature {NONE} -- Handlers

	report_create_request (a_type_name: STRING;
							a_target_variable_name: STRING;
							a_creation_procedure_name: STRING;
							an_argument_list: ERL_LIST [ITP_EXPRESSION]) is
		local
			class_: ERL_CLASS
			arguments: ARRAY [ANY]
			actuals: STRING
			l_class_name: STRING
		do
			log_message ("report_create_request start%N")
			create l_class_name.make (a_type_name.count)
			create actuals.make (a_type_name.count)
			split_type_name (a_type_name, l_class_name, actuals)
			class_ := universe.class_by_name (l_class_name)
			if class_ = Void then
				report_error ("Unknown class " + l_class_name + ".")
			elseif not class_.is_instantiatable (actuals) then
				report_error ("Type '" + a_type_name + "' is not instantiatable.")
			else
				if not class_.is_valid_creation_procedure_name (actuals, a_creation_procedure_name) then
					if a_creation_procedure_name = Void then
						report_error ("Type " + a_type_name + " does not support default creation.")
					else
						report_error ("`" + a_creation_procedure_name + "' is not a valid creation procedure for type " + a_type_name + ".")
					end
				else
					arguments := store.arguments (an_argument_list)
					if arguments = Void or not class_.valid_creation_procedure_arguments (actuals, a_creation_procedure_name, arguments) then
						report_error ("Invalid actual arguments.")
					else
						execute_protected (agent class_.invoke_creation_procedure (actuals, a_creation_procedure_name, arguments))
						if last_protected_execution_successfull then
							store.assign_value (class_.last_result, a_target_variable_name)
						end
					end
				end
			end
			print_and_flush ("done:%N")
			log_message ("report_create_request end%N")
		end

	report_invoke_request (a_target_variable_name: STRING;
							a_feature_name: STRING;
							an_argument_list: ERL_LIST [ITP_EXPRESSION]) is
		local
			target: ANY
			class_: ERL_CLASS
			arguments: ARRAY [ANY]
		do
			log_message ("report_invoke_request start%N")
			store.lookup_variable (a_target_variable_name)
			if not store.last_variable_defined then
				report_error ("Target variable `" + a_target_variable_name + "' not defined.")
			else
				target := store.last_variable_value
				if target = Void then
					report_error ("Cannot invoke feature on void target.")
				else
					class_ := universe.class_by_object (target)
						check
							class_not_void: class_ /= Void
						end
					if not class_.is_valid_feature_name (a_feature_name) then
						report_error ("Class " + class_.name + " does not have feature `" + a_feature_name + "'.")
					else
						arguments := store.arguments (an_argument_list)
						if arguments = Void or not class_.valid_feature_operands (a_feature_name, target, arguments) then
							report_error ("Invalid actual arguments.")
						else
							execute_protected (agent class_.invoke_feature (a_feature_name, target, arguments))
						end
					end
				end
			end
			print_and_flush ("done:%N")
			log_message ("report_invoke_request end%N")
		end

	report_invoke_and_assign_request (a_left_hand_variable_name: STRING;
										a_target_variable_name: STRING;
										a_query_name: STRING;
										an_argument_list: ERL_LIST [ITP_EXPRESSION]) is
		local
			target: ANY
			class_: ERL_CLASS
			arguments: ARRAY [ANY]
		do
			log_message ("report_invoke_and_assign_request start%N")
			store.lookup_variable (a_target_variable_name)
			if not store.last_variable_defined then
				report_error ("Target variable `" + a_target_variable_name + "' not defined.")
			else
				target := store.last_variable_value
				if target = Void then
					report_error ("Cannot invoke feature on void target.")
				else
					class_ := universe.class_by_object (target)
					check
						class_not_void: class_ /= Void
					end
					if not class_.is_valid_query_name (a_query_name) then
						report_error ("Class " + class_.name + " does not have query `" + a_query_name + "'.")
					else
						arguments := store.arguments (an_argument_list)
						if arguments = Void or not class_.valid_feature_operands (a_query_name, target, arguments) then
							report_error ("Invalid actual arguments.")
						else
							execute_protected (agent class_.invoke_query (a_query_name, target, arguments))
							if last_protected_execution_successfull then
								store.assign_value (class_.last_result, a_left_hand_variable_name)
							end
						end
					end
				end
			end
			print_and_flush ("done:%N")
			log_message ("report_invoke_and_assign_request end%N")
		end

	report_assign_request (a_left_hand_variable_name: STRING;
							an_expression: ITP_EXPRESSION) is
		do
			log_message ("report_assign_request start%N")
			if store.is_expression_defined (an_expression) then
				store.assign_expression (an_expression, a_left_hand_variable_name)
				if store.has_error then
					report_error ("Could not evaluate expression")
				end
			else
				report_error ("Could not evaluate expression")
			end
			print_and_flush ("done:%N")
			log_message ("report_assign_request end%N")
		end

	report_type_request (a_variable_name: STRING) is
		do
			log_message ("report_type_request start%N")
			store.lookup_variable (a_variable_name)
			if not store.last_variable_defined then
				report_error ("Variable `" + a_variable_name + "' not defined.")
			else
				if store.last_variable_value = Void then
					print_and_flush ("NONE%N")
				else
					print_and_flush (store.last_variable_value.generating_type)
					print_and_flush ("%N")
				end
			end
			print_and_flush ("done:%N")
			log_message ("report_type_request end%N")
		end

	report_quit_request is
		do
			should_quit := True
		end

feature {NONE} -- Error Reporting

	report_error (a_reason: STRING) is
		do
			print_and_flush ("error: " + a_reason + "%N")
		end

feature {NONE} -- Logging

	log_instance (an_object: ANY) is
			-- Log an XML representation of `an_object' to `log_file'.
		do
			log_message ("<instance<![CDATA[%N")
			if an_object = Void then
				log_message ("Void%N")
			else
				log_message (an_object.tagged_out)
			end
			log_message ("]]>%N</instance>%N")
		end

	log_message (a_message: STRING) is
			-- Log message `a_messgae' to `log_message'.
		require
			a_message_not_void: a_message /= Void
		do
			if log_file /= Void then
				log_file.put_string (a_message)
			end
		end

	log_file: PLAIN_TEXT_FILE
			-- Log file

feature {NONE} -- Implementation

	execute_protected (procedure: PROCEDURE [ANY, TUPLE]) is
			-- Execute `procedure' in a protected way.
		local
			failed: BOOLEAN
			l_exception: INTEGER
			l_recipient_name: STRING
			l_class_name: STRING
			l_tag_name: STRING
			l_meaning: STRING
			l_exception_trace: STRING
		do
			last_protected_execution_successfull := False
			if not failed then
				print_multi_line_value_start_tag
				procedure.apply
				print_multi_line_value_end_tag
				print_and_flush ("status: success%N")
				last_protected_execution_successfull := True
			end
		rescue
			failed := True
			print_multi_line_value_end_tag
			l_exception := exception
			l_tag_name := tag_name
			l_recipient_name := recipient_name
			l_class_name := class_name
			l_meaning := meaning (l_exception)
			l_exception_trace := exception_trace

			if l_recipient_name = Void then
				l_recipient_name := ""
			end
			check
				l_class_name_not_void: l_class_name /= Void
			end
			if l_tag_name = Void then
				l_tag_name := ""
			end
			if l_meaning = Void then
				l_meaning := ""
			end
			print_line_and_flush ("status: exception")
			print_line_and_flush (l_exception.out)
			print_line_and_flush (l_recipient_name)
			print_line_and_flush (l_class_name)
			print_line_and_flush (l_tag_name)
			print_multi_line_value_start_tag
			print_line_and_flush (l_exception_trace)
			print_multi_line_value_end_tag
			log_message ("<call_result type='exception'>%N")
			log_message ("%T<meaning value='" + l_meaning + "'/>%N")
			log_message ("%T<tag value='" + l_tag_name + "'/>%N")
			log_message ("%T<recipient value='" + l_recipient_name + "'/>%N")
			log_message ("%T<class value='" + l_class_name + "'>%N")
			log_message ("%T<exception_trace>%N<![CDATA[%N")
			log_message (l_exception_trace)
			log_message ("]]>%N</exception_trace>%N")
			log_message ("</call_result>%N")
			if l_exception = Class_invariant then
				-- A class invariant cannot be recovered from since we
				-- don't know how many and what objects are now invalid
				should_quit := True
			end
			retry
		end

	last_protected_execution_successfull: BOOLEAN
			-- Was the last protected execution successfull?
			-- (i.e. did it not trigger an exception)

	should_quit: BOOLEAN
			-- Should main loop quit?

	store: ITP_STORE
			-- Object store

	multi_line_value_start_tag: STRING is "---multi-line-value-start---"
			-- Multi line start tag

	multi_line_value_end_tag: STRING is "---multi-line-value-end---"
			-- Multi line end tag

	print_and_flush (a_text: STRING) is
			-- Print `a_text' and flush output stream.
		require
			a_text_not_void: a_text /= Void
		do
			print (a_text)
			io.output.flush
		end

	print_line_and_flush (a_text: STRING) is
			-- Print `a_text' followed by a newline and flush output stream.
		require
			a_text_not_void: a_text /= Void
		do
			print (a_text)
			io.output.put_new_line
			io.output.flush
		end

	print_multi_line_value_start_tag is
			-- Print the start tag for a multi line value.
		do
			print_and_flush (multi_line_value_start_tag)
			print_and_flush ("%N")
		end

	print_multi_line_value_end_tag is
			-- Print the start tag for a multi line value.
		do
			print_and_flush (multi_line_value_end_tag)
			print_and_flush ("%N")
		end

	split_type_name (a_type_name: STRING; a_class_name: STRING; a_actuals: STRING) is
			-- Split the type name `a_type_name' into its class name and
			-- actuals and fill `a_class_name' and `a_actuals' correspondingly.
			-- Typename needs to be normalized.
		require
			a_type_name_not_void: a_type_name /= Void
			a_class_name_not_void: a_class_name /= Void
			a_actuals_not_void: a_actuals /= Void
		local
			i: INTEGER
			nb: INTEGER
			in_actuals: BOOLEAN
			char: CHARACTER
		do
			i := a_type_name.index_of (' ', 1)
			if i = 0 then
				a_class_name.share (a_type_name)
			else
				if i > 1 then
					a_class_name.share (a_type_name.substring (1, i - 1))
				end
				if i + 1 <= a_type_name.count then
					a_actuals.share (a_type_name.substring (i + 1, a_type_name.count))
				end
			end
		end

invariant

	log_file_open_write: log_file /= Void implies log_file.is_open_write
	store_not_void: store /= Void

end
