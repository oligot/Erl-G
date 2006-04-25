indexing

	description	: "GERL implementation for ERL_CREATION_PROCEDURE"
	library: "Erl-G"
	copyright: "Copyright (c) 2005, Beat Fluri and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ERL_CREATION_PROCEDURE_IMP

inherit

	ERL_CREATION_PROCEDURE
	
	ERL_SHARED_UNIVERSE
		export {NONE} all end
	
	INTERNAL
		export {NONE} all end

create
	
	make,
	make_default
	
feature {NONE} -- Initialization

	make (a_name: like name; 
			a_formal_arguments: like formal_arguments;
			a_type: like type;
			a_creation_function: like creation_function) is
			-- Create new creation procedure.
		require
			a_name_not_void: a_name /= Void
			a_formal_arguments_not_void: a_formal_arguments /= Void
			a_formal_arguments_doesnt_have_void: not a_formal_arguments.has (Void)
			a_creation_function_not_void: a_creation_function /= Void
			creation_function_argument_match: a_formal_arguments.count = a_creation_function.empty_operands.count  
		do
			name := a_name
			formal_arguments := a_formal_arguments
			type := a_type
			creation_function := a_creation_function
		ensure
			name_set: name = a_name
			formal_arguments_set: formal_arguments = a_formal_arguments
			type_set: type = a_type
			creation_function_set: creation_function = a_creation_function	
		end

	make_default (a_type: like type;
			a_creation_function: like creation_function) is
			-- Create new creation procedure.
		require
			a_creation_function_not_void: a_creation_function /= Void
			creation_function_argument_match: a_creation_function.operands /= Void implies a_creation_function.operands.count = 0
		do
			create formal_arguments.make
			type := a_type
			creation_function := a_creation_function
		ensure
			is_default: is_default
			type_set: type = a_type
			creation_function_set: creation_function = a_creation_function	
		end

feature -- Access

	name: STRING
			-- Name of this creation procedure

	formal_arguments: ERL_LIST [ERL_ARGUMENT]

    type: ERL_TYPE
		    -- Type of objects that this creation procedure creates

    last_result: ANY
		    -- Last object created

	empty_arguments: TUPLE is
		do
			Result ?= new_instance_of (dynamic_type_from_string (argument_tuple_name))
		end

feature -- Status report

    valid_arguments (a_arguments: TUPLE): BOOLEAN is
            -- Are `a_operands' valid operands?
        do
	        Result := creation_function.valid_operands (a_arguments)
        end
    
feature -- Basic operations

	apply (a_arguments: TUPLE)is
			-- Call creation routine with operands `operands'.
		do
			creation_function.call (a_arguments)
			last_result := creation_function.last_result
		end
		
feature {NONE} -- Implementation

	creation_function: FUNCTION [ANY, TUPLE, ANY]
		-- Creation procedure packed into a function agent

	argument_tuple_name: STRING is
			-- Type name of argument tuple
		local
			i: INTEGER
		do
			if argument_tuple_name_cache = Void then
				create argument_tuple_name_cache.make (30)
				argument_tuple_name_cache.append_string ("TUPLE")
				if formal_arguments.count > 0 then
					argument_tuple_name_cache.append_string (" [")
					from
						i := 1
					until
						i > formal_arguments.count
					loop
						argument_tuple_name_cache.append_string (formal_arguments.item (i).type.name)
						i := i + 1
						if i <= formal_arguments.count then
							argument_tuple_name_cache.append_string (", ")
						end
					end
					argument_tuple_name_cache.append_string ("]")
				end
			end
			Result := argument_tuple_name_cache
		ensure
			name_not_void: Result /= Void
			name_not_empty: Result.count > 0
		end
	
	argument_tuple_name_cache: STRING

invariant

	creation_function_not_void: creation_function /= Void 
	creation_function_argument_match: formal_arguments.count = creation_function.empty_operands.count

end
