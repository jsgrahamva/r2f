RMPR9S4E	;HOIFO/SPS - GUI 2319 Extended Display Transaction screen 4 ;12/17/02  09:35
	;;3.0;PROSTHETICS;**59,92,99,90,75,168**;Feb 09, 1996;Build 43
	;
	; Reference to $$SINFO^ICDEX supported by ICR #5747
	; Reference to $$ICDDX^ICDEX supported by ICR #5747
	;
	;         (IEN)=ien of file 660
	;
	;AAC Patch 92 08/04/04 - Code Set Versioning (CSV)
	;
	;display detailed record
A1(IEN)	G A2
EN(RESULTS,IEN)	;Broker
A2	;
	I +IEN'>0 S RESULTS(0)="NOTHING TO REPORT" G EXIT
	I '$D(^RMPR(660,IEN)) S RESULTS(0)="NOTHING TO REPORT" G EXIT
	N DIC,DIQ,DR,DA,I,RMPRDFN,RMPRDOB,RMPRLA,RMPRNAM,RMPRSSN,RMPRV,RMPRDA,RV
	S DIC=660,DIQ="R19",DR=".01:96",DIQ(0)="EN"
	S (RMPRDA,DA)=(IEN)
	D EN^DIQ1
	S DIQ="R19",DR=72,DIQ(0)="I" D EN^DIQ1
	;get vendor info
	S DA=$P(^RMPR(660,RMPRDA,0),U,9)
	I DA D
	.S DIC=440,DIQ="RV",DR=".01:6",DIQ(0)="EN"
	.S (RMPRV,DA)=$P(^RMPR(660,RMPRDA,0),U,9)
	.D EN^DIQ1
	;
	;array defined for record in following format:
	;R19(filenumber,ien,field,E)=external form of data
	;RV(filenumber,ien,field,E)=external form of data
	;example:
	;R19(660,100,.01,"E")=APR 27, 1995
	;R19(660,100,.02,"E")=NAME,PATIENT
	;RV(440,131,.01,"E")=ORTHOTIC LAB
	S RMPRDFN=$P(^RMPR(660,RMPRDA,0),U,2)
	S RMPRNAM=$P(^DPT(RMPRDFN,0),U),RMPRSSN=$P(^(0),U,9),RMPRDOB=$P(^(0),U,3)
	;
	D HDR
	; "TYPE OF FORM: ",
	S RESULTS(5)=$G(R19(660,RMPRDA,11,"E"))
	; "INITIATOR: ",
	S RESULTS(6)=$G(R19(660,RMPRDA,27,"E"))
	; "DATE: ",
	S RESULTS(7)=$G(R19(660,RMPRDA,1,"E"))
	; "DELIVER TO: ",
	S RESULTS(8)=$G(R19(660,RMPRDA,25,"E"))
	; "TYPE TRANS: ",
	S RESULTS(9)=$G(R19(660,RMPRDA,2,"E"))
	; "QTY: ",
	S RESULTS(10)=$G(R19(660,RMPRDA,5,"E"))
	; "INVENTORY POINT: "
	S RESULTS(11)=$G(R19(660,RMPRDA,29,"E"))
	; "SOURCE: ",
	S RESULTS(12)=$G(R19(660,RMPRDA,12,"E"))
	;vendor tracking number
	S (RESULTS(13),RESULTS(14))=""
	I $G(R19(660,RMPRDA,11,"E"))="VISA" D
	.; "VENDOR TRACKING: ",
	.S RESULTS(13)=$G(R19(660,RMPRDA,4.2,"E"))
	.; "BANK AUTHORIZATION: ",
	.S RESULTS(14)=$G(R19(660,RMPRDA,38.7,"E"))
	; "VENDOR: ",
	S RESULTS(15)=$G(R19(660,RMPRDA,7,"E"))
	; VENDOR PHONE AND ADDRESS INFO
	F I=16:1:20 S RESULTS(I)=""
	I $D(RV) D
	.; "VENDOR PHONE: and Address ",
	.S RESULTS(16)=$G(RV(440,RMPRV,5,"E"))
	.S RESULTS(17)=$G(RV(440,RMPRV,1,"E"))
	.S RESULTS(18)=$G(RV(440,RMPRV,4.2,"E"))
	.S RESULTS(19)=$G(RV(440,RMPRV,4.4,"E"))
	.S RESULTS(20)=$G(RV(440,RMPRV,4.6,"E"))
	; "DELIVERY DATE: "
	S RESULTS(21)=$G(R19(660,RMPRDA,10,"E"))
	; "TOTAL COST: "
	S RESULTS(22)=0.00
	I $G(R19(660,RMPRDA,14,"E"))'="" S RESULTS(22)="$"_$FN(R19(660,RMPRDA,14,"E"),"T",2)
	I $G(R19(660,RMPRDA,14,"E"))="" S RESULTS(22)=$S($G(R19(660,RMPRDA,6,"E"))'="":"$"_$FN(R19(660,RMPRDA,6,"E"),"T",2),$G(R19(660,RMPRDA,48,"E"))'="":"$"_$FN(R19(660,RMPRDA,48,"E"),"T",2),1:"")
	; "OBL: ",
	S RESULTS(23)=$G(R19(660,RMPRDA,23,"E"))
	;
	;lab data
	F I=24:1:32 S RESULTS(I)=""
	I $D(^RMPR(660,RMPRDA,"LB")) D
	.N DIC,DIQ,DR,L19,DA
	.S (DA,RMPRLA)=$P(^RMPR(660,RMPRDA,"LB"),U,10)
	.Q:DA=""
	.S DIC=664.1,DIQ="L19",DR="15",DIQ(0)="E"
	.D EN^DIQ1
	.; "WORK ORDER: ",
	.S RESULTS(24)=$G(R19(660,RMPRDA,71,"E"))
	.I $P(^RMPR(660,RMPRDA,"AM"),U,2)=1 S RESULTS(24)=$G(R19(660,RMPRDA,72.5,"E"))
	.I $P(^RMPR(660,RMPRDA,"LB"),U,14)=1 S RESULTS(24)=$G(R19(660,RMPRDA,72.5,"E"))
	.; "RECEIVING STATION: ",
	.S RESULTS(25)=$G(R19(660,RMPRDA,70,"E"))
	.; "TECHNICIAN: ",
	.S RESULTS(26)=$G(L19(664.1,RMPRLA,15,"E"))
	.; "TOTAL LABOR HOURS: ",
	.S RESULTS(27)=$G(R19(660,RMPRDA,45,"E"))
	.; "TOTAL LABOR COST: ",
	.S RESULTS(28)=$G(R19(660,RMPRDA,46,"E"))
	.; "TOTAL MATERIAL COST: ",
	.S RESULTS(29)=$G(R19(660,RMPRDA,47,"E"))
	.; "TOTAL LAB COST: ",
	.S RESULTS(30)=$G(R19(660,RMPRDA,48,"E"))
	.; "COMPLETION DATE: ",
	.S RESULTS(31)=$G(R19(660,RMPRDA,50,"E"))
	.; "LAB REMARKS: ",
	.S RESULTS(32)=$G(R19(660,RMPRDA,51,"E"))
	; "REMARKS: ",
	S RESULTS(33)=$G(R19(660,RMPRDA,16,"E"))
	; "RETURN STATUS: ",
	S RESULTS(34)=$G(R19(660,RMPRDA,17.5,"E"))
	;
	; CoreFLS Data used to be/and same as historical data
	F I=35:1:42 S RESULTS(I)=""
	I $G(R19(660,RMPRDA,15,"E"))["*" D
	.;include records that have been merged
	.; "COREFLS/HISTORICAL DATA",!
	.Q:'$D(R19(660,RMPRDA,89))
	.; "ITEM: ",
	.S RESULTS(35)=$G(R19(660,RMPRDA,89,"E"))
	.; "STATION: ",
	.S RESULTS(36)=$G(R19(660,RMPRDA,90,"E"))
	.; "VENDOR: ",
	.S RESULTS(37)=$G(R19(660,RMPRDA,91,"E"))
	.; "   PHONE: ",
	.S RESULTS(38)=$G(R19(660,RMPRDA,92,"E"))
	.; " STREET
	.S RESULTS(39)=$G(R19(660,RMPRDA,93,"E"))
	.; CITY
	.S RESULTS(40)=$G(R19(660,RMPRDA,94,"E"))
	.; STATE
	.S RESULTS(41)=$G(R19(660,RMPRDA,95,"E"))
	.; ZIP
	.S RESULTS(42)=$G(R19(660,RMPRDA,96,"E"))
	;put in lab display here fields 45,46,47,48 and 51
	;lab amis
	F I=43:1:44 S RESULTS(I)=""
	I $G(R19(660,RMPRDA,73,"E")) D
	.; "ORTHOTICS LAB CODE: "
	.S RESULTS(43)=$S($D(R19(660,RMPRDA,74,"E")):R19(660,RMPRDA,74,"E"),$D(R19(660,RMPRDA,75,"E")):R19(660,RMPRDA,75,"E"),1:"")
	.; "RESTORATIONS LAB CODE: "
	.S RESULTS(44)=$S($D(R19(660,RMPRDA,76,"E")):R19(660,RMPRDA,76,"E"),$D(R19(660,RMPRDA,77,"E")):R19(660,RMPRDA,77,"E"),1:"")
	;purchasing and issue from stock amis
	; "DISABILITY SERVED: ",
	S RESULTS(45)=$G(R19(660,RMPRDA,62,"E"))
	;appliance/item information
	; "APPLIANCE: ",
	;S RESULTS(46)=$G(R19(660,RMPRDA,4,"E"))
	S RESULTS(46)=$G(R19(660,RMPRDA,89,"E"))
	; "PSAS HCPCS: ",
	S RESULTS(47)=$G(R19(660,RMPRDA,4.5,"E"))
	; "PSAS HCPCS DESC.
	S RESULTS(48)=""
	I $P($G(^RMPR(660,RMPRDA,1)),U,4) S RESULTS(48)=$P($G(^RMPR(661.1,$P(^RMPR(660,RMPRDA,1),U,4),0)),U,2)
	;
	; Updates for ICD10 project
	N RMPRACS,RMPRCSI,RMPRDATE,RMPRICD,RMPRLLEN,RMPRSICD,RMPRTXT
	S (RMPRACS,RMPRCSI,RMPRDATE,RMPRICD,RMPRLLEN,RMPRSICD,RMPRTXT,RESULTS(49))="",RMPRERR=0
	S RMPRDATE=$P(^RMPR(660,RMPRDA,0),U,1)
	I $D(^RMPR(660,RMPRDA,10)) S RMPRSICD=$P(^RMPR(660,RMPRDA,10),U,8) ; SUSPENSE ICD (#8.8)
	; Retrieve and process the Suspense ICD
	I RMPRSICD'=""  D
	.S RMPRCSI=$$SINFO^ICDEX("DIAG",RMPRDATE) ; Supported by ICR 5747
	.S RMPRACS=$P(RMPRCSI,U,1) ; Internal format Active Coding System based on Date of Interest
	.; Retrieve ICD Code Data
	.S RMPRICD=$$ICDDX^ICDEX(RMPRSICD,RMPRDATE,RMPRACS,"I") ; Supported by ICR 5747
	.S RMPRERR=$P(RMPRICD,U,1)
	.I RMPRERR<0 S RESULTS(49)=$P(RMPRICD,U,2)
	.S RMPRACS=$P(RMPRCSI,U,2) ; External format Active Coding System based on Date of Interest
	.S RMPRACS=$S(RMPRACS="ICD-9-CM":9,RMPRACS="ICD-10-CM":10,1:"") ; adjust for 2nd return piece
ZZ	;
	I RMPRERR>0 D
	.S RESULTS(49)=$P(RMPRICD,U,2)_" "
	.; Return brief description 
	.S RESULTS(49)=RESULTS(49)_$S(RMPRACS=9:$E($P(RMPRICD,U,4),1,55),1:$P(RMPRICD,U,4))
	.; Check for Inactive Status
	.I $P(RMPRICD,U,10)'>0 D
	..S RMPRTXT=" ** Inactive ** Date: "
	..S Y=$P(RMPRICD,U,12) ; Inactive Date
	..D DD^%DT
	..S RMPRTXT=RMPRTXT_Y ; External format date
	..S RESULTS(49)=RESULTS(49)_RMPRTXT Q
	.; Add Coding System for ICD as 2nd ^ delimited piece
	.S RESULTS(49)=RESULTS(49)_"^"_RMPRACS
	;
	; End Patch 92
	; End of ICD10 Updates
	;
	; "CPT MODIFIER: ",
	S RESULTS(50)=$G(R19(660,RMPRDA,38.1,"E"))
	; "DESCRIPTION: ",
	S RESULTS(51)=$G(R19(660,RMPRDA,24,"E"))
	; ,"EXTENDED DESCRIPTION: ",!
	N R28
	I $D(R19(660,RMPRDA,28)) D
	.;command part of new standards
	.MERGE R28=R19(660,RMPRDA,28)
	N CNT,LN
	S LN=0,CNT=52
	F  S LN=$O(R28(LN)) Q:LN'>0  D
	.S RESULTS(CNT)=R28(LN)
	.S CNT=CNT+1
	G EXIT
	;
HDR	;display heading
	S RESULTS(1)=RMPRNAM
	; " SSN: "
	S RESULTS(2)=$E(RMPRSSN,1,3)_"-"_$E(RMPRSSN,4,5)_"-"_$E(RMPRSSN,6,10)
	S RESULTS(3)=$G(R19(660,RMPRDA,8,"E"))
	; "DOB: "
	S RESULTS(4)=$S(RMPRDOB:$E(RMPRDOB,4,5)_"-"_$E(RMPRDOB,6,7)_"-"_(1700+$E(RMPRDOB,1,3)),1:"Unknown")
	Q
EXIT	;common exit point
	I '$D(RESULTS) S RESULTS(0)="NOTHING TO REPORT"
	K R19,RV,RMPRICC,RMPRERR,Y
	Q
	;end
