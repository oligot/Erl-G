indexing
	description: "[
		Object store for interpreter
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ITP_STORE

create

	make

feature {NONE} -- Initialization

	make is
			-- Create new store
		do
			create storage.make_with_capacity (1000)
		end

feature -- Status report

	is_variable_defined (a_name: STRING): BOOLEAN is
			-- Is variable named `a_name' defined in this store?
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		do
			lookup_variable (a_name)
			Result := last_variable_defined
		end

	is_expression_defined (an_expression: ITP_EXPRESSION): BOOLEAN is
			-- Is expression defined in the context of this store? An
			-- expression is defined iff it is a constant or a variable
			-- which is defined in this store.
		require
			an_expression_not_void: an_expression /= Void
		local
			variable: ITP_VARIABLE
		do
			variable ?= an_expression
			if variable /= Void then
				Result := is_variable_defined (variable.name)
			else
				Result := True
			end
		end

	last_variable_defined: BOOLEAN
			-- Was the variable last looked-up defined?

	has_error: BOOLEAN
			-- Has there been an error during an operation?

feature -- Access

	variable_value (a_name: STRING): ANY is
			-- Value of variable named `a_name'
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
			defined: is_variable_defined (a_name)
		do
			lookup_variable (a_name)
			Result := last_variable_value
		end

	expression_value (an_expression: ITP_EXPRESSION): ANY is
			-- Value of expression `an_expression' in the context of this store.
		require
			an_expression_not_void: an_expression /= Void
			an_expression_defined: is_expression_defined (an_expression)
		local
			variable: ITP_VARIABLE
			constant: ITP_CONSTANT
		do
			variable ?= an_expression
			if variable /= Void then
				Result := variable_value (variable.name)
			else
				constant ?= an_expression
					check
						constant_not_void: constant /= Void
					end
				Result := constant.value
			end
		end

	last_variable_value: ANY
			-- Value of last looked-up variable

	last_variable_index: INTEGER
			-- Index in `variables' of last looked-up variable

feature -- Basic routines

	lookup_variable (a_name: STRING) is
			-- Lookup variable `a_name'. If it is not defined set
			-- `last_variable_defined' to `False', else set it to
			-- `True' and `last_variable_value' to its attached value and
			-- `last_variable_index' to the variables index in `variables'.
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: a_name.count > 0
		local
			i: INTEGER
			count: INTEGER
			variable: TUPLE [STRING, ANY]
		do
			last_variable_defined := False
			from
				i := 1
				count := storage.count
			until
				i > count or last_variable_defined
			loop
				variable := storage.item (i)
				if variable.item (1).is_equal (a_name) then
					last_variable_defined := True
					last_variable_value ?= variable.item (2)
					last_variable_index := i
				else
					i := i + 1
				end
			end
		ensure
			index_valid: last_variable_defined implies (last_variable_index >= 1 and last_variable_index <= storage.count)
		end

	assign_value (a_value: ANY; a_name: STRING) is
			-- Assign the value `a_value' to variable named `a_name'.
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		local
			cell: TUPLE [STRING, ANY]
		do
			lookup_variable (a_name)
			if last_variable_defined then
				cell := storage.item (last_variable_index)
				cell.put (a_value, 2)
			else
				cell := [a_name, a_value]
				storage.force_last (cell)
			end
		ensure
			variable_defined: is_variable_defined (a_name) xor has_error
			value_set: variable_value (a_name) = a_value
		end

	assign_expression (an_expression: ITP_EXPRESSION; a_name: STRING) is
			-- Assign the value of expression `an_expression' to variable named `a_name'.
		require
			an_expression_not_void: an_expression /= Void
			an_expression_defined: is_expression_defined (an_expression)
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		local
			variable: ITP_VARIABLE
			constant: ITP_CONSTANT
			value: ANY
		do
			assign_value (expression_value (an_expression), a_name)
		ensure
			variable_defined: is_variable_defined (a_name) xor has_error
		end

	arguments (an_expression_list: ERL_LIST [ITP_EXPRESSION]): ARRAY [ANY] is
			-- Arguments with the values from `an_expression_list'
			-- using `variables' to lookup variable values or `Void'
			-- in case of an error
		require
			an_expression_list_not_void: an_expression_list /= Void
		local
			i: INTEGER
			count: INTEGER
			expression: ITP_EXPRESSION
		do
			from
				count := an_expression_list.count
				create Result.make (1, count)
				i := 1
			until
				i > count or Result = Void
			loop
				expression := an_expression_list.item (i)
				if not is_expression_defined (expression) then
					Result := Void
				else
					Result.put (expression_value (expression), i)
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	storage: ERL_LIST [TUPLE [STRING, ANY]]
			-- Variables and their attached values

invariant

	storage_not_void: storage /= Void

end
