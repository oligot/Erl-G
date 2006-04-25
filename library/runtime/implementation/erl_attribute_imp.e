indexing

	description	: "GERL implementation for ERL_ATTRIBUTE"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_ATTRIBUTE_IMP

inherit

	ERL_ATTRIBUTE

	ERL_QUERY_IMP
	
	INTERNAL
		export {NONE} all end

create

	make,
	make_constant

feature {NONE} -- Initialization

	make (a_name: like name; a_type: like type; a_result_type: ERL_TYPE) is
			-- Create new attribute.
		require
			a_name_not_void: a_name /= Void
			a_type_not_void: a_type /= Void
			a_result_type_not_void: a_result_type /= Void
		do
			name := a_name
			type := a_type
			result_type := a_result_type
		ensure
			a_name_set: name = a_name
			a_type_set: type = a_type
			result_type_set: result_type = a_result_type
			writable: not is_constant
		end

	make_constant (a_value: like last_result; a_name: like name; a_type: like type; a_result_type: ERL_TYPE) is
			-- Create new constant attribute.
		require
			a_name_not_void: a_name /= Void
			a_type_not_void: a_type /= Void
			a_result_type_not_void: a_result_type /= Void
		do
			last_result := a_value
			name := a_name
			type := a_type
			result_type := a_result_type
			is_constant := True
		ensure
			last_result_set: last_result = a_value
			a_name_set: name = a_name
			a_type_set: type = a_type
			result_type_set: result_type = a_result_type
			is_constant: is_constant
		end

feature -- Status report

	is_constant: BOOLEAN

	result_type: ERL_TYPE

	last_result: ANY

	valid_operands (a_target: ANY; a_operands: TUPLE): BOOLEAN is
			-- Are `a_operands' valid operands?
			-- TODO: Check if `a_target' conforms to target object type.
		do
			if a_target /= Void then
				Result := True
			end
		end

	formal_arguments: ERL_LIST [ERL_ARGUMENT] is
			-- Note: attributes do not take attributes.
		once
			create Result.make
		end 

	empty_arguments: TUPLE is
		once
			create Result
		end
		
feature -- Basic Operations

	retrieve_value (a_target: ANY; a_arguments: TUPLE) is
			-- Retrieve query result and store it in `last_result'.
		local
			l_position: INTEGER
			l_field_type: INTEGER
		do
			if not is_constant then
				l_position := position (a_target, name) 
	 			l_field_type := field_type (l_position, a_target)
	 			inspect l_field_type
	 			when Reference_type then
		 			last_result := field (l_position, a_target)
				when Pointer_type then
		 			last_result := pointer_field (l_position, a_target)
				when Boolean_type then
		 			last_result := boolean_field (l_position, a_target)
				when Character_type then
		 			last_result := character_field (l_position, a_target)
				when Real_type then
		 			last_result := real_field (l_position, a_target)
				when Double_type then
		 			last_result := double_field (l_position, a_target)
				when Integer_8_type then
		 			last_result := integer_8_field (l_position, a_target)
				when Integer_16_type then
		 			last_result := integer_16_field (l_position, a_target)
				when Integer_type then
		 			last_result := integer_field (l_position, a_target)
				when Integer_64_type then
		 			last_result := integer_64_field (l_position, a_target)
				when Natural_8_type then
		 			last_result := natural_8_field (l_position, a_target)
				when Natural_16_type then
		 			last_result := natural_16_field (l_position, a_target)
				when Natural_32_type then
		 			last_result := natural_32_field (l_position, a_target)
				when Natural_64_type then
		 			last_result := natural_64_field (l_position, a_target)
				else
					check
						dead_end: False
					end
				end
			end
		end

feature -- Element change

	replace (a_target: ANY; a_value: ANY) is
			-- See `{ERL_ATTRIBUTE}.replace' for more details.
		local
			l_position: INTEGER
			l_field_type: INTEGER
			boolean_ref: BOOLEAN_REF
			pointer_ref: POINTER_REF
			character_ref: CHARACTER_REF
			real_ref: REAL_REF
			double_ref: DOUBLE_REF
			integer_8_ref: INTEGER_8_REF
			integer_16_ref: INTEGER_16_REF
			integer_ref: INTEGER_REF
			integer_64_ref: INTEGER_64_REF
			natural_8_ref: NATURAL_8_REF
			natural_16_ref: NATURAL_16_REF
			natural_32_ref: NATURAL_32_REF
			natural_64_ref: NATURAL_64_REF
		do
			l_position := position (a_target, name) 
 			l_field_type := field_type (l_position, a_target)
 			inspect l_field_type
 			when Reference_type then
	 			set_reference_field (l_position, a_target, a_value)
			when Pointer_type then
				pointer_ref ?= a_value
	 			set_pointer_field (l_position, a_target, pointer_ref)
			when Boolean_type then
				boolean_ref ?= a_value
	 			set_boolean_field (l_position, a_target, boolean_ref)
			when Character_type then
				character_ref ?= a_value
	 			set_character_field (l_position, a_target, character_ref)
			when Real_type then
				real_ref ?= a_value
	 			set_real_field (l_position, a_target, real_ref)
			when Double_type then
				double_ref ?= a_value
	 			set_double_field (l_position, a_target, double_ref)
			when Integer_8_type then
				integer_8_ref ?= a_value
	 			set_integer_8_field (l_position, a_target, integer_8_ref)
			when Integer_16_type then
				integer_16_ref ?= a_value
	 			set_integer_16_field (l_position, a_target, integer_16_ref)
			when Integer_type then
				integer_ref ?= a_value
	 			set_integer_field (l_position, a_target, integer_ref)
			when Integer_64_type then
				integer_64_ref ?= a_value
	 			set_integer_64_field (l_position, a_target, integer_64_ref)
			when Natural_8_type then
				natural_8_ref ?= a_value
	 			set_natural_8_field (l_position, a_target, natural_8_ref)
			when Natural_16_type then
				natural_16_ref ?= a_value
	 			set_natural_16_field (l_position, a_target, natural_16_ref)
			when Natural_32_type then
				natural_32_ref ?= a_value
	 			set_natural_32_field (l_position, a_target, natural_32_ref)
			when Natural_64_type then
				natural_64_ref ?= a_value
	 			set_natural_64_field (l_position, a_target, natural_64_ref)
			else
				check
					dead_end: False
				end
			end
		end

feature {NONE} -- Implementation

	position (a_target: ANY; a_field_name: STRING): INTEGER is
			-- Index of field named `a_field_name' in object `a_target'
			-- TODO: Cache result!
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
				if field_name (i, a_target).is_equal (name) then
					Result := i
					i := count + 1
				else
					i := i + 1  
				end			
			end
		ensure
			position_positive: Result >= 0
		end

end
