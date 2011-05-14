Message hack - a Win32 automation demo

The purpose of this demo is to write a Win32 program which takes control of
another Win32 app by using message passing.  In this case, the "hack" app
uses a message to cause the demo target app to behave as though a disabled
button was clicked.


Note on Cross-Compliation

Using MinGW it is possible to compile and run this demo using Wine on a
Linux system or something similar.  For example, under Debian / Ubuntu
install the mingw package and compile the demo with the following
commands:

	apt-get install mingw

	i586-mingw32msvc-gcc demo.c -o demo
	i586-mingw32msvc-gcc hack.c -o hack

More info on this subject:

	http://wiki.njh.eu/Cross_Compiling_for_Win32
