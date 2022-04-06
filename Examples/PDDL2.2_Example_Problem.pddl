(define (problem trainplanning1)

    (:domain railways)

    (:objects
        Pompey Guildford London - station
        train1 train2 - train
    )

    (:init
        (train_not_in_use train1)
        ; This is a Timed Initial Literal which means that that liter will 
        ; become true after the specified time has passed.
        ; This simulates something unexpected that occurs (the train breaks).
        (at 20 (train_not_in_use train2))
    )

    ;(:goal .. )
)