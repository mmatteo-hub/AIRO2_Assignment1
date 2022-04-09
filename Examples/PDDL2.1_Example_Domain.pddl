(define (domain rover_domain)

    (:requirements 
        ; This is required to have the basic action effects
        :strips
        ; This is required to define types for objects
        :typing
        ; This is required to define numeric fluents
        :fluents 
        ; This is required to define durative actions
        :durative-actions
        ; This is required to have other operators (< > ...) when defining a duration
        :duration-inequalities
    )

    ; Types can be used to restrict the type of objects that can be used as parameters.
    ; We have two types which derive from the base type which is "object".
    (:types 
        rover waypoint - object     
    )

    ; Here we define Numeric Fluents which are integer variables that apply to zero or more objects.
    ; The first fluent mesn that every object has the same value for the battery_capacity.
    ; The second fluent means that every object of type rover has a variable called battery_amount.
    (:functions
        (battery_amount ?r - rover)
        (distance_travelled)
    )
    ; Some operations can be defined with fluents:
    ;  ({operation} {numeric_fluent} {amount})
    ; - The {operation} can be: increase, decrease, assign, scale-up, scale-down.
    ; - The {numeric_fluent} is the numeric fluent on which we want to perform the operation.
    ; - The {amount} can a fixed value or another numeric fluent.
    ; There are other types of operations which do not change the value of the fluents but
    ; instead, return the resulting value so that it can be used as parameter:
    ;  ({operation} {amount_1} {amount_2})
    ; - The {operation} can be: + , - , * , / .
    ; - The {amount_1} {amount_2} can be a numeric fluent or a fixed value.
    
    ; Here we define Predicates whichare boolean variables that apply to zero or more objects.
    ; The parameters can be restricted with types.
    (:predicates
        (can_move ?rover - rover ?from - waypoint ?to - waypoint)
        (at ?rover ?waypoint - waypoint)
        (been_at ?rover ?waypoint - waypoint)
	)

    ; This is a durative-action which is an action that takes some time to be completed.
    (:durative-action move
        :parameters
            (?rover - rover
             ?from - waypoint
             ?to - waypoint)

        ; Here we can define the duration of the action, it can be a fixed value but also a fluent.
        ; (Or, as said before, an operation that return a value that can be used as parameter).
        :duration
            (= ?duration 5)

        ; A condition is a expression that must be met in order for a durative action to execute.
        ; at start: conditions that must be true when the action starts.
        ; over all: conditions that must be true during all the execution of the action.
        ; at end: conditions that must be true when the action ends.
        :condition
	        (and
	            (at start (at ?rover ?from))
	            (at start (> (battery_amount ?rover) 10))
	            (over all (can_move ?rover ?from ?to))
            )

        ; This is a durative-action, so, the effects can be applied at different times.
        ; at start: effects that are applied when the action starts.
        ; at end: effects that are applied when the action ends.
        :effect
	        (and
                (at end (assign (battery_amount ?rover) 5))
            )
	)
)