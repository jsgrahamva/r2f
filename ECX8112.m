ECX8112 ; COMPILED XREF FOR FILE #727.811 ; 01/26/16
 ; 
 S DIKZK=1
 S DIKZ(0)=$G(^ECX(727.811,DA,0))
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" S ^ECX(727.811,"AC",$E(X,1,30),DA)=""
END Q
