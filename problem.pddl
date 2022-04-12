
(define (problem warehouse_1)
    (:domain warehouse)
    (:objects 
        m1 - mover
    )

    (:init
        (= (velocity m1) -1)
    )

    (:goal 
        (and
            (> (velocity m1) 0)
        )
    )
)