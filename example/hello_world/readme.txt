This is a simple example that demonstrates the use of Erl-G. To run the
example you have to do the following:

Run `geant install'
 
  This will run the 'erl_g' tool. Via the file 'build.eant' 'erl_g' is
  instructed to generate meta-classes for class PERSON. To see the
  exact command line used to invoke the 'erl_g' tool, issue 'geant -v
  install'. The resulting meta classes will be stored in directory 
  'reflection_library'.

Compile the example with EiffelStudio using the file `hello_world.ecf'

  This will compile a system with the root class HELLO_WORLD. The
  generated executable will at runtime introspect and use the features of
  class PERSON.


Please note that the example depends only on the Erl-G runtime classes
and not on all of Erl-G and its dependencies.

