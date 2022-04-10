(define (domain warehouse)

    (:requirements
        :strips
        :typing
        :fluents
        :negative-preconditions
        :time
    )

    (:types
        robot crate - object
        mover loader - robot
    )

    (:predicates     
        ; True iff ?m is carrying ?c
        (is_carrying ?m - mover ?c - crate)
        ; If ?c is currently being targetted by some mover
        (targetted ?c - crate)
        ; If ?l is free then it can load a crate
        (is_loading ?l - loader ?c - crate)
    )

    (:functions
        ; Each object ?o has a distance from the Loading Bay
        (distance_from_lb ?o - object)  
        ; Each object ?o has a distance from the Conveyor Belt
        (remaining_time_to_load ?l - loader)
        ; Each ?c has a certain weight
        (weight ?c - crate)
        ; Each ?r can lift only an amount of weight
        (lift_capability ?r - robot)

        ; The destination to which ?m arrives when travelled the distance1
        (destination ?m - mover)
        ; The velocity at which ?m moves when travelling (always positive)
        (velocity ?m - mover)
        ; The direction of the velocity (can be -1 or 1)
        (velocity_dir ?m - mover)
    )

    (:action move_to_crate
        :parameters 
            (?m - mover ?c - crate)
        :precondition 
            (and
                ; ?m must not be already moving
                (= (velocity ?m) 0)
                ; ?m must no be carrying somethine else
                (forall (?c1 - crate) (not (is_carrying ?m ?c1)))
                ; ?c must not be carried by something else
                (> (distance_from_lb ?c) 0)
                ; ?m must be near loading bay before going to pick a crate
                (<= (distance_from_lb ?m) 1)
                ; ?c must not be already the targer of some mover
                (not (targetted ?c))
            )
        :effect 
            (and
                (assign (destination ?m) (distance_from_lb ?c))
                ; the distance_from_lb ?m must increase, velocity is positive
                (assign (velocity ?m) 10) (assign (velocity_dir) 1)
                ; mark ?c as targetted by this mover
                (targetted ?c)
            )
    )

    (:action move_crate_near_lb
        :parameters 
            (?m - mover ?c - crate)
        :precondition 
            (and 
                ; ?m must not be already moving
                (= (velocity ?m) 0)
                ; ?m must be carrying ?c to be able to move it
                (is_carrying ?m ?c)
                ; ?m must be far from the loading bay to move ?c near it
                (> (distance_from_lb ?m) 1)
            )
        :effect 
        (and 
            (assign (destination ?m) 1)
            ; the distance_from_lb ?m must decrease, velocity is negative
            (assign (velocity ?m) (/ 100 (weight ?c))) (assign (velocity_dir) -1)
        )
    )

    (:action move_crate_to_lb
        :parameters 
            (?m - mover ?c - crate)
        :precondition 
            (and 
                ; ?m must not be already moving
                (= (velocity ?m) 0)
                ; ?m must be carrying ?c to be able to move it
                (is_carrying ?m ?c)
                ; ?m must not already be at loading bay
                (> (distance_from_lb ?m) 0)
            )
        :effect 
            (and 
                (assign (destination ?m) 0)
                ; the distance_from_lb ?m must decrease, velocity is negative
                (assign (velocity ?m) (/ 100 (weight ?c))) (assign (velocity_dir) -1)
            )
    )

    (:action load_crate_lb
        :parameters 
            (?l - loader ?c - crate)
        :precondition 
        (and 
            (= (distance_from_lb ?c) 0)
            (not(is_loading ?l ?c))
            (> (lift_capability ?l) (weight ?c))
        )
        :effect 
            (and
                ; initialize the remaining time to load to 4 unit time
                (assign (remaining_time_to_load ?l) 4)
            )
    )

    (:process LOAD
        :parameters (?l - loader)
        :precondition
            (and
                (> (remaining_time_to_load ?l) 0)
            )
        :effect
            (and
                (decrease (remaining_time_to_load ?l) (* #t 1))
            )
    )

    (:event ON_LOAD_FINISH
        :parameters
            (?l - loader ?c - crate)
        :precondition
            (and
                (= (remaining_time_to_load ?l) 0)
                (is_loading ?l ?c)
            )
        :effect
            (and
                ; distance of ?c from Loading Bay so not considered any longer
                (assign (distance_from_lb ?c) -1)
            )
    )

    (:process MOVE
        :parameters (?m - mover)
        :precondition 
            (and
                ; ?m must move if it's velocity is more that 0
                (> (velocity ?m) 0)
            )
        :effect 
            (and
                ; ? must is moved based on the velocity and the direction of the velocity
                (increase (distance_from_lb ?m) (* #t (*(velocity_dir ?m)(velocity ?m))))
            )
    )

    (:event ON_DESTINATION_ARRIVAL
        :parameters 
            (?m - mover)
        :precondition 
            (and
                ; To arrive at destination, ?m must first be moving
                (> (velocity ?m) 0)
                ; This is the formula that makes it possible for ?m to move
                ; without worring about the direction of travel
                (<= (*(destination ?m)(velocity_dir ?m)) (*(distance_from_lb ?m)(velocity_dir ?m)))
            )
        :effect 
            (and
                ; ?m arrived at destination so it is not moving anymore
                (assign (velocity ?m) 0)
                ; ?m is at destination
                (assign (distance_from_lb ?m) (destination ?m))
            )
    )
    
    (:action pick
        :parameters
            (?m - mover ?c - crate)

        :precondition
            (and 
                ; ?m must not be moving
                (= (velocity ?m) 0)
                ; ?m must not be carrying anything else
                (forall (?c1 - crate) (not (is_carrying ?m ?c1)))
                ; ?m and ?c must be at the same position
                (= (distance_from_lb ?c)(distance_from_lb ?m))
                ; ?m must be able to carry the weight of ?c
                (>= (lift_capability ?m)(weight ?c))
            )
        :effect
            (and
                ; ?m is now carrying ?c
                (is_carrying ?m ?c)
                ; ?c has no more a distance from lb because carried by ?r
                (assign (distance_from_lb ?c) -1)
                ; when ?c is pick is not considered targetted anymore
                (not (targetted ?c))
            )
    )
    
    (:action leave
        :parameters 
            (?m - mover ?c - crate)

        :precondition 
            (and
                ; ?m must not be moving
                (= (velocity ?m) 0)
                ; ?m must be carrying ?c to leave it
                (is_carrying ?m ?c)
            )

        :effect 
            (and
                ; ?m is not not carrying ?c
                (not (is_carrying ?m ?c))
                ; ?c has the same distance of ?m when leaved
                (assign (distance_from_lb ?c) (distance_from_lb ?m))
            )
    )
)