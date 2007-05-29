indexing

	description:

		"Common Eiffel type related routines"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_G_TYPE_ROUTINES

feature

	is_alias_class (a_class_name: ET_CLASS_NAME; a_universe: ET_UNIVERSE): BOOLEAN is
			-- Is `a_class_name' the name of an alias class?
			-- (Classes STRING, INTEGER, ... are typically aliased to a
			-- sized variant.)
		require
			a_class_name_not_void: a_class_name /= Void
			a_universe_not_void: a_universe /= Void
		do
			Result := not a_universe.eiffel_class (a_class_name).name.same_class_name (a_class_name)
		end


	has_feature (a_class: ET_CLASS; a_feature: ET_FEATURE): BOOLEAN is
			-- Does `a_class' contain `a_feature'?
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
		local
			procedure: ET_PROCEDURE
			query: ET_QUERY
		do
			procedure ?= a_feature
			if procedure /= Void then
				Result := a_class.procedures.has (procedure)
			else
				query ?= a_feature
				Result := a_class.queries.has (query)
			end
		end

	seeded_feature (a_class: ET_CLASS; a_seed: INTEGER): ET_FEATURE is
			-- Feature from class `a_class' with seed `a_seed'; Void if no such feature
		require
			a_class_not_void: a_class /= Void
			a_seed_not_void: a_seed /= Void
		do
			Result := a_class.seeded_query (a_seed)
			if Result = Void then
				Result := a_class.seeded_procedure (a_seed)
			end
		end

	is_external_feature (a_feature: ET_FEATURE): BOOLEAN is
		require
			a_feature_not_void: a_feature /= Void
		local
			external_routine: ET_EXTERNAL_ROUTINE
		do
			external_routine ?= a_feature
			Result := external_routine /= Void
		end

	generic_derivation (a_class: ET_CLASS; a_universe: ET_UNIVERSE): ET_GENERIC_CLASS_TYPE is
			-- Generic derivation `a_class'; this is a type which has `a_class' as base class
			-- but where all formal parameters have been closed with types. The types to be used
			-- as actual paramenters will be ANY for unconstrained formal parameters and
			-- the constraining type for constrained parameters.
		require
			a_class_not_void: a_class /= Void
			a_class_is_generic: a_class.is_generic
			a_universe_not_void: a_universe /= Void
		local
			formal_parameters: ET_FORMAL_PARAMETER_LIST
			formal_parameter: ET_FORMAL_PARAMETER
			actual_parameters: ET_ACTUAL_PARAMETER_LIST
			actual_parameter: ET_ACTUAL_PARAMETER
			i: INTEGER
		do
			formal_parameters := a_class.formal_parameters
			create actual_parameters.make_with_capacity (formal_parameters.count)

			from
				i := formal_parameters.count
			until
				i < 1
			loop
				formal_parameter := formal_parameters.item (i).formal_parameter
				if formal_parameter.constraint = Void then
					actual_parameter := a_universe.any_type
				else
					actual_parameter := formal_parameter.constraint
				end
				actual_parameters.put_first (actual_parameter)
				i := i - 1
			end
			actual_parameters := actual_parameters.resolved_formal_parameters (actual_parameters)
			create Result.make (Void, a_class.name, actual_parameters, a_class)
			Result.set_unresolved_type (a_class)
		ensure
			derivation_not_void: Result /= Void
			unresolved_type_is_set: Result.unresolved_type = a_class
		end

	has_deferred_actual_with_create_clause (a_type: ET_BASE_TYPE; a_universe: ET_UNIVERSE): BOOLEAN is
			-- Has the base class of `a_type' a formal generic parameter that
			-- is constrained with a create clause and has the corresponding
			-- `a_type' a deferred actual parameter? (Such types cannot be
			-- instanciated even though they can have creation procedures.)
		require
			a_type_not_void: a_type /= Void
			a_universe_not_void: a_universe /= Void
		local
			base_class: ET_CLASS
			formal_parameters: ET_FORMAL_PARAMETER_LIST
			formal_parameter: ET_FORMAL_PARAMETER
			actual_parameters: ET_ACTUAL_PARAMETER_LIST
			i: INTEGER
			nb: INTEGER
		do
			base_class := a_type.direct_base_class (a_universe)
			formal_parameters := base_class.formal_parameters
			if formal_parameters /= Void then
				actual_parameters := a_type.actual_parameters
				from
					nb := formal_parameters.count
					i := 1
				until
					i > nb or Result
				loop
					formal_parameter := formal_parameters.item (i).formal_parameter
					if
						formal_parameter.creation_procedures /= Void and then
						formal_parameter.creation_procedures.count > 0
					then
						Result := actual_parameters.type (i).direct_base_class (a_universe).is_deferred
					end
					i := i + 1
				end
			end
		end

	is_default_creatable (a_class: ET_CLASS; a_universe: ET_UNIVERSE): BOOLEAN is
			-- Are objects of type `a_class' creatable via default creation?
		require
			a_class_not_void: a_class /= Void
			a_universe_not_void: a_universe /= Void
		local
			procedure: ET_PROCEDURE
		do
			if not a_class.is_deferred then
				procedure := a_class.seeded_procedure (a_universe.default_create_seed)
				if procedure = Void then
					Result := False
				elseif a_class.creators = Void then
					Result := True
				elseif a_class.is_creation_exported_to (procedure.name, a_universe.any_class, a_universe) then
					Result := True
				end
			end
		end

	is_basic_class (a_class: ET_CLASS; a_universe: ET_UNIVERSE): BOOLEAN is
			-- Is `a_class' a basic class?
		require
			a_class_not_void: a_class /= Void
			a_universe_not_void: a_universe /= Void
		do
			Result := a_class = a_universe.boolean_class or
				a_class = a_universe.character_class or
				a_class = a_universe.wide_character_class or
				a_class = a_universe.integer_class or
				a_class = a_universe.integer_8_class or
				a_class = a_universe.integer_16_class or
				a_class = a_universe.integer_64_class or
				a_class = a_universe.natural_class or
				a_class = a_universe.natural_32_class or
				a_class = a_universe.natural_8_class or
				a_class = a_universe.natural_16_class or
				a_class = a_universe.natural_64_class or
				a_class = a_universe.real_class or
				a_class = a_universe.double_class or
				a_class = a_universe.pointer_class or
				a_class = a_universe.typed_pointer_class
		end

	creation_procedure_count (a_base_type: ET_BASE_TYPE; a_base_class: ET_CLASS; a_universe: ET_UNIVERSE): INTEGER is
			-- Number of creation procedures in class `base_class';
			-- Note that types, whose base class is generic and has a
			-- formal parameter that includes a create clause and said
			-- formal parameter is closed with an actual that is deferred,
			-- we report 0 creation procedures regardless of the true number,
			-- since such a type cannot be instanciated anyway.
		require
			a_base_type_not_void: a_base_type /=  Void
			a_base_class_not_void: a_base_class /= Void
			a_universe_not_void: a_universe /= Void
			a_base_class_is_valid: a_base_type.direct_base_class (a_universe) = a_base_class
		local
			creator_index: INTEGER
			feature_index: INTEGER
			creator: ET_CREATOR
		do
			if
				not has_deferred_actual_with_create_clause (a_base_type, a_universe)
			then
				if a_base_class.creators /= Void then
					from
						creator_index := 1
					until
						creator_index > a_base_class.creators.count
					loop
						creator := a_base_class.creators.item (creator_index)
						if creator.clients.has_class (a_universe.any_class) then
							Result := Result + creator.count
							feature_index := feature_index + creator.count
						end
						creator_index := creator_index + 1
					end
				end
				if is_default_creatable (a_base_class, a_universe) then
					Result := Result + 1
				end
			end
		ensure
			count_positive: Result >= 0
		end

	true_feature (a_class: ET_CLASS; an_index: INTEGER): ET_FEATURE is
			-- `an_index'-th feature of class `a_class';
			-- All features will be considered
		require
			a_class_not_void: a_class /= Void
			an_index_greater_zero: an_index > 0
			an_index_small_enough: an_index <= true_feature_count (a_class)
		do
			if an_index <= a_class.queries.count then
				Result := a_class.queries.item (an_index)
			else
				Result := a_class.procedures.item (an_index - a_class.queries.count)
			end
		ensure
			feature_not_void: Result /= Void
		end

	true_feature_count (a_class: ET_CLASS): INTEGER is
			-- Number of features in class `a_class'; All features will
			-- be considered
		require
			a_class_not_void: a_class /= Void
		do
			Result := a_class.queries.count + a_class.procedures.count
		ensure
			definition: Result = a_class.queries.count + a_class.procedures.count
		end

	feature_count (a_base_class: ET_CLASS; a_universe: ET_UNIVERSE): INTEGER is
			-- Number of features in class `base_class';
			-- Only supported feature will be considered.
		require
			a_base_class_not_void: a_base_class /= Void
			a_universe_not_void: a_universe /= Void
		local
			count: INTEGER
			i: INTEGER
			feature_: ET_FEATURE
		do
			count := true_feature_count (a_base_class)
			from
				i := 1
			until
				i > count
			loop
				feature_ := true_feature (a_base_class, i)
				if
					feature_.clients.has_class (a_universe.any_class) and
						not feature_.name.is_infix and not feature_.name.is_prefix
				then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	i_th_feature (an_index: INTEGER; a_base_class: ET_CLASS; a_universe: ET_UNIVERSE): ET_FEATURE is
			-- `an_index'-th feature of class `a_base_class';
			-- Only supported feature will be considered.
		require
			a_base_class_not_void: a_base_class /= Void
			a_universe_not_void: a_universe /= Void
			an_index_valid: an_index > 0 and an_index <= feature_count (a_base_class, a_universe)
		local
			count: INTEGER
			i: INTEGER
			j: INTEGER
			feature_: ET_FEATURE
		do
			count := true_feature_count (a_base_class)
			from
				i := 1
				j := 1
			until
				i > count or Result /= Void
			loop
				feature_ := true_feature (a_base_class, i)
				if
					feature_.clients.has_class (a_universe.any_class) and
						not feature_.name.is_infix and not feature_.name.is_prefix
				then
					if j = an_index then
						Result := feature_
					end
					j := j + 1
				end
				i := i + 1
			end
		ensure
			feature_not_void: Result /= Void
		end

feature {NONE} -- Parsing class types

	base_type (a_name: STRING; a_universe: ET_UNIVERSE): ET_BASE_TYPE is
			-- Base type of `a_name' or `Void' if it doesn't exist
		require
			a_name_not_void: a_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			i: INTEGER
		do
			i := parse_base_type (a_name, 1, a_universe)
			Result := last_base_type
			last_base_type := Void
		ensure
			valid_context: Result /= Void implies Result.is_valid_context
		end

	parse_class (str: STRING; a_position: INTEGER; a_universe: ET_UNIVERSE): INTEGER is
			-- Parse class in `str' starting at `a_position'.
			-- Make result available in `last_class', or Void
			-- if an error was found.
		require
			a_universe_not_void: a_universe /= Void
		local
			a_name: STRING
			i, nb: INTEGER
			c: CHARACTER
			an_identifier: ET_IDENTIFIER
			stop: BOOLEAN
		do
			last_class := Void
			from
				i := a_position
				nb := str.count
			until
				i > nb or
				stop
			loop
				c := str.item (i)
				inspect c
				when 'a'..'z', 'A'..'Z', '0'..'9', '_' then
					stop := True
				else
					i := i + 1
				end
			end
			from
				stop := False
				create a_name.make (10)
			until
				i > nb or
				stop
			loop
				c := str.item (i)
				inspect c
				when 'a'..'z', 'A'..'Z', '0'..'9', '_' then
					a_name.append_character (c)
					i := i + 1
				else
					stop := True
				end
			end
			Result := i
			if not a_name.is_empty then
				create an_identifier.make (a_name)
				if a_universe.has_class (an_identifier) then
					last_class := a_universe.eiffel_class (an_identifier)
				else
					Result := nb + 2
				end
			else
				Result := nb + 2
			end
		ensure
			valid_position: Result > a_position
		end

	last_class: ET_CLASS
			-- Last class parsed by `parse_class';
			-- Void if an error was found when parsing

	parse_base_type (str: STRING; a_position: INTEGER; a_universe: ET_UNIVERSE): INTEGER is
			-- Parse class type or tuple type in `str' starting at `a_position'.
			-- Make result available in `last_base_type', or Void
			-- if an error was found.
		require
			a_universe_not_void: a_universe /= Void
		local
			i, nb: INTEGER
			stop: BOOLEAN
			a_class: ET_CLASS
			an_actuals, tmp_actuals: ET_ACTUAL_PARAMETER_LIST
			close_brackets_parsed: BOOLEAN
		do
			last_base_type := Void
			Result := parse_class (str, a_position, a_universe)
			a_class := last_class
			if a_class /= Void then
				if a_class = a_universe.tuple_class then
						-- Tuples have a variable number of arguments.
					i := parse_open_bracket (str, Result)
					if i > str.count + 1 then
						create {ET_TUPLE_TYPE} last_base_type.make (Void)
					else
						from
							Result := i
							create tmp_actuals.make
						until
							close_brackets_parsed or stop
						loop
							Result := parse_base_type (str, Result, a_universe)
							if last_base_type /= Void then
								tmp_actuals.force_first (last_base_type)
								i := parse_comma (str, Result)
								if i > str.count + 1 then
									Result := parse_close_bracket (str, Result)
									if Result > str.count + 1 then
										stop := True
										Result := str.count + 2
									else
										close_brackets_parsed := True
									end
								else
									Result := i
								end
							else
								stop := True
								Result := str.count + 2
							end
						end
						last_base_type := Void
						if not stop then
							nb := tmp_actuals.count
							create an_actuals.make_with_capacity (nb)
							from i := 1 until i > nb loop
								an_actuals.force_first (tmp_actuals.item (i))
								i := i + 1
							end
							create {ET_TUPLE_TYPE} last_base_type.make (an_actuals)
						end
					end
				elseif a_class.is_generic then
					Result := parse_open_bracket (str, Result)
					if Result > str.count + 1 then
						stop := True
					end
					nb := a_class.formal_parameters.count
					create tmp_actuals.make_with_capacity (nb)
					from
						i := 1
					until
						i > nb or stop
					loop
						Result := parse_base_type (str, Result, a_universe)
						if last_base_type /= Void then
							tmp_actuals.put_first (last_base_type)
							if i /= nb then
								Result := parse_comma (str, Result)
								if Result > str.count + 1 then
									stop := True
								end
							end
						else
							stop := True
							Result := str.count + 2
						end
						i := i + 1
					end
					last_base_type := Void
					if not stop then
						Result := parse_close_bracket (str, Result)
						if Result <= str.count + 1 then
							create an_actuals.make_with_capacity (nb)
							from i := 1 until i > nb loop
								an_actuals.put_first (tmp_actuals.item (i))
								i := i + 1
							end
							create {ET_GENERIC_CLASS_TYPE} last_base_type.make (Void, a_class.name, an_actuals, a_class)
						end
					end
				else
					last_base_type := a_class
					create {ET_CLASS_TYPE} last_base_type.make (Void, create {ET_IDENTIFIER}.make (a_class.name.name), a_class)
				end
			end
		ensure
			valid_position: Result > a_position
			valid_context: last_base_type /= Void implies last_base_type.is_valid_context
		end

	last_base_type: ET_BASE_TYPE
			-- Last class type or tuple type parsed by `parse_base_type';
			-- Void if an error was found when parsing

	parse_open_bracket (str: STRING; a_position: INTEGER): INTEGER is
			-- Parse '[' in `str' starting at `a_position'.
			-- Return the new position in `str', or
			-- 'str.count + 2' if no ']' was found.
		local
			i, nb: INTEGER
			found, error: BOOLEAN
			c: CHARACTER
		do
			from
				i := a_position
				nb := str.count
			until
				i > nb or
				found or error
			loop
				c := str.item (i)
				inspect c
				when '[' then
					i := i + 1
					found := True
				when ' ', '%T', '%R', '%N' then
						-- Skip spaces.
					i := i + 1
				else
					error := True
				end
			end
			if not found or error then
				Result := nb + 2
			else
				Result := i
			end
		ensure
			valid_position: Result > a_position
		end

	parse_comma (str: STRING; a_position: INTEGER): INTEGER is
			-- Parse ',' in `str' starting at `a_position'.
			-- Return the new position in `str', or
			-- 'str.count + 2' if no ']' was found.
		local
			i, nb: INTEGER
			found, error: BOOLEAN
			c: CHARACTER
		do
			from
				i := a_position
				nb := str.count
			until
				i > nb or
				found or error
			loop
				c := str.item (i)
				inspect c
				when ',' then
					i := i + 1
					found := True
				when ' ', '%T', '%R', '%N' then
						-- Skip spaces.
					i := i + 1
				else
					error := True
				end
			end
			if not found or error then
				Result := nb + 2
			else
				Result := i
			end
		ensure
			valid_position: Result > a_position
		end

	parse_close_bracket (str: STRING; a_position: INTEGER): INTEGER is
			-- Parse ']' in `str' starting at `a_position'.
			-- Return the new position in `str', or
			-- 'str.count + 2' if no ']' was found.
		local
			i, nb: INTEGER
			found, error: BOOLEAN
			c: CHARACTER
		do
			from
				i := a_position
				nb := str.count
			until
				i > nb or
				found or error
			loop
				c := str.item (i)
				inspect c
				when ']' then
					i := i + 1
					found := True
				when ' ', '%T', '%R', '%N' then
						-- Skip spaces.
					i := i + 1
				else
					error := True
				end
			end
			if not found or error then
				Result := nb + 2
			elseif found then
				from
					found := False
				until
					i > nb or
					found
				loop
					c := str.item (i)
					inspect c
					when ' ', '%T', '%R', '%N' then
							-- Skip spaces.
						i := i + 1
					else
						found := True
					end
				end
				Result := i
			else
				Result := i
			end
		ensure
			valid_position: Result > a_position
		end

end
