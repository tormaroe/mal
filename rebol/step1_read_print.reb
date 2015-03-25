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

do load %reader.reb
do load %printer.reb

READ': func [str] [
    read_str str
]

EVAL: func [ast] [
    ast
]

PRINT': func [exp] [
    pr_str exp
]

rep: func [str] [
    PRINT' EVAL READ' str
]

forever [
    if error? result: try [print rep ask "user> " 'dummy] [
        probe disarm result
    ]
]
