(define (problem warehouse_1)
    (:domain warehouse1)
    (:objects 
        m1 m2 - mover
        l1 - loader
        c1 c2 c3 c4 c5 - crate
    )

    (:init
        (= (last_crate_group) -1)

        (= (position m1) 0) (= (destination m1) 0)
        (= (lift_capability m1) 50)
        (= (velocity m1) 10) (= (velocity_dir m1) 0)

        (= (position m2) 0) (= (destination m2) 0)
        (= (lift_capability m2) 50)
        (= (velocity m2) 10) (= (velocity_dir m2) 0)

        (= (position l1) 0)
        (= (lift_capability l1) 100)
        (= (loading_time l1) -1)

        (= (position c1) 40) (= (weight c1) 30) (= (group c1) -1)
        (= (position c2) 30) (= (weight c2) 45) (= (group c2) 0)
        (= (position c3) 10) (= (weight c3) 90) (= (group c3) 1)
        (= (position c4) 20) (= (weight c4) 10) (= (group c4) 1)
        (= (position c5) 15) (= (weight c5) 40) (= (group c5) 1)
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