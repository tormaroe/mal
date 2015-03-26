REBOL [
    Title: "Mal (make-a-lisp) in Rebol: Step 3"
    Date: 26-Mar-2015
    Author: "Torbjørn Marø"
    Purpose: {
        Environments
    }
    Note: {

    }
]

do load %types.reb
do load %env.reb
do load %reader.reb
do load %printer.reb

repl_env: make Env []
repl_env/set '+ (func[a b][ a + b ])
repl_env/set '- func[a b][ a - b ]
repl_env/set '* func[a b][ a * b ]
repl_env/set to-word "/" func[a b][ to-integer (a / b) ]

eval_ast: func [ast env /local eval-in-env] [
    eval-in-env: func [x] [ EVAL x env ]
    switch/default type?/word ast [
        word! [
            env/get ast
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

apply: func [list] [
    do compose [(first list/values) (skip list/values 1)]
]

EVAL: func [ast env /local let-env tmp] [
    either all [ equal? type? ast object!
                 equal? "(" ast/start ] [
        switch/default first ast/values [
            def! [ 
                env/set pick ast/values 2 
                        EVAL pick ast/values 3 env 
            ]
            let* [
                let-env: make Env [ outer: env ]
                tmp: pick ast/values 2
                print ["TMP" tmp]
                forskip tmp/values 2 [
                    print "FOREACH"
                    env/set first tmp/values
                            EVAL second tmp/values let-env
                ]
                print "END FORSKIP"
                EVAL pick ast/values 3 let-env
            ]
        ] [ 
            apply eval_ast ast env 
        ]
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
        print tmp/arg1
    ]
]
