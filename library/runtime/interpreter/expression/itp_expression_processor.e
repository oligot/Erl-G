indexing
	description: "[
		Object store for interpreter
		]"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

deferred class ITP_EXPRESSION_PROCESSOR

feature {ITP_EXPRESSION} -- Processing

	process_boolean (a_value: ITP_BOOLEAN) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end
	
	process_character (a_value: ITP_CHARACTER) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end
	
	process_double (a_value: ITP_DOUBLE) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end
	
	process_integer_8 (a_value: ITP_INTEGER_8) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end
	
	process_integer_16 (a_value: ITP_INTEGER_16) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end
	
	process_integer (a_value: ITP_INTEGER) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end

	process_integer_64 (a_value: ITP_INTEGER_64) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end
	
	process_natural_8 (a_value: ITP_NATURAL_8) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end

	process_natural_16 (a_value: ITP_NATURAL_16) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end
	
	process_natural_32 (a_value: ITP_NATURAL_32) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end
	
	process_natural_64 (a_value: ITP_NATURAL_64) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end
	
	process_pointer (a_value: ITP_POINTER) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end

	process_real (a_value: ITP_REAL) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end

	process_reference (a_value: ITP_REFERENCE) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end
	
	process_variable (a_value: ITP_VARIABLE) is
			-- Process `a_value'.
		require
			a_value_not_void: a_value /= Void
		deferred
		end

end
