(define (domain railways)

    (:requirements
        :typing
        ; This is required to create derived predicates
        :derived-predicates
        ; This is required to initialize literals after some time
        :timed-initial-literals
    )

    (:types
        train station - object
    )

    (:predicates
        (train_not_in_use ?t - train)
        (train_has_guard ?t - train)
        (train_has_driver ?t - train)
        (train_usable ?t - train)
    )

    ; A derived predicate which is the result of putting togheter other literals.
    ; NB. It still needs to be defined in the :predicates.
    (:derived (train_usable ?t - train)
        (and
            (train_has_guard ?t)
            (train_has_driver ?t)
        )
    )
)