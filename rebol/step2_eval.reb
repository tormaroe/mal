REBOL [
    Title: "Mal (make-a-lisp) in Rebol: Step 2"
    Date: 26-Mar-2015
    Author: "Torbjørn Marø"
    Purpose: {
        Implement eval.
    }
    Note: {

    }
]

do load %types.reb
do load %reader.reb
do load %printer.reb

repl_env: compose [
    "+" ( func[a b][ a + b ] )
    "-" ( func[a b][ a - b ] )
    "*" ( func[a b][ a * b ] )
    "/" ( func[a b][ to-integer (a / b) ] )
]

eval_ast: func [ast env /local eval-in-env] [
    eval-in-env: func [x] [ EVAL x env ]
    switch/default type?/word ast [
        word! [
            select env to-string ast
        ]
        object! [
            quick-seq ast map :eval-in-env
                              ast/values
        ]
    ] [ ast ]
]

READ': func [str] [
    read_str str
]

apply: func[f args] [
    do compose [f (args)]
]

EVAL: func [ast env /local tmp f args] [
    either all [ equal? type? ast object!
                 equal? "(" ast/start ] [
        tmp: eval_ast ast env
        f: first tmp/values
        args: skip tmp/values 1
        apply :f args
    ] [
        eval_ast ast env
    ]
]

PRINT': func [exp] [
    pr_str exp
]

rep: func [str] [
    PRINT' EVAL READ' str repl_env
]

forever [
    if error? result: try [print rep ask "user> " 'dummy] [
        tmp: disarm result
        print tmp
    ]
]
