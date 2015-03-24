REBOL [
    Title: "Mal Reader"
    Author: "Torbjørn Marø"
]

Reader: make object! [
    tokens: none
    peek: does [ first tokens ]
    next': does [
        tokens: next tokens
        pick tokens -1
    ]
]

digit: charset "0123456789"
int: [opt #"-" some digit]
ws: charset ", "
comment: [#";" [thru newline | to end]]
special: charset "()[]{}'"
symbolchars: charset [#"A" - #"Z" #"a" - #"z" #"0" - #"9" "-_'?*+"]
symbol: [some symbolchars]

tokenize: func [str /local tokens x y] [
    tokens: copy []
    parse/all str [
        some [
            newline
            | comment
            | [some ws]
            | x: [ int | special | symbol ] y: (append tokens copy/part x y)
        ]
    ]
    tokens
]

read_atom: func [rdr /local token] [
    print append copy "READ_ATOM " rdr/peek
    token: rdr/next'
    switch/default token [
        "true" [true]
        "false" [false]
        "nil" [none]
    ] [to-word token]
]

read_list: func [rdr /local ast token] [
    print append copy "READ_LIST " rdr/peek
    ast: copy []
    rdr/next'
    token: rdr/peek
    while [not token = ")"] [
        if not token [
            make error! "expected ), got ___"
        ]
        append/only ast read_form rdr
        token: rdr/peek
    ]
    rdr/next'
    ast
]

read_form: func [rdr] [
    switch/default first rdr/peek [
        #";" [none]
        #"'" [rdr/next' compose [quote (read_form rdr)]]
        #"`" [rdr/next' compose [quasiquote (read_form rdr)]]
        #"~" [rdr/next' compose [unquote (read_form rdr)]]
        #"(" [read_list rdr]
    ] [read_atom rdr]
]

read_str: func [str /local tx] [
    tx: tokenize str
    if not empty? tx [
        read_form make Reader [
            tokens: tx
        ]
    ]
]

