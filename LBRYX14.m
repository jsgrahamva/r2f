LBRYX14 ; COMPILED XREF FOR FILE #680 ; 09/19/10
 ; 
 S DIKZK=1
 S DIKZ(0)=$G(^LBRY(680,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^LBRY(680,"B",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,1)
 I X'="" D NTIT^LBRYEDI
 S X=$P(DIKZ(0),U,2)
 I X'="" I $G(LBRYCLS)'="",$D(^LBRY(680.5,LBRYCLS,0)) S $P(^LBRY(680.5,LBRYCLS,0),U,2)=2
 S X=$P(DIKZ(0),U,4)
 I X'="" S ^LBRY(680,"E",$E(X,1,30),DA)=""
END G ^LBRYX15
