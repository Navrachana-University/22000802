Name: Purv Patel
RollNo: 22000802

Flex (lexer.l) scans the input text and identifies tokens like keywords (int, if), identifiers, numbers, and operators.

Bison (parser.y) uses grammar rules to define how these tokens combine to form valid statements and expressions.

Actions inside grammar rules generate intermediate code like t1 = a + b; for each expression or statement.

A symbol table stores declared variable names to track identifiers.

You compile the code by running:
bison -d parser.y  
flex lexer.l  
gcc -o compiler parser.tab.c lex.yy.c -lf

Then run the compiler with input and output files:
compiler < input.txt > output.txt
The result is intermediate code printed to the output file, simulating a simple compiler's behavior.
