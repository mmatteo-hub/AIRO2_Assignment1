; THE CORRECT OUTPUT OF THIS TEST SHOULD BE
; 0: (set_destination m1 c3)
; 0: (set_destination m2 c3)
; 0.0: -----waiting---- [3.0]
; 3.0: (grab2 m2 m1 c3)
; 3.0: (set_destination2 m1 m2 loading_bay)
; 3.0: -----waiting---- [19.0]
; 19.0: (leave2 m1 m2 c3)
; 19.0: (set_destination m2 c1)
; 19.0: (set_destination m1 c2)
; 19.0: (grab l1 c3)
; 19.0: -----waiting---- [23.0]
; 23.0: (grab m2 c1)
; 23.0: (set_destination m2 loading_bay)
; 23.0: (ON_LOAD_FINISH l1 c3)
; 23.0: -----waiting---- [24.0]
; 24.0: (grab m1 c2)
; 24.0: (set_destination m1 loading_bay)
; 24.0: -----waiting---- [33.0]
; 33.0: (leave m2 c1)
; 33.0: (grab l1 c1)
; 33.0: -----waiting---- [37.0]
; 37.0: (ON_LOAD_FINISH l1 c1)
; 37.0: -----waiting---- [42.0]
; 42.0: (leave m1 c2)
; 42.0: (grab l1 c2)
; 42.0: -----waiting---- [46.0]
; 46.0: (ON_LOAD_FINISH l1 c2)

(define (problem warehouse_1)
    (:domain warehouse1)
    (:objects 
        loading_bay - waypoint
        m1 m2 - mover
        l1 - loader
        c1 c2 c3 - crate
    )

    (:init
        (= (position loading_bay) 0)

        (is_mover m1)
        (= (position m1) 0) (= (destination m1) 0)
        (= (lift_capability m1) 50)
        (= (velocity m1) 10) (= (velocity_dir m1) 0)

        (is_mover m2)
        (= (position m2) 0) (= (destination m2) 0)
        (= (lift_capability m2) 50)
        (= (velocity m2) 10) (= (velocity_dir m2) 0)

        (is_loader l1)
        (= (position l1) 0)
        (= (lift_capability l1) 100)
        (= (loading_time l1) -1)

        (= (position c1) 40) (= (weight c1) 25)
        (= (position c2) 45) (= (weight c2) 40)
        (= (position c3) 25) (= (weight c3) 90)
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