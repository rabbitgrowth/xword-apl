⎕IO←0

nul lf cr esc←⎕UCS 0 10 13 27

argv←2⎕NQ#'GetCommandLineArgs'
file←1⊃argv
tie←file⎕NTIE 0
data←256|⎕NREAD tie 83 ¯1
⎕NUNTIE tie
shape ←2,  data[44+⍳2]
nclues←16⊥⌽data[46+⍳2]
bound←×/shape
body←⎕UCS 52↓data
sol ans←⊂⍤2⊢shape⍴' '@(∊∘'.-')bound↑body
strings←(¯1↓¨⊢⊂⍨¯1⌽nul∘=)     bound↓body
cluestr←¯1↓3↓strings

dirs←⍳2
Count←⊢×⍴⍴+\⍤,
white←' '≠sol
nblack nwhite←+/0 1∘.=,white
heads←{2</[⍵]0,[⍵]white}¨dirs
nwords←+/⍤,¨heads
nos←Count⊃∨/heads
listnos←heads/⍥,¨⊂nos
listids←(1⊃nwords)0+⍳¨nwords
wordids←dirs{¯1+white×⌈\[⍺]⍵}¨⊂⍤2⊖Count⊖↑heads
charidy←¯1+white×1+nwhite+nblack-⍨(⍴⍴⍋⍤⍋⍤,)⊃wordids
charidx←¯1+Count white
charids←charidy charidx
words←⊃,/⌽listids(⍸¨=∘⊂)¨wordids
chars←⊃,/words

sorted←{⍵[⍋⍵]}∊listnos
icluex←sorted⍳1⊃listnos
icluey←icluex~⍨⍳≢sorted
clues←{cluestr[⍵]}¨icluey icluex

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

CharID←{dir pos←⍵ ⋄ pos⌷dir⊃charids}
Nav←(≢chars)|+
Next← 1∘Nav
Prev←¯1∘Nav
Char←<∘nwhite,⌷∘chars

w ←∊(⌽1+⍳⍤≢)¨words
ge←∊(-1+⍳⍤≢)¨words
e ← 1⌽w
b ←¯1⌽ge
Jump←{Char(⊃∘⍺Nav⊢)CharID⍵}
W ←w ∘Jump
GE←ge∘Jump
E ←e ∘Jump
B ←b ∘Jump

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

Wrap←{
    ⍺≥⍴⍵:⍉⍪⍺↑⍵
    take←⊃⌽⍺,⍸' '=(⍺+1)↑⍵
    drop←take+' '=take⊃⍵
    (⍉⍪⍺↑take↑⍵)⍪⍺∇drop↓⍵
}

boxes←25 Wrap¨¨clues
heights←≢¨¨boxes
lists←{(⊃⍪/(⍵⊃heights)↑∘(⍉⍤⍪¯2↑⍕)¨⍵⊃listnos),' ',⊃⍪/⍵⊃boxes}¨dirs
padded←¯1+heights(∊↑¨)¨1+listids

stdin ←'/dev/stdin' ⎕NTIE 0
stdout←'/dev/stdout'⎕NTIE 0
Read ←{⎕UCS⊃1stdin⎕ARBIN⍬}
Write←{stdout⎕ARBOUT'UTF-8'⎕UCS⍵}

Cursor←{y x←⍕¨1+⍵ ⋄ esc,'[',y,';',x,'H'}
clear    ←esc,'[2J'
block    ←esc,'[0 q'
ibeam    ←esc,'[5 q'
underline←esc,'[3 q'

mode←0 ⍝ normal insert
dir ←1 ⍝ down   across
pos←⊃chars

Render←{
    shape←⍴light←Light⍴ans ⍝ can technically be precomputed
    word←words⊃⍨pos⌷dir⊃wordids
    dy dx←-⊃word
    heavy←dy⊖dx⌽shape↑Heavy dir⌽1,⍨≢word
    vertex←(light,¨heavy)⌷¨⊂box
    edgex←heavy{3↑(3⍴'─━'⊃⍨2|⍺),⍨(0∘=↓⍕)⍵}¨shape↑nos
    edgey←'│┃'[heavy∊1 2 6]
    face←shape↑white{~⍺:3⍴'░' ⋄ ' '⍵' '}¨ans
    grid←¯1 ¯3↓⊃⍪⌿,/(vertex,¨edgex),[¯0.5]¨edgey,¨face
    arrows←{(' ','->'⊃⍨dir=⍵)[(pos⌷⍵⊃wordids)=⍵⊃padded]}¨dirs
    text←'Across' 'Down'{⍵⍪⍨⍺↑⍨≢⍉⍵}¨⌽,⌿↑arrows lists
    height←⌈/≢¨(⊂grid),text
    ⊃,/height↑¨(⊂grid),' ',¨text
}

Set←{⍵∊' ',⎕C⎕A:(pos⌷ans)⊢←1⎕C⍵}

:Repeat
    out ←clear
    out,←Cursor 0 0
    out,←,lf,⍨cr,⍨Render⍬
    out,←Cursor 1 2+2 4×pos
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
            Write ibeam
        :Case 'r'
            Write underline
            Set Read⍬
            Write block
        :Case 'x' ⋄ Set ' '
        :EndSelect
    :Else
        :Select char
        :Case esc
            mode←0
            Write block
        :Else
            Set char
            dir pos←Char Next CharID dir pos
        :EndSelect
    :EndIf
:EndRepeat
