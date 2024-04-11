(define (problem p4-dangeon)
  (:domain Dangeon)
  (:objects
            cell1_1 cell1_2 cell1_3 cell1_4 cell1_5 
            cell2_1 cell2_2 cell2_3 cell2_4 cell2_5
            cell3_1 cell3_2 cell3_3 cell3_4 cell3_5
            cell4_1 cell4_2 cell4_3 cell4_4 cell4_5 - cells
            hero1 hero2 - heros
            key - keys
            sword1 - swords
  )
  (:init
    ; Initial Hero Location
    (at-hero hero1 cell4_5)
    (at-hero hero2 cell4_1)
    
    ; Heros start with free arms
    (arm-free hero1)
    (arm-free hero2)
    
    ; Initial location of Locked Rooms
    (locked cell1_2)
    (locked cell1_3)
    (locked cell2_1)
    (locked cell2_4)
    
    ; Initial keys
    (at-key key cell4_4)
    (has-monster cell1_4)
    (has-monster cell3_2)
    (has-monster cell3_3)
    (has-monster cell3_5)
    (has-monster cell4_3)
    (has-trap cell2_2)
    (has-trap cell2_5)
    (at-sword sword1 cell3_1)
    
    
    
    ; Initial state for hero completeness
    (not (hero-complete hero1))
    (not (hero-complete hero2))
    
    ; Graph Connectivity
    (connected cell1_1 cell1_2)
    (connected cell1_1 cell2_1)
    (connected cell1_2 cell1_1)
    (connected cell1_2 cell2_2)
    (connected cell1_2 cell1_3)
    (connected cell1_3 cell1_2)
    (connected cell1_3 cell2_3)
    (connected cell1_3 cell1_4)
    (connected cell1_4 cell1_3)
    (connected cell1_4 cell2_4)
    (connected cell1_4 cell1_5)
    (connected cell1_5 cell1_4)
    (connected cell1_5 cell2_5)
    (connected cell2_1 cell1_1)
    (connected cell2_1 cell2_2)
    (connected cell2_1 cell3_1)
    (connected cell2_2 cell2_1)
    (connected cell2_2 cell1_2)
    (connected cell2_2 cell2_3)
    (connected cell2_2 cell3_2)
    (connected cell2_3 cell2_2)
    (connected cell2_3 cell1_3)
    (connected cell2_3 cell2_4)
    (connected cell2_3 cell3_3)
    (connected cell2_4 cell2_3)
    (connected cell2_4 cell1_4)
    (connected cell2_4 cell2_5)
    (connected cell2_4 cell3_4)
    (connected cell2_5 cell2_4)
    (connected cell2_5 cell1_5)
    (connected cell2_5 cell3_5)
    (connected cell3_1 cell2_1)
    (connected cell3_1 cell3_2)
    (connected cell3_1 cell4_1)
    (connected cell3_2 cell3_1)
    (connected cell3_2 cell2_2)
    (connected cell3_2 cell3_3)
    (connected cell3_2 cell4_2)
    (connected cell3_3 cell3_2)
    (connected cell3_3 cell2_3)
    (connected cell3_3 cell3_4)
    (connected cell3_3 cell4_3)
    (connected cell3_4 cell3_3)
    (connected cell3_4 cell2_4)
    (connected cell3_4 cell3_5)
    (connected cell3_4 cell4_4)
    (connected cell3_5 cell3_4)
    (connected cell3_5 cell2_5)
    (connected cell3_5 cell4_5)
    (connected cell4_1 cell3_1)
    (connected cell4_1 cell4_2)
    (connected cell4_2 cell4_1)
    (connected cell4_2 cell3_2)
    (connected cell4_2 cell4_3)
    (connected cell4_3 cell4_2)
    (connected cell4_3 cell3_3)
    (connected cell4_3 cell4_4)
    (connected cell4_4 cell4_3)
    (connected cell4_4 cell3_4)
    (connected cell4_4 cell4_5)
    (connected cell4_5 cell4_4)
    (connected cell4_5 cell3_5)

    
    
    ; Hero's Goals
    (goals hero1 cell2_3)
    (goals hero2 cell1_1)
  )
  (:goal (and
    ; Hero's Goal Location
    (at-hero hero1 cell2_3)
    (at-hero hero2 cell1_1)
  ))
)