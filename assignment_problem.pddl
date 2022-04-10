(define (problem warehouse_1)
    (:domain warehouse)
    (:objects 
        m1 m2 - mover
        l - loader
        c1 c2 - crate
    )

    (:init
        ; NB. Remembre to always initialize fluents otherwise nothing works

        ; Mover m1 has a lifting capability of 50, a current velocity of 0 and at Loading Bay
        (= (distance_from_lb m1) 0) (= (lift_capability m1) 50) 
        (= (velocity m1) 0) (= (velocity_dir m1) 1) (= (destination m1) -1)

        ; Mover m2 has a lifting capability of 50, a current velocity of 0 and at Loading Bay
        (= (distance_from_lb m2) 0) (= (lift_capability m2) 50) 
        (= (velocity m2) 0) (= (velocity_dir m2) 1) (= (destination m2) -1)

        (= (distance_from_lb c1) 40) (= (weight c1) 25)
        (= (distance_from_lb c2) 45) (= (weight c2) 40)

        (= (distance_from_lb l) 0)(= (lift_capability l) 100)
        (= (remaining_time_to_load l) 0)
    )

    (:goal 
        (and
            (= (distance_from_lb c1) -3)
            (= (distance_from_lb c2) -3)
        )
    )

    (:metric minimize 
        (total-time)
    )
)
