PRSATE1	; HISC/REL-Display Tour Change ;5/5/93  10:40
	;;4.0;PAID;**115,132**;Sep 21, 1995;Build 13
	;;Per VHA Directive 2004-038, this routine should not be modified.
LST	; Display Change
	N PRSDAYN,X,X1,X2,PRSD1,PRSD2,PRSDNP1,PRSDNP2,PRSDW,PRSNXT,PRSWREC
	W !?34,"Tour Change",!,"    Date",?14,"TW",?18,"Scheduled Tour",?45,"TW",?49,"Permanent Tour",?75,"Type"
	S PRSD1=$G(^PRST(458,PPI,1)),PRSD2=$G(^PRST(458,PPI,2))
	S PRSDNP1=$G(^PRST(458,PPI+1,1)),PRSDNP2=$G(^PRST(458,PPI+1,2))
	S PRSNXT=0
	F DAY=0:0 S DAY=$O(^PRST(458,"ATC",DFN,PPI,DAY)) Q:DAY=""!PRSNXT  D
	. I $P($G(^PRST(458,PPI,"E",DFN,"D",DAY,0)),U,3)=2 S PRSNXT=1
	. Q
	F DAY=0:0 S DAY=$O(^PRST(458,"ATC",DFN,PPI,DAY)) Q:DAY=""  D L1
	Q
L1	N PRSTW,PRSTD2,PRSTD4
	S PRSWREC=$G(^PRST(458,PPI,"E",DFN,"D",DAY,0)),TD=$P(PRSWREC,U,2),PRSTW=$G(^(8))
	S PRSDW=$P(PRSD2,U,DAY)
	I PRSNXT  D
	. I $P(PRSDNP1,U,DAY) S PRSDW=$P(PRSDNP2,U,DAY) Q
	. S PRSDW=$P(PRSD1,U,DAY),X1=PRSDW,X2=14 D C^%DTC S PRSDW=X
	. D DW^%DTC S PRSDAYN=X S X=PRSDW D DTP^PRSAPPU
	. S PRSDW=$E(PRSDAYN,1,3)_" "_Y
	. QUIT
	S PRSTD2=$P($G(^PRST(457.1,+TD,0)),U),X=$L(PRSTD2)
	S TD=$P(PRSWREC,U,4),PRSTD4=$P($G(^PRST(457.1,+TD,0)),U),Y=$L(PRSTD4)
	W !,PRSDW,?14,$P(PRSTW,U),?18,$S(X<26:PRSTD2,1:$P(PRSTD2," "))
	W ?45,$P(PRSTW,U,5),?49,$S(Y<26:PRSTD4,1:$P(PRSTD4," "))
	S TYP=$P(PRSWREC,U,3) W ?75,$S(TYP:"Temp",1:"Perm")
	I X>25!(Y>25) W ! W:X>25 ?18,$P(PRSTD2," ",2,999) W:Y>25 ?49,$P(PRSTD4," ",2,999)
	S TD=$P(PRSWREC,U,13) Q:'TD  W !?18,$P($G(^PRST(457.1,+TD,0)),U,1),?75,"Temp" Q
