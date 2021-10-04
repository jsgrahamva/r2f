C0CRXN22 ; COMPILED XREF FOR FILE #176.002 ; 08/23/15
 ; 
 S DIKZK=1
 S DIKZ(0)=$G(^C0CRXN(176.002,DA,0))
 S X=$P($G(DIKZ(0)),U,1)
 I X'="" S ^C0CRXN(176.002,"XATN",$E(X,1,30),DA)=""
 S X=$P($G(DIKZ(0)),U,11)
 I X'="" S ^C0CRXN(176.002,"XATV",$E(X,1,30),DA)=""
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" S ^C0CRXN(176.002,"NDC",$E(X,1,30),DA)=""
CR1 S DIXR=737
 K X
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,3)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . S ^C0CRXN(176.002,"COMB",X(1),X(2),DA)=""
CR2 S DIXR=1122
 K X
 S DIKZ(0)=$G(^C0CRXN(176.002,DA,0))
 S X(1)=$P(DIKZ(0),U,9)
 S X(2)=$P(DIKZ(0),U,10)
 S X(3)=$P(DIKZ(0),U,1)
 S X(4)=$P(DIKZ(0),U,11)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(3))]"",$G(X(4))]"" D
 . K X1,X2 M X1=X,X2=X
 . N DIKXARR M DIKXARR=X S DIKCOND=1
 . S X=X(2)="NDFRT"
 . S DIKCOND=$G(X) K X M X=DIKXARR
 . Q:'DIKCOND
 . S ^C0CRXN(176.002,"ANDFRT",X(1),$E(X(3),1,30),$E(X(4),1,30),DA)=""
CR3 S DIXR=1123
 K X
 S DIKZ(0)=$G(^C0CRXN(176.002,DA,0))
 S X(1)=$P(DIKZ(0),U,10)
 S X(2)=$P(DIKZ(0),U,1)
 S X(3)=$P(DIKZ(0),U,11)
 S X(4)=$P(DIKZ(0),U,9)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"",$G(X(3))]"" D
 . K X1,X2 M X1=X,X2=X
 . S ^C0CRXN(176.002,"ASAA",X(1),$E(X(2),1,30),$E(X(3),1,30),DA)=X(4)
CR4 S DIXR=1124
 K X
 S DIKZ(0)=$G(^C0CRXN(176.002,DA,0))
 S X(1)=$P(DIKZ(0),U,10)
 S X(2)=$P(DIKZ(0),U,1)
 S X(3)=$P(DIKZ(0),U,9)
 S X(4)=$P(DIKZ(0),U,11)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"",$G(X(3))]"" D
 . K X1,X2 M X1=X,X2=X
 . S ^C0CRXN(176.002,"ASAR",X(1),$E(X(2),1,30),X(3),DA)=X(4)
CR5 S DIXR=1125
 K X
 S DIKZ(0)=$G(^C0CRXN(176.002,DA,0))
 S X(1)=$P(DIKZ(0),U,9)
 S X=$G(X(1))
 I $G(X(1))]"" D
 . K X1,X2 M X1=X,X2=X
 . S ^C0CRXN(176.002,"RXCUI",X,DA)=""
CR6 K X
END Q
