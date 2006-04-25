indexing
	description	: "Generates meta-class for a given type"
	author		: "Andreas Leitner"
	date		: "$Date$"
	revision	: "1.0.0"

class ERL_G_TYPE_GENERATOR

inherit

	ERL_G_TYPE_ROUTINES
		rename
			base_type as base_type_from_string
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
			output_stream := null_output_stream
			create ast_printer.make_null (reflection_generator.universe)
		ensure
			reflection_generator_set: reflection_generator = a_reflection_generator
		end

feature -- Status report

	has_fatal_error: BOOLEAN
			-- Has a fatal error occurred while generating?

feature -- Generation

	generate (a_file: KI_TEXT_OUTPUT_STREAM;
				a_base_type: like base_type;
				a_meta_class_name: STRING) is
			-- Generate reflection class for `a_base_type' to `a_file'.
			-- Use `a_meta_class_name' as the name for the reflection class.
			-- Sets `has_fatal_error' to `True' if generation cannot be completed.
		require
			a_file_not_void: a_file /= Void
			a_file_open_write: a_file.is_open_write
			a_base_type_not_void: a_base_type /= Void
			a_meta_class_name_not_void: a_meta_class_name /= Void
			a_meta_class_name_not_empty: not a_meta_class_name.is_empty
		do
			base_type := a_base_type
			base_class := a_base_type.context_base_class (reflection_generator.universe)
			meta_class_name := a_meta_class_name

			output_stream := a_file
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
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		do
			output_stream.put_line ("indexing")
			output_stream.put_string ("%Tdescription: %"Reflection class for type ")
			output_stream.put_string (base_type.to_text)
			output_stream.put_line ("%"")
			output_stream.put_line ("%Tnote: %"Generated class. Do not edit.%"")
			output_stream.put_new_line
		end

	generate_class_clause is
			-- Generate class clause for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
			meta_class_name_not_void: meta_class_name /= Void
			meta_class_name_not_empty: not meta_class_name.is_empty
		do
			output_stream.put_string ("class ")
			output_stream.put_line (meta_class_name)
			output_stream.put_new_line
			output_stream.put_new_line
		end

	generate_inheritance_clause is
			-- Generate inheritance clause for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		do
			output_stream.put_line ("inherit")
			output_stream.put_line ("%TERL_ABSTRACT_TYPE_IMP")
			output_stream.put_new_line
			output_stream.put_line ("%TERL_SHARED_UNIVERSE")
			output_stream.put_new_line
		end

	generate_create_clause is
			-- Generate creation clause for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		do
			output_stream.put_string ("create")
			output_stream.put_new_line
			output_stream.put_new_line
			output_stream.put_string ("%Tmake")
			output_stream.put_new_line
			output_stream.put_new_line
		end

	generate_status_report_features is
			-- Generate features in "Status report" feature clause for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		do
			output_stream.put_line ("feature -- Status report")
			output_stream.put_new_line

			generate_name_feature
			output_stream.put_new_line
			generate_is_expanded_feature
			output_stream.put_new_line
			generate_is_basic_type_feature
			output_stream.put_new_line
			generate_creation_procedure_count_feature
			output_stream.put_new_line
			generate_feature_count_feature
			output_stream.put_new_line
			generate_query_count_feature
			output_stream.put_new_line
			generate_attribute_count_feature
			output_stream.put_new_line
			generate_function_count_feature
			output_stream.put_new_line
			generate_procedure_count_feature
			output_stream.put_new_line
		end

	generate_access_features is
			-- Generate features in "Access" feature clause for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		do
			output_stream.put_line ("feature -- Access")
			output_stream.put_new_line
			generate_creation_procedure_by_index_feature
			output_stream.put_new_line
			generate_creation_procedure_by_name_feature
			output_stream.put_new_line
			generate_feature_by_index_feature
			output_stream.put_new_line
			generate_feature_by_name_feature
			output_stream.put_new_line
			generate_query_by_index_feature
			output_stream.put_new_line
			generate_query_by_name_feature
			output_stream.put_new_line
			generate_attribute_by_index_feature
			output_stream.put_new_line
			generate_attribute_by_name_feature
			output_stream.put_new_line
			generate_function_by_index_feature
			output_stream.put_new_line
			generate_function_by_name_feature
			output_stream.put_new_line
			generate_procedure_by_index_feature
			output_stream.put_new_line
			generate_procedure_by_name_feature
			output_stream.put_new_line
		end

	generate_implementation_features is
			-- Generate features in "Implemenetation" feature clause for reflection class.
		require
			 base_type_not_void: base_type /= Void
			 base_class_not_void: base_class /= Void
		do
			output_stream.put_line ("feature {NONE} -- Implementation")
			output_stream.put_new_line
			generate_creation_procedure_i_features
			generate_feature_i_features
			generate_creation_procedure_wrappers
			generate_feature_wrappers
		end

feature {NONE} -- Generation of features beloging to the "Status Report" feature clause

	generate_name_feature is
			-- Generate `name' feature for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		do
			output_stream.put_string ("%Tname: STRING is %"")
			output_stream.put_string (base_type.to_text)
			output_stream.put_line ("%"")
		end

	generate_is_expanded_feature is
			-- Generate `is_expanded' feature for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		do
			output_stream.put_string ("%Tis_expanded: BOOLEAN is ")
			if base_type.is_expanded then
				output_stream.put_line ("True")
			else
				output_stream.put_line ("False")
			end
		end

	generate_is_basic_type_feature is
			-- Generate `is_basic_type' for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		do
			output_stream.put_string ("%Tis_basic_type: BOOLEAN is ")
			if
				base_class = reflection_generator.universe.boolean_class or
				base_class = reflection_generator.universe.character_class or
				base_class = reflection_generator.universe.wide_character_class or
				base_class = reflection_generator.universe.integer_class or
				base_class = reflection_generator.universe.integer_8_class or
				base_class = reflection_generator.universe.integer_16_class or
				base_class = reflection_generator.universe.integer_64_class or
				base_class = reflection_generator.universe.natural_class or
				base_class = reflection_generator.universe.natural_8_class or
				base_class = reflection_generator.universe.natural_16_class or
				base_class = reflection_generator.universe.natural_64_class or
				base_class = reflection_generator.universe.real_class or
				base_class = reflection_generator.universe.double_class or
				base_class = reflection_generator.universe.pointer_class
			then
				output_stream.put_line ("True")
			else
				output_stream.put_line ("False")
			end
		end

	generate_creation_procedure_count_feature is
			-- Generate feature `creation_procedure_count'.
		do
			output_stream.put_string ("%Tcreation_procedure_count: INTEGER is ")
			if base_type.is_expanded then
				output_stream.put_character ('0')
			else
				output_stream.put_integer (creation_procedure_count (base_type, base_class, reflection_generator.universe))
			end
			output_stream.put_new_line
		end

	generate_feature_count_feature is
			-- Generate feature `feature_count'.
		do
			output_stream.put_string ("%Tfeature_count: INTEGER is ")
			if base_type.is_expanded then
				output_stream.put_character ('0')
			else
				output_stream.put_integer (feature_count (base_class, reflection_generator.universe))
			end
			output_stream.put_new_line
		end

	generate_query_count_feature is
			-- Generate feature `query_count'.
		do
			output_stream.put_string ("%Tquery_count: INTEGER is ")
			if base_type.is_expanded then
				output_stream.put_character ('0')
			else
				output_stream.put_integer (query_count)
			end
			output_stream.put_new_line
		end

	generate_attribute_count_feature is
			-- Generate feature `attribute_count'.
		do
			output_stream.put_string ("%Tattribute_count: INTEGER is ")
			if base_type.is_expanded then
				output_stream.put_character ('0')
			else
				output_stream.put_integer (attribute_count)
			end
			output_stream.put_new_line
		end

	generate_function_count_feature is
			-- Generate feature `function_count'.
		do
			output_stream.put_string ("%Tfunction_count: INTEGER is ")
			if base_type.is_expanded then
				output_stream.put_character ('0')
			else
				output_stream.put_integer (function_count)
			end
			output_stream.put_new_line
		end

	generate_procedure_count_feature is
			-- Generate feature `procedure_count'.
		do
			output_stream.put_string ("%Tprocedure_count: INTEGER is ")
			if base_type.is_expanded then
				output_stream.put_character ('0')
			else
				output_stream.put_integer (procedure_count)
			end
			output_stream.put_new_line
		end

feature {NONE} -- Generation of features belonging to the "Access" feature clause

	generate_creation_procedure_by_index_feature is
			-- Generate feature `creation_procedure'. It makes creation procedures accessible by
			-- index.
		local
			count: INTEGER
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [STRING]
			i: INTEGER
			name: STRING
		do
			if not base_type.is_expanded then
				count := creation_procedure_count (base_type, base_class, reflection_generator.universe)
			end
			from
				create list.make (count)
				i := 1
			until
				i > count
			loop
				name := ("creation_procedure_").twin
				INTEGER_.append_decimal_integer (i, name)
				list.put_last (name)
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_index_query ("creation_procedure", "ERL_CREATION_PROCEDURE", list)
		end

	generate_creation_procedure_by_name_feature is
			-- Generate feature `creation_procedure_by_name'. It makes creation procedures accessible by
			-- their name.
		local
			count: INTEGER
			creator_index: INTEGER
			feature_index: INTEGER
			creator: ET_CREATOR
			procedure: ET_PROCEDURE
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			i: INTEGER
			name: STRING
		do
			if not base_type.is_expanded then
				count := creation_procedure_count (base_type, base_class, reflection_generator.universe)
			end
			create list.make (count)
			if count > 0 then
				if base_class.creators /= Void then
					from
						creator_index := 1
						if is_default_creatable (base_class, reflection_generator.universe) then
							i := 2
						else
							i := 1
						end
					until
						creator_index > base_class.creators.count
					loop
						creator := base_class.creators.item (creator_index)
						if creator.clients.has_class (reflection_generator.universe.any_class) then
							from
								feature_index := 1
							until
								feature_index > creator.count
							loop
								procedure := base_class.named_procedure (creator.feature_name (feature_index))
								name := ("creation_procedure_").twin
								INTEGER_.append_decimal_integer (i, name)
								create pair.make (name, procedure.name.name)
								list.put_last (pair)
								feature_index := feature_index + 1
								i := i + 1
							end
						end
						creator_index := creator_index + 1
					end
				end
			end
			create printer.make (output_stream)
			printer.print_item_by_name_query ("creation_procedure_by_name", "ERL_CREATION_PROCEDURE", list)
		end

	generate_feature_by_index_feature is
			-- Generate feature `feature_'. It makes features accessible by
			-- index.
		local
			count: INTEGER
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [STRING]
			i: INTEGER
			name: STRING
		do
			if not base_type.is_expanded then
				count := feature_count (base_class, reflection_generator.universe)
			end
			from
				create list.make (count)
				i := 1
			until
				i > count
			loop
				name := ("feature_").twin
				INTEGER_.append_decimal_integer (i, name)
				list.put_last (name)
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_index_query ("feature_", "ERL_FEATURE", list)
		end

	generate_feature_by_name_feature is
			-- Generate feature `feature_by_name'. It makes features accessible by
			-- their name.
		local
			count: INTEGER
			feature_: ET_FEATURE
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			i: INTEGER
			j: INTEGER
			name: STRING
		do
			if not base_type.is_expanded then
				count := true_feature_count (base_class)
			end
			create list.make (count)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				feature_ := true_feature (base_class, i)
				if
					feature_.clients.has_class (reflection_generator.universe.any_class) and
						not feature_.name.is_infix and not feature_.name.is_prefix
				then
					name := ("feature_").twin
					INTEGER_.append_decimal_integer (j, name)
					create pair.make (name, feature_.name.name)
					list.put_last (pair)
					j := j + 1
				end
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_name_query ("feature_by_name", "ERL_FEATURE", list)
		end

	generate_query_by_index_feature is
			-- Generate feature `query'. It makes queries accessible by
			-- index.
		local
			count: INTEGER
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [STRING]
			i: INTEGER
			j: INTEGER
			feature_: ET_FEATURE
			query: ET_QUERY
			name: STRING
		do
			if not base_type.is_expanded then
				count := true_feature_count (base_class)
			end
			from
				create list.make (count)
				i := 1
				j := 1
			until
				i > count
			loop
				feature_ := true_feature (base_class, i)
				if
					feature_.clients.has_class (reflection_generator.universe.any_class) and
					not feature_.name.is_infix and not feature_.name.is_prefix
				then
					query ?= feature_
					if query /= Void then
						name := ("feature_").twin
						INTEGER_.append_decimal_integer (j, name)
						list.put_last (name)
					end
					j := j + 1
				end
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_index_query ("query", "ERL_QUERY", list)
		end

	generate_query_by_name_feature is
			-- Generate feature `feature_by_name'. It makes features accessible by
			-- their name.
		local
			count: INTEGER
			feature_: ET_FEATURE
			query: ET_QUERY
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			i: INTEGER
			j: INTEGER
			name: STRING
		do
			if not base_type.is_expanded then
				count := true_feature_count (base_class)
			end
			create list.make (count)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				feature_ := true_feature (base_class, i)
				if
					feature_.clients.has_class (reflection_generator.universe.any_class) and
					not feature_.name.is_infix and not feature_.name.is_prefix
				then
					query ?= feature_
					if query /= Void then
						name := ("feature_").twin
						INTEGER_.append_decimal_integer (j, name)
						create pair.make (name, query.name.name)
						list.put_last (pair)
					end
					j := j + 1
				end
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_name_query ("query_by_name", "ERL_QUERY", list)
		end


	generate_attribute_by_index_feature is
			-- Generate feature `attribute'. It makes queries accessible by
			-- index.
		local
			count: INTEGER
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [STRING]
			i: INTEGER
			j: INTEGER
			feature_: ET_FEATURE
			attribute: ET_ATTRIBUTE
			name: STRING
		do
			if not base_type.is_expanded then
				count := true_feature_count (base_class)
			end
			from
				create list.make (count)
				i := 1
				j := 1
			until
				i > count
			loop
				feature_ := true_feature (base_class, i)
				if
					feature_.clients.has_class (reflection_generator.universe.any_class) and
					not feature_.name.is_infix and not feature_.name.is_prefix
				then
					attribute ?= feature_
					if attribute /= Void then
						name := ("feature_").twin
						INTEGER_.append_decimal_integer (j, name)
						list.put_last (name)
					end
					j := j + 1
				end
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_index_query ("attribute", "ERL_ATTRIBUTE", list)
		end

	generate_attribute_by_name_feature is
			-- Generate feature `feature_by_name'. It makes features accessible by
			-- their name.
		local
			count: INTEGER
			feature_: ET_FEATURE
			attribute: ET_ATTRIBUTE
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			i: INTEGER
			j: INTEGER
			name: STRING
		do
			if not base_type.is_expanded then
				count := true_feature_count (base_class)
			end
			create list.make (count)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				feature_ := true_feature (base_class, i)
				if
					feature_.clients.has_class (reflection_generator.universe.any_class) and
					not feature_.name.is_infix and not feature_.name.is_prefix
				then
					attribute ?= feature_
					if attribute /= Void then
						name := ("feature_").twin
						INTEGER_.append_decimal_integer (j, name)
						create pair.make (name, attribute.name.name)
						list.put_last (pair)
					end
					j := j + 1
				end
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_name_query ("attribute_by_name", "ERL_ATTRIBUTE", list)
		end


	generate_function_by_index_feature is
			-- Generate feature `function'. It makes queries accessible by
			-- index.
		local
			count: INTEGER
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [STRING]
			i: INTEGER
			j: INTEGER
			feature_: ET_FEATURE
			function: ET_FUNCTION
			name: STRING
		do
			if not base_type.is_expanded then
				count := true_feature_count (base_class)
			end
			from
				create list.make (count)
				i := 1
				j := 1
			until
				i > count
			loop
				feature_ := true_feature (base_class, i)
				if
					feature_.clients.has_class (reflection_generator.universe.any_class) and
					not feature_.name.is_infix and not feature_.name.is_prefix
				then
					function ?= feature_
					if function /= Void then
						name := ("feature_").twin
						INTEGER_.append_decimal_integer (j, name)
						list.put_last (name)
					end
					j := j + 1
				end
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_index_query ("function", "ERL_FUNCTION", list)
		end

	generate_function_by_name_feature is
			-- Generate feature `feature_by_name'. It makes features accessible by
			-- their name.
		local
			count: INTEGER
			feature_: ET_FEATURE
			function: ET_FUNCTION
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			i: INTEGER
			j: INTEGER
			name: STRING
		do
			if not base_type.is_expanded then
				count := true_feature_count (base_class)
			end
			create list.make (count)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				feature_ := true_feature (base_class, i)
				if
					feature_.clients.has_class (reflection_generator.universe.any_class) and
					not feature_.name.is_infix and not feature_.name.is_prefix
				then
					function ?= feature_
					if function /= Void then
						name := ("feature_").twin
						INTEGER_.append_decimal_integer (j, name)
						create pair.make (name, function.name.name)
						list.put_last (pair)
					end
					j := j + 1
				end
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_name_query ("function_by_name", "ERL_FUNCTION", list)
		end


	generate_procedure_by_index_feature is
			-- Generate feature `procedure'. It makes queries accessible by
			-- index.
		local
			count: INTEGER
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [STRING]
			i: INTEGER
			j: INTEGER
			feature_: ET_FEATURE
			procedure: ET_PROCEDURE
			name: STRING
		do
			if not base_type.is_expanded then
				count := true_feature_count (base_class)
			end
			from
				create list.make (count)
				i := 1
				j := 1
			until
				i > count
			loop
				feature_ := true_feature (base_class, i)
				if
					feature_.clients.has_class (reflection_generator.universe.any_class) and
					not feature_.name.is_infix and not feature_.name.is_prefix
				then
					procedure ?= feature_
					if procedure /= Void then
						name := ("feature_").twin
						INTEGER_.append_decimal_integer (j, name)
						list.put_last (name)
					end
					j := j + 1
				end
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_index_query ("procedure", "ERL_PROCEDURE", list)
		end

	generate_procedure_by_name_feature is
			-- Generate feature `feature_by_name'. It makes features accessible by
			-- their name.
		local
			count: INTEGER
			feature_: ET_FEATURE
			procedure: ET_PROCEDURE
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			i: INTEGER
			j: INTEGER
			name: STRING
		do
			if not base_type.is_expanded then
				count := true_feature_count (base_class)
			end
			create list.make (count)
			from
				i := 1
				j := 1
			until
				i > count
			loop
				feature_ := true_feature (base_class, i)
				if
					(feature_.clients.has_class (reflection_generator.universe.any_class) and
					not feature_.name.is_infix and not feature_.name.is_prefix)
				then
					procedure ?= feature_
					if procedure /= Void then
						name := ("feature_").twin
						INTEGER_.append_decimal_integer (j, name)
						create pair.make (name, procedure.name.name)
						list.put_last (pair)
					end
					j := j + 1
				end
				i := i + 1
			end
			create printer.make (output_stream)
			printer.print_item_by_name_query ("procedure_by_name", "ERL_PROCEDURE", list)
		end

feature {NONE} -- Creation procedures wrappers

	generate_creation_procedure_i_features is
			-- Generate `creation_procedure_i' features for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		local
			i: INTEGER
			count: INTEGER
			creator_index: INTEGER
			feature_index: INTEGER
			creator: ET_CREATOR
			procedure: ET_PROCEDURE
		do
			if not base_type.is_expanded then
				count := creation_procedure_count (base_type, base_class, reflection_generator.universe)
			end
			if count > 0 then
				i := 1
				if is_default_creatable (base_class, reflection_generator.universe) then
					generate_creation_procedure_i_feature (i, Void, Void)
					i := i + 1
				end
				if base_class.creators /= Void then
					from
						creator_index := 1
					until
						creator_index > base_class.creators.count
					loop
						creator := base_class.creators.item (creator_index)
						if creator.clients.has_class (reflection_generator.universe.any_class) then
							from
								feature_index := 1
							until
								feature_index > creator.count
							loop
								procedure := base_class.named_procedure (creator.feature_name (feature_index))
								generate_creation_procedure_i_feature (i, procedure.name.name, procedure.arguments)
								feature_index := feature_index + 1
								i := i + 1
							end
						end
						creator_index := creator_index + 1
					end
				end
			end
		end

	generate_creation_procedure_i_feature (an_index: INTEGER; a_procedure_name: STRING; a_formal_arguments: ET_FORMAL_ARGUMENT_LIST) is
			-- Generate the `an_index'-th `creation_procedure_i' feature. The wrapped creation procedure has the name
			-- `a_procedure_name' and the formal_arguments `a_formal_arguments'. Note that an empty name describes the
			-- default creation procedure.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
			an_index_greater_zero: an_index >= 1
		do
			output_stream.put_string ("%Tcreation_procedure_")
			output_stream.put_integer (an_index)
			output_stream.put_line (": ERL_CREATION_PROCEDURE_IMP is")
			output_stream.put_line ("%T%Tlocal")
			output_stream.put_line ("%T%T%Targuments: ERL_LIST [ERL_ARGUMENT_IMP]")
			output_stream.put_line ("%T%Tonce")

			-- create helper object `arguments'
			generate_formal_argument_list (a_formal_arguments)

			-- create actual function
			output_stream.put_string ("%T%T%Tcreate Result.")
			if a_procedure_name /= Void then
				output_stream.put_string ("make (%"")
				output_stream.put_string (a_procedure_name)
				output_stream.put_string ("%", arguments, ")
			else
				output_stream.put_string ("make_default (")
			end
			output_stream.put_string ("Current, agent creation_procedure_wrapper")
			if a_procedure_name /= Void then
				output_stream.put_character ('_')
				output_stream.put_string (a_procedure_name)
			end
			output_stream.put_line (")")
			output_stream.put_line ("%T%Tend")
			output_stream.put_new_line
		end

	generate_creation_procedure_wrappers is
			-- Generate creation procedure wrappers for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		local
			count: INTEGER
			creator_index: INTEGER
			feature_index: INTEGER
			creator: ET_CREATOR
			procedure: ET_PROCEDURE
		do
			if not base_type.is_expanded then
				count := creation_procedure_count (base_type, base_class, reflection_generator.universe)
			end

			output_stream.put_line ("feature {NONE} -- Creation procedure wrapper")
			output_stream.put_new_line
			if count > 0 then
				if is_default_creatable (base_class, reflection_generator.universe) then
					generate_creation_procedure_wrapper (Void)
					output_stream.put_new_line
				end
				if base_class.creators /= Void then
					from
						creator_index := 1
					until
						creator_index > base_class.creators.count
					loop
						creator := base_class.creators.item (creator_index)
						if creator.clients.has_class (reflection_generator.universe.any_class) then
							from
								feature_index := 1
							until
								feature_index > creator.count
							loop
								procedure := base_class.named_procedure (creator.feature_name (feature_index))
									check
										procedure_not_void: procedure /= Void
									end
								generate_creation_procedure_wrapper (procedure)
								output_stream.put_new_line
								feature_index := feature_index + 1
							end
						end
						creator_index := creator_index + 1
					end
				end
			end
		end

	generate_creation_procedure_wrapper (a_procedure: ET_PROCEDURE) is
			-- Generate creation procedure wrapper for creation procedure `a_procedure'.
			-- A `Void' value for `a_procedure' describes the default creation procedure.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		local
			i: INTEGER
			type: ET_TYPE
		do
			output_stream.put_string ("%Tcreation_procedure_wrapper")
			if a_procedure /= Void then
				output_stream.put_character ('_')
				output_stream.put_string (a_procedure.name.name)
			end
			output_stream.put_character (' ')
			if a_procedure /= Void and then a_procedure.arguments /= Void then
				output_stream.put_string ("(")
				from
					i := 1
				until
					i > a_procedure.arguments.count
				loop
					output_stream.put_string ("a_param_")
					output_stream.put_integer (i)
					output_stream.put_string (": ")
					type := a_procedure.arguments.formal_argument (i).type
					type := type.base_type (base_type, reflection_generator.universe)
					output_stream.put_string (type.to_text)
					i := i + 1
					if i <= a_procedure.arguments.count then
						output_stream.put_string ("; ")
					end
				end
				output_stream.put_string (")")
			end
			output_stream.put_line (": ANY is")
			output_stream.put_string ("%T%T%T-- Wrapper for ")
			if a_procedure /= Void then
				output_stream.put_string ("creation procedure `")
				output_stream.put_string (a_procedure.name.name)
				output_stream.put_line ("`")
			else
				output_stream.put_line ("default creation procedure")
			end

			output_stream.put_line ("%T%Tdo")
			output_stream.put_string ("%T%T%TResult := create {")
			output_stream.put_string (base_type.to_text)
			output_stream.put_string ("}")
			if a_procedure /= Void then
				output_stream.put_character ('.')
				output_stream.put_string (a_procedure.name.name)
				if a_procedure.arguments /= Void then
					output_stream.put_string ("(")
					from
						i := 1
					until
						i > a_procedure.arguments.count
					loop
						output_stream.put_string ("a_param_")
						output_stream.put_string (i.out)
						i := i + 1
						if i <= a_procedure.arguments.count then
							output_stream.put_string (", ")
						end
					end
					output_stream.put_string (")")
				end
			end
			output_stream.put_new_line
			output_stream.put_line ("%T%Tend")
		end

feature {NONE} -- Feature wrappers

	generate_feature_i_features is
			-- Generate `feature_i' features for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		local
			count: INTEGER
			i: INTEGER
			j: INTEGER
			feature_: ET_FEATURE
			constant: ET_CONSTANT_ATTRIBUTE
		do
			if not base_type.is_expanded then
				count := true_feature_count (base_class)
			end
			from
				i := 1
				j := 1
			until
				i > count
			loop
				feature_ := true_feature (base_class, i)
				if
					feature_.clients.has_class (reflection_generator.universe.any_class) and
						not feature_.name.is_infix and not feature_.name.is_prefix
				then
					output_stream.put_string ("%Tfeature_")
					output_stream.put_integer (j)
					if feature_.is_attribute or feature_.is_constant_attribute or feature_.is_unique_attribute then
						output_stream.put_line (": ERL_ATTRIBUTE_IMP is")
					elseif feature_.is_function then
						output_stream.put_line (": ERL_FUNCTION_IMP is")
					elseif feature_.is_procedure then
						output_stream.put_line (": ERL_PROCEDURE_IMP is")
					else
						check
							dead_end: False
						end
					end
					if not feature_.is_attribute and not feature_.is_constant_attribute and not feature_.is_unique_attribute then
						output_stream.put_line ("%T%Tlocal")
						output_stream.put_line ("%T%T%Targuments: ERL_LIST [ERL_ARGUMENT]")
					end
					output_stream.put_line ("%T%Tonce")
					if not feature_.is_attribute and not feature_.is_constant_attribute and not feature_.is_unique_attribute then
						-- Create helper object `arguments'
						generate_formal_argument_list (feature_.arguments)
					end

					-- Create actual routine
					output_stream.put_string ("%T%T%Tcreate Result.make")
					if feature_.is_constant_attribute then
						output_stream.put_string ("_constant (")
						constant ?= feature_
						check
							constant_not_void: constant /= Void
						end
						constant.constant.process (ast_printer)
						output_stream.put_string (", ")
					elseif feature_.is_unique_attribute then
						-- TODO: The value of a unique feature cannot be retrieved with
						-- agents nor INTERNAL. We are currently lying and always report `0'.
						output_stream.put_string ("_constant (0, ")
					else
						output_stream.put_string (" (")
					end
					output_stream.put_character ('%"')
					output_stream.put_string (feature_.name.name)
					output_stream.put_string ("%"")
					if not feature_.is_attribute and not feature_.is_constant_attribute and not feature_.is_unique_attribute then
						output_stream.put_string (", arguments")
					end
					output_stream.put_string (", Current")
					if not feature_.is_attribute and not feature_.is_constant_attribute and not feature_.is_unique_attribute then
						output_stream.put_string (", agent feature_wrapper_")
						output_stream.put_string (feature_.name.name)
					end
					if feature_.type /= Void then
						output_stream.put_string (", universe.type_by_name (%"")
						output_stream.put_string (feature_.type.base_type (base_type, reflection_generator.universe).to_text)
						output_stream.put_string ("%")")
					end
					output_stream.put_line (")")
					output_stream.put_line ("%T%Tend")
					output_stream.put_new_line
					j := j + 1
				end
				i := i + 1
			end
		end

	generate_feature_wrappers is
			-- Generate feature wrappers for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		local
			count: INTEGER
			i: INTEGER
			feature_: ET_FEATURE
		do
			output_stream.put_string ("feature {NONE} -- Feature wrappers")
			output_stream.put_new_line
			output_stream.put_new_line

			if not base_type.is_expanded then
				count := true_feature_count (base_class)
			end
			from
				i := 1
			until
				i > count
			loop
				feature_ := true_feature (base_class, i)
				if
					feature_.clients.has_class (reflection_generator.universe.any_class) and
						not feature_.name.is_infix and not feature_.name.is_prefix
				then
					generate_feature_wrapper (feature_)
				end
				i := i + 1
			end
		end

	generate_feature_wrapper (a_feature: ET_FEATURE) is
			-- Generate feature wrapper for feature `a_feature' for reflection class.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
			a_feature_not_void: a_feature /= Void
			a_feature_not_infix: not a_feature.name.is_infix
			a_feature_not_prefix: not a_feature.name.is_prefix
		local
			i: INTEGER
			type: ET_TYPE
		do
			output_stream.put_string ("%Tfeature_wrapper_")
			output_stream.put_string (a_feature.name.name)
			output_stream.put_string (" (an_object: ")
			output_stream.put_string (base_type.to_text)
			if a_feature.arguments /= Void then
				from
					i := 1
				until
					i > a_feature.arguments.count
				loop
					output_stream.put_string ("; ")
					output_stream.put_string ("a_param_")
					output_stream.put_string (i.out)
					output_stream.put_string (": ")
					type := a_feature.arguments.formal_argument (i).type
					type := type.base_type (base_type, reflection_generator.universe)
					output_stream.put_string (type.to_text)
					i := i + 1
				end
			end
			output_stream.put_string (") ")
			if a_feature.type /= Void then
				output_stream.put_string (": ANY")
			end
			output_stream.put_line (" is")
			output_stream.put_line ("%T%Tdo")
			output_stream.put_string ("%T%T%T")
			if a_feature.type /= Void then
				output_stream.put_string ("Result := ")
			end
			output_stream.put_string ("an_object.")
			output_stream.put_string (a_feature.name.name)
			if a_feature.arguments /= Void then
				output_stream.put_string ("(")
				from
					i := 1
				until
					i > a_feature.arguments.count
				loop
					output_stream.put_string ("a_param_")
					output_stream.put_string (i.out)
					i := i + 1
					if i <= a_feature.arguments.count then
						output_stream.put_string (", ")
					end
				end
				output_stream.put_string (")")
			end
			output_stream.put_new_line
			output_stream.put_line ("%T%Tend")
			output_stream.put_new_line
		end

feature {NONE} -- Helpers

	query_count: INTEGER is
			-- Number of query in class `base_class'
			-- Only supported queries will be considered.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		local
			count: INTEGER
			i: INTEGER
			query: ET_QUERY
		do
			count := base_class.queries.count
			from
				i := 1
			until
				i > count
			loop
				query := base_class.queries.item (i)
				if
					(query.clients.has_class (reflection_generator.universe.any_class) and
					not query.name.is_infix and not query.name.is_prefix)
				then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	attribute_count: INTEGER is
			-- Number of attribute in class `base_class'
			-- Only supported attributes will be considered.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		local
			count: INTEGER
			i: INTEGER
			attribute: ET_ATTRIBUTE
		do
			count := base_class.queries.count
			from
				i := 1
			until
				i > count
			loop
				attribute ?= base_class.queries.item (i)
				if
					attribute /= Void and then
					(attribute.clients.has_class (reflection_generator.universe.any_class) and
					not attribute.name.is_infix and not attribute.name.is_prefix)
				then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	function_count: INTEGER is
			-- Number of function in class `base_class'
			-- Only supported functions will be considered.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		local
			count: INTEGER
			i: INTEGER
			function: ET_FUNCTION
		do
			count := base_class.queries.count
			from
				i := 1
			until
				i > count
			loop
				function ?= base_class.queries.item (i)
				if
					function /= Void and then
					(function.clients.has_class (reflection_generator.universe.any_class) and
					not function.name.is_infix and not function.name.is_prefix)
				then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	procedure_count: INTEGER is
			-- Number of procedure in class `base_class'
			-- Only supported procedures will be considered.
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		local
			count: INTEGER
			i: INTEGER
			procedure: ET_PROCEDURE
		do
			count := base_class.procedures.count
			from
				i := 1
			until
				i > count
			loop
				procedure ?= base_class.procedures.item (i)
				if
					procedure /= Void and then
					(procedure.clients.has_class (reflection_generator.universe.any_class) and
					not procedure.name.is_infix and not procedure.name.is_prefix)
				then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	generate_formal_argument_list (a_list: ET_FORMAL_ARGUMENT_LIST) is
			-- Generate code that creates a list filled with the formal arguments from `a_list'
		require
			base_type_not_void: base_type /=  Void
			base_class_not_void: base_class /= Void
		local
			i: INTEGER
			an_argument: ET_FORMAL_ARGUMENT
			argument_base_type: ET_BASE_TYPE
		do
			output_stream.put_string ("%T%T%Tcreate arguments.make_with_capacity (")
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
					output_stream.put_string ("%T%T%Targuments.put_last ( create {ERL_ARGUMENT_IMP}.make (%"")
					output_stream.put_string (an_argument.formal_argument.name.name)
					output_stream.put_string ("%", universe.type_by_name (%"")
					argument_base_type :=  an_argument.type.base_type (base_type, reflection_generator.universe)
					output_stream.put_string (argument_base_type.to_text)
					output_stream.put_line ("%")))")
					i := i + 1
				end
			end
		end

feature {NONE}

	output_stream: KI_TEXT_OUTPUT_STREAM
			-- Output stream for code generation

	reflection_generator: ERL_G_GENERATOR
			-- Main reflection generator

	base_type: ET_BASE_TYPE
			-- Type for which we want to generate a reflection class

	base_class: ET_CLASS
			-- Base class of `base_type'

	meta_class_name: STRING
			-- Name of the reflection class for `base_type.

	ast_printer: ET_AST_PRINTER

invariant

	output_stream_not_void: output_stream /= Void
	reflection_generator_not_void: reflection_generator /= Void
	ast_printer_not_void: ast_printer /= Void

end
