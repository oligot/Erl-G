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

	ITP_SHARED_CONSTANT_FACTORY
		export {NONE} all end

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
			type: ERL_TYPE
			creation_procedure: ERL_CREATION_PROCEDURE
			arguments: TUPLE
			constant: ITP_CONSTANT
		do
			log_message ("report_create_request start%N")
			type := universe.type_by_name (a_type_name)
			if type = Void then
				report_error ("Unknown type " + a_type_name + ".")
			else
				if a_creation_procedure_name = Void then
					creation_procedure := type.default_creation_procedure
					if creation_procedure = Void then
						report_error ("Type " + a_type_name + " does not support default creation.")
					end
				else
					creation_procedure := type.creation_procedure_by_name (a_creation_procedure_name)
					if creation_procedure = Void then
						report_error ("`" + a_creation_procedure_name + "' is not a valid creation procedure for type " + a_type_name + ".")
					end
				end
				if creation_procedure /= Void then
					arguments := creation_procedure.empty_arguments
					if arguments.count /= an_argument_list.count then
						report_error ("Invalid number of actual arguments.")
					else
						store.fill_arguments (arguments, an_argument_list)
						if store.has_error then
							report_error ("Invalid actual arguments.")
						else
							execute_protected (agent creation_procedure.apply (arguments))
							if last_protected_execution_successfull then
								constant := constant_factory.new_constant (creation_procedure.last_result, creation_procedure.type)
								store.assign_expression (constant, a_target_variable_name)
							end
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
			target_reference: ITP_REFERENCE
			type: ERL_TYPE
			feature_: ERL_FEATURE
			routine: ERL_ROUTINE
			arguments: TUPLE
		do
			log_message ("report_invoke_request start%N")
			store.lookup_variable (a_target_variable_name)
			if not store.last_variable_defined then
				report_error ("Target variable `" + a_target_variable_name + "' not defined.")
			else
				target_reference ?= store.last_variable_value
				if target_reference = Void then
					report_error ("Feature calls on expanded types not yet supported.")
				else
					type := universe.type_by_object (target_reference.value)
					check
						type_not_void: type /= Void
					end
					feature_ := type.feature_by_name (a_feature_name)
					if feature_ = Void then
						report_error ("Type " + type.name + " does not have feature `" + a_feature_name + "'.")
					else
						routine ?= feature_
						if routine /= Void then
							arguments := routine.empty_arguments
							if arguments.count /= an_argument_list.count then
								report_error ("Invalid number of actual arguments.")
							else
								store.fill_arguments (arguments, an_argument_list)
								if store.has_error then
									report_error ("Invalid actual arguments.")
								else
									execute_protected (agent routine.apply (target_reference.value, arguments))
								end
							end
						end
					end
				end
			end
			print_and_flush ("done:%N")
			log_message ("report_invoke_request end%N")
		end

	report_invoke_and_assign_request (a_left_hand_variable_name: STRING;
										a_target_variable_name: STRING;
										a_feature_name: STRING;
										an_argument_list: ERL_LIST [ITP_EXPRESSION]) is
		local
			target_reference: ITP_REFERENCE
			type: ERL_TYPE
			query: ERL_QUERY
			arguments: TUPLE
			result_constant: ITP_CONSTANT
		do
			log_message ("report_invoke_and_assign_request start%N")
			store.lookup_variable (a_target_variable_name)
			if not store.last_variable_defined then
				report_error ("Target variable `" + a_target_variable_name + "' not defined.")
			else
				target_reference ?= store.last_variable_value
				if target_reference = Void then
					report_error ("Feature calls on expanded types not yet supported.")
				else
					type := universe.type_by_object (target_reference.value)
					check
						type_not_void: type /= Void
					end
					query := type.query_by_name (a_feature_name)
					if query = Void then
						report_error ("Type " + type.name + " does not have query `" + a_feature_name + "'.")
					else
						arguments := query.empty_arguments
						if arguments.count /= an_argument_list.count then
							report_error ("Invalid number of actual arguments.")
						else
							store.fill_arguments (arguments, an_argument_list)
							if store.has_error then
								report_error ("Invalid actual arguments.")
							else
								execute_protected (agent query.retrieve_value (target_reference.value, arguments))
								if last_protected_execution_successfull then
									result_constant := constant_factory.new_constant (query.last_result, query.result_type)
									store.assign_expression (result_constant, a_left_hand_variable_name)
								end
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
			store.assign_expression (an_expression, a_left_hand_variable_name)
			if store.has_error then
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
				print_line_and_flush (store.last_variable_value.type_name)
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

invariant

	log_file_open_write: log_file /= Void implies log_file.is_open_write
	store_not_void: store /= Void

end
