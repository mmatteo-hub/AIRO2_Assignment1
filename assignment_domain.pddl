(define (domain warehouse)

    (:requirements
        :strips
        :typing
        :fluents
        :negative-preconditions
        :disjunctive-preconditions
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
        (is_delivered ?c)
        ; If ?c is currently being targetted by some mover
        (targetted ?c - crate)
    )

    (:functions
        ; Each ?c has a certain weight
        (weight ?c - crate)
        ; Each ?r can lift only an amount of weight
        (lift_capability ?r - robot)

        ; Each object ?o has a distance from the Loading Bay
        (distance_from_lb ?o - object)

        ; The destination to which ?m arrives when travelled the distance1
        (destination ?m - mover)
        ; The velocity at which ?m moves when travelling (always positive)
        (velocity ?m - mover)
        ; The direction of the velocity (can be -1 or 1)
        (velocity_dir ?m - mover)

        ; The time that ?l has currently passed loading a crate
        (loading_time ?l - loader)
    )

    (:action move_to_crate
        :parameters 
            (?m - mover ?c - crate)
        :precondition 
            (and
                ; ?m must not be already moving
                (= (velocity ?m) 0)
                ; ?m must be at or near loading bay before going to pick a crate
                (<= (distance_from_lb ?m) 1)
                ; ?m must not be carrying somethine else
                (forall (?c1 - crate) (not (is_grabbing ?m ?c1)))
                ; ?c must not be already grabbed by another robot
                (forall (?r - robot) (not (is_grabbing ?r ?c)))
                ; ?c must not be delivered
                (not (is_delivered ?c))
                ; ?c must not be already the targer of another mover
                (not (targetted ?c))
            )
        :effect 
            (and
<<<<<<< HEAD
                ; the destination is the distance from the Loading Bay
=======
                ; Mark the positon of ?c as the destination
>>>>>>> 993080e1f691ef66ab49e91f52881283ff30a280
                (assign (destination ?m) (distance_from_lb ?c))
                ; The distance_from_lb ?m must increase, velocity is positive
                (assign (velocity ?m) 10) (assign (velocity_dir) 1)
                ; Mark ?c as targetted by this mover
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
                ; ?m must be grabbing ?c to be able to move it
                (is_grabbing ?m ?c)
                ; ?m must be far from the loading bay to move ?c near it
                (> (distance_from_lb ?m) 1)
            )
        :effect 
        (and 
            ; the destination is 1 : means near the Loading Bay
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
                (is_grabbing ?m ?c)
                ; ?m must not already be at loading bay
                (> (distance_from_lb ?m) 0)
            )
        :effect 
            (and 
                ; the destination is 1 : means near the Loading Bay
                (assign (destination ?m) 0)
                ; the distance_from_lb ?m must decrease, velocity is negative
                (assign (velocity ?m) (/ 100 (weight ?c))) (assign (velocity_dir) -1)
            )
    )

<<<<<<< HEAD
    (:process LOAD
        :parameters
            (?l - loader)
        :precondition
            (and
                ; ?l takes some time to load
                (> (remaining_time_to_load ?l) 0)
            )
        :effect
            (and
                ; decreaase the remaining time by 1 unit proportionally to the time
                (decrease (remaining_time_to_load ?l) (* #t 1))
            )
    )

    (:event ON_LOAD_FINISH
        :parameters
            (?l - loader ?c - crate)

        :precondition
            (and
                ; ?l has finished loading when the remaining time is 0
                (= (remaining_time_to_load ?l) 0)
                ; the loader is now loading something
                (is_loading ?l ?c)
            )

        :effect
            (and
                ; distance of ?c from Loading Bay so not considered any longer
                (assign (distance_from_lb ?c) -3)
                ; the loader is no more loading
                (not (is_loading ?l ?c))
            )
    )

=======
>>>>>>> 993080e1f691ef66ab49e91f52881283ff30a280
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

    (:event ON_MOVE_FINISH
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

    (:action grab
        :parameters 
            (?r - robot ?c - crate)

        :precondition 
            (and 
                ; ?r and ?c must be at the same spot
                (= (distance_from_lb ?c) (distance_from_lb ?r))
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
                ; ?r is now grabbing ?c
                (is_grabbing ?r ?c)
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
                (increase (loading_time ?l) (* #t 1))
            )
    )

    (:event ON_LOAD_FINISH
        :parameters
            (?l - loader ?c - crate)

        :precondition
            (and
                ; ?l takes 4 units of time to load a create
                (= (loading_time ?l) 4)
                ; ?l must be grabbing ?c to load it
                (is_grabbing ?l ?c)
            )

        :effect
            (and
                ; ?l is no more grabbing ?c
                (not (is_grabbing ?l ?c))
                ; ?c is considered as delivered
                (is_delivered ?c)
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
                (is_grabbing ?m ?c)
                
                (or
                    ; If not at loading bay, ?m can always leave ?c
                    (> (distance_from_lb ?m) 0)
                    ; If at loading bay, ?m can leave ?c if no loader is operating
                    (forall (?l - loader ?c1 - crate) (not (is_grabbing ?l ?c1))) 
                )
            )

        :effect 
            (and
                ; ?m is not not carrying ?c
                (not (is_grabbing ?m ?c))
                ; ?c has the same distance of ?m when leaved
                (assign (distance_from_lb ?c) (distance_from_lb ?m))
                ; when ?c is left, it is not considered targetted anymore
                (not (targetted ?c))
            )
    )
)