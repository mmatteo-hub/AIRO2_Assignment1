(define (problem warehouse_problem_1)
    (:domain warehouse_no_extension)
    (:objects 
        m1 m2 - mover
        l1 - loader
        c1 c2 c3 - crate
    )

    (:init
        ; Init mover m1
        (= (occupied_time m1) 0)
        (= (lift_capability m1) 50)

        ; Init mover m2
        (= (occupied_time m2) 0)
        (= (lift_capability m2) 50)

        ; Init loader l1
        (= (occupied_time l1) 0)
        (= (lift_capability l1) 200)

        ; Init world
        (= (weight c1) 70) (= (position c1) 10)
        (= (weight c2) 20) (= (position c2) 20)
        (= (weight c3) 20) (= (position c3) 20)
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