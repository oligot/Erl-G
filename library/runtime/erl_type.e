indexing

	description	: "Objects that represent a reflectable Eiffel type"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_TYPE

inherit

	ANY

feature -- Status report

	is_expanded: BOOLEAN is
			-- Is type expanded?
		deferred
		end

	is_basic_type: BOOLEAN is
			-- Is type a basic type (INTEGER,...)?
		deferred
		end

	conforms_to_type (other: ERL_TYPE): BOOLEAN is
			-- Does current type conform to `other' type?
		require
			other_not_void: other /= VOid
		deferred
		end

	is_boolean: BOOLEAN is
			-- Does current type represent type BOOLEAN
		deferred
		end

	is_character: BOOLEAN is
			-- Does current type represent type CHARACTER
		deferred
		end

	is_double: BOOLEAN is
			-- Does current type represent type DOUBLE
		deferred
		end

	is_integer_8: BOOLEAN is
			-- Does current type represent type INTEGER_8
		deferred
		end

	is_integer_16: BOOLEAN is
			-- Does current type represent type INTEGER_16
		deferred
		end

	is_integer: BOOLEAN is
			-- Does current type represent type INTEGER
		deferred
		end

	is_integer_64: BOOLEAN is
			-- Does current type represent type INTEGER_64
		deferred
		end

	is_natural_8: BOOLEAN is
			-- Does current type represent type NATURAL_8
		deferred
		end

	is_natural_16: BOOLEAN is
			-- Does current type represent type NATURAL_16
		deferred
		end

	is_natural_32: BOOLEAN is
			-- Does current type represent type NATURAL_32
		deferred
		end

	is_natural_64: BOOLEAN is
			-- Does current type represent type NATURAL_64
		deferred
		end

	is_pointer: BOOLEAN is
			-- Does current type represent type POINTER
		deferred
		end

	is_real: BOOLEAN is
			-- Does current type represent type REAL
		deferred
		end

feature -- Access

	name: STRING is
			-- Name of this type
		deferred
		ensure
			name_not_void: Result /= Void
			name_not_empty: not Result.is_empty
		end

	creation_procedure_count: INTEGER is
			-- Number of creation procedures of this type
		deferred
		ensure
			creation_procedure_count_positive: Result >= 0
		end

	feature_count: INTEGER is
			-- Number of features of this type
		deferred
		ensure
			feature_count_positive: Result >= 0
		end

	query_count: INTEGER is
			-- Number of queries of this type
		deferred
		ensure
			query_count_positive: Result >= 0
		end

	attribute_count: INTEGER is
			-- Number of attribute of this type
		deferred
		ensure
			attribute_count_positive: Result >= 0
		end

	function_count: INTEGER is
			-- Number of functions of this type
		deferred
		ensure
			function_count_positive: Result >= 0
		end

	procedure_count: INTEGER is
			-- Number of procedures of this type
		deferred
		ensure
			procedure_count_positive: Result >= 0
		end

	creation_procedure (an_index: INTEGER): ERL_CREATION_PROCEDURE is
			-- Creation procedure with index `an_index'
		require
			an_index_valid: an_index >= 1 and an_index <= creation_procedure_count
		deferred
		ensure
			creation_procedure_not_void: Result /= Void
		end

	creation_procedure_by_name (a_name: STRING): ERL_CREATION_PROCEDURE is
			-- Creation procedure with name `a_name'; `Void' if no such
			-- creation procedure exists.
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		deferred
		ensure
			name_matches: Result /= Void implies Result.name.is_equal (a_name)
		end

	default_creation_procedure: ERL_CREATION_PROCEDURE is
			-- Default creation procedure (if available)
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > creation_procedure_count or Result /= Void
			loop
				if creation_procedure (i).is_default then
					Result := creation_procedure (i)
				else
					i := i + 1
				end
			end
		end

	feature_ (an_index: INTEGER): ERL_FEATURE is
			-- Feature with index `an_index'
		require
			an_index_valid: an_index >= 1 and an_index <= feature_count
		deferred
		ensure
			feature_not_void: Result /= Void
		end

	feature_by_name (a_name: STRING): ERL_FEATURE is
			-- Feature with name `a_name'; `Void' if no such
			-- feature exists.
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		deferred
		ensure
			name_matches: Result /= Void implies Result.name.is_equal (a_name)
		end

	query (an_index: INTEGER): ERL_QUERY is
			-- Query with index `an_index'
		require
			an_index_valid: an_index >= 1 and an_index <= query_count
		deferred
		ensure
			query_not_void: Result /= Void
		end

	query_by_name (a_name: STRING): ERL_QUERY is
			-- Query with name `a_name'; `Void' if no such
			-- query exists.
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		deferred
		ensure
			name_matches: Result /= Void implies Result.name.is_equal (a_name)
		end

	attribute (an_index: INTEGER): ERL_ATTRIBUTE is
			-- Attribute with index `an_index'
		require
			an_index_valid: an_index >= 1 and an_index <= attribute_count
		deferred
		ensure
			attribute_not_void: Result /= Void
		end

	attribute_by_name (a_name: STRING): ERL_ATTRIBUTE is
			-- Attribute with name `a_name'; `Void' if no such
			-- attribute exists.
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		deferred
		ensure
			name_matches: Result /= Void implies Result.name.is_equal (a_name)
		end

	function (an_index: INTEGER): ERL_FUNCTION is
			-- Function with index `an_index'
		require
			an_index_valid: an_index >= 1 and an_index <= function_count
		deferred
		ensure
			function_not_void: Result /= Void
		end

	function_by_name (a_name: STRING): ERL_FUNCTION is
			-- Function with name `a_name'; `Void' if no such
			-- function exists.
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		deferred
		ensure
			name_matches: Result /= Void implies Result.name.is_equal (a_name)
		end

	procedure (an_index: INTEGER): ERL_PROCEDURE is
			-- Procedure with index `an_index'
		require
			an_index_valid: an_index >= 1 and an_index <= procedure_count
		deferred
		ensure
			procedure_not_void: Result /= Void
		end

	procedure_by_name (a_name: STRING): ERL_PROCEDURE is
			-- Procedure with name `a_name'; `Void' if no such
			-- procedure exists.
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		deferred
		ensure
			name_matches: Result /= Void implies Result.name.is_equal (a_name)
		end

end
