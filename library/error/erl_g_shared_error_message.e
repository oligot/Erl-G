indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERL_G_SHARED_ERROR_MESSAGE

feature -- Access

	cannot_create_file_error (a_filename: STRING): STRING is
			-- Cannot create file named `a_filename' error.
		do
			Result := "Cannot create file '" + a_filename + "' for writing."
		end

	reflection_generator_has_error: STRING is
			-- Reflection generator has error.
		do
			Result := "Error occured in reflection library generator."
		end

	class_not_compiled_or_contain_error (a_class_path: STRING): STRING is
			-- Class `a_class_path' contains error.
		do
			Result := "Class '" + a_class_path + "' not compiled or contains error."
		end

end
