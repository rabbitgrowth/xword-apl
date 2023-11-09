⎕IO←0

puzzle←⍉⍪' RACED '
puzzle⍪← 'BELARUS'
puzzle⍪← 'LABTECH'
puzzle⍪← 'ALE CHE'
puzzle⍪← 'KIRSTIE'
puzzle⍪← 'ESTREET'
puzzle⍪← ' MAIDS '

white←' '≠puzzle
headx← 2</0, white
heady←⍉2</0,⍉white
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
