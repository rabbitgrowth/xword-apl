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

Square←{dir pos←⍵ ⋄ pos⌷dir⊃squarex squarey}
Nav←{(≢point)|⍺+⍵}
Next← 1∘Nav
Prev←¯1∘Nav
Point←{(⍵≥nwhite)(⍵⊃point)}

∆ dir pos≡Point      Square dir pos
∆ 0(0 2) ≡Point Next Square dir pos
∆ 1(6 3) ≡Point Prev Square dir pos

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
