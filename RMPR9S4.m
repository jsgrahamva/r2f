RMPR9S4	;HOIFO/HNC - GUI 2319 ITEM TRANSACTIONS LIST ;9/10/02  08:42
	;;3.0;PROSTHETICS;**59,99,90,75,162**;Feb 09, 1996;Build 5
	;IEN = INTERNAL ENTRY NUMBER OF FILE 668
	Q
A1(IEN)	G A2
EN(RESULTS,IEN)	;broker
A2	S (RA,AN,ANS,RK,RZ)=0 K ^TMP($J,"TT"),^TMP($J,"AG"),IT
	K ^TMP($J,"RMPRB")
	K ^TMP($J,"RMPRC"),RMPRLPRO
	;IT IS RESULTS
	;0;2 DFN in 668
	S RMPRDFN=$P($G(^RMPR(668,IEN,0)),U,2)
	I RMPRDFN="" S ^TMP($J,"RMPRB",1)="PATIENT NOT KNOWN" Q
	MERGE ^TMP($J,"TT")=^RMPR(660,"AC",RMPRDFN)
	S B=0
	F  S B=$O(^TMP($J,"TT",B)) Q:B'>0  D
	. S BC=0
	. F  S BC=$O(^TMP($J,"TT",B,BC)) Q:BC'>0  D
	. .;Q:$P($G(^RMPR(660,BC,0)),U,10)'=RMPR("STA")
	. .S GN=$P($G(^RMPR(660,BC,"AMS")),U,1)
	. .S ND=$P($G(^RMPR(660,BC,1)),U,4)
	. .I ND S ND=$P(^RMPR(661.1,ND,0),U,8)
	. .S:ND="" ND=2
	. .S:GN="" GN=BC
	. .S ^TMP($J,"AG",GN,BC,ND)=B  ;set linked grouper counter structure differently in array;RMPR*3.0*162
	;COMBINE ITEMS FOR CALC FLAG
	;modified linked grouper structure determination in patch RMPR*3.0*162
	S B=""
	F  S B=$O(^TMP($J,"AG",B)),ITM=0,HITM=0 Q:B=""!(B]"@")  D
	.F  S ITM=$O(^TMP($J,"AG",B,ITM)),BC=0 Q:+ITM=0  D
	. .F  S BC=$O(^TMP($J,"AG",B,ITM,BC)) Q:+BC=0  D
	. . .I $P($G(^RMPR(660,ITM,0)),U,17) Q
	. . .I HITM=0,BC=2 Q
	. . .I BC=1 S HITM=ITM,BDAT=^TMP($J,"AG",B,ITM,BC)
	. . .S $P(^TMP($J,"TT",BDAT,HITM),U,3)=$P(^TMP($J,"TT",BDAT,HITM),U,3)+$P($G(^RMPR(660,ITM,0)),U,16)
	. . .I BC=2 K ^TMP($J,"TT",BDAT,ITM)
	K ^TMP($J,"AG"),BDC
	S B=0,RC=1
	F  S B=$O(^TMP($J,"TT",B)) Q:B'>0  D
	.S RK=0
	.F  S RK=$O(^TMP($J,"TT",B,RK)) Q:RK'>0  D
	. .Q:$D(^RMPO(665.72,"AC",RK))
	. .S ^TMP($J,"RMPRC",RC)=RK
	. .I $P(^TMP($J,"TT",B,RK),U,3) S $P(^TMP($J,"RMPRC",RC),U,3)=$P(^TMP($J,"TT",B,RK),U,3)
	. .S RC=RC+1
	S RK=0,RZ=0
	K ^TMP($J,"TT"),B
	;
	G:'$D(^TMP($J,"RMPRC")) END
	;
DIS	;format data string - ALL
	S RC=""
	S RK=0
	F  S RK=$O(^TMP($J,"RMPRC",RK)) Q:RK=""  D
	.S AN=+^TMP($J,"RMPRC",RK)
	.S RMPRY=$G(^RMPR(660,AN,0))
	.I RMPRY'="" D PRT
	.Q
	;
	;
END	I RC=0 S ^TMP($J,"RMPRB",1)="NOTHING TO REPORT" G EXIT
	;
	;
EXIT	;common exit point
	;pass to broker
	K ^TMP($J,"RMPRC")
	;S RESULT=$NA(^TMP($J))
	M RESULTS=^TMP($J,"RMPRB")
	I '$D(RESULTS) S RESULTS(0)="NOTHING TO REPORT"
	K I,J,L,R0,RA,AMIS,AN,ANS,CST,FRM,RC,RK,RMPRDFN,RMPRNC,RZ,STA,TRANS,TRANS,TYPE,BDAT,HITM,ITM,TRANS1
	Q
PRT	;
	S DATE=$P(RMPRY,U,3),TYPE=$P(RMPRY,U,6),QTY=$P(RMPRY,U,7)
	S VEN=$P(RMPRY,U,9),TRANS=$P(RMPRY,U,4),STA=$P(RMPRY,U,10),SN=$P(RMPRY,U,11)
	S DEL=$P(RMPRY,U,12)
	S CST=$S($P(RMPRY,U,16)'="":$P(RMPRY,U,16),$D(^RMPR(660,AN,"LB")):$P(^RMPR(660,AN,"LB"),U,9),1:"")
	;lab source of procurement
	I $D(^RMPR(660,AN,"LB")) S RMPRLPRO=$P(^("LB"),U,3) D
	.I RMPRLPRO="O" S RMPRLPRO="ORTHOTIC" Q
	.I RMPRLPRO="R" S RMPRLPRO="RESTORATION" Q
	.I RMPRLPRO="S" S RMPRLPRO="SHOE" Q
	.I RMPRLPRO="W" S RMPRLPRO="WHEELCHAIR" Q
	.I RMPRLPRO="N" S RMPRLPRO="FOOT CENTER" Q
	.I RMPRLPRO="D" S RMPRLPRO="DDC" Q
	.I RMPRLPRO="E" S RMPRLPRO="EYE GLASS" Q
	.I RMPRLPRO="" K RMPRLPRO
	;form requested on
	S FRM=$P(RMPRY,U,13)
	S RMPRNC=$P($G(^RMPR(660,AN,"AM")),U,2)
	S DATE=$$DAT2^RMPRUTL1(DATE)
	S TYPE=$P($G(^RMPR(660,AN,1)),U,4)
	;S TYPE=$S(TYPE="":"",$D(^RMPR(661,TYPE,0)):$P(^(0),U,1),1:"")
	S AMIS=$P(RMPRY,U,15),VEN=$S(VEN="":"",$D(^PRC(440,VEN,0)):$P(^(0),U,1),1:"")
	I $D(^RMPR(660.1,"AC",AN)),$P(^RMPR(660.1,$O(^RMPR(660.1,"AC",AN,0)),0),U,11)]"" S AMIS=AMIS_"+"
	S TRANS=$S(TRANS]"":TRANS,1:""),TRANS1="" S:TRANS="X" TRANS1=TRANS,TRANS=""
	S DEL=$E(DEL,4,5)_"/"_$E(DEL,6,7)_"/"_$E(DEL,2,3) S:DEL="//" DEL=""
	;
	;set results array
	;
	S HTYPE=""
	I $D(^RMPR(660,$P(^TMP($J,"RMPRC",RK),U,1),"HST")) S HTYPE=$E(^RMPR(660,$P(^TMP($J,"RMPRC",RK),U,1),"HST"),1,15)
	S ITEM=AMIS_$S(TYPE'="":$P($G(^RMPR(661.1,TYPE,0)),U,2),$P(RMPRY,U,26)="D":"DELIVERY",$P(RMPRY,U,26)="P":"PICKUP",$P(RMPRY,U,17):"SHIPPING",HTYPE'="":HTYPE,1:"")
	K HTYPE
	;
	S HCPCS=$P($G(^RMPR(660,$P(^TMP($J,"RMPRC",RK),U,1),1)),U,4)
	I HCPCS'="" S HCPCS=$P($G(^RMPR(661.1,HCPCS,0)),U,1)
	;
	S ^TMP($J,"RMPRB",RK)=$P(^TMP($J,"RMPRC",RK),U,1)_U_DATE_U_QTY_U_ITEM
	S ^TMP($J,"RMPRB",RK)=^TMP($J,"RMPRB",RK)_U_HCPCS_U_TRANS_TRANS1
	;
	;display source of procurement for 2529-3 under vendor header
	I $D(RMPRLPRO) S ^TMP($J,"RMPRB",RK)=^TMP($J,"RMPRB",RK)_U_RMPRLPRO
	E  S:VEN'="" ^TMP($J,"RMPRB",RK)=^TMP($J,"RMPRB",RK)_U_$E(VEN,1,10)
	I VEN=""&'$D(RMPRLPRO) S:'$D(^RMPR(660,$P(^TMP($J,"RMPRC",RK),U,1),"HST")) ^TMP($J,"RMPRB",RK)=^TMP($J,"RMPRB",RK)_U_$E(VEN,1,10)
	I VEN=""&'$D(RMPRLPRO) S:$D(^RMPR(660,$P(^TMP($J,"RMPRC",RK),U,1),"HST")) ^TMP($J,"RMPRB",RK)=^TMP($J,"RMPRB",RK)_U_$E($P(^RMPR(660,$P(^TMP($J,"RMPRC",RK),U,1),"HST"),U,3),1,10)
	;
	I STA'="" S ^TMP($J,"RMPRB",RK)=^TMP($J,"RMPRB",RK)_U_$P($G(^DIC(4,STA,99)),U,1)
	I STA="" S ^TMP($J,"RMPRB",RK)=^TMP($J,"RMPRB",RK)_U_"UNKNOWN"
	S ^TMP($J,"RMPRB",RK)=^TMP($J,"RMPRB",RK)_U_SN_U_DEL
	I $P(^TMP($J,"RMPRC",RK),U,3) S CST=$P(^TMP($J,"RMPRC",RK),U,3)
	S COST=$J($FN($S(CST'="":CST,$P(RMPRY,U,17):$P(RMPRY,U,17),1:""),"T",2),9)
	;
	S ^TMP($J,"RMPRB",RK)=^TMP($J,"RMPRB",RK)_U_COST_U_RMPRNC
	;
	I $P(^TMP($J,"RMPRC",RK),U,2)="" S $P(^TMP($J,"RMPRC",RK),U,2)=RZ
	K DATE,QTY,ITEM,HCPSC,RMPRLPRO,VEN,SN,DEL,COST,REM
	;
	Q
	;END
