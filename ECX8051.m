ECX8051 ; COMPILED XREF FOR FILE #727.805 ; 03/10/12
 ; 
 S DIKZK=2
 S DIKZ(0)=$G(^ECX(727.805,DA,0))
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" K ^ECX(727.805,"AC",$E(X,1,30),DA)
END Q
