indexing

	description:

		"Generates a reflection library"

	library: "Erl-G"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_G_GENERATOR

inherit

	ERL_SHARED_DEBUG_MODE
		export {NONE} all end

	ERL_G_TYPE_ROUTINES
		export {NONE} all end

	ET_SHARED_CLASS_NAME_TESTER
		export {NONE} all end

	ET_SYSTEM
		rename
			make as make_system
		redefine
			activate_dynamic_type_set_builder
		end

	KL_SHARED_STREAMS
		export {NONE} all end

	KL_SHARED_FILE_SYSTEM
		export {NONE} all end

	KL_IMPORTED_INTEGER_ROUTINES
		export {NONE} all end

create

	make

feature {NONE} -- Initialization

	make (a_universe: ET_UNIVERSE) is
			-- Create new reflection universe based on the gelint
			-- universe `a_universe'.
		do
			make_system (a_universe)
			universe.activate_processors
			activate_dynamic_type_set_builder
			universe.parse_all
			universe.compile_degree_4
			universe.compile_degree_3
			compile_kernel
		end

feature -- Element change

	mark_type_reflectable (a_type: ET_BASE_TYPE) is
			-- Mark type `a_type' reflectable.
		require
			a_type_not_void: a_type /= Void
		local
			l_dynamic_type: ET_DYNAMIC_TYPE
			l_queries: ET_QUERY_LIST
			l_procedures: ET_PROCEDURE_LIST
			l_query: ET_QUERY
			l_procedure: ET_PROCEDURE
			l_class: ET_CLASS
			nb: INTEGER
			i: INTEGER
		do
			l_class := a_type.direct_base_class (universe)
			if not has_dynamic_type (a_type) then
				l_dynamic_type := dynamic_type (a_type, a_type)
				l_queries := l_class.queries
				nb := l_class.queries.count
				from i := 1 until i > nb loop
					l_query := l_queries.item (i)
					mark_feature_reflectable (l_dynamic_type, a_type, l_query)
					i := i + 1
				end
				l_procedures := l_class.procedures
				nb := l_class.procedures.count
				from i := 1 until i > nb loop
					l_procedure := l_procedures.item (i)
					mark_feature_reflectable (l_dynamic_type, a_type, l_procedure)
					i := i + 1
				end
			end
	end

	mark_default_types_reflectable is
			-- Mark all classes reflectable. Note that this will not
			-- make all types reflectable, since there can be
			-- infintely many. Every non generic class, will be made
			-- reflectable. For every generic class, the standard generic
			-- derivation will be made reflectable. Generic classes that have
			-- deferred constraints, but a create clause will not be made
			-- reflectable however.
		local
			l_class: ET_CLASS
			l_class_type: ET_CLASS_TYPE
			l_cursor: DS_HASH_TABLE_CURSOR [ET_CLASS, ET_CLASS_NAME]
		do
			l_cursor := universe.classes.new_cursor
			from l_cursor.start until l_cursor.after loop
				l_class := l_cursor.item
				if not l_class.implementation_checked or else l_class.has_implementation_error then
					set_fatal_error
				else
					if l_class.is_generic then
						l_class_type := generic_derivation (l_class, universe)
					else
						l_class_type := l_class
					end
					mark_type_reflectable (l_class_type)
				end
				l_cursor.forth
			end
		end

feature -- Generation

	generate_all (a_pathname: STRING) is
			-- Generate both the reflection universe class and the
			-- reflection type classes for all types marked reflectible.
			-- Generate all files into the directory `a_pathname'.
			-- Set `has_fatal_error' to `True' if generation cannot be
			-- completed.
		require
			a_pathname_not_void: a_pathname /= Void
			a_pathname_not_empty: a_pathname.count > 0
		do
			build_dynamic_type_sets
			build_class_name_list
			generate_reflection_universe_class (a_pathname)
			generate_reflection_type_classes (a_pathname)
		end

feature -- Processors

	activate_dynamic_type_set_builder is
			-- Activate dynamic type set builder.
		do
			if dynamic_type_set_builder = null_dynamic_type_set_builder then
				create {ET_DYNAMIC_TYPE_BUILDER} dynamic_type_set_builder.make (Current)
			end
		end

feature {ERL_G_UNIVERSE_GENERATOR, ERL_G_TYPE_GENERATOR} -- Features for file generators

	class_name_list: DS_LIST [DS_PAIR [ET_BASE_TYPE, STRING]]
			-- List of tuples containing the reflectable base types and
			-- their corresponding reflection class names

feature {NONE} -- Implementation

	build_class_name_list is
			-- Build table that maps to each Eiffel types a class name
			-- for its meta-class. The table will be made available
			-- via `class_name_list'.
		local
			nb: INTEGER
			i: INTEGER
			l_dynamic_type: ET_DYNAMIC_TYPE
			l_base_type: ET_BASE_TYPE
			name: STRING
			pair: DS_PAIR [ET_BASE_TYPE, STRING]
		do
			nb := dynamic_types.count
			create {DS_ARRAYED_LIST [DS_PAIR [ET_BASE_TYPE, STRING]]} class_name_list.make (nb)
			from
				i := 1
			until
				i > nb
			loop
				l_dynamic_type := dynamic_types.item (i)
				l_base_type := l_dynamic_type.base_type
				name := ("ERL_TYPE_IMP_").twin
				INTEGER_.append_decimal_integer (i, name)
				name.append_character ('_')
				name.append_string (l_base_type.direct_base_class (universe).name.name)
				create pair.make (l_base_type, name)
				class_name_list.put_last (pair)
				i := i + 1
			end
		ensure
			class_name_list_not_void: class_name_list /= Void
		end

	generate_reflection_universe_class (a_pathname: STRING) is
			-- Generate the reflection universe class.
			-- Generate the file into the directory `a_pathname'.
			-- Set `has_fatal_error' to `True' if generation cannot be
			-- completed.
		require
			a_pathname_not_void: a_pathname /= Void
			class_names_available: class_name_list /= Void
		local
			reflection_universe_generator: ERL_G_UNIVERSE_GENERATOR
			file: KL_TEXT_OUTPUT_FILE
		do
			create reflection_universe_generator.make (Current)
			create file.make (file_system.pathname (a_pathname, "erl_universe_imp.e"))
			debug_mode.disable
			file.recursive_open_write
			debug_mode.enable
			if file.is_open_write then
				reflection_universe_generator.generate (file)
				file.close
				if reflection_universe_generator.has_fatal_error then
					has_fatal_error := True
				end
			else
				has_fatal_error := True
			end
		end

	generate_reflection_type_classes  (a_pathname: STRING) is
			-- Generate reflection type classes for all types makred reflectible.
			-- Generate all files into the directory `a_pathname'.
			-- Set `has_fatal_error' to `True' if generation cannot be
			-- completed.
		require
			a_pathname_not_void: a_pathname /= Void
			class_names_available: class_name_list /= Void
		local
			cs: DS_LINEAR_CURSOR [DS_PAIR [ET_BASE_TYPE, STRING]]
			reflection_type_generator: ERL_G_TYPE_GENERATOR
			file: KL_TEXT_OUTPUT_FILE
			filename: STRING
		do
			create reflection_type_generator.make (Current)
			from
				cs := class_name_list.new_cursor
				cs.start
			until
				cs.off
			loop
				filename := cs.item.second.as_lower
				filename.append_string (".e")
				create file.make (file_system.pathname (a_pathname, filename))
				file.recursive_open_write
				if file.is_open_write then
					reflection_type_generator.generate (file, cs.item.first, cs.item.second)
					file.close
					if reflection_type_generator.has_fatal_error then
						has_fatal_error := True
					end
				else
					has_fatal_error := True
				end
				cs.forth
			end
		end

	mark_feature_reflectable (a_dynamic_type: ET_DYNAMIC_TYPE; a_type: ET_BASE_TYPE; a_feature: ET_FEATURE) is
			-- Mark `a_feature' of static type `a_type' and dynamic type `a_dynamic_type' reflectable.
		require
			a_dynamic_type_not_void: a_dynamic_type /= Void
			a_feature_not_void: a_feature /= Void
		local
			l_query: ET_QUERY
			l_procedure: ET_PROCEDURE
			l_dynamic_feature: ET_DYNAMIC_FEATURE
			i: INTEGER
			arguments: ET_FORMAL_ARGUMENT_LIST
			count: INTEGER
		do
			l_query ?= a_feature
			l_procedure ?= a_feature
			check
				exclusivness: l_query /= Void xor l_procedure /= Void
			end
			if l_query /= Void then
				mark_type_reflectable (l_query.type.base_type (a_type, universe))
				l_dynamic_feature := a_dynamic_type.dynamic_query (l_query, Current)
			else
				l_dynamic_feature := a_dynamic_type.dynamic_procedure (l_procedure, Current)
			end
			arguments := a_feature.arguments
			if arguments /= Void then
				from
					i := 1
					count := arguments.count
				until
					i > count
				loop
					mark_type_reflectable (arguments.item (i).type.base_type (a_type, universe))
					i := i + 1
				end
			end
		end

	has_dynamic_type (a_type: ET_BASE_TYPE): BOOLEAN is
			-- Is there a dynamic type for `a_type' already?
		require
			a_type_not_void: a_type /= Void
		local
			cs: DS_LINEAR_CURSOR [ET_DYNAMIC_TYPE]
		do
			from
				cs := dynamic_types.new_cursor
				cs.start
			until
				cs.off or Result
			loop
				if cs.item.base_type.same_named_type (a_type, a_type, cs.item.base_type, universe) then
					Result := True
				else
					cs.forth
				end
			end
			cs.go_after
		end


feature {NONE} -- Assertions helpers

	is_valid_pair (a_pair: DS_PAIR [ET_BASE_TYPE, STRING]): BOOLEAN is
			-- Is `a_pair's valid?
		do
			Result := a_pair /= Void and then
					a_pair.first /= Void and then
					a_pair.second /= Void and then
					a_pair.first.is_valid_context
		ensure
			definition: Result = (a_pair /= Void and then
										 a_pair.first /= Void and then
										 a_pair.second /= Void and then
										 a_pair.first.is_valid_context)
		end

	is_class_name_list_valid: BOOLEAN is
			-- Are all types in `class_name_list' valid contexts?
		local
			cs: DS_LINEAR_CURSOR [DS_PAIR [ET_BASE_TYPE, STRING]]
		do
			Result := True
			from
				cs := class_name_list.new_cursor
				cs.start
			until
				cs.off or not Result
			loop
				if not is_valid_pair (cs.item) then
					Result := False
				end
				cs.forth
			end
			cs.go_after
		end

invariant

	class_name_list_valid: class_name_list /= Void implies is_class_name_list_valid

end
