RMPRPAT7	;HINES-CIOFO/HNC DISPLAY NPPD KEY ITEMS CONSOLIDATED
	;;3.0;PROSTHETICS;**32,34,35,77,162**;Feb 14, 1998;Build 5
	;;
	;RVD 3/18/03 patch #77 - only prints item for the same pt.
	N HCHCPS,HCHCPSD
	W !,?5,"PSAS HCPCS",?18,"DESCRIPTION",?48,"QTY",?52,"COST",?62,"ITEM"
	W !,RMPR("L") S HCTOT=0
	S HCREC=$P(IT(AN),U,1) Q:HCREC'>0
	S HC=$G(R19(660,HCREC,68,"E")) Q:HC=""
	S HC1=0
	F  S HC1=$O(^TMP($J,"TTT",HC,HCREC,HC1)) Q:HC1'>0  D
	.Q:$P($G(^RMPR(660,HC1,0)),U,10)'=RMPR("STA")  ;QUIT if different station;RMPR*3.0*162
	.S (HCHCPS,HCHCPSD)=""
	.I $P(^RMPR(660,HC1,0),U,2)'=RMPRDFN Q
	.S HCQTY=$P(^RMPR(660,HC1,0),U,7)
	.S HCCOST=$P(^RMPR(660,HC1,0),U,16)
	.S HCTOT=HCTOT+HCCOST
	.S HCRK=$P(^RMPR(660,HC1,0),U,6)
	.I HCRK S HCRK=$P(^RMPR(661,HCRK,0),U,1),HCRK=$P(^PRC(441,HCRK,0),U,2)
	.S HCHCP=$P($G(^RMPR(660,HC1,1)),U,4)
	.I HCHCP S HCHCPS=$P(^RMPR(661.1,HCHCP,0),U,1),HCHCPSD=$P(^(0),U,2)
	.I $P(^RMPR(660,HC1,0),U,17) S HCHCPSD="SHIPPING"  ;modify descrip to shipping charge;RMPR*3.0*162
	.W !,?5,$G(HCHCPS),?18,$G(HCHCPSD)
	.W ?48,HCQTY
	.W ?52,"$"_$J($FN(HCCOST,"P",2),9)
	.W ?62,$E(HCRK,1,18)
	W !,?52,"========="
	W !,?52,"$"_$J($FN(HCTOT,"P",2),9)
	;END