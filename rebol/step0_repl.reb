REBOL [
    Title: "Mal (make-a-lisp) in Rebol: Step 0"
    Date: 20-Mar-2015
    Author: "Torbjørn Marø"
    Purpose: {
        Implement a basic REPL that does nothing.
    }
    Note: {
        I added a single quote to READ and PRINT
        in order to not collide with existing
        functions in Rebol.
    }
]

READ': func [str] [
    str
]

EVAL: func [str] [
    str
]

PRINT': func [str] [
    str
]

rep: func [str] [
    PRINT' EVAL READ' str
]

while [true] [
    print rep ask "user> "
]
