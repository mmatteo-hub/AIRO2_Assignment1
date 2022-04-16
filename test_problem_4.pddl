(define (problem warehouse_1)
    (:domain warehouse_movers)
    (:objects 
        m1 m2 - mover
        l1 l2 - loader
        c1 c2 c3 c4 c5 c6 - crate
    )

    (:init
        
        (= (occupied_time m1) 0)
        (= (lift_capability m1) 50)

        (= (occupied_time m2) 0)
        (= (lift_capability m2) 50)

        (= (occupied_time l1) 0)
        (= (lift_capability l1) 200)

        (= (occupied_time l2) 0)
        (= (lift_capability l2) 50)

        (= (position c1) 40) (= (weight c1) 30)
        (= (position c2) 30) (= (weight c2) 80)
        (= (position c3) 10) (= (weight c3) 20)
        (= (position c4) 20) (= (weight c4) 70)
        (= (position c5) 15) (= (weight c5) 60)
        (= (position c6) 65) (= (weight c6) 30)
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