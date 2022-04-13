; THE CORRECT OUTPUT OF THIS TEST SHOULD BE
; 0: m1 moves to c1
; 0.0: -----waiting---- [4.0]
; 4.0: m1 grabs c1
; 4.0: m1 moves to loading bay
; 4.0: -----waiting---- [14.0]
; 14.0: m1 leaves c1
; 14.0: m1 moves to c2
; 14.0: -----waiting---- [19.0]
; 19.0: m1 grabs c2
; 19.0: m1 moves to loading bay
; 19.0: -----waiting---- [37.0]
; 37.0: m1 leaves c2

(define (problem warehouse_1)
    (:domain warehouse)
    (:objects 
        m1 m2 - mover
        c1 c2 - crate
    )

    (:init
        (= (distance_from_lb m1) 0) (= (lift_capability m1) 50) 
        (= (velocity m1) 0) (= (velocity_dir m1) 1) (= (destination m1) -1)

        (= (distance_from_lb m2) 0) (= (lift_capability m2) 50) 
        (= (velocity m2) 0) (= (velocity_dir m2) 1) (= (destination m2) -1)

        (= (distance_from_lb c1) 40) (= (weight c1) 25)
        (= (distance_from_lb c2) 45) (= (weight c2) 40)
    )

    (:goal 
        (and
            (= (distance_from_lb c1) 0)
            (= (distance_from_lb c2) 0)
        )
    )

    (:metric 
        minimize (total-time)
    )
)