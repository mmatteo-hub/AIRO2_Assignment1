(define (domain warehouse1)

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
        ; True iff ?r is currently grabbing ?c
        (is_grabbing ?r - robot ?c - crate)
        ; True iff ?c has been loaded on the Conveyor Belt
        (is_delivered ?c - crate)
    )

    (:functions
        ; Each ?c has a certain weight
        (weight ?c - crate)
        ; Each ?c has a group it belong to
        (group ?c - crate)

        ; Each ?r can lift only an amount of weight
        (lift_capability ?r - robot)

        ; Each object ?o has a position relative to the Loading Bay
        (position ?o - object)

        ; The current destination of ?r
        (destination ?m - mover)
        ; The velocity at which ?m moves when travelling (always non negative)
        (velocity ?m - mover)
        ; The direction of the velocity (can be -1, 0 or 1)
        (velocity_dir ?m - mover)

        ; The time that ?l has currently passed loading a crate
        (loading_time ?l - loader)

        ; The group that is currently being loaded on the Conveyour Belt
        (last_crate_group)
    )

    (:action move_to_crate
        :parameters 
            (?m - mover ?c - crate)
        :precondition 
            (and
                ; ?w must have a valid position (non negative)
                (>= (position ?c) 0)
                ; ?m must be at the previous destination
                (= (destination ?m) (position ?m))
                ; ?m must not be already moving
                (= (velocity_dir ?m) 0)
            )
        :effect 
            (and
                ; ?m destionation is now the position of ?w
                (assign (destination ?m) (position ?c))
                ; ?m has a vector velocity poiting toward the destination
                (assign (velocity_dir ?m) 1)
            )
    )

    (:action take_to_lb
        :parameters 
            (?m - mover ?c - crate)
        :precondition 
            (and 
                ; ?m must be arrived at its destination
                (= (destination ?m) (position ?m))
                ; ?m and ?c must be at the same spot
                ; NB. No check for delivered because position is valid
                ; NB. No check for others grabbing because position is valid
                (= (position ?c) (position ?m))
                ; ?m must not be currently be grabbing anything else
                (forall (?c1 - crate) (not (is_grabbing ?m ?c1)))
                ; ?m must be able to pick ?c
                (> (lift_capability ?m) (weight ?c))
            )
        :effect 
            (and 
                ; ?c position is valid only if on ground
                (assign (position ?c) -1)
                ; ?m is now grabbing ?c
                (is_grabbing ?m ?c)
                ; ?m has a velocity corresponding to the features of ?c
                (assign (velocity ?m) (/ 100 (weight ?c))) (assign (velocity_dir ?m) -1)
                ; ?m destination is now the loading bay
                (assign (destination ?m) 0)
            )
    )

    (:action take2_to_lb
        :parameters 
            (?m1 - mover ?m2 - mover ?c - crate)
        :precondition 
            (and 
                ; ?m1 and ?m2 must not be the same robot
                (not (= ?m1 ?m2))
                ; ?m1 and ?m2 must be at their destination to grab something
                (= (destination ?m1) (position ?m1))
                (= (destination ?m2) (position ?m2))
                ; ?m1 and ?m2 and ?c must be at the same position
                ; NB. No check for delivered because position is valid
                ; NB. No check for others grabbing because position is valid
                (= (position ?c) (position ?m1))
                (= (position ?c) (position ?m2))
                ; Both ?m1 and ?m2 must no be grabbing something else
                ; NB. No check for collaboration with others (only if carrying something)
                (not (exists (?c1 - crate) (or (is_grabbing ?m1 ?c1) (is_grabbing ?m2 ?c1))))
                ; ?m must be able to pick ?c
                (> (+ (lift_capability ?m1)(lift_capability ?m2)) (weight ?c))
            )
        :effect 
            (and 
                ; ?c position is valid only if on ground
                (assign (position ?c) -1)
                ; ?m1 and ?m2 are both grabbing ?c
                (is_grabbing ?m1 ?c)(is_grabbing ?m2 ?c)
                ; Assign the correct velocity to ?m1 and ?m2
                (assign (velocity ?m1) (/ 150 (weight ?c))) (assign (velocity_dir ?m1) -1)
                (assign (velocity ?m2) (/ 150 (weight ?c))) (assign (velocity_dir ?m2) -1)
                ; ?m1 and ?m2 destination is now the loading bay
                (assign (destination ?m1) 0)
                (assign (destination ?m2) 0)
            )
    )

    (:process MOVE
        :parameters (?m - mover)
        :precondition 
            (and
                ; ?m must move if it's velocity vector is more that 0
                (not (= (velocity_dir ?m) 0))
            )

        :effect 
            (and
                ; ?m must is moved based on the velocity and the direction of the velocity
                (increase (position ?m) (* #t (*(velocity_dir ?m)(velocity ?m))))
            )
    )
    
    (:event ON_MOVE_FINISH
        :parameters 
            (?m - mover)

        :precondition 
            (and
                ; To arrive at destination, ?m must first be moving
                (not (= (velocity_dir ?m) 0))
                ; This is the arrival check (no worries about the direction of travel)
                (<= (*(destination ?m)(velocity_dir ?m)) (*(position ?m)(velocity_dir ?m)))
            )

        :effect 
            (and
                ; ?m is now not moving anymore
                (assign (velocity_dir ?m) 0)
                ; ?m is at destination
                (assign (position ?m) (destination ?m))
            )
    )

    (:event LEAVE_CRATE
        :parameters
            (?m - mover ?c - crate)
        :precondition
            (and 
                ; ?m must be arrive at destination which is Loading Bay
                (= (destination ?m) 0)
                (= (position ?m) 0)
                ; ?m must be carrying ?c to leave it
                (is_grabbing ?m ?c)
                ; Each ?l must not be operating
                (forall (?l - loader ?c1 - crate) (not (is_grabbing ?l ?c1)))
            )
        :effect
            (and
                ; The position of ?c is the Loading Bay
                (assign (position ?c) 0)
                ; ?m is not not carrying ?c
                (not (is_grabbing ?m ?c))
                ; ?m has not the default velocity
                (assign (velocity ?m) 10)
            )
    )

    (:action start_loading
        :parameters 
            (?l - loader ?c - crate)

        :precondition 
            (and
                (or 
                    (= (last_crate_group) -1) 
                    (= (group ?c) (last_crate_group))
                    (forall (?c1 - crate) (or (= ?c ?c1) (is_delivered ?c1) (not (= (group ?c)(group ?c1)))))
                )
                ; ?r and ?c must be at the same spot
                ; NB. No check for delivered because position is valid
                ; NB. No check for others grabbing because position is valid
                (= (position ?c) (position ?l))
                ; ?r must not be currently be grabbing anything else
                (forall (?c1 - crate) (not (is_grabbing ?l ?c1)))
                ; ?r must be able to pick ?c
                (> (lift_capability ?l) (weight ?c))
            )

        :effect 
            (and
                ; ?c position is valid only if on ground
                (assign (position ?c) -1)
                ; ?r is now grabbing ?c
                (is_grabbing ?l ?c)
                ; Assign the correct parameter to the robot ?r
                (assign (last_crate_group) -1)
                (assign (loading_time ?l) 4)
            )
    )

    (:process LOAD
        :parameters
            (?l - loader)
        :precondition
            (and
                ; ?l must load when the reimaing time is greater than 0
                (> (loading_time ?l) 0)
            )
        :effect
            (and
                ; Increase the time that ?l has passed by loading
                (decrease (loading_time ?l) (* #t 1))
            )
    )

    (:event ON_LOAD_FINISH
        :parameters
            (?l - loader ?c - crate)

        :precondition
            (and
                ; ?l must have finished loading
                (= (loading_time ?l) 0)
                ; ?l must be grabbing ?c to load it
                (is_grabbing ?l ?c)
            )

        :effect
            (and
                ; ?l is now not loading anything
                (assign (loading_time ?l) -1)
                ; ?l is no more grabbing ?c
                (not (is_grabbing ?l ?c))
                ; ?c is considered as delivered and the position is not valid anymore
                (is_delivered ?c) (assign (position ?c) -1)
                ; Storing the group of the last delivered crate
                (assign (last_crate_group) (group ?c))
            )
    )
)