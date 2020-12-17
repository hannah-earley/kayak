# Kayak

## Attributions

- Kayak was developed by Ben Roudiak-Gould for the 2002 Essies
- Ben wrote the interpreter (`kayak.cpp`), the brainfuck-to-kayak compiler (`bf2kayak.pl`), the documentation below, and the programs `hello.bf.kayak`, `reverse.kayak`, and `invert.kayak`
- Bertram Felgenhauer wrote `sort3.kayak` (a merge sort discarding data to the bit-bucket)
- The above constitute all the associated files on the [Esoteric Files Archive](https://github.com/graue/esofiles/tree/master/kayak) as of 2020-12-17
- I (Will Earley) wrote `arith.kayak` (reversibilised unary/peano arithmetic, Fibonacci numbers, factorial, as well as routines to read and write space-separated numbers in base 10 (or any base 2-10) from stdin/stdout)

## Disclaimer

I am submitting Kayak to category #1 of the Essies. I hereby give the
judges permission to distribute the archive for their own nefarious
purposes.

## Abstract

Kayak is a programming language in which every primitive operation, and hence every program, is invertible. Any Kayak procedure can be run either forwards or backwards, or even both within one invocation of the program. The syntax of Kayak is such that running a procedure in reverse is equivalent to running a characterwise reversal of that procedure forward.

Of course, there are many useful operations, such as sorting, which inherently lose information about the input. Programmers wishing to implement such operations in Kayak can dump the unneeded information into an optional system-supplied bit bucket. Indeed, they must do so, because there is no other way to get rid of it.

## Building and running details

The Kayak interpreter is written in C++ using the STL. I have tested it
only with Visual C++ 6.0, but it should work with any standards-compliant
compiler. bf2kayak.pl is written in Perl and should be very portable
(though you might have to change the first line).

To run a Kayak program just specify it on the command line. You can also
specify it in reverse; see the html file for details.

## The language

### Lexical structure

A Kayak lexical token is either an identifier or an operator. There are nine operators in Kayak: `<`, `>`, `[`, `]`, `(`, `)`, `{`, `}`, and `|`. Identifiers may not contain whitespace or any of these nine characters, but other than that, anything goes. `!@%$&*@!$`, for example, is a valid identifier. Whitespace serves to delimit adjacent identifiers but is otherwise ignored. There are no reserved words.

### Comments

Comments are introduced by `<` and end with `>`. Comments may be nested.

### Data types

The only data type in Kayak is the infinite stack of bits. As the name implies, this is a stack which can hold only zeroes and ones, and which can be popped indefinitely without underflow. A Kayak program may have arbitrarily many of these stacks. Additionally, there are scoped single-bit temporary registers, as described below.

### Syntax and semantics

Every Kayak program consists of a list of one or more procedures. Procedure definitions look like this:

    name1(arg1|arg2) { body } (arg3|arg4)name2

A procedure's name is bipartite; one half of it appears at the left end of the definition and the other half at the right. Both halves are always specified when calling the procedure, and two procedures may share one half of a name as long as they differ in the other half. Both halves must be nonempty, except in the case of the main procedure (see below).

A procedure may take any number of arguments (but in order to be useful must take at least one). These arguments are named twice, once at the left of the definition and once at the right. Upon entry to the procedure the names at the entry point (which may be either the left or the right) are bound to the arguments of the procedure call, and upon exit (at the other end of the procedure) the caller's arguments are updated with the contents of the variables named at that end. For example, `swap(a|b) {} (b|a)paws` is a procedure which swaps its arguments, while `i(a|b) {} (a|b)i` is a do-nothing procedure of two arguments.

The procedure body is a sequence of commands which are not delimited (except possibly by whitespace). The following commands are available:

| _syntax_ | _description_ |
| -------- | ------------- |
| `identifier` | If the temporary register is unoccupied, the top value is popped off the local variable named by `identifier`, and placed in the temporary register. If the temporary register is occupied, its contents are removed and pushed onto the named stack. So, for example, `foo bar` has the effect of transfering one bit from `foo` to `bar`. |
| `\|` | Complement the value in the temporary register. It is an error to use this instruction when the temporary register is empty. Example: `foo \| foo` has the effect of complementing the top value on the stack `foo`. |
| `[` _body_ `]` | The value in the temporary register is tested and, if it is true, the code in _body_ is executed. If it is not true, the code is skipped. The code in _body_ gets its own independent temporary register; the register used for the test is inaccessible within _body_. It is an error to use this construct when the temporary register (outside the loop) is empty. It is an error to exit the loop when the temporary register (inside the loop) is full. Example: `a[b\|b]a` has the effect of `top(b) ^= top(a)` in C. |
| `name1(arg1\|arg2)name2` | Perform a procedure call to the procedure `name1()name2`. The arguments are names of variables local to the current procedure. These variables may be modified by the called procedure (and should be, since there is no other way for the procedure to have any effect). Recursive calls are legal, and are in fact the only looping construct. If the procedure name is written in reverse (i.e. `2eman(arg2\|arg1)1eman` in this case) then the procedure is called backwards from the current execution direction. This is frequently useful: for example, the reverse of an addition procedure is a subtraction procedure. Procedures with palindromic names cannot be called in reverse. It is recommended (but not enforced) that you use palindromic names only for functions which are self-inverses. |

Note that the occupancy status of a temporary register is a static property which can be checked at parse time (and is, by the present interpreter).


### Variables

All variables referenced within a procedure are local to that procedure invocation. They cease to exist when the procedure returns, unless they are passed out as one of the named parameters at the exit point. At procedure entry, all local variables (except for the parameters at that end) are initialized to hold infinitely many zeroes, and at procedure exit, all local variables (except for the parameters at _that_ end) must again contain only zeroes, or the interpreter will complain.


### The main procedure

The main procedure, is, natch, the top-level procedure run by the interpreter. It is distinguished from other procedures by having an empty name.

The main procedure may be declared to take one argument or two. If it takes one argument, that argument contains the input to the program on entry and must contain the output on exit. If it takes two arguments, the argument closest to the procedure body on both sides is the input/output, and the argument farther from the body is the bit bucket. This is a list which contains random (unpredictable) bits on program entry, and may contain anything the program likes on exit. This is the only way to discard information when performing a many-to-one transformation on the input.


### Input and output encoding

Input and output are encoded in a reasonably simple if brain-damaged way. Each input/output byte is encoded as nine bits on the corresponding stack. The bit closest to the top of the stack is 1, indicating that this byte is valid. The next eight bits are a binary representation of the byte, with the least significant bit nearest the top. This is repeated for each byte, with the first byte of input or output closest to the top of the stack. Below all the bytes are infinitely many zeroes. Thus end-of-input can be detected by checking every ninth bit until a zero is found.

Note that there is no possibility of interaction in a Kayak program, nor of handling infinite input or output.


### That's about it

That really is all there is to it.


## The interpreter

The Kayak interpreter is a hastily-written utility which takes a single command-line argument (e.g. `myprog.kayak`). It looks for a file by that name, and if found runs it in the forward direction. If the file is not found, it looks for the characterwise reversal of that filename (e.g. `kayak.gorpym`), and if found runs it in the reverse direction. Files with palindromic names can be run only in the forward direction. It is recommended (but not enforced) that you use palindromic names only for programs which are self-inverses.

The interpreter has terrible error reporting capabilities: it will report parse errors but give no hint of the context in which they occurred. There's no excuse for this except the fact that I wrote the whole thing a few hours before the deadline for the Essies.


## Sample programs

- `reverse.kayak` reverses its input (and produces no garbage).
- `invert.kayak` reverses its input and exchanges `[{(<` with `]})>`, which is the transformation required to invert a Kayak program. It also produces no garbage. Try running various Kayak programs (including `invert.kayak`) through this filter and running the results. (This should be equivalent to typing the file name in reverse.)
- `bf2kayak.pl` is a Brainfuck-to-Kayak compiler, written in Perl. I haven't tested it carefully, but it works with some simple programs. I hope this will resolve any lingering doubts as to the Turing-completeness of Kayak.


## What's the point?

Reversible programming may sound like a silly game, but it's actually quite possibly the future of computing. Here's why. As far as anyone knows, the laws of physics are reversible: that is, you can run them in reverse and recover the state of the universe at any earlier time. This means that from a physical perspective, information can never be destroyed, only shuffled around. If information disappears from an abstract von Neumann machine, it must show up in some other physical guise. In fact, it shows up as heat, which must then be physically carried away from the computing circuitry to avoid meltdown. It's possible to prove a lower bound on the amount of heat which will be emitted per abstract bit destroyed. So the bit bucket is not a joke -- it's real. The von Neumann architecture is a physically unrealistic model which requires hardware garbage collection (in the form of a heat sink) to support it. Microprocessors which are reversible at the level of their fundamental logic gates can potentially emit radically less heat than irreversible processors, and someday that may make them more economical than irreversible processors.


## Bugs and warts

There may well be bugs in the interpreter or the sample programs, but I don't know of any of them.

Unfortunately, despite Kayak's low-level reversibility not all Kayak programs will work in reverse. There are two reasons for this: first, programs which dump entropy into the bit bucket may hang or otherwise behave badly when run backwards with the bucket contents replaced with random bits. Second, even if the postcondition on local variables (restored to all zeroes) is met in one direction, it will not necessarily be met in the other direction (with different inputs). I would prefer to do without the lists of zeroes, but unfortunately this appears not to be possible. You can't extract any useful computational "work" from the input entropy alone. And as long as you need a source of order, you will have to worry about programs which fail to preserve the order.

On the plus side, this makes writing working reversible Kayak programs a more interesting challenge.
