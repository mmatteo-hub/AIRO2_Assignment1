(define (problem warehouse_1)
    (:domain warehouse1)
    (:objects 
        safe_spot loading_bay - waypoint
        m1 m2 - mover
        c1 c2 - crate
    )

    (:init
        (= (current_group) 0)

        (= (position loading_bay) 0)
        (= (position safe_spot) 1)

        (is_mover m1)
        (= (position m1) 0) (= (destination m1) 0)
        (= (velocity m1) 10) (= (velocity_dir m1) 0) 
        (= (lift_capability m1) 50)

        (is_mover m2)
        (= (position m2) 0) (= (destination m2) 0)
        (= (velocity m2) 10) (= (velocity_dir m2) 0) 
        (= (lift_capability m2) 50)

        (= (position c1) 40) (= (weight c1) 25) (= (group c1) 0)
        (= (position c2) 95) (= (weight c2) 40) (= (group c2) 1)
        
    )

    (:goal 
        (and
            (= (position c1) (position loading_bay))
            (= (position c2) (position loading_bay))
        )
    )

    (:metric 
        minimize (total-time)
    )
)