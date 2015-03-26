REBOL [
    Title: "Mal Reader"
    Author: "Torbjørn Marø"
]

Reader: make object! [
    tokens: none
    peek: does [ 
        if not empty? tokens [
            first tokens
        ]
    ]
    next': does [
        tokens: next tokens
        pick tokens -1
    ]
]

digit: charset "0123456789"
int: [opt #"-" some digit]
ws: charset ", "
chars: complement charset {\"}
comment: [#";" [thru newline | to end]]
special: charset "()[]{}'`~@^^"
symbolchars: charset [#"A" - #"Z" #"a" - #"z" #"0" - #"9" "-_`'?*+:/"]
symbol: [some symbolchars]
string-literal: [#"^"" any [some chars | "\^"" | "\n" | "\r" | "\t" ]  #"^""]

tokenize: func [str /local tokens x y] [
    tokens: copy []
    parse/all str [
        some [
            newline
            | comment
            | [some ws]
            | x: [ int | ["~@" | special] | symbol | string-literal ] y: (
                append tokens copy/part x y
              )
        ]
    ]
    tokens
]

read_atom: func [rdr /local token] [
    token: rdr/next'
    switch/default token [
        "true" [true]
        "false" [false]
        "nil" [none]
    ] [
        either parse token [ some digit ] [
            to-integer token
        ] [
            switch/default first token [
                #"^"" [ token ]
                #":"  [ token ]
            ] [ to-word token ]
        ]
    ]
]

read_list: func [rdr /local ast token seq] [
    ast: copy []
    seq: seq-factory rdr/next'
    token: rdr/peek
    while [not token = seq/end] [
        if not token [
            make error! "expected ')', got EOF"
        ]
        append/only ast read_form rdr
        token: rdr/peek
    ]
    rdr/next'
    seq/values: ast
    seq
]

read_form: func [rdr /local tmp] [
    either rdr/peek = "~@" [
        rdr/next' quick-list compose/only [splice-unquote (read_form rdr)]
    ] [
        switch/default first rdr/peek [
            #";" [none]
            #"'" [rdr/next' quick-list compose/only [quote (read_form rdr)]]
            #"`" [rdr/next' quick-list compose/only [quasiquote (read_form rdr)]]
            #"~" [rdr/next' quick-list compose/only [unquote (read_form rdr)]]
            #"@" [rdr/next' quick-list compose/only [deref (read_form rdr)]]
            #"^^" [
                rdr/next' 
                tmp: read_form rdr
                quick-list compose/only [with-meta (read_form rdr) (tmp)]
            ]
            #"(" [read_list rdr]
            #"[" [read_list rdr]
            #"{" [read_list rdr]
        ] [read_atom rdr]
    ]
]

read_str: func [str /local tx] [
    tx: tokenize str
    if not empty? tx [
        read_form make Reader [
            tokens: tx
        ]
    ]
]

