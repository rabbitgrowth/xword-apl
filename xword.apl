⎕IO←0

∆←{0=⍵:⎕SIGNAL 8}

puzzle←⍉⍪' RACED '
puzzle⍪← 'BELARUS'
puzzle⍪← 'LABTECH'
puzzle⍪← 'ALE CHE'
puzzle⍪← 'KIRSTIE'
puzzle⍪← 'ESTREET'
puzzle⍪← ' MAIDS '

white←' '≠puzzle
headx←2</0,white
heady←2<⌿0⍪white
Count←{⍵×(⍴⍵)⍴+\,⍵}
number←Count headx∨heady
nwhite←+/, white
nblack←+/,~white
nwordx←+/, headx
wordx←¯1+white×       ⌈\Count headx
wordy←¯1+white×nwordx+⌈⍀Count heady
points←⊃,/{(×nblack)↓⍵⊂⍤⊢⌸⍥,⍳⍴⍵}¨wordx wordy
squarex←¯1+Count white
squarey←¯1+white×1+nwhite+nblack-⍨{(⍴⍵)⍴⍋⍋,⍵}wordy
point←(⍸white),{nblack↓(,⍳⍴⍵)[⍋,⍵]}squarey

dir←0
pos←0 1

Move←{3::⍵ ⋄ ⍺+⍣{⍺⌷white}⍵}
H← 0 ¯1∘Move
J← 1  0∘Move
K←¯1  0∘Move
L← 0  1∘Move

∆ 1 2≡H 1 3
∆ 4 3≡J 2 3
∆ 1 0≡K 1 0
∆ 3 6≡L 3 6

gg    ←  1-+⍀∨⍀ white
g     ←⊖¯1++⍀∨⍀⊖white
zero  ←  1-+\∨\ white
dollar←⌽¯1++\∨\⌽white
GG    ←{y x←⍵ ⋄ y+←⍵⌷gg     ⋄ y x}
G     ←{y x←⍵ ⋄ y+←⍵⌷g      ⋄ y x}
Zero  ←{y x←⍵ ⋄ x+←⍵⌷zero   ⋄ y x}
Dollar←{y x←⍵ ⋄ x+←⍵⌷dollar ⋄ y x}

∆ 1 0≡GG     3 0
∆ 5 0≡G      3 0
∆ 0 1≡Zero   0 3
∆ 0 5≡Dollar 0 3

Word  ←{dir pos←⍵ ⋄ pos⌷dir⊃wordx   wordy}
Square←{dir pos←⍵ ⋄ pos⌷dir⊃squarex squarey}
Nav←(≢point)|+
Next← 1∘Nav
Prev←¯1∘Nav
Point←{(⍵≥nwhite)(⍵⊃point)}
Points←points⊃⍨Word

∆ 0(0 1)≡Point      Square 0(0 1)
∆ 0(0 2)≡Point Next Square 0(0 1)
∆ 1(6 3)≡Point Prev Square 0(0 1)

w ←∊{⌽1+⍳≢⍵}¨points
ge←∊{-1+⍳≢⍵}¨points
e ← 1⌽w
b ←¯1⌽ge
Jump←{Point(⊃∘⍺Nav⊢)Square⍵}
W ←w ∘Jump
GE←ge∘Jump
E ←e ∘Jump
B ←b ∘Jump

∆ 0(2 0)≡W  0(1 3)
∆ 0(0 5)≡GE 0(1 3)
∆ 0(1 6)≡E  0(1 3)
∆ 0(2 6)≡E  0(1 6)
∆ 0(1 0)≡B  0(1 3)
∆ 0(0 1)≡B  0(1 0)

⍝      0123456
⍝       ┏┓┗┛━┃
box←⍉⍪'┌┏     '
box⍪← '┬┲┱  ┯ '
box⍪← '┐ ┓    '
box⍪← '├┢ ┡  ┠'
box⍪← '┼╆╅╄╃┿╂'
box⍪← '┤ ┪ ┩ ┨'
box⍪← '└  ┗   '
box⍪← '┴  ┺┹┷ '
box⍪← '┘   ┛  '

Rect←{y x←⍵-1 ⋄ 1 y 1⌿1 x 1/3 3⍴⍺}
shape←⍴light←(⍳9)Rect⍴puzzle
rect←1 5 2 6 0 6 3 5 4 Rect dir⌽1,≢Points dir pos
dy dx←-pos
heavy←dy⊖dx⌽shape↑rect
vertex←(⊂box)⌷¨⍨light,¨heavy
edgex←heavy{3↑(3⍴'─━'[2|⍺]),⍨(0=⍵)↓⍕⍵}¨shape↑number
edgey←'│┃'[heavy∊1 2 6]
face←3∘⍴¨'░ '[shape↑white]
grid←¯1 ¯3↓⊃⍪⌿,/(vertex,¨edgex),[¯0.5]¨edgey,¨face

⎕←grid
