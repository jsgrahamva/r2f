LRPHSET2	;DALOI/STAFF - COLLECTION LIST TO ACCESSIONS CONT ;12/13/12  12:13
	;;5.2;LAB SERVICE;**121,202,350,427**;Sep 27, 1994;Build 33
	;
REUP	;FROM LRPHSET1 - ADD TO OR REBUILD TO COLLECTION LIST
	N LRORDTYP
	S $P(LRORDTYP,"^",2)=$$FIND1^DIC(64.061,"","OX","L","D","I $P(^(0),U,5)=""0065""")
	S LRDPF=$P(^LR(LRDFN,0),U,2),DFN=$P(^(0),U,3)
	S LRRB=0
	I LRDPF=2 S LRRB=$$GET1^DIQ(2,DFN_",",.101),LRRB=$S(LRRB'="":LRRB,1:0)
	;
	S I=0
	F  S I=$O(^LRO(69,DT,1,LRSN,2,I)) Q:I<1  S X=^(I,0) I $P(X,U,3)'="" S LRAA($P(X,U,4))=$P(X,U,3)_"^"_$P(X,U,4)_"^"_$P(X,U,5)
	;
	S LRK=0
	F  S LRK=$O(^LRO(69,DT,1,LRSN,2,LRK)) Q:LRK<1  S X=^(LRK,0) I $P(X,U,3)="",'$P(X,"^",11) D
	. S LRTS=+X,LRAA=$S($D(^LAB(60,LRTS,8,DUZ(2),0)):$P(^(0),U,2),1:"")
	. I LRAA'="",$D(LRAA(LRAA)),$P(^LAB(60,LRTS,0),U,7)'=1 D JAM
	;
	S LRI=0
	F  S LRI=$O(^LRO(69,DT,1,LRSN,2,LRI)) Q:LRI<1  S X=^(LRI,0) I '$P(X,U,6),$P(X,U,3) D
	. S LRTSTN=+X,LRAD=$P(X,U,3),LRAA=$P(X,U,4),LRAN=$P(X,U,5)
	. I '$D(^LRO(69.1,"LRPH",LRTE,LRLLOC,LRRB,LRDFN,LRSN,LRAA,LRAN,+LRTSTN)) D REUP1
	I $D(REUP) S LRCOUNT=LRCOUNT+1,^LRO(69,DT,1,LRSN,3)=LRDTI
	I '$D(REUP) S $P(^LRO(69,DT,1,LRSN,1),U)=$P(^LRO(69,DT,1,LRSN,3),U)
	K LRAD,LRI,LRAN,LRAA,LRDPF,DFN,LRZ3,LRZB,LRZ1,LRTSTN,LRRB,LRURG,REUP,I,J,LRK,F,LRAODT,LRWRD
	Q
	;
REUP1	L +^LRO(69.1,LRTE):90 I '$T G REUP1
	S LRZ3=$S($D(^LRO(69.1,LRTE,1,0)):$P(^(0),U,3),1:0)
	I '$D(^LRO(69.1,"LRPH",LRTE,LRLLOC,LRRB,LRDFN,LRSN,LRAA,LRAN)) S REUP=1
	;
REUP2	S LRZ3=LRZ3+1
	G:$D(^LRO(69.1,LRTE,1,LRZ3)) REUP2
	S LRZO="^LRO(69.1,"_LRTE_",1,",LRZ1="69.11P",LRZB=+LRTSTN,LRIFN=LRZ3
	D Z^LRWU
	L -^LRO(69.1,LRTE)
	S ^LRO(69.1,LRTE,1,LRIFN,0)=+LRTSTN_"^"_LRLLOC_"^"_LRRB_"^"_LRDFN_"^"_LRSN_"^"_LRTJ_"^"_LRAD_"^"_LRAA_"^"_LRAN_"^"_LROLLOC,^LRO(69.1,"LRPH",LRTE,LRLLOC,LRRB,LRDFN,LRSN)=LRTJ_"^"_LRAD_"^"_LRIFN,^(LRSN,LRAA,LRAN,+LRTSTN)=+LRTSTN
	Q
	;
JAM	;
	S LRAA=$P(LRAA(LRAA),U,2),LRAD=$P(LRAA(LRAA),U),LRAODT=LRAD,LRAN=$P(LRAA(LRAA),U,3),(LRURG,Y)=$P(X,U,2)
	D EN^LRTSTSET
	Q
	;
S7	;FROM LRPHSET1 - COMBINE OR MERGE TESTS ON ORDERS
	S T=0 F  S T=$O(T(LRSAMP,T)) Q:T<1  D S7A
	Q
S7A	S LRPSN=0 F  S LRPSN=$O(T(LRSAMP,T,LRPSN)) Q:LRPSN<1  D @$S(LRSTEP=0:"S8",1:"S9")
	Q
S8	S J=T
	D COMBINE
	S J=0 F  S J=$O(T(LRSAMP,J)) Q:J<1  D SCAN60
	Q
S9	S J=0 F  S J=$O(T(LRSAMP,J)) Q:J<1  D MERG
	Q
SCAN60	S K=0 F  S K=$O(^LAB(60,T,2,K)) Q:K<1  I +^(K,0)=J S LRSN=0,LRSN=$O(T(LRSAMP,J,LRSN)) D @$S(LRPSN>LRSN:"MERG",1:"COMBINE")
	Q
COMBINE	S LRSN=0 F  S LRSN=$O(T(LRSAMP,J,LRSN)) Q:LRSN<1  D:LRPSN>LRSN SWAP I LRSN'=LRPSN D CB2
	Q
CB2	I $P(^LRO(69,DT,1,LRSN,2,+T(LRSAMP,J,LRSN),0),U,6)'="",$D(^LRO(69,DT,1,LRSN,.1)),$D(^LRO(69,DT,1,+$O(^LRO(69,"C",+^(.1),DT,0)),1)),$P(^(1),U,4)'="" Q
	I $P(T(LRSAMP,T,LRPSN),U,2)'=$P(T(LRSAMP,J,LRSN),U,2) D URGENCY S $P(^LRO(69,DT,1,LRPSN,2,+T(LRSAMP,T,LRPSN),0),U,2)=LRURG
	S $P(^LRO(69,DT,1,LRPSN,2,+T(LRSAMP,T,LRPSN),0),"^",14)=DT_";"_LRSN_";"_+T(LRSAMP,J,LRSN)
	N X,XI,X1,I,TST
	S X1=^LRO(69,DT,1,LRPSN,.1),TST=^LRO(69,DT,1,LRSN,2,+T(LRSAMP,J,LRSN),0),$P(^(0),U,6)=X1,$P(^LRO(69,DT,1,LRSN,1),U,4)="M",XI=$P(^(1),U,7),XI=XI_X1_"/",$P(^(1),U,7)=XI
	D OERR(TST)
	K T(LRSAMP,J,LRSN)
	Q
	;
MERG	S LRSN=0 F  S LRSN=$O(T(LRSAMP,J,LRSN)) Q:LRSN<1  D:LRPSN>LRSN SWAP,SWAP1 I LRSN'=LRPSN D M1
	Q
	;
M1	Q:$P(^LRO(69,DT,1,LRSN,2,+T(LRSAMP,J,LRSN),0),U,6)'=""
	S X=$P(^LRO(69,DT,1,LRPSN,2,0),"^",3)
LP	S X=X+1
	I $D(^LRO(69,DT,1,LRPSN,2,X)) G LP
	S ^LRO(69,DT,1,LRPSN,2,X,0)=^LRO(69,DT,1,LRSN,2,+T(LRSAMP,J,LRSN),0),$P(^(0),"^",14)=DT_";"_LRSN_";"_+T(LRSAMP,J,LRSN),^LRO(69,DT,1,LRPSN,2,"B",J,X)="",$P(^LRO(69,DT,1,LRPSN,2,0),"^",3,4)=X_"^"_X
	N I,XI,X1,TST
	S X1=^LRO(69,DT,1,LRPSN,.1),$P(^LRO(69,DT,1,LRSN,2,+T(LRSAMP,J,LRSN),0),"^",6)=X1
	S TST=^LRO(69,DT,1,LRPSN,2,X,0),LRURG=$P(TST,"^",2),T(LRSAMP,J,LRPSN)=T(LRSAMP,J,LRSN),$P(T(LRSAMP,J,LRPSN),"^")=X
	S $P(^LRO(69,DT,1,LRSN,1),U,4)="M",XI=$P(^(1),U,7),XI=XI_X1_"/",$P(^LRO(69,DT,1,LRSN,1),U,7)=XI
	D OERR(TST)
	K T(LRSAMP,J,LRSN)
	Q
	;
SWAP	S LRSWAP=LRSN,LRSN=LRPSN,LRPSN=LRSWAP K LRSWAP
	Q
	;
SWAP1	S LRSWAP=J,J=T,T=LRSWAP
	Q
	;
URGENCY	S LRURG1=$P(T(LRSAMP,T,LRPSN),U,2),LRURG2=$P(T(LRSAMP,J,LRSN),U,2),LRURG=$S(LRURG1<LRURG2:LRURG1,1:LRURG2)
	K LRURG1,LRURG2
	Q
	;
OERR(TSTNODE)	;OE/RR - CPRS calls
	N X,TTT,LRNATURE,LRSJ ;OE/RR 3.0
	S LRSJ=J,X=$O(^ORD(100.03,"C","LRDUP",0)),LRNATURE=$$DC1^LROR6(X,"Combined with LB #"_X1)
	S TTT(+TSTNODE)="",DIE="^LRO(69,DT,1,LRSN,2,",DA=+T(LRSAMP,LRSJ,LRSN),DA(1)=LRSN,DA(2)=DT,DR="99.1///DUPLICATE TEST: "_$S($P($G(LRNATURE),"^",5)'="":$P(LRNATURE,"^",5),1:"")
	D ^DIE
	D NEW^LR7OB1(DT,LRSN,"OC",$G(LRNATURE),.TTT)
	S $P(^LRO(69,DT,1,LRSN,2,+T(LRSAMP,LRSJ,LRSN),0),"^",3,5)="^^",$P(^(0),"^",9,11)="CA^L^"_DUZ,J=LRSJ
	Q
