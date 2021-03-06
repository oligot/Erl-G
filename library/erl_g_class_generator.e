indexing
	description	: "Generates meta-class for a given class"
	author		: "Andreas Leitner"
	date		: "$Date$"
	revision	: "1.0.0"

class ERL_G_CLASS_GENERATOR

inherit

	ERL_G_TYPE_ROUTINES
		rename
			base_type as base_type
		export
			{NONE} all
		end

	KL_SHARED_STREAMS
		export {NONE} all end

	KL_IMPORTED_INTEGER_ROUTINES
		export {NONE} all end

create

	make

feature {NONE} -- Initialization

	make (a_reflection_generator: like reflection_generator) is
			-- Create new reflection type generator.
		require
			a_reflection_generator_not_void: a_reflection_generator /= Void
		do
			reflection_generator := a_reflection_generator
			create output_stream.make (null_output_stream)
			create ast_printer.make_null
		ensure
			reflection_generator_set: reflection_generator = a_reflection_generator
		end

feature -- Status report

	has_fatal_error: BOOLEAN
			-- Has a fatal error occurred while generating?

feature -- Generation

	generate (a_file: KI_TEXT_OUTPUT_STREAM;
				a_class: like class_) is
			-- Generate reflection class for `a_class' to `a_file' and
			-- set `has_fatal_error' to `True' if generation cannot be
			-- completed due to fatal errors.
		require
			a_file_not_void: a_file /= Void
			a_file_open_write: a_file.is_open_write
			a_class_not_void: a_class /= Void
		do
			class_ := a_class
			if class_.is_generic then
				type := generic_derivation (class_, reflection_generator.universe)
			else
				type := class_
			end
			output_stream.set_output_stream (a_file)
			ast_printer.set_file (output_stream)

			generate_indexing
			generate_class_clause
			generate_inheritance_clause
			generate_create_clause
			generate_status_report_features
			output_stream.put_new_line
			generate_access_features
			output_stream.put_new_line
			generate_implementation_features
			output_stream.put_string ("end")
			output_stream.put_new_line
			ast_printer.set_null_file
		end

feature {NONE} -- Generation of top level constructs

	generate_indexing is
			-- Generate indexing clause for reflection class.
		require
			class_not_void: class_ /= Void
		do
			output_stream.put_line ("indexing")
			output_stream.indent
			output_stream.put_string ("description: %"Reflection class for class ")
			output_stream.put_string (class_.to_text)
			output_stream.put_line ("%"")
			output_stream.put_line ("warning: %"Generated by Erl-G. Do not edit. Changes will be lost.%"")
			output_stream.dedent
			output_stream.put_new_line
		end

	generate_class_clause is
			-- Generate class clause for reflection class.
		require
			class_not_void: class_ /= Void
		do
			output_stream.put_string ("class ")
			output_stream.put_line (reflection_generator.meta_class_name (class_))
			output_stream.put_new_line
			output_stream.put_new_line
		end

	generate_inheritance_clause is
			-- Generate inheritance clause for reflection class.
		require
			class_not_void: class_ /= Void
		do
			output_stream.put_line ("inherit")
			output_stream.indent
			output_stream.put_line ("ERL_CLASS")
			output_stream.put_new_line
			output_stream.put_line ("ERL_SHARED_UNIVERSE")
			output_stream.dedent
			output_stream.put_new_line
		end

	generate_create_clause is
			-- Generate creation clause for reflection class.
		require
			class_not_void: class_ /= Void
		do
			output_stream.put_string ("create")
			output_stream.put_new_line
			output_stream.put_new_line
			output_stream.indent
			output_stream.put_string ("make")
			output_stream.dedent
			output_stream.put_new_line
			output_stream.put_new_line
		end

	generate_status_report_features is
			-- Generate features in "Status report" feature clause for reflection class.
		require
			class_not_void: class_ /= Void
		do
			output_stream.put_line ("feature -- Status report")
			output_stream.put_new_line

			output_stream.indent
			generate_name_feature
			output_stream.put_new_line
			generate_is_expanded_feature
			output_stream.put_new_line
			generate_is_basic_class_feature
			output_stream.put_new_line
			output_stream.dedent
		end

	generate_access_features is
			-- Generate features in "Access" feature clause for reflection class.
		require
			class_not_void: class_ /= Void
		do
			output_stream.put_line ("feature -- Access")
			output_stream.put_new_line

			output_stream.indent
			generate_is_instanciatable_feature
			output_stream.put_new_line
			generate_parents_feature
			output_stream.put_new_line
			output_stream.dedent
		end

	generate_implementation_features is
			-- Generate features in "Implemenetation" feature clause for reflection class.
		require
			class_not_void: class_ /= Void
		do
			output_stream.put_line ("feature {NONE} -- Implementation")
			output_stream.put_new_line

			output_stream.indent
			generate_creation_function_feature
			output_stream.put_new_line
			generate_immediate_feature_feature
			output_stream.put_new_line
			generate_immediate_query_feature
			output_stream.put_new_line
			output_stream.dedent
		end

feature {NONE} -- Generation of features beloging to the "Status Report" feature clause

	generate_name_feature is
			-- Generate `name' feature for reflection class.
		require
			class_not_void: class_ /= Void
		do
			output_stream.put_string ("name: STRING is %"")
			output_stream.put_string (class_.name.name)
			output_stream.put_line ("%"")
		end

	generate_is_expanded_feature is
			-- Generate `is_expanded' feature for reflection class.
		require
			class_not_void: class_ /= Void
		do
			output_stream.put_string ("is_expanded: BOOLEAN is ")
			if class_.is_expanded then
				output_stream.put_line ("True")
			else
				output_stream.put_line ("False")
			end
		end

	generate_is_basic_class_feature is
			-- Generate `is_basic_class' for reflection class.
		require
			class_not_void: class_ /= Void
		do
			output_stream.put_string ("is_basic_class: BOOLEAN is ")
			if
				is_basic_class (class_, reflection_generator.universe)
			then
				output_stream.put_line ("True")
			else
				output_stream.put_line ("False")
			end
		end

feature {NONE} -- Generation of features belonging to the "Access" feature clause

	generate_is_instanciatable_feature is
			-- Generate feature `is_instanciatable_feature'.
		local
			types: DS_LINEAR [ET_BASE_TYPE]
			cs: DS_LINEAR_CURSOR [ET_BASE_TYPE]
			actuals: ET_ACTUAL_PARAMETER_LIST
		do
			output_stream.put_line ("is_instantiatable (a_actuals: STRING): BOOLEAN is")
			output_stream.indent
			output_stream.put_line ("do")
			output_stream.indent
			output_stream.put_string ("Result := ")
			types := reflection_generator.creatable_types_of_class (class_)
			if types = Void then
				output_stream.put_line ("False")
			else
				from
					cs := types.new_cursor
					cs.start
				until
					cs.off
				loop
					output_stream.put_string ("a_actuals.is_equal (%"")
					actuals := cs.item.actual_parameters
					if actuals /= Void then
						generate_actual_parameter_list (actuals)
					end
					output_stream.put_line ("%")")
					cs.forth
					if not cs.off then
						output_stream.put_string ("or ")
					end
				end
			end
			output_stream.dedent
			output_stream.put_line ("end")
			output_stream.dedent
		end

	generate_parents_feature is
			-- Generate feature `is_valid_query_name'.
		local
			i: INTEGER
		do
			output_stream.put_line ("parents: ARRAY [ERL_CLASS] is")
			output_stream.indent
			output_stream.put_line ("do")
			output_stream.indent
			output_stream.put_string ("Result := <<")
			if	class_ = reflection_generator.universe.any_class then
					-- No parent
			elseif class_.parents = Void then
				output_stream.put_string ("universe.class_by_name (%"ANY%")")
			else
				from
					i := 1
				until
					i > class_.parents.count
				loop
					output_stream.put_string ("universe.class_by_name (%"")
					output_stream.put_string (class_.parents.item (i).parent.type.base_class.name.name)
					output_stream.put_string ("%")")
					i := i + 1
					if i <= class_.parents.count then
						output_stream.put_string (", ")
					end
				end
			end
			output_stream.put_line (">>")
			output_stream.dedent
			output_stream.put_line ("end")
			output_stream.dedent
		end

feature {NONE} -- Generation of features belonging to the "Implementation" feature clause


	generate_creation_function_feature is
			-- Generate feature `creation_function_feature'.
		local
			cs: DS_LINEAR_CURSOR [ET_BASE_TYPE]
			actuals: ET_ACTUAL_PARAMETER_LIST
		do
			output_stream.put_line ("creation_function (a_actuals: STRING; a_name: STRING): FUNCTION [ANY, TUPLE, ANY] is")
			output_stream.indent
			output_stream.put_line ("local")
			output_stream.indent
			output_stream.put_line ("i: INTEGER")
			output_stream.put_line ("c: CHARACTER")
			output_stream.dedent
			output_stream.put_line ("do")
			output_stream.indent
			if not is_basic_class (class_, reflection_generator.universe) then
				from
					cs := reflection_generator.creatable_types_of_class (class_).new_cursor
					cs.start
				until
					cs.off
				loop
					output_stream.put_string ("if a_actuals.is_equal (%"")
					actuals := cs.item.actual_parameters
					if actuals /= Void then
						generate_actual_parameter_list (actuals)
					end
					output_stream.put_line ("%") then")
					output_stream.indent
					generate_creation_function_result (cs.item)
					output_stream.dedent
					output_stream.put_line ("end")
					cs.forth
				end
			end
			output_stream.dedent
			output_stream.put_line ("end")
			output_stream.dedent
		end

	generate_creation_function_result (a_type: ET_BASE_TYPE) is
			-- Create Result expression for feature
			-- `creation_function_feature' creatable type `a_type' with
			-- base class `class_'.
		local
			count: INTEGER
			creator_index: INTEGER
			feature_index: INTEGER
			creator: ET_CREATOR
			procedure: ET_PROCEDURE
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			j: INTEGER
			name: STRING
			l_type: ET_TYPE
		do
			count := creation_procedure_count (a_type, class_, reflection_generator.universe)
			create list.make (count)
			if count > 0 then
				if is_default_creatable (class_, reflection_generator.universe) then
					name := ("agent : ANY do create {").twin
					name.append_string (a_type.to_text)
					name.append_string ("} Result end")
					create pair.make (name, "")
					list.force_last (pair)
				end
				if class_.creators /= Void then
					from
						creator_index := 1
					until
						creator_index > class_.creators.count
					loop
						creator := class_.creators.item (creator_index)
						if creator.clients.has_class (reflection_generator.universe.any_class) then
							from
								feature_index := 1
							until
								feature_index > creator.count
							loop
								procedure := class_.named_procedure (creator.feature_name (feature_index))
								name := ("agent ").twin
								if procedure.arguments /= Void then
									name.append_string ("(")
									from
										j := 1
									until
										j > procedure.arguments.count
									loop
										name.append_string ("a_param_")
										name.append_integer (j)
										name.append_string (": ")
										l_type := procedure.arguments.formal_argument (j).type
										l_type := l_type.base_type (a_type)
										name.append_string (l_type.to_text)
										j := j + 1
										if j <= procedure.arguments.count then
											name.append_string ("; ")
										end
									end
									name.append_string (")")
								end
								name.append_string (": ANY")
								name.append_string (" do create {")
								name.append_string (a_type.to_text)
								name.append_string ("} Result.")
								name.append_string (procedure.name.name)
								if procedure.arguments /= Void then
									name.append_string ("(")
									from
										j := 1
									until
										j > procedure.arguments.count
									loop
										name.append_string ("a_param_")
										name.append_integer (j)
										j := j + 1
										if j <= procedure.arguments.count then
											name.append_string (", ")
										end
									end
									name.append_string (")")
								end
								name.append_string (" end")
								create pair.make (name, procedure.name.name)
								list.force_last (pair)
								feature_index := feature_index + 1
							end
						end
						creator_index := creator_index + 1
					end
				end
			end
			create printer.make (output_stream)
			printer.print_item_by_name_switch_block ("a_name", list)
		end

	generate_immediate_feature_feature is
			-- Generate feature `immedate_feature'.
		local
			count: INTEGER
			i: INTEGER
			j: INTEGER
			feature_: ET_FEATURE
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			type_name: STRING
			parent: ET_PARENT
			rename_: ET_RENAME
			expression: STRING
		do
			if is_basic_class (class_, reflection_generator.universe) then
				create list.make (0)
			else
				if not class_.is_generic then
					type_name := class_.name.name
				else
					type_name := generic_derivation (class_, reflection_generator.universe).to_text
				end
					-- Immediate features
				count := true_feature_count (class_)
				from
					create list.make (count)
					i := 1
				until
					i > count
				loop
					feature_ := true_feature (class_, i)
					if
						is_supported (feature_) and
						feature_.implementation_class = class_ and
						feature_.first_precursor = Void
					then
						list.put_last (agent_entry (feature_, type_name))
					end
					i := i + 1
				end
					-- Renamed features
				if class_.parents /= Void then
					from
						i := 1
					variant
						class_.parents.count - i + 1
					until
						i > class_.parents.count
					loop
						parent := class_.parents.item (i).parent
						if parent.renames /= Void then
							from
								j := 1
							variant
								parent.renames.count - j + 1
							until
								j > parent.renames.count
							loop
								rename_ := parent.renames.item (j).rename_pair
								feature_ := class_.named_feature (rename_.new_name.feature_name)
								check
									feature_not_void: feature_ /= Void
								end
								if is_supported (feature_) then
									list.put_last (agent_entry (feature_, type_name))
								end
								j := j + 1
							end
						end
						i := i + 1
					end
				end
			end
			create printer.make (output_stream)
			printer.print_item_by_name_query ("immediate_feature", "ROUTINE [ANY, TUPLE]", list)
		end

	generate_immediate_query_feature is
			-- Generate feature `immediate_query'.
		local
			count: INTEGER
			i: INTEGER
			j: INTEGER
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			type_name: STRING
			query: ET_QUERY
			feature_: ET_FEATURE
			parent: ET_PARENT
			rename_: ET_RENAME
			expression: STRING
		do
			if is_basic_class (class_, reflection_generator.universe) then
				create list.make (0)
			else
				if not class_.is_generic then
					type_name := class_.name.name
				else
					type_name := generic_derivation (class_, reflection_generator.universe).to_text
				end
				count := true_feature_count (class_)
				from
					create list.make (count)
					i := 1
				until
					i > count
				loop
					feature_ := true_feature (class_, i)
					query ?= feature_
					if query /= Void then
						if
							is_supported (feature_) and
							feature_.implementation_class = class_ and
							feature_.first_precursor = Void
						then
							list.put_last (agent_entry (feature_, type_name))
						end
					end
					i := i + 1
				end
					-- Renamed features
				if class_.parents /= Void then
					from
						i := 1
					variant
						class_.parents.count - i + 1
					until
						i > class_.parents.count
					loop
						parent := class_.parents.item (i).parent
						if parent.renames /= Void then
							from
								j := 1
							variant
								parent.renames.count - j + 1
							until
								j > parent.renames.count
							loop
								rename_ := parent.renames.item (j).rename_pair
								query := class_.named_query (rename_.new_name.feature_name)
								if query /= Void then
									if is_supported (query) then
										list.put_last (agent_entry (query, type_name))
									end
								end
								j := j + 1
							end
						end
						i := i + 1
					end
				end
			end
			create printer.make (output_stream)
			printer.print_item_by_name_query ("immediate_query", "FUNCTION [ANY, TUPLE, ANY]", list)
		end

	is_supported (a_feature: ET_FEATURE): BOOLEAN is
			-- Is `a_feature' supported for reflection ?
		require
			a_feature_not_void: a_feature /= Void
		do
			Result := 	a_feature.clients.has_class (reflection_generator.universe.any_class) and
					not a_feature.name.is_infix and not a_feature.name.is_prefix
		end

	agent_entry (a_feature: ET_FEATURE; a_type_name: STRING): DS_PAIR [STRING, STRING] is
			-- Agent entry pair for feature `a_feature' apprearing in type named `a_type_name' suitable for lookup printer
		require
			a_feature_not_void: a_feature /= Void
			a_type_name_not_void: a_type_name /= Void
		local
			expression: STRING
			stream: KL_STRING_OUTPUT_STREAM
			old_stream: KI_CHARACTER_OUTPUT_STREAM
			constant: ET_CONSTANT_ATTRIBUTE
		do
			if a_feature.is_attribute then
				create expression.make (9 + class_.name.name.count + a_feature.name.name.count)
				expression.append_string ("agent attribute_value (%"")
				expression.append_string (a_feature.name.name)
				expression.append_string ("%", ?)")
			elseif a_feature.is_unique_attribute then
				-- TODO: currently we lie about the value of unique attributes
				expression := "agent identity (0, ?)"
			elseif a_feature.is_constant_attribute then
				old_stream := ast_printer.file
				create stream.make_empty
				ast_printer.set_file (stream)
				constant ?= a_feature
				constant.constant.process (ast_printer)
				ast_printer.set_file (old_stream)
				create expression.make (19 + stream.string.count)
				expression.append_string ("agent identity (")
				expression.append_string (stream.string)
				expression.append_string (", ?)")
			else
				create expression.make (9 + class_.name.name.count + a_feature.name.name.count)
				expression.append_string ("agent {")
				expression.append_string (a_type_name)
				expression.append_string ("}.")
				expression.append_string (a_feature.name.name)
			end
			create Result.make (expression, a_feature.name.name)
		ensure
			agent_entry_not_void: Result /= Void
		end



	generate_formal_argument_list (a_list: ET_FORMAL_ARGUMENT_LIST) is
			-- Generate code that creates a list filled with the formal arguments from `a_list'
		require
			class_not_void: class_ /= Void
		local
			i: INTEGER
			an_argument: ET_FORMAL_ARGUMENT
			argument_base_type: ET_BASE_TYPE
		do
			output_stream.put_string ("create arguments.make_with_capacity (")
			if a_list = Void then
				output_stream.put_string ("0")
			else
				output_stream.put_string (a_list.count.out)
			end
			output_stream.put_line (")")
			if a_list /= Void then
				from
					i := 1
				until
					i > a_list.count
				loop
					an_argument := a_list.item (i).formal_argument
					output_stream.put_string ("arguments.put_last ( create {ERL_ARGUMENT_IMP}.make (%"")
					output_stream.put_string (an_argument.formal_argument.name.name)
					output_stream.put_string ("%", universe.type_by_name (%"")
					argument_base_type :=  an_argument.type.base_type (type)
					output_stream.put_string (argument_base_type.to_text)
					output_stream.put_line ("%")))")
					i := i + 1
				end
			end
		end

	generate_actual_parameter_list (an_actuals: ET_ACTUAL_PARAMETER_LIST) is
			-- Generate sequence of actuals from `an_actuals'.
		require
			an_actuals_not_void: an_actuals /= Void
		local
			i: INTEGER
			count: INTEGER
		do
			output_stream.put_character ('[')
			from
				i := 1
				count := an_actuals.count
			until
				i > count
			loop
				an_actuals.item (i).process (ast_printer)
				i := i + 1
				if i <= count then
					output_stream.put_string (", ")
				end
			end
			output_stream.put_character (']')
		end

feature {NONE} -- Implementation

	escaped_string (a_string: STRING): STRING is
			-- Clone of `a_string' except that all occurences of double quotes are
			-- escaped with the '%' character.
		require
			a_string_not_void: a_string /= Void
		local
			i: INTEGER
			c: CHARACTER
		do
			if a_string.has ('"') then
				from
					i := 1
					create Result.make (a_string.count + a_string.occurrences ('"'))
				variant
					a_string.count - i + 1
				until
					i > a_string.count
				loop
					c := a_string.item (i)
					if c = '"' then
						Result.append_character ('%%')
					end
					Result.append_character (c)
					i := i + 1
				end
			else
				Result := a_string
			end
		ensure
			escaped_string_not_void: Result /= Void
			escaped_string_bigger_equal: Result.count = a_string.count + a_string.occurrences ('"')
			no_quotes_same_string: not a_string.has ('"') = (Result = a_string)
		end


	output_stream: ERL_G_INDENTING_TEXT_OUTPUT_FILTER
			-- Output stream for code generation

	reflection_generator: ERL_G_GENERATOR
			-- Main reflection generator

	type: ET_BASE_TYPE
			-- Type with base class `class_' to which all type derivations of `class_' conform to.

	class_: ET_CLASS
			-- Class for which we want to generate a reflection class

	ast_printer: ET_AST_PRINTER

invariant

	output_stream_not_void: output_stream /= Void
	reflection_generator_not_void: reflection_generator /= Void
	ast_printer_not_void: ast_printer /= Void
	class_not_void_means_type_not_void: class_ /= Void implies type /= Void
	base_class_of_type_valid: class_ /= Void implies type.base_class = class_

end
