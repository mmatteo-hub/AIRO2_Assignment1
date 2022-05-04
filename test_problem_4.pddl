(define (problem warehouse_1)
    (:domain warehouse_movers)
    (:objects 
        m1 - mover
        l1 - loader
        c1 c2 - crate
    )

    (:init
        (= (last_crate_group) -1)
        
        (= (occupied_time m1) 0)
        (= (battery m1) 20)
        (= (lift_capability m1) 50)

        (= (occupied_time l1) 0)
        (= (lift_capability l1) 200)

        (= (position c1) 40) (= (weight c1) 30) (= (group c1) 1)
        (= (position c2) 40) (= (weight c2) 30) (= (group c2) 1)
    )

    (:goal 
        (and
            (is_delivered c1)
            (is_delivered c2)
        )
    )

    (:metric 
        minimize (total-time)
    )
)