; THE CORRECT OUTPUT OF THIS TEST SHOULD BE
; 0: m1 moves to c1
; 0: m2 moves to c2
; 0.0: -----waiting---- [4.0]
; 4.0: m1 grabs c1
; 4.0: m1 moves to loading bay
; 4.0: -----waiting---- [5.0]
; 5.0: m2 grabs c2
; 5.0: m2 moves to loading bay
; 5.0: -----waiting---- [14.0]
; 14.0: m1 leaves c1
; 14.0: -----waiting---- [19.0]
; 19.0: l grabs c1
; 19.0: -----waiting---- [23.0]
; 23.0: m2 leaves c2
; 23.0: l grabs c2
; 23.0: -----waiting---- [27.0]

(define (problem warehouse_1)
    (:domain warehouse)
    (:objects 
        m1 m2 - mover
        l - loader
        c1 c2 - crate
    )

    (:init
        (= (distance_from_lb m1) 0) (= (lift_capability m1) 50) 
        (= (velocity m1) 0) (= (velocity_dir m1) 1) (= (destination m1) -1)

        (= (distance_from_lb m2) 0) (= (lift_capability m2) 50) 
        (= (velocity m2) 0) (= (velocity_dir m2) 1) (= (destination m2) -1)

        (= (distance_from_lb c1) 40) (= (weight c1) 25)
        (= (distance_from_lb c2) 45) (= (weight c2) 40)
        
        (= (distance_from_lb l) 0)(= (lift_capability l) 100)
        (= (loading_time l) 0)
    )

    (:goal 
        (and
            (is_delivered c1)
            (is_delivered c2)
        )
    )

    (:metric 
        minimize (total-time)
    )
)