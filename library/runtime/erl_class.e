indexing

	description	: "Objects that represent a reflectable Eiffel class"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_CLASS

inherit

	ERL_SHARED_UNIVERSE
		export {NONE} all end

	INTERNAL
		rename
			is_tuple as is_object_tuple
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make is
		do
		end

feature -- Status report

	is_basic_class: BOOLEAN is
			-- Is class a basic class (i.e. it is one of BOOLEAN, INTEGER, ...)
		deferred
		end

	is_expanded: BOOLEAN is
			-- Is class expanded?
		deferred
		end

	is_boolean: BOOLEAN is
			-- Does current class represent class BOOLEAN
		do
			Result := name.is_equal ("BOOLEAN")
		end

	is_character: BOOLEAN is
			-- Does current class represent class CHARACTER
		do
			Result := name.is_equal ("CHARACTER")
		end

	is_double: BOOLEAN is
			-- Does current class represent class DOUBLE
		do
			Result := name.is_equal ("DOUBLE")
		end

	is_integer_8: BOOLEAN is
			-- Does current class represent class INTEGER
		do
			Result := name.is_equal ("INTEGER_8")
		end

	is_integer_16: BOOLEAN is
			-- Does current class represent class INTEGER_16
		do
			Result := name.is_equal ("INTEGER_16")
		end

	is_integer: BOOLEAN is
			-- Does current class represent class INTEGER
		do
			Result := name.is_equal ("INTEGER")
		end

	is_integer_64: BOOLEAN is
			-- Does current class represent class INTEGER_64
		do
			Result := name.is_equal ("INTEGER_64")
		end

	is_natural_8: BOOLEAN is
			-- Does current class represent class NATURAL_8
		do
			Result := name.is_equal ("NATURAL_8")
		end

	is_natural_16: BOOLEAN is
			-- Does current class represent class NATURAL_16
		do
			Result := name.is_equal ("NATURAL_16")
		end

	is_natural_32: BOOLEAN is
			-- Does current class represent class NATURAL_32
		do
			Result := name.is_equal ("NATURAL_32")
		end

	is_natural_64: BOOLEAN is
			-- Does current class represent class NATURAL_64
		do
			Result := name.is_equal ("NATURAL_64")
		end

	is_pointer: BOOLEAN is
			-- Does current class represent class POINTER
		do
			Result := name.is_equal ("POINTER")
		end

	is_real: BOOLEAN is
			-- Does current class represent class REAL
		do
			Result := name.is_equal ("REAL")
		end

	is_tuple: BOOLEAN is
			-- Does current class represent class TUPLE
		do
			Result := name.is_equal ("TUPLE")
		end

	is_valid_creation_procedure_name (a_actuals: STRING; a_name: STRING): BOOLEAN is
			-- Is `a_name' the name of a creation procedure of this
			-- class? Asking with a Void `a_name' will ask if the default
			-- creation procedure is available.
		require
			a_actuals_not_void: a_actuals /= Void
		do
			Result := creation_function (a_actuals, a_name) /= Void
		end

	is_valid_feature_name (a_name: STRING): BOOLEAN is
			-- Is `a_name' the name of a feature of this class?
		require
			a_name_not_void: a_name /= Void
		do
			Result := feature_ (a_name) /= Void
		end

	is_valid_query_name (a_name: STRING): BOOLEAN is
			-- Is `a_name' the name of a query of this class?
		require
			a_name_not_void: a_name /= Void
		do
			Result := query (a_name) /= Void
		end

	valid_feature_operands (a_name: STRING; a_target: ANY; a_arguments: ARRAY [ANY]): BOOLEAN is
			-- Does the type of `a_target' conform to the current class
			-- and are `a_arguments' valid arguments for the feature
			-- named `a_name' when applied to `a_target'?
		require
			a_name_not_void: a_name /= Void
			a_target_not_void: a_target /= Void
			a_arguments_not_void: a_arguments /= Void
			a_name_valid: is_valid_feature_name (a_name)
		do
			Result := operands (a_name, a_target, a_arguments) /= Void
		end

	is_instantiatable (a_actuals: STRING): BOOLEAN is
			-- Is the type based on the class represented by Current and
			-- `a_actuals' as actual parameters creatable? The actuals
			-- need to be normalized according to the Eiffel style
			-- guidelines.
		require
			a_actuals_not_void: a_actuals /= Void
		deferred
		end

	valid_creation_procedure_arguments (a_actuals: STRING; a_name: STRING; a_arguments: ARRAY [ANY]): BOOLEAN is
			-- Are `a_arguments' valid arguments for the creation
			-- procedure `a_name' of this class?
		require
			a_actuals_not_void: a_actuals /= Void
			a_arguments_not_void: a_arguments /= Void
			a_name_valid: is_valid_creation_procedure_name (a_actuals, a_name)
			is_instantiatable: is_instantiatable (a_actuals)
		do
			Result := creation_function_operands (a_actuals, a_name, a_arguments) /= Void
		end

feature -- Access

	name: STRING is
			-- Name of this class
		deferred
		ensure
			name_not_void: Result /= Void
			name_not_empty: not Result.is_empty
		end

	last_result: ANY
			-- Last query result retrieved via `invoke_query' or
			-- `invoke_create'

	parents: ARRAY [ERL_CLASS] is
			-- Direct ancestors of current class
		deferred
		ensure
			parents_not_void: Result /= Void
			no_parent_void: not Result.has (Void)
		end

feature -- Invokation

	invoke_creation_procedure (a_actuals: STRING; a_name: STRING; a_arguments: ARRAY [ANY]) is
			-- Invoke creation procedure named `a_name' using the
			-- arguments `a_arguments'. Use the default creation
			-- procedure if `a_name' is Void. Make newly created object
			-- available via `last_result'.
		require
			a_actuals_not_void: a_actuals /= Void
			a_arguments_exist: a_arguments /= Void
			is_instantiatable: is_instantiatable (a_actuals)
			a_arguments_valid: valid_creation_procedure_arguments (a_actuals, a_name, a_arguments)
		local
			function: like creation_function
		do
			function := creation_function (a_actuals, a_name)
			function.call (creation_function_operands (a_actuals, a_name, a_arguments))
			last_result := function_result (function)
		ensure
			last_result_not_void: last_result /= Void
		end

	creation_function (a_actuals: STRING; a_name: STRING): FUNCTION [ANY, TUPLE, ANY] is
			-- Creation function named `a_name' for the type based on the
			-- class represented by Current and the actuals `a_actuals';
			-- the default creation procedure can be queried using a void
			-- name (if it exists for the given type). Note that the
			-- actuals must be normalized according to the Eiffel style
			-- guidelines.
		require
			a_actuals_not_void: a_actuals /= Void
			is_instantiatable: is_instantiatable (a_actuals)
		deferred
		end

	invoke_feature (a_name: STRING; a_target: ANY; a_arguments: ARRAY [ANY]) is
			-- Invoke feature named `a_name' on `a_target' using `a_arguments'. Dismiss results if any.
		require
			a_name_not_void: a_name /= Void
			a_target_not_void: a_target /= Void
			a_arguments_not_void: a_arguments /= Void
			a_name_valid: is_valid_feature_name (a_name)
			valid_operands: valid_feature_operands (a_name, a_target, a_arguments)
		do
			feature_ (a_name).call (operands (a_name, a_target, a_arguments))
		end

	invoke_query (a_name: STRING; a_target: ANY; a_arguments: ARRAY [ANY]) is
			-- Invoke query named `a_name' on `a_target' using `a_arguments' and store the result in `last_result'.
		require
			a_name_not_void: a_name /= Void
			a_target_not_void: a_target /= Void
			a_arguments_not_void: a_arguments /= Void
			a_name_valid: is_valid_query_name (a_name)
			valid_operands: valid_feature_operands (a_name, a_target, a_arguments)
		local
			function: like query
		do
			function := query (a_name)
			function.call (operands (a_name, a_target, a_arguments))
			last_result := function_result (function)
		end

	feature_ (a_name: STRING): ROUTINE [ANY, TUPLE] is
			-- Feature named `a_name'
		require
			a_name_not_void: a_name /= Void
		local
			i: INTEGER
		do
			Result := immediate_feature (a_name)
			if Result = Void then
				from
					i := 1
				until
					i > parents.count or Result /= Void
				loop
					Result := parents.item (i).feature_ (a_name)
					i := i + 1
				end
			end
		end

	query (a_name: STRING): FUNCTION [ANY, TUPLE, ANY] is
			-- Function named `a_name'
		require
			a_name_not_void: a_name /= Void
		local
			i: INTEGER
		do
			Result := immediate_query (a_name)
			if Result = Void then
				from
					i := 1
				until
					i > parents.count or Result /= Void
				loop
					Result := parents.item (i).query (a_name)
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	function_result (a_function: FUNCTION [ANY, TUPLE, ANY]): ANY is
			-- Last result of function `a_function';
			-- Note: This function is only here as long as EiffelStudio cannot
			-- automatically assign expanded values to ANY (bug #10471)
		require
			a_function_not_void: a_function /= Void
		local
			boolean: FUNCTION [ANY, TUPLE, BOOLEAN]
			character_32: FUNCTION [ANY, TUPLE, CHARACTER_32]
			character_8: FUNCTION [ANY, TUPLE, CHARACTER_8]
			integer_16: FUNCTION [ANY, TUPLE, INTEGER_16]
			integer_32: FUNCTION [ANY, TUPLE, INTEGER_32]
			integer_64: FUNCTION [ANY, TUPLE, INTEGER_64]
			integer_8: FUNCTION [ANY, TUPLE, INTEGER_8]
			natural_16: FUNCTION [ANY, TUPLE, NATURAL_16]
			natural_32: FUNCTION [ANY, TUPLE, NATURAL_32]
			natural_64: FUNCTION [ANY, TUPLE, NATURAL_64]
			natural_8: FUNCTION [ANY, TUPLE, NATURAL_8]
			real_32: FUNCTION [ANY, TUPLE, REAL_32]
			real_64: FUNCTION [ANY, TUPLE, REAL_64]
			pointer: FUNCTION [ANY, TUPLE, POINTER]
		do
			boolean ?= a_function
			character_32 ?= a_function
			character_8 ?= a_function
			integer_16 ?= a_function
			integer_32 ?= a_function
			integer_64 ?= a_function
			integer_8 ?= a_function
			natural_16 ?= a_function
			natural_32 ?= a_function
			natural_64 ?= a_function
			natural_8 ?= a_function
			real_32 ?= a_function
			real_64 ?= a_function
			pointer ?= a_function

			if boolean /= Void then
				Result := boolean.last_result
			elseif character_32 /= Void then
				Result := character_32.last_result
			elseif character_8 /= Void then
				Result := character_8.last_result
			elseif integer_16 /= Void then
				Result := integer_16.last_result
			elseif integer_32 /= Void then
				Result := integer_32.last_result
			elseif integer_64 /= Void then
				Result := integer_64.last_result
			elseif integer_8 /= Void then
				Result := integer_8.last_result
			elseif natural_16 /= Void then
				Result := natural_16.last_result
			elseif natural_32 /= Void then
				Result := natural_32.last_result
			elseif natural_64 /= Void then
				Result := natural_64.last_result
			elseif natural_8 /= Void then
				Result := natural_8.last_result
			elseif real_32 /= Void then
				Result := real_32.last_result
			elseif real_64 /= Void then
				Result := real_64.last_result
			elseif pointer /= Void then
				Result := pointer.last_result
			else
				Result := a_function.last_result
			end
		end

	immediate_feature (a_name: STRING): ROUTINE [ANY, TUPLE] is
			-- Immediate feature named `a_name'
		require
			a_name_not_void: a_name /= Void
		deferred
		end

	immediate_query (a_name: STRING): FUNCTION [ANY, TUPLE, ANY] is
			-- Immediate query named `a_name'
		require
			a_name_not_void: a_name /= Void
		deferred
		end

	creation_function_operands (a_actuals: STRING; a_name: STRING; an_arguments: ARRAY [ANY]): TUPLE is
			-- Operand tuple for creation procedure `a_name' containing
			--  the items of `a_arguments' or `Void' if -- there is a
			--  type mismatch
		require
			a_actuals_not_void: a_actuals /= Void
			is_instantiatable: is_instantiatable (a_actuals)
			an_arguments_not_void: an_arguments /= Void
			a_name_valid: is_valid_creation_procedure_name (a_actuals, a_name)
		local
			i: INTEGER
		do
			Result := creation_function (a_actuals, a_name).empty_operands
			if Result = Void then
				create Result
			elseif Result.count /= an_arguments.count then
				Result := Void
			else
				Result := Result.twin
				from
					i := 1
				until
					i > an_arguments.count or Result = Void
				loop
					if Result.valid_type_for_index (an_arguments.item (i), i) then
						Result.put (an_arguments.item (i), i)
						i := i + 1
					else
						Result := Void
					end
				end
			end
		ensure
			operands_count_valid: Result /= Void implies Result.count = an_arguments.count
		end

	operands (a_name: STRING; a_target: ANY; an_arguments: ARRAY [ANY]): TUPLE is
			-- Operand tuple for feature `a_name' containing `a_target'
			-- and the items of `a_arguments' or `Void' if there is a
			-- type mismatch
		require
			a_name_not_void: a_name /= Void
			a_target_not_void: a_target /= Void
			an_arguments_not_void: an_arguments /= Void
			a_name_valid: is_valid_feature_name (a_name)
		local
			i: INTEGER
		do
			Result := feature_ (a_name).empty_operands.twin
			if
				Result.count /= an_arguments.count + 1 or
				not Result.valid_type_for_index (a_target, 1)
			then
				Result := Void
			else
				Result.put (a_target, 1)
				from
					i := 1
				until
					i > an_arguments.count or Result = Void
				loop
					if Result.valid_type_for_index (an_arguments.item (i), i + 1) then
						Result.put (an_arguments.item (i), i + 1)
						i := i + 1
					else
						Result := Void
					end
				end
			end
		ensure
			operands_count_valid: Result /= Void implies Result.count = an_arguments.count + 1
			target_set: Result /= Void implies Result.item (1) = a_target
		end

	attribute_value (a_name: STRING; a_target: ANY): ANY is
			-- Value of attribute named `a_name' of object `a_target'
		require
			a_name_not_void: a_name /= Void
			a_target_not_void: a_target /= Void
		local
			l_position: INTEGER
			l_field_type: INTEGER
		do
			l_position := position (a_target, a_name)
			check
				l_position_not_zero: l_position /= 0
			end
			l_field_type := field_type (l_position, a_target)
			inspect l_field_type
			when Reference_type then
				Result := field (l_position, a_target)
			when Pointer_type then
				Result := pointer_field (l_position, a_target)
			when Boolean_type then
				Result := boolean_field (l_position, a_target)
			when Character_type then
				Result := character_field (l_position, a_target)
			when Real_type then
				Result := real_field (l_position, a_target)
			when Double_type then
				Result := double_field (l_position, a_target)
			when Integer_8_type then
				Result := integer_8_field (l_position, a_target)
			when Integer_16_type then
				Result := integer_16_field (l_position, a_target)
			when Integer_type then
				Result := integer_field (l_position, a_target)
			when Integer_64_type then
				Result := integer_64_field (l_position, a_target)
			when Natural_8_type then
				Result := natural_8_field (l_position, a_target)
			when Natural_16_type then
				Result := natural_16_field (l_position, a_target)
			when Natural_32_type then
				Result := natural_32_field (l_position, a_target)
			when Natural_64_type then
				Result := natural_64_field (l_position, a_target)
			else
					check
						dead_end: False
					end
			end
		end

	position (a_target: ANY; a_field_name: STRING): INTEGER is
			-- Index of field named `a_field_name' in object `a_target'
		local
			i: INTEGER
			count: INTEGER
		do
			count := field_count (a_target)
			from
				i := 1
			until
				i > count
			loop
				if field_name (i, a_target).is_equal (a_field_name) then
					Result := i
					i := count + 1
				else
					i := i + 1
				end
			end
		ensure
			position_positive: Result >= 0
		end

	identity (v: ANY; o: ANY): ANY is
			-- Identidy of `v', ignore `o'
		do
			Result := v
		ensure
			definition: Result = v
		end

end
