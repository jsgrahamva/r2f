PSSMRTUX	;BIR/RTR-Process Standard Medication Route File Updates continued ;03/02/09
	;;1.0;PHARMACY DATA MANAGEMENT;**147**;9/30/97;Build 16
	;
	;Reference to TMP("XUMF EVENT" supported by DBIA 5470
CHL	;Check Length, called from locked entries section of PSSMRTUP
	N PSSMRTL1
	S PSSMRTL1=$L(PSSMRPP4)
	I PSSMRTL1<37 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     Recommend mapping to Standard Route: "_PSSMRPP4 S PSSMRPCT=PSSMRPCT+1 Q
	S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     Recommend mapping to Standard Route:" S PSSMRPCT=PSSMRPCT+1
	S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="       "_PSSMRPP4 S PSSMRPCT=PSSMRPCT+1
	Q
	;
	;
ATTN	;
	S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="PLEASE REVIEW, MAY REQUIRE YOUR ATTENTION!",PSSMRPCT=PSSMRPCT+1
	S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" ",PSSMRPCT=PSSMRPCT+1
	Q
	;
	;
ZERO	;Miscellaneous Standard Med Route changes
	N PSSMRPHH,PSSMRPJ1,PSSMRPJ2,PSSMRPJ5,PSSMRPA1,PSSMRPA2,PSSMRPA3,PSSMRPA4,PSSMRPA5,PSSMRPA6,PSSMRPA8,PSSMRPA9,PSSMRPA7
	;If just the .01 changes, we are not showing
	S PSSMRPJ5=0
	S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="The following entries in the Standard Medication Routes (#51.23) File have had",PSSMRPCT=PSSMRPCT+1
	S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="changes to the associated First DataBank Med Route and/or Replacement Term.",PSSMRPCT=PSSMRPCT+1 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" ",PSSMRPCT=PSSMRPCT+1
	S PSSMRPCT=PSSMRPCT+1
	F PSSMRPHH=0:0 S PSSMRPHH=$O(^TMP("XUMF EVENT",$J,51.23,"BEFORE",PSSMRPHH)) Q:'PSSMRPHH  D
	.S PSSMRPJ1=$P($G(^TMP("XUMF EVENT",$J,51.23,"BEFORE",PSSMRPHH,0)),"^",2)
	.S PSSMRPJ2=$P($G(^TMP("XUMF EVENT",$J,51.23,"AFTER",PSSMRPHH,0)),"^",2)
	.S PSSMRPA1=$P($G(^TMP("XUMF EVENT",$J,51.23,"BEFORE",PSSMRPHH,"VUID")),"^",3)
	.S PSSMRPA2=$P($G(^TMP("XUMF EVENT",$J,51.23,"AFTER",PSSMRPHH,"VUID")),"^",3)
	.S (PSSMRPA3,PSSMRPA4)=0 K PSSMRPA5,PSSMRPA6,PSSMRPA7
	.I PSSMRPJ1'=PSSMRPJ2 S PSSMRPA3=1
	.I PSSMRPA1'=PSSMRPA2 S PSSMRPA4=1
	.I 'PSSMRPA3,'PSSMRPA4 Q
	.I PSSMRPA3 S PSSMRPA5=$S($G(PSSMRPJ2)'="":$G(PSSMRPJ2),1:"<deleted>")
	.I PSSMRPA4 S PSSMRPA6=$S('$G(PSSMRPA2):"<deleted>",1:$P($G(^PS(51.23,+$G(PSSMRPA2),0)),"^")) S PSSMRPA7=$S('$G(PSSMRPA2):"<deleted>",$P($G(^PS(51.23,+$G(PSSMRPA2),0)),"^",2)'="":$P($G(^PS(51.23,+$G(PSSMRPA2),0)),"^",2),1:"(None)")
	.S PSSMRPJ5=1 S PSSMRPA8=PSSMRPHH S PSSMRPA9=$$STAT^PSSMRTUP(PSSMRPA8)
	.S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   "_$P($G(^PS(51.23,+PSSMRPHH,0)),"^")_$S('PSSMRPA9:"   (Inactive)",1:"") S PSSMRPCT=PSSMRPCT+1
	.I PSSMRPA3 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     FDB Route: "_$G(PSSMRPA5) S PSSMRPCT=PSSMRPCT+1
	.I PSSMRPA4 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     Replacement Term: "_$G(PSSMRPA6) S PSSMRPCT=PSSMRPCT+1 I $G(PSSMRPA2) S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="     Replacement Term FDB Route: "_$G(PSSMRPA7) S PSSMRPCT=PSSMRPCT+1
	I 'PSSMRPJ5 S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)="   (None)",PSSMRPCT=PSSMRPCT+1
	S ^TMP($J,"PSSMRPTX",PSSMRPCT,0)=" " S PSSMRPCT=PSSMRPCT+1
	Q
	;
	;
INACZ	;Set 51.23 entries as Inactive if the FDB Route has changed
	;
	;Here we only reset the value of Inact if the FDB field changes
	N PSSMRPWH,PSSMRPWJ,PSSMRPW1,PSSMRPW2,PSSMRPW9,PSSMRPW8,PSSMRPW7
	F PSSMRPWH=0:0 S PSSMRPWH=$O(^TMP("XUMF EVENT",$J,51.23,"BEFORE",PSSMRPWH)) Q:'PSSMRPWH  D
	.S PSSMRPWJ=$G(^TMP("XUMF EVENT",$J,51.23,"BEFORE",PSSMRPWH,0)) Q:PSSMRPWJ=""
	.S PSSMRPW1=$P($G(^TMP("XUMF EVENT",$J,51.23,"BEFORE",PSSMRPWH,0)),"^",2)
	.S PSSMRPW2=$P($G(^TMP("XUMF EVENT",$J,51.23,"AFTER",PSSMRPWH,0)),"^",2)
	.I PSSMRPW1=PSSMRPW2 Q
	.S PSSMRPW7=""
	.S PSSMRPW8=PSSMRPWH
	.S PSSMRPW9=$$RPLCMNT^XTIDTRM(51.23,PSSMRPW8)
	.I $P(PSSMRPW9,";")'=PSSMRPWH S PSSMRPW7=$P(PSSMRPW9,";")
	.I '$D(^TMP($J,"PSSMRPCC","INACT",PSSMRPWH)) D  Q
	..;S ^TMP($J,"PSSMRPCC","INACT",PSSMRPWH)=$S('$P($G(^TMP("XUMF EVENT",$J,51.23,"AFTER",PSSMRPWH,"REPLACED BY")),"^"):0,1:$P($G(^TMP("XUMF EVENT",$J,51.23,"AFTER",PSSMRPWH,"REPLACED BY")),"^"))
	..S ^TMP($J,"PSSMRPCC","INACT",PSSMRPWH)=$S('$G(PSSMRPW7):0,1:$G(PSSMRPW7))
	.I '^TMP($J,"PSSMRPCC","INACT",PSSMRPWH),$G(PSSMRPW7) S ^TMP($J,"PSSMRPCC","INACT",PSSMRPWH)=$G(PSSMRPW7)
	Q