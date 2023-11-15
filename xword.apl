⎕IO←0

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
groups←⊃,/{(×nblack)↓⍵⊂⍤⊢⌸⍥,⍳⍴⍵}¨wordx wordy
squarex←¯1+Count white
squarey←¯1+white×1+nwhite+nblack-⍨{(⍴⍵)⍴⍋⍋,⍵}wordy
points←(⍸white),{nblack↓(,⍳⍴⍵)[⍋,⍵]}squarey

Move←{3::⍵ ⋄ ⍺+⍣{⍺⌷white}⍵}
H← 0 ¯1∘Move
J← 1  0∘Move
K←¯1  0∘Move
L← 0  1∘Move

gg    ←  1-+⍀∨⍀ white
g     ←⊖¯1++⍀∨⍀⊖white
zero  ←  1-+\∨\ white
dollar←⌽¯1++\∨\⌽white
GG    ←{y x←⍵ ⋄ y+←⍵⌷gg     ⋄ y x}
G     ←{y x←⍵ ⋄ y+←⍵⌷g      ⋄ y x}
Zero  ←{y x←⍵ ⋄ x+←⍵⌷zero   ⋄ y x}
Dollar←{y x←⍵ ⋄ x+←⍵⌷dollar ⋄ y x}

Word  ←{dir pos←⍵ ⋄ pos⌷dir⊃wordx   wordy}
Square←{dir pos←⍵ ⋄ pos⌷dir⊃squarex squarey}
Nav←(≢points)|+
Next← 1∘Nav
Prev←¯1∘Nav
Point←{(⍵≥nwhite)(⍵⊃points)}

w ←∊{⌽1+⍳≢⍵}¨groups
ge←∊{-1+⍳≢⍵}¨groups
e ← 1⌽w
b ←¯1⌽ge
Jump←{Point(⊃∘⍺Nav⊢)Square⍵}
W ←w ∘Jump
GE←ge∘Jump
E ←e ∘Jump
B ←b ∘Jump

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
Render←{
    dir pos puzzle←⍵
    shape←⍴light←(⍳9)Rect⍴puzzle
    group←groups⊃⍨Word dir pos
    rect←1 5 2 6 0 6 3 5 4 Rect dir⌽1,≢group
    dy dx←-⊃group
    heavy←dy⊖dx⌽shape↑rect
    vertex←(⊂box)⌷¨⍨light,¨heavy
    edgex←heavy{3↑(3⍴'─━'[2|⍺]),⍨(0=⍵)↓⍕⍵}¨shape↑number
    edgey←'│┃'[heavy∊1 2 6]
    face←3∘⍴¨'░ '[shape↑white]
    ¯1 ¯3↓⊃⍪⌿,/(vertex,¨edgex),[¯0.5]¨edgey,¨face
}

stdin←'/dev/stdin' ⎕NTIE 0
cr esc←⎕UCS 13 27

dir←0
pos←⊃points

:Repeat
    grid←Render dir pos puzzle
    out ←esc,'[2J'   ⍝ clear screen
    out,←esc,'[1;1H' ⍝ move cursor to top left
    out,←∊grid,cr
    y x←⍕¨2 3+2 4×pos
    out,←esc,'[',y,';',x,'H' ⍝ move cursor to pos
    ⍞←out
    {
        ⍵=' ':dir⊢←~dir
        ⍵='h':pos⊢←H      pos
        ⍵='j':pos⊢←J      pos
        ⍵='k':pos⊢←K      pos
        ⍵='l':pos⊢←L      pos
        ⍵='g':pos⊢←GG     pos ⍝ gg
        ⍵='G':pos⊢←G      pos
        ⍵='0':pos⊢←Zero   pos
        ⍵='$':pos⊢←Dollar pos
        ⍵='w':dir pos⊢←W  dir pos
        ⍵='[':dir pos⊢←GE dir pos ⍝ ge
        ⍵='e':dir pos⊢←E  dir pos
        ⍵='b':dir pos⊢←B  dir pos
    }⎕UCS⊃1stdin⎕ARBIN⍬
:EndRepeat

T←{0=⍵:⎕SIGNAL 8}

T 1 2≡H 1 3
T 4 3≡J 2 3
T 1 0≡K 1 0
T 3 6≡L 3 6

T 1 0≡GG     3 0
T 5 0≡G      3 0
T 0 1≡Zero   0 3
T 0 5≡Dollar 0 3

T 0(0 1)≡Point      Square 0(0 1)
T 0(0 2)≡Point Next Square 0(0 1)
T 1(6 3)≡Point Prev Square 0(0 1)

T 0(2 0)≡W  0(1 3)
T 0(0 5)≡GE 0(1 3)
T 0(1 6)≡E  0(1 3)
T 0(2 6)≡E  0(1 6)
T 0(1 0)≡B  0(1 3)
T 0(0 1)≡B  0(1 0)
