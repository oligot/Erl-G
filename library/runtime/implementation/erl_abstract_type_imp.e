indexing

	description	: "Abstract ERL_G type. Concrete descendant will be generated."
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_ABSTRACT_TYPE_IMP

inherit

	ERL_TYPE

	ERL_SHARED_UNIVERSE
		export {NONE} all end

	INTERNAL
		export {NONE} all end

feature {NONE} -- Initialization

	make is
			-- Initialize `Current'.
		do
			type_id := dynamic_type_from_string (name)
		end

feature -- Status report

	is_boolean: BOOLEAN is
		do
			Result := name.is_equal ("BOOLEAN")
		end

	is_character: BOOLEAN is
		do
			Result := name.is_equal ("CHARACTER")
		end

	is_double: BOOLEAN is
		do
			Result := name.is_equal ("DOUBLE")
		end

	is_integer_8: BOOLEAN is
		do
			Result := name.is_equal ("INTEGER_8")
		end

	is_integer_16: BOOLEAN is
		do
			Result := name.is_equal ("INTEGER_16")
		end

	is_integer: BOOLEAN is
		do
			Result := name.is_equal ("INTEGER")
		end

	is_integer_64: BOOLEAN is
		do
			Result := name.is_equal ("INTEGER_64")
		end

	is_natural_8: BOOLEAN is
		do
			Result := name.is_equal ("NATURAL_8")
		end

	is_natural_16: BOOLEAN is
		do
			Result := name.is_equal ("NATURAL_16")
		end

	is_natural_32: BOOLEAN is
		do
			Result := name.is_equal ("NATURAL_32")
		end

	is_natural_64: BOOLEAN is
		do
			Result := name.is_equal ("NATURAL_64")
		end

	is_pointer: BOOLEAN is
		do
			Result := name.is_equal ("POINTER")
		end

	is_real: BOOLEAN is
		do
			Result := name.is_equal ("REAL")
		end

feature -- Access

	name: STRING is
		deferred
		ensure then
			valid_type_string: is_valid_type_string (Result)
		end

	conforms_to_type (other: ERL_TYPE): BOOLEAN is
		local
			other_imp: ERL_ABSTRACT_TYPE_IMP
		do
			other_imp ?= other
			check
				other_imp_not_void: other_imp /= Void
			end
			if type_id = -1 then
				if other.is_expanded then
					Result := False
				else
					Result := True
				end
			else
				if other_imp.type_id = -1 then
					Result := False
				else
					Result := type_conforms_to (type_id, other_imp.type_id)
				end
			end
		end


feature {ERL_ABSTRACT_TYPE_IMP} -- Implementation

	type_id: INTEGER

feature {NONE} -- Implementation

	cached_actual_arguments: ERL_LIST [ERL_TYPE]
			-- Cached `actual_arguments'

invariant

	none_type_id: (name.is_equal ("NONE") = (type_id = -1))
	other_type_id: (not name.is_equal ("NONE") = (type_id >= 0))

end
