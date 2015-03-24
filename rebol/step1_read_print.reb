REBOL [
    Title: "Mal (make-a-lisp) in Rebol: Step 1"
    Date: 20-Mar-2015
    Author: "Torbjørn Marø"
    Purpose: {
        Implement read and print.
    }
    Note: {

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

forever [
    print rep ask "user> "
]
