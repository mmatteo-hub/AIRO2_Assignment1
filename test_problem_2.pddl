(define (problem warehouse_1)
    (:domain warehouse1)
    (:objects 
        loading_bay - waypoint
        m1 - mover
        l1 - loader
        c1 c2 c3 c4 c5 - crate
    )

    (:init
        (= (delivering_group) -1)

        (= (position loading_bay) 0)

        (is_mover m1)
        (= (position m1) 0) (= (destination m1) 0)
        (= (lift_capability m1) 50)
        (= (velocity m1) 10) (= (velocity_dir m1) 0)

        (is_loader l1)
        (= (position l1) 0)
        (= (lift_capability l1) 100)
        (= (loading_time l1) -1)

        (= (position c1) 40) (= (weight c1) 25) (= (group c1) -1)
        (= (position c2) 30) (= (weight c2) 25) (= (group c2) 0)
        (= (position c3) 10) (= (weight c3) 25) (= (group c3) 1)
        (= (position c4) 20) (= (weight c4) 25) (= (group c4) 1)
        (= (position c5) 15) (= (weight c5) 25) (= (group c5) -2)
    )

    (:goal 
        (and
            (is_delivered c1)
            (is_delivered c2)
            (is_delivered c3)
            (is_delivered c4)
            (is_delivered c5)
        )
    )

    (:metric 
        minimize (total-time)
    )
)