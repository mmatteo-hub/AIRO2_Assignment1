(define (problem warehouse_problem_1)
    (:domain warehouse)
    (:objects 
        m1 m2 - mover
        l1 l2 - loader
        c1 c2 c3 - crate
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
        (= (weight c1) 70) (= (position c1) 10) (= (group c1) -1)
        (= (weight c2) 20) (= (position c2) 20) (= (group c2) 0) (is_fragile c2)
        (= (weight c3) 20) (= (position c3) 20) (= (group c3) 0)
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