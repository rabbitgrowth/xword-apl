⎕IO←0

nul lf cr esc←⎕UCS 0 10 13 27

⍝ ISO-8859-1
cp ←⎕UCS⍳128
cp,←32⍴''              ⍝ undefined
cp,←' ¡¢£¤¥¦§¨©ª«¬-®¯' ⍝ nbsp→space shy→hyphen
cp,←'°±²³´µ¶·¸¹º»¼½¾¿'
cp,←'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏ'
cp,←'ÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß'
cp,←'àáâãäåæçèéêëìíîï'
cp,←'ðñòóôõö÷øùúûüýþÿ'
Decode←{cp[256|⍵]}

argv←2⎕NQ#'GetCommandLineArgs'
file←1⊃argv
tie←file⎕NTIE 0
data←⎕NREAD tie 83 ¯1
shape ←2,  data[44+⍳2]
nclues←16⊥⌽data[46+⍳2]
bound←×/shape
sol ans←⊂⍤2⊢shape⍴' '@(∊∘'.-')Decode data[52+⍳bound]
strings←{¯1↓¨⍵⊂⍨¯1⌽nul=⍵}     Decode data↓⍨52+bound
clues←¯1↓3↓strings
⎕NUNTIE tie

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
groups←⊃,/{k v←↓⍉⍵,⍥⊂⌸⍥,⍳⍴⍵ ⋄ v/⍨k≥0}¨wordx wordy
squarex←¯1+Count white
squarey←¯1+white×1+nwhite+nblack-⍨{(⍴⍵)⍴⍋⍋,⍵}wordy
points←(⍸white),{nblack↓(,⍳⍴⍵)[⍋,⍵]}squarey

nums←{⍵[⍋⍵]}numx,numy
icluex←nums⍳numx
icluey←icluex~⍨⍳≢nums
cluex←clues[icluex]
cluey←clues[icluey]

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

Cursor←{y x←⍕¨1+⍵ ⋄ esc,'[',y,';',x,'H'}
clear    ←esc,'[2J'
block    ←esc,'[0 q'
ibeam    ←esc,'[5 q'
underline←esc,'[3 q'

mode←0 ⍝ normal insert
dir ←0 ⍝ across down
pos←⊃points

Set←{⍵∊' ',⎕C⎕A:(pos⌷ans)⊢←1⎕C⍵}

:Repeat
    out ←clear
    out,←Cursor 0 0
    out,←,lf,⍨cr,⍨Puzzle dir pos ans
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
            dir pos←Point Next Square dir pos
        :EndSelect
    :EndIf
:EndRepeat
