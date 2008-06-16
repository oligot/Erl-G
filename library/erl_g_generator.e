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

	ERL_G_TYPE_ROUTINES
		export {NONE} all end

	KL_SHARED_STREAMS
		export {NONE} all end

	KL_SHARED_FILE_SYSTEM
		export {NONE} all end

	KL_IMPORTED_INTEGER_ROUTINES
		export {NONE} all end

	ET_SHARED_TOKEN_CONSTANTS
		export {NONE} all end

	ERL_G_SHARED_ERROR_MESSAGE
		export {NONE} all end

create

	make

feature {NONE} -- Initialization

	make (a_universe: ET_SYSTEM) is
			-- Create new reflection universe based on the gelint
			-- universe `a_universe'.
		do
			create creatable_types.make_map_default
			set_universe (a_universe)
			universe.error_handler.set_ise
			universe.compile
			mark_default_types_creatable
		end

feature -- Access

	universe: ET_SYSTEM
			-- Universe from which reflection library is generated

	basic_classes: DS_HASH_TABLE [ET_CLASS, ET_CLASS_NAME] is
			-- Mapping between sized basic type names (e.g. INTEGER, STRING)
			-- and their actual classes (which are stored in `classes' under
			-- their actual names) when aliased
		do
			if basic_classes_internal = Void then
				create basic_classes_internal.make (15)
				basic_classes_internal.force_last (universe.string_8_class, tokens.string_class_name)
				basic_classes_internal.force_last (universe.character_8_class, tokens.character_class_name)
				basic_classes_internal.force_last (universe.character_32_class, tokens.wide_character_class_name)
				basic_classes_internal.force_last (universe.integer_32_class, tokens.integer_class_name)
				basic_classes_internal.force_last (universe.natural_32_class, tokens.natural_class_name)
				basic_classes_internal.force_last (universe.real_32_class, tokens.real_class_name)
				basic_classes_internal.force_last (universe.real_64_class, tokens.double_class_name)
				basic_classes_internal.force_last (universe.character_8_ref_class, tokens.character_ref_class_name)
				basic_classes_internal.force_last (universe.character_32_ref_class, tokens.wide_character_ref_class_name)
				basic_classes_internal.force_last (universe.integer_32_ref_class, tokens.integer_ref_class_name)
				basic_classes_internal.force_last (universe.natural_32_ref_class, tokens.natural_ref_class_name)
				basic_classes_internal.force_last (universe.real_32_ref_class, tokens.real_ref_class_name)
				basic_classes_internal.force_last (universe.real_64_ref_class, tokens.double_ref_class_name)
			end
			Result := basic_classes_internal
		end

feature -- Status report

	is_type_creatable (a_type: ET_BASE_TYPE): BOOLEAN is
			-- Is `a_type' marked creatable?
		require
			a_type_not_void: a_type /= Void
		local
			list: DS_LINEAR [ET_BASE_TYPE]
		do
			list := creatable_types_of_class (a_type.base_class)
			Result := list /= Void and then list.has (a_type)
		end

feature -- Element change

	mark_type_creatable (a_type: ET_BASE_TYPE) is
			-- Mark type `a_type' creatable.
		require
			a_type_not_void: a_type /= Void
			not_marked: not is_type_creatable (a_type)
		local
			list: DS_ARRAYED_LIST [ET_BASE_TYPE]
			base_class: ET_CLASS
		do
			base_class := a_type.base_class
			creatable_types.search (base_class)
			if creatable_types.found then
				list := creatable_types.found_item
			else
				create list.make_default
				creatable_types.force (list, base_class)
			end
			list.force_last (a_type)
		end

feature -- Setting

	set_universe (a_universe: like universe) is
			-- Set `universe' with `a_universe'.
		require
			a_universe_attached: a_universe /= Void
		do
			universe := a_universe
		ensure
			universe_set: universe = a_universe
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
			generate_universe_class (a_pathname)
			generate_class_classes (a_pathname)
		end

feature {ERL_G_UNIVERSE_GENERATOR, ERL_G_CLASS_GENERATOR} -- Features for file generators

	meta_class_name (a_class: ET_CLASS): STRING is
			-- Class name of meta class for class `a_class'
		do
			create Result.make (("ERL_CLASS_IMP_").count + a_class.name.name.count)
			Result.append_string ("ERL_CLASS_IMP_")
			Result.append_string (a_class.name.name)
		ensure
			name_not_void: Result /= Void
			name_not_empty: not Result.is_empty
		end

	creatable_types_of_class (a_class: ET_CLASS): DS_LINEAR [ET_BASE_TYPE] is
			-- Is `a_type' marked creatable?
		do
			creatable_types.search (a_class)
			if creatable_types.found then
				Result := creatable_types.found_item
			end
		ensure
			list_not_empty: Result /= Void implies not Result.has (Void)
		end

feature {NONE} -- Implementation

	mark_default_types_creatable is
			-- Mark default generic derivations of all classes as
			-- creatable.
		local
			l_class: ET_CLASS
			l_class_type: ET_CLASS_TYPE
			l_cursor: DS_HASH_TABLE_CURSOR [ET_CLASS, ET_CLASS_NAME]
		do
			l_cursor := universe.classes.new_cursor
			from l_cursor.start until l_cursor.after loop
				l_class := l_cursor.item
				if not l_class.implementation_checked or else l_class.has_implementation_error then
--					universe.error_handler.report_error_message (class_not_compiled_or_contain_error (l_class.name.name))
				else
					if l_class.is_generic then
						l_class_type := generic_derivation (l_class, universe)
					else
						l_class_type := l_class
					end
					if not is_type_creatable (l_class_type) then
						-- Due to type aliasing we need to make sure not to add a type twice.
						mark_type_creatable (l_class_type)
					end
				end
				l_cursor.forth
			end
		end

	generate_universe_class (a_pathname: STRING) is
			-- Generate the reflection universe class.
			-- Generate the file into the directory `a_pathname'.
			-- Set `has_fatal_error' to `True' if generation cannot be
			-- completed.
		require
			a_pathname_not_void: a_pathname /= Void
		local
			reflection_universe_generator: ERL_G_UNIVERSE_GENERATOR
			file: KL_TEXT_OUTPUT_FILE
		do
			create reflection_universe_generator.make (Current)
			create file.make (file_system.pathname (a_pathname, "erl_universe_imp.e"))
			file.recursive_open_write
			if file.is_open_write then
				reflection_universe_generator.generate (file)
				file.close
				if reflection_universe_generator.has_fatal_error then
					universe.error_handler.report_error_message (reflection_generator_has_error)
				end
			else
				universe.error_handler.report_error_message (cannot_create_file_error (file.name))
			end
		end

	generate_class_classes  (a_pathname: STRING) is
			-- Generate meta-classes for all classes in the universe.
			-- Generate all files into the directory `a_pathname'.  Set
			-- `has_fatal_error' to `True' if generation cannot be
			-- completed.
		require
			a_pathname_not_void: a_pathname /= Void
		local
			reflection_class_generator: ERL_G_CLASS_GENERATOR
			file: KL_TEXT_OUTPUT_FILE
			filename: STRING
			cs: DS_HASH_TABLE_CURSOR [ET_CLASS, ET_CLASS_NAME]
			class_name: STRING
		do
			create reflection_class_generator.make (Current)
			from
				cs := universe.classes.new_cursor
				cs.start
			until
				cs.off
			loop
				if not cs.item.implementation_checked or else cs.item.has_implementation_error then
--					universe.error_handler.report_error_message (class_not_compiled_or_contain_error (cs.item.name.name))
				else
					class_name := meta_class_name (cs.item)
					filename := class_name.as_lower
					filename.append_string (".e")
					create file.make (file_system.pathname (a_pathname, filename))
					file.recursive_open_write
					if file.is_open_write then
						reflection_class_generator.generate (file, cs.item)
						file.close
						if reflection_class_generator.has_fatal_error then
							universe.error_handler.report_error_message (reflection_generator_has_error)
						end
					else
						universe.error_handler.report_error_message (cannot_create_file_error (file.name))
					end
				end
				cs.forth
			end
		end

	creatable_types: DS_HASH_TABLE [DS_ARRAYED_LIST [ET_BASE_TYPE], ET_CLASS]
			-- Types that are creatable (key is corresponding base class)

	basic_classes_internal: like basic_classes
			-- Implementation of `basic_classes'

invariant

	creatable_types_not_void: creatable_types /= Void
	creatable_types_list_not_void: not creatable_types.has (Void)

end
