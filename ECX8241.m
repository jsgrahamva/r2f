ECX8241 ; COMPILED XREF FOR FILE #727.824 ; 01/26/16
 ; 
 S DIKZK=2
 S DIKZ(0)=$G(^ECX(727.824,DA,0))
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" K ^ECX(727.824,"AC",$E(X,1,30),DA)
END Q
