(define (problem warehouse_1)
    (:domain warehouse_movers)
    (:objects 
        m1 m2 - mover
        l1 l2 - loader
        c1 c2 c3 c4 c5 c6 c7 c8 - crate
    )

    (:init
        (= (last_crate_group) -1)
        
        (= (occupied_time m1) 0)
        (= (lift_capability m1) 50)

        (= (occupied_time m2) 0)
        (= (lift_capability m2) 50)

        (= (occupied_time l1) 0)
        (= (lift_capability l1) 200)

        (= (occupied_time l2) 0)
        (= (lift_capability l2) 50)

        (= (position c1) 40) (= (weight c1) 30) (= (group c1) 1) (is_fragile c1)
        (= (position c2) 30) (= (weight c2) 80) (= (group c2) -1)
        (= (position c3) 10) (= (weight c3) 20) (= (group c3) 0)
        (= (position c4) 20) (= (weight c4) 70) (= (group c4) 1) (is_fragile c4)
        (= (position c5) 15) (= (weight c5) 60) (= (group c5) 1)
        (= (position c6) 65) (= (weight c6) 30) (= (group c6) 2)
        (= (position c7) 65) (= (weight c7) 60) (= (group c7) 0)
        (= (position c8) 30) (= (weight c8) 25) (= (group c8) 2) (is_fragile c8)
    )

    (:goal 
        (and
            (is_delivered c1)
            (is_delivered c2)
            (is_delivered c3)
            (is_delivered c4)
            (is_delivered c5)
            (is_delivered c6)
            (is_delivered c7)
            (is_delivered c8)
        )
    )

    (:metric 
        minimize (total-time)
    )
)