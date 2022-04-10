; RUN WITH
; java -jar .\ENHSP\enhsp.jar -o .\assignment_domain.pddl -f .\problem_unit_test_1.pddl -planner opt-blind

; THE CORRECT OUTPUT OF THIS TEST SHOULD BE
; 0: (move_to_crate m1 c1)
; 0: (move_to_crate m2 c2)
; 0.0: -----waiting---- [4.0]
; 4.0: (grab m1 c1)
; 4.0: (move_crate_to_lb m1 c1)
; 4.0: -----waiting---- [5.0]
; 5.0: (grab m2 c2)
; 5.0: (move_crate_to_lb m2 c2)
; 5.0: -----waiting---- [14.0]
; 14.0: (leave m1 c1)
; 14.0: -----waiting---- [19.0]
; 19.0: (grab l c1)
; 19.0: -----waiting---- [23.0]
; 23.0: (leave m2 c2)
; 23.0: (grab l c2)
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