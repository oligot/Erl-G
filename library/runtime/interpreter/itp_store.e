indexing
	description: "[
		Object store for interpreter
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class ITP_STORE

inherit

	ITP_EXPRESSION_PROCESSOR

	ITP_SHARED_CONSTANT_FACTORY
		export {NONE} all end

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
			-- Is variable named `a_name' defined?
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		do
			lookup_variable (a_name)
			Result := last_variable_defined
		end

	last_variable_defined: BOOLEAN
			-- Was the variable last looked-up defined?

	has_error: BOOLEAN

feature -- Access

	variable_value (a_name: STRING): ITP_CONSTANT is
			-- Value of variable named `a_name'
		require
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
			defined: is_variable_defined (a_name)
		do
			lookup_variable (a_name)
			Result := last_variable_value
		end

	last_variable_value: ITP_CONSTANT
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
			variable: TUPLE [STRING, ITP_CONSTANT]
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

	assign_expression (an_expression: ITP_EXPRESSION; a_name: STRING) is
			-- Assign the value of expression `an_expression' to variable named `a_name'.
			-- Set `has_error' to `True' if expression cannot be assigned.
		require
			an_exprssion_not_void: an_expression /= Void
			a_name_not_void: a_name /= Void
			a_name_not_empty: not a_name.is_empty
		local
			variable: ITP_VARIABLE
			constant: ITP_CONSTANT
			cell: TUPLE [STRING, ITP_CONSTANT]
		do
			variable ?= an_expression
			if variable /= Void then
				lookup_variable (variable.name)
				if last_variable_defined then
					constant := last_variable_value
				else
					constant := Void
				end
			else
				constant ?= an_expression
				check
					constant_not_void: constant /= Void
				end
			end
			if constant = Void then
				has_error := True
			else
				lookup_variable (a_name)
				if last_variable_defined then
					cell := storage.item (last_variable_index)
					cell.put (constant, 2)
				else
					cell := [a_name, constant]
					storage.force_last (cell)
				end
			end
		ensure
			variable_defined: is_variable_defined (a_name) xor has_error
		end

	fill_arguments (an_arguments: TUPLE; an_expression_list: ERL_LIST [ITP_EXPRESSION]) is
			-- Fill `an_arguments' with the values from `an_expression_list'
			-- using `variables' to lookup variable values.
			-- Set `has_error' to `True' if an error occurs.
		require
			an_arguments_not_void: an_arguments /= Void
			an_expression_list_not_void: an_expression_list /= Void
			counts_match: an_arguments.count = an_expression_list.count
		local
			count: INTEGER
		do
			has_error := False
			from
				tuple := an_arguments
				tuple_index := 1
				count := an_expression_list.count
			until
				tuple_index > count
			loop
				an_expression_list.item (tuple_index).process (Current)
				tuple_index := tuple_index + 1
			end
			tuple := Void
		end

feature {ITP_EXPRESSION} -- Processing

	process_boolean (a_value: ITP_BOOLEAN) is
		do
			if tuple.is_boolean_item (tuple_index) then
				tuple.put_boolean (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_character (a_value: ITP_CHARACTER) is
		do
			if tuple.is_character_item (tuple_index) then
				tuple.put_character (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_double (a_value: ITP_DOUBLE) is
		do
			if tuple.is_double_item (tuple_index) then
				tuple.put_double (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_integer_8 (a_value: ITP_INTEGER_8) is
		do
			if tuple.is_integer_8_item (tuple_index) then
				tuple.put_integer_8 (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_integer_16 (a_value: ITP_INTEGER_16) is
		do
			if tuple.is_integer_16_item (tuple_index) then
				tuple.put_integer_16 (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_integer (a_value: ITP_INTEGER) is
		do
			if tuple.is_integer_item (tuple_index) then
				tuple.put_integer (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_integer_64 (a_value: ITP_INTEGER_64) is
		do
			if tuple.is_integer_64_item (tuple_index) then
				tuple.put_integer_64 (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_natural_8 (a_value: ITP_NATURAL_8) is
		do
			if tuple.is_natural_8_item (tuple_index) then
				tuple.put_natural_8 (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_natural_16 (a_value: ITP_NATURAL_16) is
		do
			if tuple.is_natural_16_item (tuple_index) then
				tuple.put_natural_16 (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_natural_32 (a_value: ITP_NATURAL_32) is
		do
			if tuple.is_natural_32_item (tuple_index) then
				tuple.put_natural_32 (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_natural_64 (a_value: ITP_NATURAL_64) is
		do
			if tuple.is_natural_64_item (tuple_index) then
				tuple.put_natural_64 (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_pointer (a_value: ITP_POINTER) is
		do
			if tuple.is_pointer_item (tuple_index) then
				tuple.put_pointer (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_reference (a_value: ITP_REFERENCE) is
		do
			if tuple.is_reference_item (tuple_index) then
				tuple.put (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_real (a_value: ITP_REAL) is
		do
			if tuple.is_real_item (tuple_index) then
				tuple.put_real (a_value.value, tuple_index)
			else
				has_error := True
			end
		end

	process_variable (a_value: ITP_VARIABLE) is
		do
			lookup_variable (a_value.name)
			if not last_variable_defined then
				has_error := True
			else
				last_variable_value.process (Current)
			end
		end

feature {NONE} -- Implementation

	storage: ERL_LIST [TUPLE [STRING, ITP_CONSTANT]]
			-- Variables and their attached values

	tuple: TUPLE
			-- Tuple containing arguments for a call

	tuple_index: INTEGER
			-- Index in `tuple'

invariant

	storage_not_void: storage /= Void

end
