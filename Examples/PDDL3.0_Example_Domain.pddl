(define (domain logistics)

    (:requirements
        :typing
        ; This is required to have soft goals
        :preferences
        ; This is required to create constraints
        :constraints
        ; This is used to have the forall / exists expressions
        :universal-preconditions
    )

    (:types
        lorry package recipient location - object
    )

    (:predicates
        (deliver-to ?r - recipient ?p - package)
        (delivered ?p - package)
        (in ?p - package ?l - lorry)
        (at ?l - lorry ?loc - location)
    )

    ; Contrainsts are expressions that must be true in all states of a plan
    ; in order for the plan to be considered valid. These can be used to help
    ; the planner reduce the number of states they need to explore by inferring
    ; some common sense logic.
    (:constraints
        (and
            (forall (?l - lorry ?loc - location) (at-most-once (at ?l ?loc)))

            ; There universal expressions have the following syntax:
            ;  ({operator} {objects} ({trajectory}))
            ; - The {operator} can be: forall, exists .
            ; - The {objects} are the objects used in the expression.
            ; - The {trajectory} is the validation condition, it can be:
                ; - always {0}: the expression {0} must be always true.
                ; - sometime {0}: the expression {0} must be true at least once.
                ; - at-most-once {0}: the expression {0} must be true only once.
                ; - within {value} {0}: the expression {0} must be true at most {value} times.
                ; - sometime-after {0} {1}: the expression {1} must be true after {0} is true.
                ; - simetime-before {0} {1}: the expression {1} must be true before {0} is true.
                ; others
        )
    )
)