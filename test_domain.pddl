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
        ; Allows the usage of processes and events
        :time
    )

    (:types
        robot waypoint - object
        mover loader - robot
        crate - waypoint
    )

    (:predicates     
        ; True iff ?r is currently grabbing ?c
        (is_grabbing ?r - robot ?c - crate)
        ; True iff ?r1 should move together
        (are_collaborating ?m1 - mover ?m2 - mover)
        ; True iff ?c has been loaded on the Conveyor Belt
        (is_delivered ?c - crate)

        ; True iff ?r has executed an action (grab or release) on a crate
        (on_crate_action ?r)
    )

    (:functions
        ; Each ?c has a certain weight
        (weight ?c - crate)
        ; Each ?r can lift only an amount of weight
        (lift_capability ?r - robot)

        ; Each object ?o has a position relative to the Loading Bay
        (position ?o - object)

        ; The current destination of ?r
        (destination ?r - robot)
        ; The velocity at which ?m moves when travelling (always non negative)
        (velocity ?m - mover)
        ; The direction of the velocity (can be -1, 0 or 1)
        (velocity_dir ?m - mover)

        ; The time that ?l has currently passed loading a crate
        (loading_time ?l - loader)
    )

    (:action set_destination
        :parameters 
            (?m - mover ?w - waypoint)
        :precondition 
            (and
                ; ?w must have a valid position (non negative)
                (>= (position ?w) 0)
                ; ?m must be arrived at the previous destination
                (= (destination ?m) (position ?m))
                ; ?m must not be already moving
                (= (velocity_dir ?m) 0)
                ; ?m must not be collaborating with someone
                (forall (?m1 - mover) (not (are_collaborating ?m ?m1)))
            )
        :effect 
            (and
                ; Set the position of ?w as the destination
                (assign (destination ?m) (position ?w))
            )
    )

    (:action set_destination2
        :parameters 
            (?m1 - mover ?m2 - mover ?w - waypoint)
        :precondition 
            (and
                ; ?m1 and ?m2 must not be the same robot
                (not (= ?m1 ?m2))
                ; ?w must have a valid position (non negative)
                (>= (position ?w) 0)
                ; ?m1 and ?m2 must be arrived at their previous destination
                (= (destination ?m1) (position ?m1))
                (= (destination ?m2) (position ?m2))
                ; ?m1 and ?m2 must not be already moving
                (= (velocity_dir ?m1) 0)
                (= (velocity_dir ?m2) 0)
                ; ?m1 and ?m2 must be collaborating
                (are_collaborating ?m1 ?m2)
            )
        :effect 
            (and
                ; Set the position of ?w as the destination
                (assign (destination ?m1) (position ?w))
                (assign (destination ?m2) (position ?w))
            )
    )
    
    (:event SET_VELOCITY_DIR_POSITIVE
        :parameters 
            (?m - mover)
        :precondition 
            (and
                (> (destination ?m) (position ?m))
                (= (velocity_dir ?m) 0)
            )
        :effect 
            (and
                (assign (velocity_dir ?m) 1)
            )
    )

    (:event SET_VELOCITY_DIR_NEGATIVE
        :parameters 
            (?m - mover)
        :precondition 
            (and
                (< (destination ?m) (position ?m))
                (= (velocity_dir ?m) 0)
            )
        :effect 
            (and
                (assign (velocity_dir ?m) -1)
            )
    )

    (:event ON_MOVER_GRAB_CRATE
        :parameters
            (?m - mover ?c - crate)
        :precondition
            (and
                (on_crate_action ?m) (is_grabbing ?m ?c)
                (not (exists (?m1 - mover) (are_collaborating ?m ?m1)))
            )  
        :effect
            (and
                (not (on_crate_action ?m))
                (assign (velocity ?m) (/ 100 (weight ?c)))
            )
    )

    (:event ON_LOADER_GRAB_CRATE
        :parameters
            (?l - loader ?c - crate)
        :precondition
            (and
                (on_crate_action ?l) (is_grabbing ?l ?c)
            )  
        :effect
            (and
                (not (on_crate_action ?l))
                (assign (loading_time ?l) 4)
            )
    )

    (:event ON_2MOVER_GRAB_CRATE
        :parameters 
            (?m1 - mover ?m2 - mover ?c - crate)
        :precondition
            (and
                (not (= ?m1 ?m2))
                (are_collaborating ?m1 ?m2)
                (on_crate_action ?m1) (is_grabbing ?m1 ?c)
                (on_crate_action ?m2) (is_grabbing ?m2 ?c)
            )
        :effect
            (and
                (not (on_crate_action ?m1))(not (on_crate_action ?m2))
                (assign (velocity ?m1) (/ 150 (weight ?c)))
                (assign (velocity ?m2) (/ 150 (weight ?c)))
            )
    )

    (:event ON_MOVER_RELEASE_CRATE
        :parameters
            (?m - mover)
        :precondition (and
            (on_crate_action ?m)
            (forall (?c - crate) (not (is_grabbing ?m ?c)))
        )
        :effect 
            (and
                (not (on_crate_action ?m))
                (assign (velocity ?m) 10)
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

    (:action grab
        :parameters 
            (?r - robot ?c - crate)

        :precondition 
            (and 
                ; ?r must be at destination to grab something
                (= (destination ?r) (position ?r))
                ; ?r and ?c must be at the same spot
                (= (position ?c) (position ?r))
                ; ?r must not be currently be grabbing anything else
                (forall (?c1 - crate) (not (is_grabbing ?r ?c1)))
                ; ?c must not be currently be grabbed by another robot
                (forall (?r1 - robot) (not (is_grabbing ?r1 ?c)))
                ; ?c must not be delivered
                (not (is_delivered ?c))
                ; ?r must be able to pick ?c
                (> (lift_capability ?r) (weight ?c))
            )

        :effect 
            (and
                ; ?c position is valid only if on ground
                (assign (position ?c) -1)
                ; ?r is now grabbing ?c
                (on_crate_action ?r) (is_grabbing ?r ?c)
            )
    )

    (:action grab2
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
                (= (position ?c) (position ?m1))
                (= (position ?c) (position ?m2))
                ; Both ?m1 and ?m2 must not be collaborating with anyone else
                (not (exists (?m - mover) (or (are_collaborating ?m1 ?m) (are_collaborating ?m2 ?m))))
                ; Both ?m1 and ?m2 must no be grabbing something else
                (not (exists (?c1 - crate) (or (is_grabbing ?m1 ?c1) (is_grabbing ?m2 ?c1))))
                ; ?c must not be currently be grabbed by another robot
                (forall (?m1 - robot) (not (is_grabbing ?m1 ?c)))
                ; ?c must not be delivered
                (not (is_delivered ?c))
                ; ?m must be able to pick ?c
                (> (+ (lift_capability ?m1)(lift_capability ?m2)) (weight ?c))
            )
        :effect 
            (and 
                ; ?c position is valid only if on ground
                (assign (position ?c) -1)
                ; ?m1 and ?m2 are now both grabbing ?c
                (are_collaborating ?m1 ?m2)(are_collaborating ?m2 ?m1)
                (on_crate_action ?m1)(is_grabbing ?m1 ?c)
                (on_crate_action ?m2)(is_grabbing ?m2 ?c)
            )
    )

    (:action leave
        :parameters 
            (?m - mover ?c - crate)

        :precondition 
            (and
                ; ?m must be at destination to leave something
                (= (destination ?m) (position ?m))
                ; ?m must not be collaborating with another robot
                (not (exists (?m1 - mover) (are_collaborating ?m ?m1)))
                ; ?m must be carrying ?c to leave it
                (is_grabbing ?m ?c)

                (or
                    ; If not at loading bay, ?m can always leave ?c
                    (> (position ?m) 0)
                    ; If at loading bay, ?m can leave ?c if no loader is operating
                    (forall (?l - loader ?c1 - crate) (not (is_grabbing ?l ?c1))) 
                )
            )

        :effect 
            (and
                ; ?c has the same distance of ?m when leaved
                (assign (position ?c) (position ?m))
                ; ?m is not not carrying ?c
                (on_crate_action ?m) (not (is_grabbing ?m ?c))
            )
    )

    (:action leave2
        :parameters 
            (?m1 - mover ?m2 - mover ?c - crate)

        :precondition 
            (and
                ; ?m1 and ?m2 must not be the same robot
                (not (= ?m1 ?m2))
                ; ?m1 and ?m2 must be at their destination to grab something
                (= (destination ?m1) (position ?m1))
                (= (destination ?m2) (position ?m2))
                ; ?m1 and ?m2 must be collaborating
                (are_collaborating ?m1 ?m2)
                ; ?m1 and ?m2 must be carrying ?c to leave it
                (is_grabbing ?m1 ?c)(is_grabbing ?m2 ?c)

                (or
                    ; If not at loading bay, ?m1 and ?m2 can always leave ?c
                    (> (position ?m1) 0)
                    ; If at loading bay, ?m1 and ?m2 can leave ?c if no loader is operating
                    (forall (?l - loader ?c1 - crate) (not (is_grabbing ?l ?c1))) 
                )
            )

        :effect 
            (and
                ; ?c has the same distance of ?m when leaved
                (assign (position ?c) (position ?m1))
                ; ?m1 and ?m2 are not carrying ?c anymore
                (not (are_collaborating ?m1 ?m2))(not (are_collaborating ?m2 ?m1))
                (on_crate_action ?m1)(not (is_grabbing ?m1 ?c))
                (on_crate_action ?m2)(not (is_grabbing ?m2 ?c))
            )
    )

    (:process LOAD
        :parameters
            (?l - loader ?c - crate)
        :precondition
            (and
                ; ?l must be grabbing ?c to load it
                (is_grabbing ?l ?c)
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
                ; ?l takes 4 units of time to load a create
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
                ; ?c is considered as delivered
                (is_delivered ?c)
            )
    )
)