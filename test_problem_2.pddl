(define (problem warehouse_1)
    (:domain warehouse1)
    (:objects 
        safe_spot loading_bay - waypoint
        m1 m2 - mover
        l1 - loader
        c1 c2 c3 - crate
    )

    (:init
        (= (current_group) 0)

        (= (position loading_bay) 0)
        (= (position safe_spot) 1)

        (is_mover m1)
        (= (position m1) 0) (= (destination m1) 0)
        (= (lift_capability m1) 50)
        (= (velocity m1) 10) (= (velocity_dir m1) 0)

        (is_mover m2)
        (= (position m2) 0) (= (destination m2) 0)
        (= (lift_capability m2) 50)
        (= (velocity m2) 10) (= (velocity_dir m2) 0)

        (is_loader l1)
        (= (position l1) 0)
        (= (lift_capability l1) 100)
        (= (loading_time l1) -1)

        (= (position c1) 40) (= (weight c1) 25) (= (group c1) 1)
        (= (position c2) 60) (= (weight c2) 65) (= (group c2) 0)
        (= (position c3) 35) (= (weight c3) 15) (= (group c3) 1)
    )

    (:goal 
        (and
            (is_delivered c1)
            (is_delivered c2)
            (is_delivered c3)
        )
    )

    (:metric 
        minimize (total-time)
    )
)