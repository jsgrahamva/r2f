LRMIEDZ4	;DALOI/FHS/RBN - CONTINUE MICROBIOLOGY EDIT ;11/18/11  16:04
	;;5.2;LAB SERVICE;**350**;Sep 27, 1994;Build 230
	;
	; Formerly a part of LRMIEDZ2
	;
EC	;
	;
	K LRTX
	;
	S LRAN=$P($P(LRBG0,U,6)," ",3),LRLLOC=$P(LRBG0,U,8),LRODT=$P(^LRO(68,LRAA,1,LRAD,1,LRAN,0),U,4),LRSN=$P(^(0),U,5)
	I $D(^LRO(69,+LRODT,1,+LRSN,0)) D
	. S DIC="^LRO(69,"_LRODT_",1,",DA=LRSN,DR=6
	. I DA>0 D EN^DIQ
	;
	I $D(DTOUT)!($D(DUOUT)) S LREND=1 Q
	;
	K LRNPTP
	;
	S (LRI,N)=0
	F  S LRI=+$O(^LRO(68,LRAA,1,LRAD,1,+LRAN,4,LRI)) Q:LRI<.5  D
	. I $P(^LRO(68,LRAA,1,LRAD,1,+LRAN,4,LRI,0),U,2)>49 Q
	. S N=N+1,LRTS(N)=+^LRO(68,LRAA,1,LRAD,1,+LRAN,4,LRI,0)
	. S LRTX(N)=$S($P(^LAB(60,LRTS(N),0),U,14):^LAB(62.07,$P(^(0),U,14),.1),1:"")
	. I LRTS(N)=LRPTP S LRNPTP=N Q
	;
	I '$D(LRNPTP),LRPTP>0 W !,"Nothing matches with the test you preselected." Q
	I $D(LRNPTP) S LRI=LRNPTP
	;
	I '$D(LRNPTP),N>0 F J=1:1:N D
	. W !,?3,J,?8,$P(^LAB(60,LRTS(J),0),U)
	. S Y=$P(^LRO(68,LRAA,1,LRAD,1,+LRAN,4,LRTS(J),0),U,5)
	. I Y>0 W " Completed ",$$FMTE^XLFDT(Y,"1M")
	W !
	;
	Q