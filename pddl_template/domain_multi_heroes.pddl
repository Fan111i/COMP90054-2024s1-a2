(define (domain Dangeon)

  (:requirements
    :typing
    :negative-preconditions
  )

  (:types
    swords cells heros keys
  )

  (:predicates
    ; Location of hero
    (at-hero ?h - heros ?loc - cells)
    
    ; Location of sword
    (at-sword ?s - swords ?loc - cells)
    
    ; Location has a monster
    (has-monster ?loc - cells)
    
    ; Location has a trap
    (has-trap ?loc - cells)
    
    ; Indicates if a cell or sword is destroyed
    (is-destroyed ?obj)
    
    ; Connects cells
    (connected ?from ?to - cells)
    
    ; Hero's hand is free
    (arm-free ?h - heros)
    
    ; Hero is holding a sword
    (holding ?h - heros ?s - swords)
    
    ; Hero has a key
    (has-key ?h - heros ?key - keys)
    
    ; Location has a key
    (at-key ?key - keys ?loc - cells)
    
    ; Location is locked
    (locked ?loc - cells)
    
    ; Goals for different heroes
    (goals ?h - heros ?loc - cells)
    
    ; Used to control turns of each hero
    (hero-complete ?h - heros)
    
  )

  ; Hero can move if:
  ; - Hero is at current location
  ; - Cells are connected
  ; - No trap in current location
  ; - Destination does not have a trap/monster/has-been-destroyed
  (:action move
    :parameters (?h - heros ?from ?to - cells)
    :precondition (and 
      (at-hero ?h ?from)
      (not (has-monster ?to))
      (not (has-trap ?to))
      (not (has-trap ?from))
      (not (is-destroyed ?to))
      (connected ?from ?to)
      (not (locked ?to))
      (not (hero-complete ?h))
    )
    :effect (and 
      (at-hero ?h ?to)
      (is-destroyed ?from)
      (not (at-hero ?h ?from))
      (hero-complete ?h)
    )
  )

  ; When hero moves to a location with a trap
  (:action move-to-trap
    :parameters (?h - heros ?from ?to - cells)
    :precondition (and 
      (at-hero ?h ?from)
      (has-trap ?to)
      (not (has-trap ?from))
      (arm-free ?h)
      (or (not (is-destroyed ?to)) (at-hero ?h ?to))
      (connected ?from ?to)
      (not (hero-complete ?h))
    )
    :effect (and 
      (at-hero ?h ?to)
      (is-destroyed ?from)
      (not (at-hero ?h ?from))
      (hero-complete ?h)
    )
  )

  ; When hero moves to a location with a monster
  (:action move-to-monster
    :parameters (?h - heros ?from ?to - cells ?s - swords)
    :precondition (and 
      (at-hero ?h ?from)
      (has-monster ?to)
      (not (has-trap ?from))
      (holding ?h ?s)
      (not (is-destroyed ?to))
      (connected ?from ?to)
      (not (hero-complete ?h))
    )
    :effect (and 
      (at-hero ?h ?to)
      (is-destroyed ?from)
      (not (at-hero ?h ?from))
      (hero-complete ?h)
    )
  )

  ; Hero picks a sword if in the same location
  (:action pick-sword
    :parameters (?h - heros ?loc - cells ?s - swords)
    :precondition (and 
      (arm-free ?h)
      (at-hero ?h ?loc)
      (at-sword ?s ?loc)
      (not (hero-complete ?h))
    )
    :effect (and
      (holding ?h ?s)
      (not (arm-free ?h))
      (not (at-sword ?s ?loc))
      (hero-complete ?h)
    )
  )
  
  ; Hero destroys his sword
  (:action destroy-sword
    :parameters (?h - heros ?loc - cells ?s - swords)
    :precondition (and 
      (holding ?h ?s)
      (at-hero ?h ?loc)
      (not (has-trap ?loc))
      (not (has-monster ?loc))
      (not (hero-complete ?h))
    )
    :effect (and
      (not (holding ?h ?s))
      (arm-free ?h)
      (is-destroyed ?s)
      (hero-complete ?h)
    )
  )

  ; Hero disarms the trap with his free arm
  (:action disarm-trap
    :parameters (?h - heros ?loc - cells)
    :precondition (and 
      (has-trap ?loc)
      (at-hero ?h ?loc)
      (arm-free ?h)
      (not (hero-complete ?h))
    )
    :effect (and
      (not (has-trap ?loc))
      (hero-complete ?h)
    )
  )

  ; Hero picks a key if in the same location
  (:action pick-key
    :parameters (?h - heros ?loc - cells ?key - keys)
    :precondition (and 
      (arm-free ?h)
      (at-hero ?h ?loc)
      (at-key ?key ?loc)
      (not (hero-complete ?h))
    )
    :effect (and
      (has-key ?h ?key)
      (not (arm-free ?h))
      (not (at-key ?key ?loc))
      (hero-complete ?h)
    )
  )

  ; Hero destroys his key
  (:action destroy-key
    :parameters (?h - heros ?loc - cells ?key - keys)
    :precondition (and 
      (has-key ?h ?key)
      (at-hero ?h ?loc)
      (not (has-trap ?loc))
      (not (has-monster ?loc))
      (not (hero-complete ?h))
    )
    :effect (and
      (not (has-key ?h ?key))
      (arm-free ?h)
      (is-destroyed ?key)
      (hero-complete ?h)
    )
  )

  ; When hero moves to a locked location
  (:action move-to-locked
    :parameters (?h - heros ?from ?to - cells ?key - keys)
    :precondition (and 
      (at-hero ?h ?from)
      (has-key ?h ?key)
      (not (has-trap ?from))
      (locked ?to)
      (not (is-destroyed ?to))
      (connected ?from ?to)
      (not (hero-complete ?h))
    )
    :effect (and 
      (at-hero ?h ?to)
      (is-destroyed ?from)
      (not (at-hero ?h ?from))
      (hero-complete ?h)
    )
  )

  ; Hero givees his key to other hero if they're in the same location
  (:action give-key
    :parameters (?h1 ?h2 - heros ?loc - cells ?key - keys)
    :precondition (and 
      (at-hero ?h1 ?loc)
      (at-hero ?h2 ?loc)
      (has-key ?h1 ?key)
      (arm-free ?h2)
      (not (has-trap ?loc))
      (not (hero-complete ?h1))
    )
    :effect (and
      (has-key ?h2 ?key)
      (arm-free ?h1)
      (not (has-key ?h1 ?key))
      (not (arm-free ?h2))
      (hero-complete ?h1)
    )
  )

  ; Hero gives a sword to other hero if they're in the same location
  (:action give-sword
    :parameters (?h1 ?h2 - heros ?loc - cells ?s - swords)
    :precondition (and 
      (at-hero ?h1 ?loc)
      (at-hero ?h2 ?loc)
      (holding ?h1 ?s)
      (arm-free ?h2)
      (not (has-trap ?loc))
      (not (has-monster ?loc))
      (not (hero-complete ?h1))
    )
    :effect (and
      (holding ?h2 ?s)
      (arm-free ?h1)
      (not (holding ?h1 ?s))
      (not (arm-free ?h2))
      (hero-complete ?h1)
    )
  )

  ; When a hero doesn't do anything in one turn
  (:action take-no-action
    :parameters (?h - heros)
    :precondition (and 
      (not (hero-complete ?h))             
    )
    :effect (and 
      (hero-complete ?h)               
    )
  )

  ; Control turns
  (:action new-turn
    :parameters ()
    :precondition (and 
      (forall (?h - heros) (hero-complete ?h))             
    )
    :effect (and 
      (forall (?h - heros) (not (hero-complete ?h)))               
    )
  )
)

  