(define (problem logistics1)

    (:domain logistics)

    (:objects
        lorry1 lorry2 lorry3 - lorry
        p1 p2 p3 p4 - package
        r1 r2 r3 - recipient
        london portsmouth glasgow - location
    )

    (:init
    )

    (:goal
        ; A preference is how soft goals are defined: a soft goal is a goal
        ; which does not need to be met in order for a plan to be valid but may
        ; incur a cost if not met.
        (preference visit_ldn_then_gls
            (sometime-after (at lorry1 london) (at lorry1 glasgow))
        )
        (and
            (at lorry1 portsmouth)
        )
    )

    (:metric (minimize 
        (+
            ; This means that if visit_ldn_then_gls soft goal is not obtained, we have
            ; that 10 is added to the final cost.
            (* (is-violated visit_ldn_then_gls) 10)
            ; ... Some other conditions
        )
    )
)