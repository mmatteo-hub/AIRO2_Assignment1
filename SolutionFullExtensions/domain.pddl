(define (domain warehouse)

    (:requirements
        ; Allows the usage of basic actions
        :strips
        ; Allows the definition of types for objects
        :typing
        ; Allows the usage of numeric fluents
        :fluents
        ; Allows the usage of not in preconditions
        :negative-preconditions
        ; Allows the usage of or in preconditions
        :disjunctive-preconditions
        ; Allows the usage of foreach and exists in preconditions
        :universal-preconditions
        ; Allows the usage of = to compare objects
        :equality
        ; Allows the usage of when in action effects
        :conditional-effects
        ; Allows the usage of processes and events
        :time
    )

    (:types
        robot crate - object
        mover loader - robot
    )

    (:predicates
        ; True iff ?c is considered fragile
        (is_fragile ?c - crate)
        ; True iff ?c has been delivered
        (is_delivered ?c - crate)

        ; True iff ?r is occupied and cannot perform a task
        (is_occupied ?r - robot)
        ; True iff ?m is retrieving ?c
        (is_retrieving ?m - mover ?c - crate)
        ; True iff ?m is charging
        (is_charging ?m)
        ; True iff ?l is loading ?c
        (is_loading ?l - loader ?c - crate)
    )

    (:functions
        ; Each ?c has a position
        (position ?c - crate)
        ; Each ?c has a certain weight
        (weight ?c - crate)
        ; Each ?c has a group it belongs to (-1 if not)
        (group ?c - crate)
        ; The group that is currently being delivered
        (last_crate_group)
        
        ; How much weight ?r is able to pick up
        (lift_capability ?r - robot)
        ; The time ?m is occupied performing some action
        (occupied_time ?r - robot)

        ; The remaining amount of battery ?m has
        (battery ?m - mover)
    )

    (:action retrieve
        :parameters 
            (?m - mover ?c - crate)
        :precondition   
            (and 
                ; ?c must have a valid position
                ; NB. Prevents considering delivered or grabbed crates
                (> (position ?c) 0)
                ; ?m must not be performing another task when occupied
                (not (is_occupied ?m))
                ; ?m must be able to pick ?c up
                (> (lift_capability ?m) (weight ?c))
                ; ?m is not able to pick ?c if fragile
                (not (is_fragile ?c))
                ; ?m battery must be enough
                (> (battery ?m) (+ (/ (position ?c) 10) (/ (* (position ?c) (weight ?c)) 100)))
            )
        :effect 
            (and 
                ; ?m is now retrieving ?c
                (is_retrieving ?m ?c) 
                (assign (position ?c) -1)
                ; ?m is occupied until it retrieves ?c
                (assign (occupied_time ?m) (+ (/ (position ?c) 10) (/ (* (position ?c) (weight ?c)) 100)))
                (is_occupied ?m)
            )
    )

    (:action retrieve2
        :parameters 
            (?m1 - mover ?m2 - mover ?c - crate)
        :precondition 
            (and
                ; ?m1 and ?m2 must not be the same
                (not (= ?m1 ?m2))
                ; ?c must have a valid position
                ; NB. Prevents considering delivered crates
                (> (position ?c) 0)
                ; ?m1 and ?m2 must not be performing a task
                (not (is_occupied ?m1))
                (not (is_occupied ?m2))
                ; ?m1 and ?m2 must be able to pick ?c up
                (> (+ (lift_capability ?m1) (lift_capability ?m2)) (weight ?c))
                ; ?m1 and ?m2 battery must be sufficient
                (> (battery ?m1) (+ (/ (position ?c) 10) (/ (* (position ?c) (weight ?c)) 150)))
                (> (battery ?m2) (+ (/ (position ?c) 10) (/ (* (position ?c) (weight ?c)) 150)))
            )
        :effect 
            (and 
                ; ?m1 and ?m2 are retrieving ?c
                (is_retrieving ?m1 ?c) 
                (is_retrieving ?m2 ?c)
                ; ?m1 and ?m2 are now occupied until they retrieve ?c
                (assign (occupied_time ?m1) (+ (/ (position ?c) 10) (/ (* (position ?c) (weight ?c)) 150)))
                (assign (occupied_time ?m2) (+ (/ (position ?c) 10) (/ (* (position ?c) (weight ?c)) 150)))
                (is_occupied ?m1)
                (is_occupied ?m2)
            )
    )

    (:process EXECUTE_MOVE_MOVER
        :parameters 
            (?m - mover ?c - crate)
        :precondition 
            (and
                (> (occupied_time ?m) 0)
                (is_retrieving ?m ?c)
            )
        :effect
            (and
                (decrease (occupied_time ?m) (* #t 1))
                (decrease (battery ?m) (* #t 1))
            )
    )

    (:event ON_CRATE_RETRIEVED
        :parameters 
            (?m - mover ?c - crate)
        :precondition 
            (and
                ; ?m must have finished occupied time
                (<= (occupied_time ?m) 0)
                (is_occupied ?m)
                ; ?m must be retrieving ?c
                (is_retrieving ?m ?c)
                ; every ?l must not be operating
                (forall (?l - loader) (= (occupied_time ?l) 0))
            )
        :effect 
            (and
                ; ?m is not retrieving ?c anymore
                (assign (occupied_time ?m) 0)
                (not (is_occupied ?m))
                (not (is_retrieving ?m ?c))
                ; ?c is now at loading bay
                (assign (position ?c) 0)
            )
    )

    (:action recharge
        :parameters 
            (?m - mover)
        :precondition 
            (and 
                ; ?m must not be performing another task when occupied
                (not (is_occupied ?m))
                ; ?m battery must not be already at max
                (< (battery ?m) 20)
            )
        :effect 
            (and
                ; ?m is now occupied charging
                (is_charging ?m)
                ; ?m takes some time to charge
                (assign (occupied_time ?m) 1)
                (is_occupied ?m)
            )
    )

    (:process EXECUTE_RECHARGE_MOVER
        :parameters 
            (?m - mover)
        :precondition 
            (and
                (> (occupied_time ?m) 0)
                (is_charging ?m)
            )
        :effect
            (and
                (decrease (occupied_time ?m) (* #t 1))
                (increase (battery ?m) (* #t 1))
            )
    )

    (:event ON_RECHARGED
        :parameters 
            (?m - mover)
        :precondition 
            (and
                ; ?m must have finished occupied time
                (<= (occupied_time ?m) 0)
                (is_occupied ?m)
                ; ?m must be charging
                (is_charging ?m)
            )
        :effect 
            (and
                ; ?m is not occupied charging anymore
                (assign (occupied_time ?m) 0)
                (not (is_occupied ?m))
                (not (is_charging ?m))
            )
    )
    
    (:action load
        :parameters
            (?l - loader ?c - crate)
        :precondition 
            (and
                (or 
                    ; Not currently loading a group
                    (= (last_crate_group) -1) 
                    ; ?c belongs to the group that is currenlty being loaded
                    (= (group ?c) (last_crate_group))
                    ; All the crates belonging to the current group have been delivered
                    (forall (?c1 - crate) (or (= ?c ?c1) (is_delivered ?c1) (not (= (group ?c1) (last_crate_group)))))
                )
                ; ?r and ?c must be at the same spot
                ; NB. No check for delivered because position is valid
                ; NB. No check for others grabbing because position is valid
                (= (position ?c) 0)
                ; ?l must not already performing a task
                (not (is_occupied ?l))
                ; ?l must be able to pick ?c up
                (> (lift_capability ?l) (weight ?c))
            )
        :effect 
            (and 
                ; ?l is now loading ?c
                (is_loading ?l ?c) (assign (position ?c) -1)
                ; Loading time is based on ?c features
                (when (not (is_fragile ?c)) (assign (occupied_time ?l) 4))
                (when (is_fragile ?c) (assign (occupied_time ?l) 6))
                (is_occupied ?l)
            )
    )

    (:process EXECUTE_LOAD_LOADER
        :parameters 
            (?l - loader)
        :precondition 
            (> (occupied_time ?l) 0)
        :effect
            (decrease (occupied_time ?l) (* #t 1))
    )

    (:event ON_CRATE_LOADED
        :parameters 
            (?l - loader ?c - crate)
        :precondition 
            (and
                ; time of ?l must have passed
                (<= (occupied_time ?l) 0)
                (is_occupied ?l)
                ; ?m must be retrieving ?c
                (is_loading ?l ?c)
            )
        :effect 
            (and
                ; ?l has now loaded ?c onto the conveyour belt
                (assign (occupied_time ?l) 0)
                (not (is_occupied ?l))
                (not (is_loading ?l ?c))
                ; ?c is now delivered
                (is_delivered ?c)
                ; Storing the group of the last delivered crate
                (assign (last_crate_group) (group ?c))
            )
    )
)