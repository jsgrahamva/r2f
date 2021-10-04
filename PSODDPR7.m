PSODDPR7	; BIR/OG ; Enhanced order checks - IMO Utilities ;12/6/11
	;;7.0;OUTPATIENT PHARMACY;**390**;DEC 1997;Build 86
	;External reference to IN^PSJBLDOC supported by DBIA 5306
	;
	; Required to be present:
	;   DFN: patient internal entry number
	;   DRG - dispensed drug name
	;   SV - Severity
	;    ZVA - VA Generic Name
	;   ON: Order identifier =  first ";" piece: I1 - IV order. I2 - UD order; second ";" piece: order id; example:  ON="C2;4;PROFILE;5"
	;
	Q:$E($P(ON,";"))'["C"
	N DRGNAME,STATUS,STARTDT,STOPDT,SCHEDULE,ORDID,DOSAGE,FILENODE,ADD,SOL,ADDNAM,SOLNAM,BOTTLE,STRENGTH,AFLG,ADDS,SOLUTION,VOLUME,IVDATA,SORT,INFUSE,SFLG,PSOCON,PSOCLINI,SORT2,PSOCLIN
	N PSOCDRG,DRGDRG,STARTDTF,STOPDTF,ORDDATE
	S SORT="PSOPEPS CLINIC"
	S (PSOCDRG,PSOCON,STATUS)=""
	Q:'$D(PSOCLNS(SV,ZVA))
	;sort by status within drug name
	F  S PSOCDRG=$O(PSOCLNS(SV,ZVA,PSOCDRG)) Q:PSOCDRG=""  I DRG=PSOCDRG F  S PSOCON=$O(PSOCLNS(SV,ZVA,PSOCDRG,PSOCON)) Q:PSOCON=""  D
	.S (ORDID,PSOCLINI,FILENODE)="",DRGDRG=1,ORDID=$P(PSOCON,";",2),PSOCLINI=$P(^TMP($J,"PSOPEPS","IN","PROFILE",PSOCON),"^",7),FILENODE=$P(PSOCLINI,";")
	.I FILENODE=1 D PSS436^PSS55(PSODFN,ORDID,SORT) S:$D(^TMP($J,SORT,ORDID,100)) STATUS=$P(^TMP($J,SORT,ORDID,100),"^",2)
	.I FILENODE=2 D PSS431^PSS55(PSODFN,ORDID,"","",SORT) S:$D(^TMP($J,SORT,ORDID,28)) STATUS=$P(^TMP($J,SORT,ORDID,28),"^",2)
	.I FILENODE=3!(FILENODE=4)!(FILENODE=5) D PSJ^PSJ53P1(ORDID,SORT) S:$D(^TMP($J,SORT,ORDID,28)) STATUS=$P(^TMP($J,SORT,ORDID,28),"^",2)
	.I STATUS="" S STATUS="Z"
	.S PSOCLIN(SV,ZVA,$S(STATUS["ACTIVE":1,STATUS["NON-VERIFIED":2,STATUS["DISCONTINUED":3,STATUS["EXPIRE":4,1:5),PSOCON)=PSOCDRG
	Q:'$D(PSOCLIN(SV,ZVA))
	S (SORT2,ORDID,PSOCLINI,FILENODE,PSOCON)=""
	K ^TMP($J,SORT)
	F  S SORT2=$O(PSOCLIN(SV,ZVA,SORT2)) Q:SORT2=""  F  S PSOCON=$O(PSOCLIN(SV,ZVA,SORT2,PSOCON)) Q:PSOCON=""  D CLINIC
	Q
DUP	;
	;Required:  ZCT =  Order identifier =  first ";" piece: I1 - IV order. I2 - UD order; second ";" piece: order id; example:  ON="C2;4;PROFILE;5"
	Q:ZCT=""
	N DRGNAME,STATUS,STARTDT,STOPDT,SCHEDULE,ORDID,DOSAGE,FILENODE,ADD,SOL,ADDNAM,SOLNAM,BOTTLE,STRENGTH,AFLG,ADDS,SOLUTION,VOLUME,IVDATA,SORT,INFUSE,SFLG,PSOCON
	N PSOCLINI,SORT2,PSOCLIN,DRGDRG,STARTDTF,STOPDTF,ORDDATE
	S SORT="PSOPEPS CLINIC",DRGDRG=0
	S PSOCON=$P(ZCT,"^",3),DRGNAME=$P(ZCT,"^",2) D CLINIC
	Q
	;
CLINIC	;
	K ^TMP($J,SORT)
	S (ORDID,PSOCLINI,FILENODE)="",ORDID=$P(PSOCON,";",2),PSOCLINI=$P(^TMP($J,"PSOPEPS","IN","PROFILE",PSOCON),"^",7)
	Q:'PSOCLINI
	S FILENODE=$P(PSOCLINI,";") I DRGDRG S DRGNAME=PSOCLIN(SV,ZVA,SORT2,PSOCON) I DRGNAME'="" S DRGDRG=0
	S (STATUS,SCHEDULE,DOSAGE,STARTDT,STOPDT,INFUSE,STARTDTF,STOPDTF,ORDDATE)=""
	D GETDATA
	K ^TMP($J,SORT)
	W !
	Q
GETDATA	;
	I FILENODE=1 D PSS436^PSS55(PSODFN,ORDID,SORT) D  Q  ;IV for file 55
	.I DRGDRG S DRGNAME=$P(^TMP($J,"PSOPEPS","IN","PROFILE",PSOCON),"^",4)
	.I $D(^TMP($J,SORT,ORDID,100)) S STATUS=$P(^TMP($J,SORT,ORDID,100),"^",2)
	.I $D(^TMP($J,SORT,ORDID,.09)) S SCHEDULE=^TMP($J,SORT,ORDID,.09)
	.I $D(^TMP($J,SORT,ORDID,109)) S DOSAGE=^TMP($J,SORT,6,109)
	.I $D(^TMP($J,SORT,ORDID,.02)) S STARTDT=$P(^TMP($J,SORT,ORDID,.02),"^",2)
	.I STARTDT="" S:$D(^TMP($J,SORT,ORDID,115)) STARTDT=$D(^TMP($J,SORT,ORDID,115)) S:STARTDT'="" STARTDTF=1
	.I $D(^TMP($J,SORT,ORDID,.03)) S STOPDT=$P(^TMP($J,SORT,ORDID,.03),"^",2)
	.S:$D(^TMP($J,SORT,ORDID,27)) ORDDATE=^TMP($J,SORT,ORDID,27)
	.I STOPDT="" S:$D(^TMP($J,SORT,ORDID,117)) STARTDT=$D(^TMP($J,SORT,ORDID,117)) S:STOPDT'="" STOPDTF=1
	.I $D(^TMP($J,SORT,ORDID,.08)) S INFUSE=^TMP($J,SORT,ORDID,.08)
	.D WRITE
	;
	I FILENODE=2 D PSS431^PSS55(PSODFN,ORDID,"","",SORT) D  Q  ;Unit dose for file 55
	.I DRGDRG S DRGNAME=$P(^TMP($J,"PSOPEPS","IN","PROFILE",PSOCON),"^",4)
	.I $D(^TMP($J,SORT,ORDID,28)) S STATUS=$P(^TMP($J,SORT,ORDID,28),"^",2)
	.I $D(^TMP($J,SORT,ORDID,26)) S SCHEDULE=^TMP($J,SORT,ORDID,26)
	.I $D(^TMP($J,SORT,ORDID,109)) S DOSAGE=^TMP($J,SORT,ORDID,109)
	.I $D(^TMP($J,SORT,ORDID,10)) S STARTDT=$P(^TMP($J,SORT,ORDID,10),"^",2)
	.I $D(^TMP($J,SORT,ORDID,34)) S STOPDT=$P(^TMP($J,SORT,ORDID,34),"^",2)
	.I $D(^TMP($J,SORT,ORDID,.08)) S INFUSE=^TMP($J,SORT,ORDID,.08)
	.D WRITE
	;
	I FILENODE=3!(FILENODE=4)!(FILENODE=5) D  Q  ;unit dose for file 53.1
	.D PSJ^PSJ53P1(ORDID,SORT)
	.I DRGDRG,$D(^TMP($J,SORT,ORDID,108)) S DRGNAME=$P(^TMP($J,SORT,ORDID,108),"^",2)
	.I $D(^TMP($J,SORT,ORDID,28)) S STATUS=$P(^TMP($J,SORT,ORDID,28),"^",2)
	.I $D(^TMP($J,SORT,ORDID,26)) S SCHEDULE=$P(^TMP($J,SORT,ORDID,26),"^",2)
	.I $D(^TMP($J,SORT,ORDID,27)) S ORDDATE=^TMP($J,SORT,ORDID,27) S Y=ORDDATE D DD^%DT S ORDDATE=Y
	.I $D(^TMP($J,SORT,ORDID,109)) S DOSAGE=^TMP($J,SORT,ORDID,109)
	.I $D(^TMP($J,SORT,ORDID,10)) S STARTDT=$P(^TMP($J,SORT,ORDID,10),"^",2)
	.I STARTDT="",$D(^TMP($J,SORT,ORDID,115)) S STARTDT=$P(^TMP($J,SORT,ORDID,115),"^",2) S:STARTDT'="" STARTDTF=1
	.I $D(^TMP($J,SORT,ORDID,25)) S STOPDT=$P(^TMP($J,SORT,ORDID,25),"^",2)
	.I $D(^TMP($J,SORT,ORDID,117))&(STOPDT="") S STOPDT=$P(^TMP($J,SORT,ORDID,117),"^",2)  S:STOPDT'="" STOPDTF=1
	.I $D(^TMP($J,SORT,ORDID,116)) S DURATION=^TMP($J,SORT,ORDID,116)
	.D WRITE
	Q
	;
WRITE	;
	D HD^PSODDPR2() Q:$G(PSODLQT)
	S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1 W:'$G(PSODUPF) !,$J("Clinic Order: ",23)_DRGNAME_" ("_STATUS_")"
	I $D(^TMP($J,SORT,ORDID,"ADD")) D:FILENODE=1 IV55 D:FILENODE=3 IV531
	I SCHEDULE'="" S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1 W:'$G(PSODUPF) !,$J("Schedule: ",23),SCHEDULE
	I DOSAGE'="" S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1 W:'$G(PSODUPF) !,$J("Dosage: ",23),DOSAGE
	I STARTDT=""&(ORDDATE'="")  S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1 W:'$G(PSODUPF) !,$J("Order Date: ",23),ORDDATE
	I STARTDT'="" S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1 W:'$G(PSODUPF) !,$J($S($G(STARTDTF):"Requested Start Date: ",1:"Start Date: "),23),STARTDT
	E  S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1 W:'$G(PSODUPF) !,$J("Start Date: ",23),"********"
	I STOPDT'="" S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1 W:'$G(PSODUPF) !,$J($S($G(STOPDTF):"Requested Stop Date: ",1:"Stop Date: "),23),STOPDT
	E  S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1 W:'$G(PSODUPF) !,$J("Stop Date: ",23),"********"
WRITE2	;
	I '$G(PSODUPF) D HD^PSODDPR2():(($Y+5)>IOSL)
	Q 
	; 
IMO(DFN)	;Inpatient Meds ordered in outpatient pharmacy (IMO) - determine IMO drugs to be added to the profile drugs submitted to FDB.
	;         In: DFN - Patient IED
	; Output: ^TMP( file of inpatient meds drugs; example of each type of order:
	;                 ^TMP(540771229,"PSOPEPS","IN","PROFILE","C2;6;PROFILE;6")="16579^4010153^65^SIMVASTATIN 40MG TAB^10711^I"
	;                 ^TMP(540771229,"PSOPEPS","IN","PROFILE","C4;1597;PROFILE;7")="11664^4006819^1848^CIMETIDINE 300MG/5ML SOL (OZ)^10746^I"
	;
	;              The first piece of the 5th subscript denotes the type of order (ex: C2 and C4 in the example above).  
	;               When adding clinic orders, this piece is always "C" concatenated with an number 1-4 where 1 means UD file 55, 2 means IV file 55, 3 means UD file 53.1 or 4 means IV for file 53.1. 
	;               For clinic orders, the 2nd piece of the 5th subscript is the subfile IEN.
	;
	D IN^PSJBLDOC(DFN,LIST,.PDRG,"O;")
	Q
	;
IV55	;
	I '$G(PSODUPF) D HD^PSODDPR2() Q:$G(PSODLQT)
	S (ADD,SOL,AFLG)=0
	;W:'$G(AFLG) !,$J("Other Additives: ",23)
	F  S ADD=$O(^TMP($J,SORT,ORDID,"ADD",ADD)) Q:ADD=""  D
	.I $D(^TMP($J,SORT,ORDID,"ADD",ADD,.01)) S ADDNAM=$P(^TMP($J,SORT,ORDID,"ADD",ADD,.01),"^",2)
	.Q:DRGNAME[(ADDNAM_" "_^TMP($J,SORT,ORDID,"ADD",ADD,.02))
	.S (BOTTLE,STRENGTH)=""
	.I $D(^TMP($J,SORT,ORDID,"ADD",ADD,.03)) S BOTTLE=^TMP($J,SORT,ORDID,"ADD",ADD,.03)
	.I $D(^TMP($J,SORT,ORDID,"ADD",ADD,.02)) S STRENGTH=^TMP($J,SORT,ORDID,"ADD",ADD,.02)
	.I '$G(AFLG) S ADDS=ADDNAM_" "_STRENGTH S:BOTTLE'="" ADDS=ADDS_" ("_BOTTLE_")"
	.I $G(AFLG) S ADDS=ADDS_", "_ADDNAM_" "_STRENGTH S:BOTTLE'="" ADDS=ADDS_" ("_BOTTLE_")"
	.S:'$G(AFLG) AFLG=1
	S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1
	I '$G(PSODUPF) D HD^PSODDPR2() Q:$G(PSODLQT)
	I $G(AFLG),'$G(PSODUPF) W !,$J("Other Additives: ",23) D MYWRITE(ADDS,23,78)
	F  S SOL=$O(^TMP($J,SORT,ORDID,"SOL",SOL)) Q:SOL=""  D
	.S (SOLUTION,VOLUME)=""
	.I $D(^TMP($J,SORT,ORDID,"SOL",SOL,.01)) S SOLUTION=$P(^TMP($J,SORT,ORDID,"SOL",SOL,.01),"^",2)
	.I $D(^TMP($J,SORT,ORDID,"SOL",SOL,1)) S VOLUME=^TMP($J,SORT,ORDID,"SOL",SOL,1)
	.I '$G(PSODUPF) D HD^PSODDPR2() Q:$G(PSODLQT)
	.W:'$G(SFLG)&'$G(PSODUPF) !,$J("Solution(s): ",23)_SOLUTION_" "_VOLUME_" "_INFUSE
	.S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1
	.I $G(SFLG),'$G(PSODUPF) W !?23,SOLUTION_" "_VOLUME_" "_INFUSE
	.S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1
	.S SFLG=1
	Q
	;
IV531	;
	I '$G(PSODUPF) D HD^PSODDPR2() Q:$G(PSODLQT)
	S (ADD,SOL,AFLG,SFLG)=0
	F  S ADD=$O(^TMP($J,SORT,ORDID,"ADD",ADD)) Q:ADD=""  D
	.S (BOTTLE,STRENGTH,IVDATA)="",IVDATA=^TMP($J,SORT,ORDID,"ADD",ADD)
	.S BOTTLE=$P(IVDATA,"^",3),STRENGTH=$P(IVDATA,"^",2),ADDNAM=$P(IVDATA,"^")
	.I $D(^TMP($J,SORT,ORDID,"ADD",ADD+1)) Q:DRGNAME[(ADDNAM_" "_STRENGTH)
	.I '$G(AFLG) S ADDS=ADDNAM_" "_STRENGTH S:BOTTLE'="" ADDS=ADDS_" ("_BOTTLE_")"
	.I $G(AFLG) S ADDS=ADDS_", "_ADDNAM_" "_STRENGTH S:BOTTLE'="" ADDS=ADDS_" ("_BOTTLE_")"
	.S:'$G(AFLG) AFLG=1
	S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1
	I '$G(PSODUPF) D HD^PSODDPR2() Q:$G(PSODLQT)
	I $G(AFLG),'$G(PSODUPF)  W !,$J("Other Additives: ",23) D MYWRITE(ADDS,23,78)
	F  S SOL=$O(^TMP($J,SORT,ORDID,"SOL",SOL)) Q:SOL=""  D
	.S (SOLUTION,VOLUME)=""
	.S (SOLUTION,VOLUME,IVDATA)="",IVDATA=^TMP($J,SORT,ORDID,"SOL",SOL)
	.S VOLUME=$P(IVDATA,"^",2),SOLUTION=$P(IVDATA,"^")
	.S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1
	.W:'$G(SFLG)&'$G(PSODUPF) !,$J("Solution(s): ",23)_SOLUTION_" "_VOLUME_" "_INFUSE
	.I $G(SFLG),'$G(PSODUPF)  W !?23,SOLUTION_" "_VOLUME_" "_INFUSE
	.S:$G(PSODUPF) PSODUPC(ZCT)=PSODUPC(ZCT)+1
	.S SFLG=1
	I '$G(PSODUPF) D HD^PSODDPR2() Q:$G(PSODLQT)
	Q
	;
MYWRITE(X,DIWL,DIWR)	;Continue writing on the same line
	NEW DN,PSOCNT
	I '$G(DIWL) S DIWL=1
	I '$G(DIWR) S DIWR=75
	K ^UTILITY($J,"W") D ^DIWP
	F PSOCNT=0:0 S PSOCNT=$O(^UTILITY($J,"W",DIWL,PSOCNT)) Q:'PSOCNT  W:PSOCNT'=1 ! W ?DIWL,^UTILITY($J,"W",DIWL,PSOCNT,0)
	Q
