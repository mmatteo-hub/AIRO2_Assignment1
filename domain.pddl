(define (domain warehouse)

    (:types
        mover - object
    )

    (:predicates
        (change_velocity ?m - mover)
    )

    (:functions
        (velocity ?m - mover)
    )

    (:action ch_velocity
        :parameters 
            (?m - mover)
        :precondition 
            (and (< (velocity ?m) 0))
        :effect 
            (and (change_velocity ?m))
    )

    (:event ON_VELOCITY_CHANGE
        :parameters 
            (?m - mover)
        :precondition 
            (and (change_velocity ?m))
        :effect 
            (and 
                (assign (velocity ?m) 2.0)
                (not (change_velocity ?m))
            )
    )
)