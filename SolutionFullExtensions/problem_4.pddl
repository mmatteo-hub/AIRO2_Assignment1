(define (problem warehouse_1)
    (:domain warehouse_movers)
    (:objects 
        m1 m2 - mover
        l1 l2 - loader
        c1 c2 c3 c4 c5 c6 - crate
    )

    (:init
        ; Init mover m1
        (= (occupied_time m1) 0)
        (= (battery m1) 20)
        (= (lift_capability m1) 50)

        ; Init mover m2
        (= (occupied_time m2) 0)
        (= (battery m2) 20)
        (= (lift_capability m2) 50)

        ; Init loader l1
        (= (occupied_time l1) 0)
        (= (lift_capability l1) 200)

        ; Init loader l2
        (= (occupied_time l2) 0)
        (= (lift_capability l2) 50)

        ; Init world
        (= (last_crate_group) -1)
        (= (weight c1) 30) (= (position c1) 20) (= (group c1) 0)
        (= (weight c2) 20) (= (position c2) 20) (= (group c2) 0) (is_fragile c2)
        (= (weight c3) 30) (= (position c3) 10) (= (group c3) 1) (is_fragile c3)
        (= (weight c4) 20) (= (position c4) 20) (= (group c4) 1) (is_fragile c4)
        (= (weight c5) 30) (= (position c5) 30) (= (group c5) 1) (is_fragile c5)
        (= (weight c6) 20) (= (position c6) 10) (= (group c6) -1)
    )

    (:goal 
        (and
            (is_delivered c1)
            (is_delivered c2)
            (is_delivered c3)
            (is_delivered c4)
            (is_delivered c5)
            (is_delivered c6)
        )
    )

    (:metric 
        minimize (total-time)
    )
)