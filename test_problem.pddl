; THE CORRECT OUTPUT OF THIS TEST SHOULD BE
; 0: (set_destination m2 c3)
; 0: (set_destination m1 c3)
; 0.0: -----waiting---- [3.0]
; 3.0: (grab2 m1 m2 c3)
; 3.0: (set_destination2 m1 m2 loading_bay)
; 3.0: -----waiting---- [19.0]
; 19.0: (leave2 m2 m1 c3)
; 19.0: (set_destination m1 c2)
; 19.0: -----waiting---- [24.0]
; 24.0: (grab m1 c2)
; 24.0: (set_destination m1 c3)
; 24.0: -----waiting---- [25.0]
; 25.0: (set_destination m2 c1)
; 25.0: -----waiting---- [29.0]
; 29.0: (grab m2 c1)
; 29.0: -----waiting---- [31.0]
; 31.0: (set_destination m2 c3)
; 41.0: -----waiting---- [42.0]
; 42.0: (leave m2 c1)
; 42.0: (leave m1 c2)

(define (problem warehouse_1)
    (:domain warehouse1)
    (:objects 
        loading_bay - waypoint
        m1 m2 - mover
        c1 c2 c3 - crate
    )

    (:init
        (= (position loading_bay) 0)

        (is_mover m1)
        (= (position m1) 0) (= (destination m1) 0)
        (= (velocity m1) 10) (= (velocity_dir m1) 0) 
        (= (lift_capability m1) 50)

        (is_mover m2)
        (= (position m2) 0) (= (destination m2) 0)
        (= (velocity m2) 10) (= (velocity_dir m2) 0) 
        (= (lift_capability m2) 50)

        (= (position c1) 40) (= (weight c1) 25)
        (= (position c2) 100) (= (weight c2) 40)
        (= (position c3) 25) (= (weight c3) 90)
    )

    (:goal 
        (and
            (= (position c1) (position loading_bay))
            (= (position c2) (position loading_bay))
        )
    )

    (:metric 
        minimize (total-time)
    )
)