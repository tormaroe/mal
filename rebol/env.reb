REBOL [
    Title: ""
]

Env: make object! [
    outer: none
    data: copy []
    binds: copy []
    exprs: copy []

    set: func [key [word!] val] [
        either find' key [
            change skip find/only data key 1 :val
        ] [
            append/only append data key :val
        ]
        :val
    ]

    find': func [key [word!] /local tmp] [
        tmp: select data key
        if none? :tmp [
            if not none? outer [
                tmp: outer/find' key
            ]
        ]
        :tmp
    ]

    get: func [key [word!] /local tmp] [
        tmp: find' key
        if none? :tmp [
           make error! join "'" [key "' not found"]
        ]
        :tmp
    ] 
]

make-env: func [other-env binds exprs /local e] [
    e: make Env [ outer: outer-env ]
    for idx 1 length? binds 1 [
        e/set pick binds idx
              pick exprs idx
    ]
    e
]
