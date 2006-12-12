indexing

	description	: "Reflectable Eiffel Universe. Access it using ERL_G_SHARED_UNIVERSE."
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ERL_UNIVERSE

inherit

	INTERNAL
		export {NONE} all end

feature {NONE} -- Initialization

	make is
		do
			erl_class_id := -2
		end

feature -- Access

	class_by_name (a_name: STRING): ERL_CLASS is
			-- Class with name `a_name', or `Void' if no such class
		require
			a_name_not_void: a_name /= Void
		deferred
		end

	class_by_object (an_object: ANY): ERL_CLASS is
			-- Type for object `an_object'
		do
			if an_object = Void then
				Result := class_by_name ("NONE")
			else
				if erl_class_id = -2 then
					erl_class_id := dynamic_type_from_string ("ERL_CLASS")
				end
				if erl_class_id >= 0 and is_instance_of (an_object, erl_class_id) then
					Result := class_by_name ("ERL_CLASS")
				else
					if class_name (an_object).is_equal ("ANY") then
							-- Workaround: `INTERNAL.type_name' gives wrong info for objects of type ANY
						Result := class_by_name ("ANY")
					else
						Result := class_by_name (class_name (an_object))
					end
				end
			end
		end

feature {NONE} -- Implementation

	erl_class_id: INTEGER

end
