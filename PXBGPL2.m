PXBGPL2	;ISL/JVS - DOUBLE ?? GATHERING OF PATIENT PROBLEM LIST;3/8/96  11:33 ;11/5/96  14:18
	;;1.0;PCE PATIENT CARE ENCOUNTER;**11,199**;Aug 12, 1996;Build 51
	;
	W !,"THIS IS NOT AN ENTRY POINT" Q
	;
	;
DOUBLE1(FROM)	;--Entry point
	;
NEW	;
	;
	S PNAME=NAME
	N FILE,FIELD,TITLE,HEADING,SUB,CODE,NAME,START,SCREEN,CNT,OK,INDEX,CYCLE
	N TOTAL,POV,CNT,PXBPMT,SUB2
	;---SETUP VARIABLES
	S BACK="",INDEX=""
	S START=DATA,SUB=0,SUB2=0
	;
START1	;--RECYCLE POINT
	S TITLE="PATIENT PROBLEM LIST"
	;
	D PL^PXBGPL(PATIENT)
	;
	I '$D(PXBPMT) S TOTAL=0
	I $D(PXBPMT) D
	.S (POV,CNT)="" F  S POV=$O(PXBPMT("PL",POV)) Q:POV=""  S CNT=CNT+1 D
	..S ^TMP("PXBTOTAL",$J,"DILIST","ID",CNT,.01)=POV
	I $D(CNT) S TOTAL=CNT
	;
	;--DISPLAY IF NO MATCH FOUND
	I TOTAL=0 W IOCUU,IOCUU,!,IOELEOL D
	.D LOC W !
	.W !!! D HELP^PXBUTL0("PLM")
	.D HELP1^PXBUTL1("CON") R OK:DTIME
	I TOTAL=0 Q TOTAL
	;
	;
	;----DISPLAY LIST TO THE SCREEN
	S HEADING="W !,""ITEM"",?6,""NAME"",?16,""DESCRIPTION "",IOINHI,TOTAL,"" MATCHES"",IOINLOW"
LIST	;-DISPLAY LIST TO THE SCREEN
	D LOC,HEAD
	X HEADING
	S SUB=SUB-1
	S NUM=0 F  S SUB=$O(^TMP("PXBTOTAL",$J,"DILIST","ID",SUB)) S NUM=NUM+1 Q:NUM=11  Q:SUB'>0  S SUB2=SUB2+1 D
	.S NAME=$G(^TMP("PXBTOTAL",$J,"DILIST","ID",SUB,.01))
	.W !,SUB,?6,$P(NAME," ",1),?16,$E($P(NAME," ",2,$L(NAME," ")),1,63)
	;
	;----If There is only one selection go to proper prompting
	I TOTAL=1 G PRMPT2
	I $G(VALL)=1 G PRMPT3
	;
PRMPT	;---WRITE PROMPT HERE
	D LOC^PXBCC(15,1)
	D WIN17^PXBCC(PXBCNT)
	W !
	I SUB>0 W !,"Enter '^' to quit"
	E  I TOTAL>10 W !,"               END OF LIST"
	I SUB>0 S DIR("A")="Select a single 'ITEM NUMBER' or 'RETURN' to continue: "
	E  S DIR("A")="Select a single 'ITEM NUMBER' or 'RETURN' to exit: "
	S DIR("?")="^D HELP^PXBUTL0(""PL11"")"
	S DIR(0)="N,A,O^0:"_SUB2_":0^I X'?.1""^"".N K X"
	D ^DIR
	I X="",SUB>0 G LIST
	I X="",SUB'>0 S X="^"
VAL	;-----Set the VAL equal to the value
	S VAL=$G(^TMP("PXBTOTAL",$J,"DILIST",2,X))_"^"_$G(^TMP("PXBTOTAL",$J,"DILIST","ID",X,.01))
EXITNEW	;--EXIT
	K DIR,^TMP("PXBTANA",$J),^TMP("PXBTOTAL",$J)
	K TANA,TOTAL
	Q VAL
PRMPT3	;---WRITE PROMPT HERE
	D LOC^PXBCC(15,1)
	D WIN17^PXBCC(PXBCNT)
	W !!
	D HELP1^PXBUTL1("CON") R OK:DTIME
	I SUB>0 G LIST
	I SUB'>0 S X="^"
VALL	;-----Set the VAL equal to the value
	S VAL=$G(^TMP("PXBTOTAL",$J,"DILIST",2,X))_"^"_$G(^TMP("PXBTOTAL",$J,"DILIST","ID",X,.01))
EXITNEWW	;--EXIT
	K ^TMP("PXBTANA",$J),^TMP("PXBTOTAL",$J)
	K TANA,TOTAL
	Q VAL
	Q
	;
	;-----------------SUBROUTINES--------------
BACK	;
	S START=$G(^TMP("PXBTANA",$J,"DILIST",1,1))
	S START("IEN")=$G(^TMP("PXBTANA",$J,"DILIST",2,1))
	Q
FORWARD	;
	S START=$G(^TMP("PXBTANA",$J,"DILIST",1,10))
	S START("IEN")=$G(^TMP("PXBTANA",$J,"DILIST",2,10))
	Q
LOC	;--LOCATE CURSOR
	D LOC^PXBCC(3,1) ;--LOCATE THE CURSOR
	W IOEDEOP ;--CLEAR THE PAGE
	Q
HEAD	;--HEAD
	W IOINHI,!,IOCUU,?(IOM-$L(TITLE))\2,TITLE,IOINLOW,IOELEOL
	Q
SUB	;--DISPLAY LIST TO THE SCREEN
	I $P(^TMP("PXBTANA",$J,"DILIST",0),"^",1)=0 W !!,"     E N D  O F  L I S T" Q
	X HEADING
	S SUB=0,CNT=0 F  S SUB=$O(^TMP("PXBTANA",$J,"DILIST","ID",SUB)) Q:SUB'>0  S CNT=CNT+1 D
	.S NAME=$G(^TMP("PXBTANA",$J,"DILIST","ID",SUB,.01))
	.W !,SUB,?6,NAME
	Q
SETUP	;-SETP VARIABLES
	S FILE=200,FIELD=.01
	S HEADING="W !,""ITEM"",?6,""NAME"""
	Q
PRMPT2	;-----Yes and No prompt if only choice
	D WIN17^PXBCC(PXBCNT)
	D LOC^PXBCC(15,1)
	S DIR("A")="Is this the correct entry "
	S DIR("B")="YES"
	S DIR(0)="Y"
	D ^DIR
	I Y=0 S X="^"
	I Y=1 S X=1
	G VAL