indexing

	description:

		"Vi tags file generators"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class TAG_VI_GENERATOR

inherit

	TAG_GENERATOR
		redefine
			generate
		end

	TAG_VERSION
		export {NONE} all end

creation

	make

feature -- Generation

	generate (a_file: KI_TEXT_OUTPUT_STREAM) is
		do
			a_file.put_line ("!_TAG_FILE_SORTED%T0%T/0=unsorted, 1=sorted, 2=foldcase/")
			a_file.put_line ("!_TAG_PROGRAM_AUTHOR%TAndreas Leitner%T/aleitner@raboof.at/")
			a_file.put_line ("!_TAG_PROGRAM_NAME%Tgutentag%T//")
			a_file.put_line ("!_TAG_PROGRAM_URL	http://www.raboof.at/various%T/official site/")
			a_file.put_string ("!_TAG_PROGRAM_VERSION%T")
			a_file.put_string (Version_number)
			a_file.put_line ("%T//")
			Precursor (a_file)
		end


feature {NONE} -- Generation

	generate_class (a_class: ET_CLASS) is
			-- Generate tags for class `a_class'.
		local
			i: INTEGER
			features: ET_FEATURE_LIST
		do
			current_file.put_string (a_class.name.name)
			current_file.put_character ('%T')
			current_file.put_string (a_class.filename)
			current_file.put_character ('%T')
			current_file.put_character (':')
			current_file.put_integer (a_class.class_keyword.position.line)
			current_file.put_new_line
			from
				features := a_class.queries
				i := 1
			until
				i > features.count
			loop
				generate_feature (a_class, features.item (i))
				i := i + 1
			end
			from
				features := a_class.procedures
				i := 1
			until
				i > features.count
			loop
				generate_feature (a_class, features.item (i))
				i := i + 1
			end
		end

	generate_feature (a_class: ET_CLASS; a_feature: ET_FEATURE) is
			-- Generate tags for feature `a_feature' from class `a_class'.
		require
			a_class_not_void: a_class /= Void
			a_class_has_filename: a_class.filename /= Void
			a_feature_not_void: a_feature /= Void
		do
			current_file.put_string (a_feature.name.name)
			current_file.put_character ('%T')
			current_file.put_string (a_class.filename)
			current_file.put_character ('%T')
			current_file.put_character (':')
			current_file.put_integer (a_feature.position.line)
			current_file.put_new_line
		end

end
