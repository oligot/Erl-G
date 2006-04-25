indexing

	description	: "Objects that create objects of type ITP_CONSTANT"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ITP_CONSTANT_FACTORY

create {ITP_SHARED_CONSTANT_FACTORY}

	make

feature {NONE} -- Initialization

	make is
			-- Create new factory.
		do
		end

feature -- Conversion

	new_constant (a_value: ANY; a_type: ERL_TYPE): ITP_CONSTANT is
			-- New constant of type `a_type' containing the value
			-- `a_value'; note that as long as expanded types don't conform
			-- to any, the corresponding *_REF type has to be used for `a_value'.
		require
			a_type_not_void: a_type /= Void
			a_type_not_custom_expanded: a_type.is_expanded implies a_type.is_basic_type
		local
			boolean_ref: BOOLEAN_REF
			character_ref: CHARACTER_REF
			double_ref: DOUBLE_REF
			integer_8_ref: INTEGER_8_REF
			integer_16_ref: INTEGER_16_REF
			integer_ref: INTEGER_REF
			integer_64_ref: INTEGER_64_REF
			natural_8_ref: NATURAL_8_REF
			natural_16_ref: NATURAL_16_REF
			natural_32_ref: NATURAL_32_REF
			natural_64_ref: NATURAL_64_REF
			pointer_ref: POINTER_REF
			real_ref: REAL_REF
		do
			if a_type.is_expanded then
				if a_type.is_boolean then
					boolean_ref ?= a_value
					check
						boolean_ref_not_void: boolean_ref /= Void
					end
					create {ITP_BOOLEAN} Result.make (boolean_ref.item)
				elseif a_type.is_character then
					character_ref ?= a_value
					check
						character_ref_not_void: character_ref /= Void
					end
					create {ITP_CHARACTER} Result.make (character_ref.item)
				elseif a_type.is_double then
					double_ref ?= a_value
					check
						double_ref_not_void: double_ref /= Void
					end
					create {ITP_DOUBLE} Result.make (double_ref.item)
				elseif a_type.is_integer_8 then
					integer_8_ref ?= a_value
					check
						integer_8_ref_not_void: integer_8_ref /= Void
					end
					create {ITP_INTEGER_8} Result.make (integer_8_ref.item)
				elseif a_type.is_integer_16 then
					integer_16_ref ?= a_value
					check
						integer_16_ref_not_void: integer_16_ref /= Void
					end
					create {ITP_INTEGER_16} Result.make (integer_16_ref.item)
				elseif a_type.is_integer_16 then
					integer_16_ref ?= a_value
					check
						integer_16_ref_not_void: integer_16_ref /= Void
					end
					create {ITP_INTEGER_16} Result.make (integer_16_ref.item)
				elseif a_type.is_integer then
					integer_ref ?= a_value
					check
						integer_ref_not_void: integer_ref /= Void
					end
					create {ITP_INTEGER} Result.make (integer_ref.item)
				elseif a_type.is_integer_64 then
					integer_64_ref ?= a_value
					check
						integer_64_ref_not_void: integer_64_ref /= Void
					end
					create {ITP_INTEGER_64} Result.make (integer_64_ref.item)
				elseif a_type.is_natural_8 then
					natural_8_ref ?= a_value
					check
						natural_8_ref_not_void: natural_8_ref /= Void
					end
					create {ITP_NATURAL_8} Result.make (natural_8_ref.item)
				elseif a_type.is_natural_16 then
					natural_16_ref ?= a_value
					check
						natural_16_ref_not_void: natural_16_ref /= Void
					end
					create {ITP_NATURAL_16} Result.make (natural_16_ref.item)
				elseif a_type.is_natural_32 then
					natural_32_ref ?= a_value
					check
						natural_32_ref_not_void: natural_32_ref /= Void
					end
					create {ITP_NATURAL_32} Result.make (natural_32_ref.item)
				elseif a_type.is_natural_64 then
					natural_64_ref ?= a_value
					check
						natural_64_ref_not_void: natural_64_ref /= Void
					end
					create {ITP_NATURAL_64} Result.make (natural_64_ref.item)
				elseif a_type.is_pointer then
					pointer_ref ?= a_value
					check
						pointer_ref_not_void: pointer_ref /= Void
					end
					create {ITP_POINTER} Result.make (pointer_ref.item)
				elseif a_type.is_real then
					real_ref ?= a_value
					check
						real_ref_not_void: real_ref /= Void
					end
					create {ITP_REAL} Result.make (real_ref.item)
				else
					check
						dead_end: False
					end
				end
			else
				create {ITP_REFERENCE} Result.make (a_value)
			end
		end

end
