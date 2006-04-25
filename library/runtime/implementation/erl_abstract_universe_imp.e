indexing
	description	: "Abstract Erl-G Universe. Concrete descendant will be generated."
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_ABSTRACT_UNIVERSE_IMP

inherit

	ERL_UNIVERSE

	INTERNAL
		export {NONE} all end

feature {NONE} -- Initialization

	make is
		do
			erl_abstract_type_imp_type_id := -2
		end

feature -- Access

	type_by_object (an_object: ANY): ERL_TYPE is
			-- Type for object `an_object'
		do
			if an_object = Void then
				Result := type_by_name ("NONE")
			else
				if erl_abstract_type_imp_type_id = -2 then
					erl_abstract_type_imp_type_id := dynamic_type_from_string ("ERL_ABSTRACT_TYPE_IMP")
				end
				if erl_abstract_type_imp_type_id >= 0 and is_instance_of (an_object, erl_abstract_type_imp_type_id) then
					Result := type_by_name ("ERL_ABSTRACT_TYPE_IMP")
				else
					if class_name (an_object).is_equal ("ANY") then
							-- Workaround: `INTERNAL.type_name' gives wrong info for objects of type ANY
						Result := type_by_name ("ANY")
					else
						Result := type_by_name (type_name (an_object))
					end
				end
			end
		end

feature {NONE} -- Implementation

	erl_abstract_type_imp_type_id: INTEGER

end
