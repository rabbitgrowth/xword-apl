⎕IO←0

nul lf cr esc←⎕UCS 0 10 13 27

sol←⍉⍪' RACED '
sol⍪← 'BELARUS'
sol⍪← 'LABTECH'
sol⍪← 'ALE CHE'
sol⍪← 'KIRSTIE'
sol⍪← 'ESTREET'
sol⍪← ' MAIDS '

cluex ←⊂'Competed in the downhill or super-G'
cluex,←⊂'Country between Ukraine and Lithuania'
cluex,←⊂'Worker in a bio building'
cluex,←⊂'The "A" of I.P.A.'
cluex,←⊂'Michael of "S.N.L."'
cluex,←⊂'Alley who''s a spokesperson for Jenny Craig'
cluex,←⊂'___ Band, backers of Bruce Springsteen'
cluex,←⊂'Hotel cleaners'
cluey ←⊂'Painting style of Winslow Homer and Edward Hopper'
cluey,←⊂'Canadian province that borders Montana'
cluey,←⊂'Sofa scratcher'
cluey,←⊂'Put up, as a building'
cluey,←⊂'Territories for English nobility'
cluey,←⊂'Country star Shelton'
cluey,←⊂'Unit of fabric or ice'
cluey,←⊂'___ Lanka'

Count←{⍵×(⍴⍵)⍴+\,⍵}
white←' '≠sol
headx←2</0,white
heady←2<⌿0⍪white
num←Count headx∨heady
numx←headx/⍥,num
numy←heady/⍥,num
nwhite←+/, white
nblack←+/,~white
nwordx←+/, headx
nwordy←+/, heady
iwordx←       ⍳nwordx
iwordy←nwordx+⍳nwordy
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

Word  ←{dir pos←⍵ ⋄ pos⌷dir⊃wordx wordy}
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
Light←(⍳9)             ∘Rect
Heavy←1 5 2 6 0 6 3 5 4∘Rect
Grid←{
    dir pos ans←⍵
    shape←⍴light←Light⍴ans
    group←groups⊃⍨Word dir pos
    dy dx←-⊃group
    heavy←dy⊖dx⌽shape↑Heavy dir⌽1,≢group
    vertex←(light,¨heavy)⌷¨⊂box
    edgex←heavy{3↑(3⍴'─━'[2|⍺]),⍨(0=⍵)↓⍕⍵}¨shape↑num
    edgey←'│┃'[heavy∊1 2 6]
    face←shape↑white{⍺⊃(3⍴'░')(' '⍵' ')}¨ans
    ¯1 ¯3↓⊃⍪⌿,/(vertex,¨edgex),[¯0.5]¨edgey,¨face
}

Wrap←{
    ⍺≥⍴⍵:⍉⍪⍺↑⍵
    take←⊃⌽⍺,⍸' '=(⍺+1)↑⍵
    drop←take+' '=⍵[take]
    (⍉⍪⍺↑take↑⍵)⍪⍺∇drop↓⍵
}
wrapx wrapy←25 Wrap¨¨cluex cluey
List←{(⊃⍪/(≢¨⍵)↑¨{⍉⍪2 0⍕⍵}¨⍺),' ',⊃⍪/⍵}
listx listy←numx numy List¨wrapx wrapy
Text←{
    dir pos←⍵
    words←Word¨((⊢,~)dir),¨⊂⊂pos
    Arrow←{∊(≢¨⍵)↑¨'>- '[⍺⍳¨⍨⊂words]}
    arrowx arrowy←iwordx iwordy Arrow¨wrapx wrapy
    (arrowx,listx)(arrowy,listy)
}

Puzzle←{
    grid←Grid⍵
    text←'Across' 'Down'{⍵⍪⍨⍺↑⍨≢⍉⍵}¨Text¯1↓⍵
    height←⌈/≢¨(⊂grid),text
    ⊃,/height↑¨(⊂grid),' ',¨text
}

stdin ←'/dev/stdin' ⎕NTIE 0
stdout←'/dev/stdout'⎕NTIE 0
Read ←{⎕UCS⊃1stdin⎕ARBIN⍬}
Write←{stdout⎕ARBOUT'UTF-8'⎕UCS⍵}

mode←0 ⍝ normal insert
dir ←0 ⍝ across down
pos←⊃points
ans←''⍴⍨⍴sol

:Repeat
    puzzle←Puzzle dir pos ans
    out ←esc,'[2J'   ⍝ clear screen
    out,←esc,'[1;1H' ⍝ move cursor to top left
    out,←,lf,⍨cr,⍨puzzle
    y x←⍕¨2 3+2 4×pos
    out,←esc,'[',y,';',x,'H' ⍝ move cursor to pos
    Write out
    char←Read⍬
    :If mode=0
        :Select char
        :Case ' ' ⋄ dir←~dir
        :Case 'h' ⋄ pos←H pos
        :Case 'j' ⋄ pos←J pos
        :Case 'k' ⋄ pos←K pos
        :Case 'l' ⋄ pos←L pos
        :Case 'g'
            :Select Read⍬
            :Case 'g' ⋄ pos←GG pos
            :Case 'e' ⋄ dir pos←GE dir pos
            :EndSelect
        :Case 'G' ⋄ pos←G      pos
        :Case '0' ⋄ pos←Zero   pos
        :Case '$' ⋄ pos←Dollar pos
        :Case 'w' ⋄ dir pos←W dir pos
        :Case 'e' ⋄ dir pos←E dir pos
        :Case 'b' ⋄ dir pos←B dir pos
        :Case 'i'
            mode←1
            Write esc,'[5 q' ⍝ ibeam cursor
        :Case 'x' ⋄ (pos⌷ans)←' '
        :EndSelect
    :Else
        :Select char
        :CaseList ⎕C⎕A
            (pos⌷ans)←1⎕C char
            dir pos←Point Next Square dir pos
        :Case esc
            mode←0
            Write esc,'[0 q' ⍝ block cursor
        :EndSelect
    :EndIf
:EndRepeat
