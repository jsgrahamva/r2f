MDHL7M3	; HOIFO/WAA-GE IMAGE VAULT INTERFACE ; 08/08/07
	;;1.0;CLINICAL PROCEDURES;**37**;Apr 15, 2003;Build 4
	N TCNT,ICNT,LN
	S (TCNT,ICNT,LN)=0
OBX	; Process OBX
	N MDATT,PROC
	D ATT^MDHL7U(DEVIEN,.MDATT) Q:MDATT<1
	S PROC=0
	F  S PROC=$O(MDATT(PROC)) Q:PROC<1  D
	. N PROCESS
	. S PROCESS=$P(MDATT(PROC),";",5)
	. I PROCESS="TEXT^MDHL7U2" D TXT
	. D @PROCESS
	. Q
	Q:'MDIEN
	D REX^MDHL7U1(MDIEN)
	D GENACK^MDHL7X
	Q
TXT	;
	N MDHLD,CNT,CNT2,LINE,TMPCNT,P,HDR1,HDR2
	S P="|",HDR1=" ",HDR2=""
	S (CNT,CNT2)=0
	S CNT2=CNT2+1,^TMP($J,"MDHL7","TEXT",CNT2)="OBX||TX|||Interpretation:"
	F  S CNT=$O(^TMP($J,"MDHL7A",CNT)) Q:CNT<1  D
	. S LINE=^TMP($J,"MDHL7A",CNT)
	. I $P(LINE,P,1)'="OBX" Q
	. I $P(LINE,P,3)="ST" D
	. . S $P(LINE,P,6)=$P(LINE,P,4)_"="_$P(LINE,P,6)_$P(LINE,P,7)
	. . S TMPCNT=""
	. . S TMPCNT=$O(^TMP($J,"MDHL7A",CNT))
	. . I $P(^TMP($J,"MDHL7A",TMPCNT),P,3)'="ST" D BLANK
	. . Q
	. S $P(LINE,P,3)="TX"
	. S HDR1=$P(LINE,P,5) I HDR1="" S HDR1=HDR2
	. I HDR1'=HDR2 D
	. . ;UPDATE HEADER
	. . D BLANK
	. . S CNT2=CNT2+1,^TMP($J,"MDHL7","TEXT",CNT2)=LINE
	. . S $P(^TMP($J,"MDHL7","TEXT",CNT2),P,6)="["_HDR1_"]",HDR2=HDR1
	. . Q
	. S CNT2=CNT2+1,^TMP($J,"MDHL7","TEXT",CNT2)=LINE
	. Q
	Q
BLANK	;CREAT A BLANK LINE IN THE REPORT
	S CNT2=CNT2+1,^TMP($J,"MDHL7","TEXT",CNT2)=LINE
	S $P(^TMP($J,"MDHL7","TEXT",CNT2),P,6)=" "
	Q
