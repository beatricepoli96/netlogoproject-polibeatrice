globals [
  ticks-at-last-change  ; value of the tick counter the last time a light changed
]
; active agents
breed [ cars car ]
breed [ lights light ]
breed [ accidents accident ]
breed [ raindrops raindrop ]
breed [ clouds cloud ]

cars-own [
  speed
  car-type
]
accidents-own [
  clear-in
]

;;------------------------------------------------
to make-clouds
  create-clouds 30 [
    set shape "cloud"
    setxy random-xcor max-pycor
    set heading 180
    fd random 2
    set size 4
    set color 87
  ]
end

;;------------------------------------------------
to make-rain-fall
  ;; Create new raindrops at the top of the world
  create-raindrops 10 [
    setxy random-xcor max-pycor
    set heading 180
    fd 0.5 - random-float 1.0
    set size .6
    set color 88
    set shape "drop"
  ]
  ;; Now move all the raindrops, including
  ;; the ones we just created.
  ask raindrops [
    fd random-float 2
    if ycor < -22 [die]
  ]
end

to setup
  clear-all
  set-default-shape lights "square"
  make-clouds
  ask patches [
    ifelse abs pxcor <= 1 or abs pycor <= 1
      [ set pcolor black ]     ; the roads are black
      [ set pcolor green - 2 ]  ; and outof road is blue
  ]
  ask patch 0 -2 [ sprout-lights 1 [ set color green set size 2 ] ]
  ask patch -2 0 [ sprout-lights 1 [ set color red  set size 2] ]

  create-turtles 1 [ setxy -21 0  set color white set shape "rectangle" set size 1.5]
  create-turtles 1 [ setxy -17 0  set color white set shape "rectangle" set size 1.5]
  create-turtles 1 [ setxy -13 0  set color white set shape "rectangle" set size 1.5]
  create-turtles 1 [ setxy -9 0  set color white set shape "rectangle" set size 1.5]
  create-turtles 1 [ setxy -5 0  set color white set shape "rectangle" set size 1.5]
  create-turtles 1 [ setxy 0 0  set color white set shape "rectangle" set size 1.5]
  create-turtles 1 [ setxy 4 0  set color white set shape "rectangle" set size 1.5]
  create-turtles 1 [ setxy 8 0  set color white set shape "rectangle" set size 1.5]
  create-turtles 1 [ setxy 12 0  set color white set shape "rectangle" set size 1.5]
  create-turtles 1 [ setxy 16 0  set color white set shape "rectangle" set size 1.5]
  create-turtles 1 [ setxy 20 0  set color white set shape "rectangle" set size 1.5]

  create-turtles 1 [ setxy 0 -21  set color white set shape "rectangle 2" set size 1.5 set heading 45]
  create-turtles 1 [ setxy 0 -17  set color white set shape "rectangle 2" set size 1.5]
  create-turtles 1 [ setxy 0 -13  set color white set shape "rectangle 2" set size 1.5]
  create-turtles 1 [ setxy 0 -9   set color white set shape "rectangle 2" set size 1.5]
  create-turtles 1 [ setxy 0 -5   set color white set shape "rectangle 2" set size 1.5]
  create-turtles 1 [ setxy 0 3  set color white set shape "rectangle 2" set size 1.5]
  create-turtles 1 [ setxy 0 7  set color white set shape "rectangle 2" set size 1.5]
  create-turtles 1 [ setxy 0 11 set color white set shape "rectangle 2" set size 1.5]
  create-turtles 1 [ setxy 0 15 set color white set shape "rectangle 2" set size 1.5]
  create-turtles 1 [ setxy 0 19  set color white set shape "rectangle 2" set size 1.5]
; trees
  create-turtles 1 [ setxy 7 12  set color 67 set shape "tree" set size 7]
  create-turtles 1 [ setxy 11 12  set color 67 set shape "tree" set size 7]
  create-turtles 1 [ setxy 15 12  set color 67 set shape "tree" set size 7]
  create-turtles 1 [ setxy 19 12  set color 67 set shape "tree" set size 7]
  create-turtles 1 [ setxy 7 7  set color 66 set shape "tree" set size 7]
  create-turtles 1 [ setxy 11 7  set color 66 set shape "tree" set size 7]
  create-turtles 1 [ setxy 15 7  set color 66 set shape "tree" set size 7]
  create-turtles 1 [ setxy 19 7  set color 66 set shape "tree" set size 7]


  create-turtles 1 [ setxy -21 9  set color magenta set shape "house colonial" set size 10]
  create-turtles 1 [ setxy -15 7  set color green set shape "tree" set size 7]
  create-turtles 1 [ setxy -9 7  set color magenta set shape "house colonial" set size 10]

  create-turtles 1 [ setxy 8 -7  set color brown set shape "house colonial" set size 10]
  create-turtles 1 [ setxy 15 -7  set color green set shape "tree" set size 7]
  create-turtles 1 [ setxy 21 -7  set color brown set shape "house colonial" set size 10]

 ; trees
  create-turtles 1 [ setxy -7 -7  set color green set shape "tree" set size 7]
  create-turtles 1 [ setxy -11 -7  set color green set shape "tree" set size 7]
  create-turtles 1 [ setxy -15 -7  set color green set shape "tree" set size 7]
  create-turtles 1 [ setxy -19 -7  set color green set shape "tree" set size 7]
  create-turtles 1 [ setxy -7 -12  set color 66 set shape "tree" set size 7]
  create-turtles 1 [ setxy -11 -12 set color 66 set shape "tree" set size 7]
  create-turtles 1 [ setxy -15 -12  set color 66 set shape "tree" set size 7]
  create-turtles 1 [ setxy -19 -12  set color 66 set shape "tree" set size 7]
  set-default-shape accidents "fire"
  set-default-shape cars "car"
  reset-ticks
end

to go
  if count cars = (human-cars) [stop]
  if isRain? [make-rain-fall]
  ask cars [ move ]
  check-for-collisions
  make-new-car frequency-north 0 min-pycor 0
  make-new-car frequency-east min-pxcor 0 90
  ; if we are in "auto" mode and a light has been green for long enough, we turn it yellow
  if elapsed? green-length [
    change-to-yellow
  ]
  ; if a light has been yellow for long enough, we turn it red and turn the other one green
  if any? lights with [ color = yellow ] and elapsed? yellow-length [
    change-to-red
  ]
  tick
end

to make-new-car [ freq x y h ]
  if (human-cars > 0) and (random-float 100 < freq) and not any? turtles-on patch x y [
    create-cars 1 [
      setxy x y
      set heading h
      set color one-of base-colors
      ifelse color = red [ set car-type "auto"]
      [set car-type "human"]
      adjust-speed
      set size 2
    ]
  ]
end

to move
  adjust-speed
  repeat speed [
    ifelse isRain? [fd 0.5]
    [fd 1]
    if not can-move? 1 [ die ]
    if any? accidents-here [
      ; if a car hits another car, an accident occurs
      ask accidents-here [ set clear-in 5 ]
      die
    ]
    ;show speed
  ]
end

to adjust-speed
  ; calculate the min and max possible speed that a car can go
  let min-speed max (list (speed - max-brake) 0)
  let max-speed min (list (speed + max-accel) speed-limit)

  let target-speed max-speed

  let blocked-patch next-blocked-patch
  if blocked-patch != nobody [
    ; if an obstacle ahead, reduce speed
    let space-ahead (distance blocked-patch - 1)
    while [
      breaking-distance-at target-speed > space-ahead and
      target-speed > min-speed
    ] [
      ifelse isRain? [set target-speed (target-speed - 1 - 0.5)]
      [set target-speed (target-speed - 1)]

    ]
  ]

  set speed target-speed

end

to-report breaking-distance-at [ speed-at-this-tick ]
  let min-speed-at-next-tick max (list (speed-at-this-tick - max-brake) 0)
  report speed-at-this-tick + min-speed-at-next-tick
end

to-report next-blocked-patch
  ; check all patches ahead until I find a blocked
  let patch-to-check patch-here
  while [ patch-to-check != nobody and not is-blocked? patch-to-check ] [
    set patch-to-check patch-ahead ((distance patch-to-check) + 1)
  ]
  ; report the blocked patch or nobody if I didn't find any
  report patch-to-check
end

to-report is-blocked? [ target-patch ]
  report
    any? other cars-on target-patch or
    any? accidents-on target-patch or
    any? (lights-on target-patch) with [ color = red ] or
    (any? (lights-on target-patch) with [ color = yellow ] and
      ; only stop for a yellow light if I'm not already on it:
      target-patch != patch-here)
end

to check-for-collisions
  ask accidents [
    set clear-in clear-in - 1
    if clear-in = 0 [ die ]
  ]
  ask patches with [ count cars-here > 1 ] [
    sprout-accidents 1 [
      set size 1.5
      set color yellow
      set clear-in 5
    ]
    ask cars-here [ die ]
  ]
end

to change-to-yellow
  ask lights with [ color = green ] [
    set color yellow
    set ticks-at-last-change ticks
  ]
end

to change-to-red
  ask lights with [ color = yellow ] [
    set color red
    ask other lights [ set color green ]
    set ticks-at-last-change ticks
  ]
end

to-report elapsed? [ time-length ]
  report (ticks - ticks-at-last-change) > time-length
end

; calculating mean of speed
to-report mean-speed
  let spd [0]

  ask cars [ set spd lput speed spd ]

  if length spd > 1 [set spd but-first spd]
  report mean spd
end
@#$#@#$#@
GRAPHICS-WINDOW
186
11
799
515
-1
-1
11.0
1
10
1
1
1
0
0
0
1
-27
27
-22
22
1
1
1
ticks
30.0

BUTTON
52
13
142
46
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
105
56
177
89
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
109
97
182
131
Light-Switch
change-to-yellow
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
15
387
176
420
green-length
green-length
1
50
34.0
1
1
NIL
HORIZONTAL

SLIDER
17
182
178
215
speed-limit
speed-limit
1
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
17
220
178
253
max-accel
max-accel
1
10
6.0
1
1
NIL
HORIZONTAL

SLIDER
17
258
178
291
max-brake
max-brake
1
10
4.0
1
1
NIL
HORIZONTAL

SLIDER
16
301
177
334
frequency-north
frequency-north
0
100
45.0
5
1
%
HORIZONTAL

SLIDER
16
334
177
367
frequency-east
frequency-east
0
100
45.0
5
1
%
HORIZONTAL

SLIDER
15
420
176
453
yellow-length
yellow-length
0
10
3.0
1
1
NIL
HORIZONTAL

MONITOR
826
60
977
105
Waiting # of cars Overall
count cars with [ speed = 0 ]
0
1
11

MONITOR
985
60
1096
105
waiting-left-to-right
count cars with [ heading = 90 and speed = 0 ]
0
1
11

MONITOR
1102
60
1237
105
waiting-bottom-to-top
count cars with [ heading = 0 and speed = 0 ]
0
1
11

BUTTON
26
56
91
89
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
826
11
979
56
Total # of Cars on the roads
count cars
17
1
11

MONITOR
1015
11
1151
56
Total # of Accidents
count accidents
17
1
11

PLOT
806
113
1206
336
Number of Waiting Cars
Time
# of waiting cars
0.0
100.0
0.0
10.0
true
true
"" ""
PENS
"Overall" 1.0 0 -13840069 true "" "plot count cars with [ speed = 0 ]"
"Left to Right" 1.0 0 -8630108 true "" "plot count cars with [ heading = 90 and speed = 0 ]"
"Buttom to Top" 1.0 0 -955883 true "" "plot count cars with [ heading = 0 and speed = 0 ]"

SWITCH
17
98
107
131
isRain?
isRain?
1
1
-1000

PLOT
805
352
1206
527
Mean Speed of All Cars
Time
Mean Speed
0.0
10.0
0.0
5.0
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot mean-speed"

SLIDER
17
136
179
169
human-cars
human-cars
0
400
152.0
1
1
NIL
HORIZONTAL

PLOT
1216
241
1504
465
plot 1
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -3508570 true "" "plot count cars"
"pen-1" 1.0 0 -4079321 true "" "plot count cars with [ speed = 0 ]"

@#$#@#$#@
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
true
0
Polygon -7500403 true true 180 15 164 21 144 39 135 60 132 74 106 87 84 97 63 115 50 141 50 165 60 225 150 285 165 285 225 285 225 15 180 15
Circle -16777216 true false 180 30 90
Circle -16777216 true false 180 180 90
Polygon -16777216 true false 80 138 78 168 135 166 135 91 105 106 96 111 89 120
Circle -7500403 true true 195 195 58
Circle -7500403 true true 195 47 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cloud
false
0
Circle -7500403 true true 13 118 94
Circle -7500403 true true 86 101 127
Circle -7500403 true true 51 51 108
Circle -7500403 true true 118 43 95
Circle -7500403 true true 158 68 134

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

drop
false
0
Circle -7500403 true true 73 133 152
Polygon -7500403 true true 219 181 205 152 185 120 174 95 163 64 156 37 149 7 147 166
Polygon -7500403 true true 79 182 95 152 115 120 126 95 137 64 144 37 150 6 154 165

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fire
false
0
Polygon -7500403 true true 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house colonial
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Polygon -7500403 true true 30 135 285 135 240 90 75 90
Line -16777216 false 30 135 285 135
Line -16777216 false 255 105 285 135
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rectangle
false
0
Rectangle -7500403 true true 15 105 285 210

rectangle 2
false
0
Rectangle -7500403 true true 105 15 195 285

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks &gt; 1000</exitCondition>
    <metric>ticks</metric>
    <metric>count cars</metric>
    <enumeratedValueSet variable="max-accel">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="yellow-length">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="frequency-north">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="human-car">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-limit">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-brake">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="frequency-east">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="isRain?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="automated-cars">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-length">
      <value value="12"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
