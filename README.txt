I am submitting Kayak to category #1 of the Essies. I hereby give the
judges permission to distribute the archive for their own nefarious
purposes.

Abstract (excerpted from kayak.html):

Kayak is a programming language in which every primitive operation, and
hence every program, is invertible. Any Kayak procedure can be run either
forwards or backwards, or even both within one invocation of the program.
The syntax of Kayak is such that running a procedure in reverse is
equivalent to running a characterwise reversal of that procedure forward.

Of course, there are many useful operations, such as sorting, which
inherently lose information about the input. Programmers wishing to
implement such operations in Kayak can dump the unneeded information into
an optional system-supplied bit bucket. Indeed, they must do so, because
there is no other way to get rid of it.

Building and running details:

The Kayak interpreter is written in C++ using the STL. I have tested it
only with Visual C++ 6.0, but it should work with any standards-compliant
compiler. bf2kayak.pl is written in Perl and should be very portable
(though you might have to change the first line).

To run a Kayak program just specify it on the command line. You can also
specify it in reverse; see the html file for details.
