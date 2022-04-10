; RUN WITH
; java -jar .\ENHSP\enhsp.jar -o .\assignment_domain.pddl -f .\problem_unit_test_1.pddl -planner opt-blind

; THE CORRECT OUTPUT OF THIS TEST SHOULD BE
; 0: (move_to_crate m1 c1)
; 0.0: -----waiting---- [4.0]
; 4.0: (grab m1 c1)
; 4.0: (move_crate_to_lb m1 c1)
; 4.0: -----waiting---- [14.0]
; 14.0: (leave m1 c1)

(define (problem warehouse_1)
    (:domain warehouse)
    (:objects 
        m1 - mover
        c1 c2 - crate
    )

    (:init
        (= (distance_from_lb m1) 0) (= (lift_capability m1) 50) 
        (= (velocity m1) 0) (= (velocity_dir m1) 1) (= (destination m1) -1)

        (= (distance_from_lb c1) 40) (= (weight c1) 25)
        (= (distance_from_lb c2) 45) (= (weight c2) 40)
    )

    (:goal 
        (and
            (= (distance_from_lb c1) 0)
        )
    )

    (:metric 
        minimize (total-time)
    )
)