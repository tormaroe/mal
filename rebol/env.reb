REBOL [
    Title: ""
]

Env: make object! [
    outer: none
    data: copy []
    set: func [key [word!] val] [
        append/only append data to-string key :val
    ]
    find: func [key [word!] /local tmp] [
        tmp: select data to-string key
        if none? :tmp [
            if not none? outer [
                tmp: outer/find key
            ]
        ]
        :tmp
    ]
    get: func [key [word!] /local tmp] [
        tmp: find key
        if none? :tmp [
           make error! join "'" [key "' not found"]
        ]
        :tmp
    ] 
]
