REBOL [
    Title: ""
]

map: func [projection xs /local new] [
    new: copy []
    foreach x xs [
        append new projection x
    ]
    new
]

pr_str: func [ast] [
    switch/default type?/word ast [
        block! [join "(" compose [(form map :pr_str ast) ")"]]
    ] [to-string ast]
]
