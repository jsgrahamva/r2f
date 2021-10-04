DGBTRDVW	;ALB/RFE - BENEFICIARY/TRAVEL UTILITY ROUTINES; 07/03/12
	;;1.0;Beneficiary Travel;**20,25**;September 25, 2001;Build 12
	Q
WAIV(DFN,DGBTDTI)	;
	N %H,DED,I,TRIP,TRIPCT,RETURN,DGBTDW,EXPDT,FUTURE,FDED,WAIVER
	;Return values: total number of trips ^ number of one way trips ^ number of round trips ^ deductible (all this for the month)^ waiver y/n (y will be 1, n will be no) ^ type of wavier i.e MAN for manual, PENSION etc. ^
	;total number of trips as of this claim date ^ deductible as of this claim date
	S TRIP=$$TRIP
	S WAIVER=$$WAIVYN
	S RETURN=TRIP_WAIVER_U_(TRIPCT-FUTURE)_U_(DED-FDED)
	Q RETURN
	;
TRIP()	;
	N DTRAY,I,TRIPS,TRIPTYP,MONTH,DGBTDT,ACCTYPE,DGBTEND
	S (DED,TRIPCT,FUTURE,FDED)=0
	F I=0:1:2 S TRIPS(I)=0
	S DGBTEND=$E(DGBTDTI,1,5)+1_"00"
	S (MONTH,DGBTDT)=$E(DGBTDTI,1,5)_"00"
	;F  S DGBTDT=$O(^DGBT(392,"C",DFN,DGBTDT)) Q:DGBTDT=""!(DGBTDT>DGBTDTI)  D
	F  S DGBTDT=$O(^DGBT(392,"C",DFN,DGBTDT)) Q:DGBTDT=""!(DGBTDT'<DGBTEND)  D
	.I (DGBTDT=DGBTDTI)&($G(CHZFLG)=0) Q
	.Q:$$GET1^DIQ(392,DGBTDT,56,"I")="S"
	.I $$GET1^DIQ(392,DGBTDT,45.2,"I")=1 Q
	.I $D(DTRAY(DGBTDT)) Q  ;dbe patch DGBT*1*25
	.S ACCTYPE=$$GET1^DIQ(392.3,$$GET1^DIQ(392,DGBTDT,6,"I"),5,"I")
	.I ACCTYPE="" Q
	.I 45'[ACCTYPE Q
	.S DTRAY(DGBTDT)="" ;dbe patch DGBT*1*25
	.S DED=DED+$$GET1^DIQ(392,DGBTDT,9)
	.S TRIPTYP=+$$GET1^DIQ(392,DGBTDT,31,"I")
	.S TRIPS(TRIPTYP)=TRIPS(TRIPTYP)+1
	.S TRIPCT=TRIPCT+TRIPTYP
	.I ($G(CHZFLG))&($P(DGBTDT,".")=$P(DGBTDTI,".")) S FUTURE=FUTURE+TRIPTYP,FDED=FDED+$$GET1^DIQ(392,DGBTDT,9,"I")
	Q TRIPCT_U_TRIPS(1)_U_TRIPS(2)_U_DED_U
WAIVYN()	;
	I DED'<18 Q "1^DED^"
	I TRIPCT>6 Q "1^TRIPS^"
	I '$D(DGBTINCA) N DGBTINCA,DGBTERR D GA^DGBTUTL(DFN,"DGBTINCA",DGBTDTI)
	I DGBTINCA Q "1^ALTINC^"
	I $$MANRQ Q "1^MAN^"_EXPDT
	I '$D(VAEL) N VAEL,VAERR D ELIG^VADPT
	I $$PENSION Q "1^PENSION^"
	;I '$D(DGBTDEP) N DGBTDEP S DGBTDEP=$$DEP^VAFMON(DFN,DGBTDTI)
	;I '$D(DGBTNSC) N DGBTNSC S DGBTNSC=$$NSC^DGBTUTL
	;I '$D(DGBTINC) N DGBTINC S DGBTINC=$$INCOME^VAFMON(DFN,DGBTDTI,1)
	;I '$D(DGBTMTTH) N DGBTMTTH S DGBTMTTH=$$MTTH^DGBTMTTH(DGBTDEP,DGBTDTI)
	;I (DGBTNSC)&(+$TR($P(DGBTINC,U),"$,","")<DGBTRXTH) Q "1^NSC^"
	;I '(DGBTNSC)&(+$G(VAEL(3)))&(+$TR($P(DGBTINC,U),"$,","")<DGBTMTTH) Q "1^LI^"
	;I '(DGBTNSC),+$$LI^DGBTUTL(DFN,DGBTDTI,DGBTDEP,,DGBTINCA)'=0 Q "1^LI^"
	Q 0_"^^"
MANRQ()	; Manual waiver request
	I '$D(^DGBT(392.7,"C",DFN)) Q 0_"^"
	N STDT
	S (DGBTDW,I)=""
	F  S I=$O(^DGBT(392.7,"C",DFN,I),-1) Q:I=""  D  Q:DGBTDW'=""
	.I $$GET1^DIQ(392.7,I,97,"I") Q
	.S STDT=$$GET1^DIQ(392.7,I,.01,"I")
	.I STDT>DGBTDTI S DGBTDW=0 Q
	.S EXPDT=$$GET1^DIQ(392.7,I,8,"I")
	.I EXPDT="PENSION" S DGBTDW=1 Q
	.I $E(I,1,3)=$E(DGBTDTI,1,3) S DGBTDW=^DGBT(392.7,I,0) Q
	.I $E(I,1,3)'=($E(DGBTA,1,3)-1) Q
	.I $$GET1^DIQ(392.7,I,8,"I")<$P(DGBTDTI,".") Q
	.S DGBTDW=^DGBT(392.7,I,0)
	I DGBTDW="" Q 0
	I $$GET1^DIQ(392.7,I,3)="NO" Q 0
	I $G(EXPDT)="PENSION" Q 1
	I $P(DGBTDTI,".")<$P($P(DGBTDW,U),".") Q 0
	I $G(EXPDT)?7N S EXPDT=$$DTFORM^DGBT1(EXPDT)
	Q DGBTDW
PENSION()	;
	I '$D(VAEL) N VAEL,VAERR D ELIG^VADPT
	I VAEL(1)["PENSION" Q 1
	I $P(VAEL(1),"^",2)="AID & ATTENDANCE" Q 1
	I $P(VAEL(1),"^",2)="HOUSEBOUND" Q 1
	N HIT
	S (HIT,I)=""
	F  S I=$O(VAEL(1,I)) Q:I=""  D  Q:HIT
	.I VAEL(1,I)["PENSION" S HIT=1 Q
	.I $P(VAEL(1,I),"^",2)="AID & ATTENDANCE" S HIT=1 Q
	.I $P(VAEL(1,I),"^",2)="HOUSEBOUND" S HIT=1 Q
	Q HIT