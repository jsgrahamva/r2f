PSBVDLPA	;BIRMINGHAM/EFC-BCMA UNIT DOSE VIRTUAL DUE LIST FUNCTIONS ;3/1/13 1:13pm
	;;3.0;BAR CODE MED ADMIN;**5,16,13,38,32,58,70**;Mar 2004;Build 101
	;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified.
	;
	; called by PSBVDLUD to find patches not removed
	;
	; Reference/IA
	; $$GET^XPAR/2263
	; $$FMADD^XLFDT/10103
	; GETPROVL^PSGSICH1/5653
	; INTRDIC^PSGSICH1/5654
	;
	;*58 - add 29th piece to Results for Override/Intervention flag 1/0
	;*70 - add 30th piece for consistency with psbvdlud routine.
	;    - add 32nd piece for clinic name for CO meds and a patch.
	;    - add 33rd piece to Results for Clinic ien ptr to file #44
	;      
EN	;
	S PSBGNODE="^PSB(53.79,"_"""APATCH"""_","_DFN_")"
	F  S PSBGNODE=$Q(@PSBGNODE) Q:PSBGNODE']""  Q:($QS(PSBGNODE,2)'="APATCH")!($QS(PSBGNODE,3)'=DFN)  D
	.S PSBIEN=$QS(PSBGNODE,5)
	.I '$D(^PSB(53.79,PSBIEN,.5,1)) Q
	.I $P(^PSB(53.79,PSBIEN,.5,1,0),U,4)'="PATCH" Q
	.I "G"'[$P(^PSB(53.79,PSBIEN,0),U,9)!($D(PSBONVDL(PSBIEN))) Q
	.S PSBPBK=+($$GET^XPAR("DIV","PSB VDL PATCH DAYS"))
	.S PSBZON=$P(^PSB(53.79,PSBIEN,.1),"^")
	.D CLEAN^PSBVT
	.D PSJ1^PSBVT(DFN,PSBZON) Q:$G(PSBSCRT)=-1
	.;
	.I PSBPBK'=0 D NOW^%DTC I ($$FMADD^XLFDT($P(PSBOSP,"."),(PSBPBK))<X) Q
	.S $P(PSBREC,U,1)=DFN  ; dfn
	.S $P(PSBREC,U,2)=PSBONX  ; order numer
	.S $P(PSBREC,U,3)=PSBON  ; order ien
	.S $P(PSBREC,U,4)="U"  ; order type U unit dose
	.S $P(PSBREC,U,5)=PSBSCHT
	.S $P(PSBREC,U,6)=PSBSCH
	.S $P(PSBREC,U,7)=$S(PSBHSM:"HSM",PSBSM:"SM",1:"")
	.S $P(PSBREC,U,8)=PSBOITX
	.S $P(PSBREC,U,9)=PSBDOSE
	.S $P(PSBREC,U,10)=PSBMR
	.S:$D(PSBHSTAX(PSBOIT)) $P(PSBREC,U,11)=$O(PSBHSTAX(PSBOIT,""),-1),$P(PSBREC,U,20)=$O(PSBHSTAX(PSBOIT,$P(PSBREC,U,11),""),-1)
	.D:'$D(PSBHSTAX(PSBOIT))
	..N PSBX,PSBY,PSBDONE S PSBDONE=0,PSBX="" F  S PSBX=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,PSBX),-1) Q:PSBX=""  D:'PSBDONE
	...S PSBY="" F  S PSBY=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,PSBX,PSBY),-1) Q:PSBY=""  D:'PSBDONE
	....S:$P(^PSB(53.79,PSBY,0),U,9)'="N" $P(PSBREC,U,20)=$P(^PSB(53.79,PSBY,0),U,9) S:($P(PSBREC,U,20)'="N")&($P(PSBREC,U,20)]"") $P(PSBREC,U,11)=PSBX,PSBDONE=1
	.S $P(PSBREC,U,12)=PSBIEN
	.S $P(PSBREC,U,13)="G"
	.S $P(PSBREC,U,14)=$P(^PSB(53.79,PSBIEN,.1),U,3)
	.I $P(PSBREC,U,14)="" S $P(PSBREC,U,14)=PSBNOW\1
	.S $P(PSBREC,U,15)=PSBOIT
	.D:($G(PSBTAB)="CVRSHT")!($G(PSBTAB)="UDTAB")
	..S $P(PSBREC,U,16)=PSBNJECT            ;always send this flag   *70
	..I $P(PSBREC,U,9)?1.4N1"-"1.4N.E S $P(PSBREC,U,17)=1
	..E  S $P(PSBREC,U,17)=0
	..S $P(PSBREC,U,19)=$S(PSBVNI]"":PSBVNI,PSBVNI']"":"***")
	..S $P(PSBREC,U,23)=""
	..S $P(PSBREC,U,26)=PSBOSP
	..S $P(PSBREC,U,27)=$$LASTG^PSBCSUTL($P(PSBREC,U),$P(PSBREC,U,15))
	..S $P(PSBREC,U,28)=0
	..I ($G(PSBTAB)="CVRSHT") S $P(PSBREC,U,28)=1
	..I ($G(PSBTAB)="UDTAB") I PSBSCHT'="O" S:(PSBOSTS="E")!(PSBOSTS["D") $P(PSBREC,U,28)=1
	..;*58 determine if override or intervn exists, send 1/0 (true/false)
	..N PSBARR D GETPROVL^PSGSICH1(DFN,PSBONX,.PSBARR)
	..I $O(PSBARR(""))="" D INTRDIC^PSGSICH1(DFN,PSBONX,.PSBARR,2)
	..S $P(PSBREC,U,29)=$S($O(PSBARR(""))]"":1,1:0)
	..;add last site                                                  *70
	..K LI D RPC^PSBINJEC(.LI,DFN,PSBOIT,9999999,1)
	..S $P(PSBREC,U,30)=$P(LI(1),U,6) K LI   ;if no inj, 6th will be null
	..;    piece 31 special IVPB use in vdl's not for coversheet
	..I $G(PSBTAB)="CVRSHT" D      ;If from coversheet use offset -1  *70
	...S $P(PSBREC,U,31)=$G(PSBCLORD)             ;clinic name
	...S $P(PSBREC,U,32)=$G(PSBCLIEN)             ;clinic ien ptr
	..I $G(PSBTAB)="UDTAB" D       ;Else must be Unit does VDL calling
	...S $P(PSBREC,U,32)=$G(PSBCLORD)                  ;clinic name
	...S $P(PSBREC,U,33)=$G(PSBCLIEN)                  ;clinic ien ptr
	..;
	..; Place into Coversheet activity ARRAY
	..S PSBDIDX="" I $D(^PSB(53.79,"AORD",DFN,PSBONX)) D
	...S PSBXDTI="",PSBXDTI=$O(^PSB(53.79,"AORD",DFN,PSBONX,PSBXDTI),-1)
	...Q:'$D(^PSB(53.79,"AORD",DFN,PSBONX,PSBXDTI,PSBIEN))
	...S PSBADMX(PSBONX,PSBXDTI,PSBIEN)="",PSBDIDX=1
	..I ('PSBDIDX)&$D(^PSB(53.79,"AORDX",DFN,PSBONX)) D
	...S PSBXXDTI="",PSBXXDTI=$O(^PSB(53.79,"AORDX",DFN,PSBONX,PSBXXDTI),-1)
	...Q:'$D(^PSB(53.79,"AORDX",DFN,PSBONX,PSBXXDTI,PSBIEN))
	...S PSBADMX(PSBONX,PSBXXDTI,PSBIEN)=""
	.S $P(PSBREC,U,18)="PATCH"
	.S $P(PSBREC,U,21)=PSBOST
	.S $P(PSBREC,U,22)=PSBOSTS
	.S PSBDDS="" F Y=0:0 S Y=$O(PSBDDA(Y)) Q:'Y  S:$P(PSBDDA(Y),U,4)="" $P(PSBDDA(Y),U,4)=1 S PSBDDS=PSBDDS_U_$P(PSBDDA(Y),U,1,4),$P(PSBDDS,U,1)=PSBDDS+1
	.S PSBQRR=1
	.D ADD^PSBVDLU1(PSBREC,PSBOTXT,$P(PSBREC,U,14),PSBDDS,"","",$S($G(PSBTAB)="CVRSHT":"CVRSHT",1:"UDTAB"))
	K PSBPBK,PSBONVDL
	Q
