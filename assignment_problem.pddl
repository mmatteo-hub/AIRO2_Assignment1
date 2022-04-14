(define (problem warehouse_1)
    (:domain warehouse)
    
    (:objects 
        m1 m2 - mover
        l - loader
        c1 c2 c3 c4 - crate
    )

    (:init
        ; NB. Remembre to always initialize fluents otherwise nothing works

        ; Mover m1 has a lifting capability of 50, a current velocity of 0 and at Loading Bay
        (= (distance_from_lb m1) 0) (= (lift_capability m1) 50) 
        (= (velocity m1) 0) (= (velocity_dir m1) 1) (= (destination m1) -1)

        ; Mover m2 has a lifting capability of 50, a current velocity of 0 and at Loading Bay
        (= (distance_from_lb m2) 0) (= (lift_capability m2) 50) 
        (= (velocity m2) 0) (= (velocity_dir m2) 1) (= (destination m2) -1)

        ; determining the distance from the loading bay and the weight of each crate
        (= (distance_from_lb c1) 40) (= (weight c1) 25)
        (= (distance_from_lb c2) 95) (= (weight c2) 40)
        (= (distance_from_lb c3) 25) (= (weight c3) 30)
        (= (distance_from_lb c4) 90) (= (weight c4) 10)

        ; initialization of the loader. Distance and lift capability
        (= (distance_from_lb l) 0)(= (lift_capability l) 100)
        (= (loading_time l) 0)
    )

    (:goal 
        (and
            ; both crate are delivered
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