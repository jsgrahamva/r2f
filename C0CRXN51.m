C0CRXN51 ; COMPILED XREF FOR FILE #176.005 ; 08/23/15
 ; 
 S DIKZK=2
CR1 S DIXR=1126
 K X
 S DIKZ(0)=$G(^C0CRXN(176.005,DA,0))
 S X(1)=$P(DIKZ(0),U,11)
 S X(2)=$P(DIKZ(0),U,8)
 S X(3)=$P(DIKZ(0),U,5)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"",$G(X(3))]"" D
 . K X1,X2 M X1=X,X2=X
 . S:$D(DIKIL) (X2,X2(1),X2(2),X2(3))=""
 . K ^C0CRXN(176.005,"B",X(1),X(2),X(3),DA)
CR2 K X
END Q
