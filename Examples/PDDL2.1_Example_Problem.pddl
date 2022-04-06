(define (problem rover1)

    (:domain rover_domain)

    ; Here we define the objects with their relative types.
    (:objects
        r1 r2 - rover
        wp1 wp2 - waypoint
    )

    ; This is how fluents are initialized.
    (:init
        (= (battery_amount r1) 100)
        ;...
    )

    ; (:goal ... )

    ; It is also possible to define something that we want to optimize.
    ; (:metrix {operation} {value})
    ; - The {operation} can be: maximize, minimize.
    ; - The {value} the amount that we want to optimize.
    (:metric maximize 
        (+
            (battery_amount r1)
            (battery_amount r2)
        )
    )
)