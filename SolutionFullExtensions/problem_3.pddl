(define (problem warehouse_1)
    (:domain warehouse1)
    (:objects 
        m1 m2 - mover
        l1 l2 - loader
        c1 c2 c3 c4 - crate
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
        (= (weight c1) 70) (= (position c1) 20) (= (group c1) 0)
        (= (weight c2) 80) (= (position c2) 20) (= (group c2) 0) (is_fragile c2)
        (= (weight c3) 60) (= (position c3) 30) (= (group c3) 0)
        (= (weight c4) 30) (= (position c4) 10) (= (group c4) -1)
    )

    (:goal 
        (and
            (is_delivered c1)
            (is_delivered c2)
            (is_delivered c3)
            (is_delivered c4)
        )
    )

    (:metric 
        minimize (total-time)
    )
)