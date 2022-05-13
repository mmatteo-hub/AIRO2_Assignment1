(define (problem warehouse_1)
    (:domain warehouse1)
    (:objects 
        m1 m2 - mover
        l1 - loader
        c1 c2 c3 c4 - crate
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
        (= (weight c1) 70) (= (position c1) 20)
        (= (weight c2) 80) (= (position c2) 20)
        (= (weight c3) 60) (= (position c3) 30)
        (= (weight c4) 30) (= (position c4) 10)
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