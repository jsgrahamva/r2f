RMPR9VR	;HOIFO/SPS - VIEW CONSULT REQUESTS FOR GUI;01/29/03  11:38
	;;3.0;PROSTHETICS;**59,83**;Feb 09, 1996;Build 20
	;
	;HNC #83 add free text ordering provider, results(1) call utility
	;
A1(RMPRA)	G A2
EN(RESULTS,RMPRA)	; -- Broker callback to get list to display
A2	;
	I '$D(^RMPR(668,RMPRA,0)) S RESULTS(0)="NOTHING TO REPORT" G EXIT
	K ADATE,PDAY
	; ORDER DATE/SUSPENSE DATE
	S RESULTS(0)=$P(^RMPR(668,RMPRA,0),U,1),RESULTS(0)=$$DAT1^RMPRUTL1(RESULTS(0))
	; REQUESTOR
	S RESULTS(1)=$P($G(^RMPR(668,RMPRA,0)),U,11)
	I RESULTS(1)'="" S RESULTS(1)=$$WHO^RMPREOU(RESULTS(1))
	I RESULTS(1)="" S RESULTS(1)=$$WHO^RMPREOU("",12,RMPRA)
	; SUSPENDED BY
	S RESULTS(2)=$P($G(^RMPR(668,RMPRA,0)),U,4)
	I RESULTS(2)'="" S RESULTS(2)=$P(^VA(200,RESULTS(2),0),U)
	; INITIAL ACTION DATE
	S RESULTS(3)=$P(^RMPR(668,RMPRA,0),U,9),RESULTS(3)=$$DAT1^RMPRUTL1(RESULTS(3))
	; COMPLETION DATE
	S RESULTS(4)=$P($G(^RMPR(668,RMPRA,0)),U,5)
	I RESULTS(4)>0 S RESULTS(4)=$$DAT1^RMPRUTL1(RESULTS(4))
EXIT	Q
A3(RMPRA)	G A4 ;display description
EN2(RESULTS,RMPRA)	;
A4	I '$D(^RMPR(668,RMPRA,0)) S RESULTS(0)="NOTHING TO REPORT" G EXIT
	I '$D(^RMPR(668,RMPRA,2,0)) S RESULTS(0)="NOTHING TO REPORT" G EXIT
	S (RMPRD,I)=0
	F  S RMPRD=$O(^RMPR(668,RMPRA,2,RMPRD)) Q:RMPRD'>0  D
	.S RESULTS(I)=^RMPR(668,RMPRA,2,RMPRD,0)
	.S I=I+1
	Q
A5(RMPRA)	G A6 ;display Initial Action Note
EN3(RESULTS,RMPRA)	;
A6	I '$D(^RMPR(668,RMPRA,0)) S RESULTS(0)="NOTHING TO REPORT" G EXIT
	I '$D(^RMPR(668,RMPRA,3,0)) S RESULTS(0)="NOTHING TO REPORT" G EXIT
	S (RMPRD,I)=0
	F  S RMPRD=$O(^RMPR(668,RMPRA,3,RMPRD)) Q:RMPRD'>0  D
	.S RESULTS(I)=^RMPR(668,RMPRA,3,RMPRD,0)
	.S I=I+1
	Q
A7(RMPRA)	G A8 ;display Completion Note
EN4(RESULTS,RMPRA)	;
A8	I '$D(^RMPR(668,RMPRA,0)) S RESULTS(0)="NOTHING TO REPORT" G EXIT
	I '$D(^RMPR(668,RMPRA,4,0)) S RESULTS(0)="NOTHING TO REPORT" G EXIT
	S (RMPRD,I)=0
	F  S RMPRD=$O(^RMPR(668,RMPRA,4,RMPRD)) Q:RMPRD'>0  D
	.S RESULTS(I)=^RMPR(668,RMPRA,4,RMPRD,0)
	.S I=I+1
	Q
