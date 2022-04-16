(define (problem warehouse_1)
    (:domain warehouse_movers)
    (:objects 
        m1 - mover
        l1 - loader
        c1 c2 c3 - crate
    )

    (:init
        (= (last_crate_group) -1)
        
        (= (occupied_time m1) 0)
        (= (battery m1) 20)
        (= (lift_capability m1) 50)

        (= (occupied_time l1) 0)
        (= (lift_capability l1) 200)

        (= (position c1) 20) (= (weight c1) 30) (= (group c1) 1)
        (= (position c2) 20) (= (weight c2) 30) (= (group c2) 1)
        (= (position c3) 20) (= (weight c3) 30) (= (group c3) 1)
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