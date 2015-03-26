REBOL [
    Title: "Mal Reader"
    Author: "Torbjørn Marø"
]

mal-seq: make object! [
    start: none
    end: none
    values: none
]

make-mal-vector: does [
    make mal-seq [ start: copy "[" end: copy "]" ]
]

make-mal-hashmap: does [
    make mal-seq [ start: copy "{" end: copy "}" ]
]

make-mal-list: does [
    make mal-seq [ start: copy "(" end: copy ")" ]
]

quick-list: func [vs /local ret] [
    ret: make-mal-list
    ret/values: vs
    ret
]

seq-factory: func [start] [
    switch start [
        "(" [ make-mal-list ]
        "{" [ make-mal-hashmap ]
        "[" [ make-mal-vector ]
    ]
]
