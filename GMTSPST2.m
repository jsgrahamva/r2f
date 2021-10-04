GMTSPST2	;BIR/RMS - MED RECON TOOL #2 (MEDICATION WORKSHEET) ; 6/13/11 12:37pm
	;;2.7;Health Summary;**92,100**;Oct 20, 1995;Build 3
	;
	;Reference to COVER^ORWPS supported by DBIA 4926
	;Reference to $$OI^ORX8 supported by DBIA 2467
	;Reference to $$VALUE^ORCSAVE2 supported by DBIA 2747
	;Reference to TEXT^ORQ12 supported by DBIA 4202
	;
TOOL2	N DAYSEP,DRUGHDR1,DRUGHDR2,DRUGSEP,INSTSEP1,INSTSEP2
	N EMPTYLN,PRETYPE,SUPTYPE,PSOQPEND
	N BLNKLN,IDRUG,ISIG,ITYPE
	N NVA,PAGE,PGWIDTH,PGLENGTH,GMTS59
	N RXIEN,SIGCNT,SIGPOS,XPOS1,XPOS2,XPOS4
	N RPTDATE,SUPCNT,SUPDRUG,VADM
	S GMTS59=$$PSOSITE
	S PGWIDTH=IOM-5,PGLENGTH=IOSL-9
	Q:PGWIDTH<48  ;ensure that the IOM variable is wide enough
	S RPTDATE=$$FMTE^XLFDT($$NOW^XLFDT,"1D")
	S XPOS1=(PGWIDTH-26)\2  ;title
	S XPOS2=PGWIDTH-6       ;page number
	S XPOS4=(PGWIDTH-53)\2  ;refill info
	S $P(BLNKLN," ",PGWIDTH)=" "
	S EMPTYLN="!,""|"_$E(BLNKLN,1,PGWIDTH-2)_"|"""
	S DAYSEP="|       |       |       |       |"
	S DRUGHDR1="|                 |MORNING| NOON  |EVENING|BEDTIME|       COMMENTS"
	S DRUGHDR1=DRUGHDR1_$E(BLNKLN,$L(DRUGHDR1),PGWIDTH-2)_"|"
	S DRUGHDR2="|                 "_DAYSEP
	S DRUGHDR2=DRUGHDR2_$E(BLNKLN,$L(DRUGHDR2),PGWIDTH-2)_"|"
	S $P(DRUGSEP,"~",PGWIDTH-2)="~"
	S DRUGSEP="|"_DRUGSEP_"|"
	S $P(INSTSEP1,"-",PGWIDTH-2)="-"
	S INSTSEP1="|"_INSTSEP1_"|"
	S INSTSEP2="| UNITS PER DOSE: "_DAYSEP
	S INSTSEP2=INSTSEP2_$E(BLNKLN,$L(INSTSEP2),PGWIDTH-2)_"|"
	S PAGE=1
	D CKP^GMTSUP Q:$D(GMTSQIT)
	D HD,SHOW(DFN)
	Q
SHOW(DFN)	;
	N LIST,NVA
	D COVER^ORWPS(.LIST,DFN)
	D GETOPORD(.LIST)
	D GETRXDAT(.LIST)
	S SUPTYPE=0,PRETYPE="D"
	S ITYPE="@"
	F  S ITYPE=$O(LIST(ITYPE)) Q:ITYPE]"ZZZ"  Q:ITYPE=""  D
	. I PRETYPE'=ITYPE D
	. . W !,DRUGSEP
	. . W @EMPTYLN
	. . W !,"|","SUPPLY ITEMS:"_$E(BLNKLN,14,PGWIDTH-2)_"|"
	. . S PRETYPE=ITYPE
	. . I (ITYPE="S")&(SUPTYPE=0) D
	. . . S SUPTYPE=1,SUPCNT=0,SUPDRUG=""
	. . . F  S SUPDRUG=$O(LIST(ITYPE,SUPDRUG)) Q:SUPDRUG=""  D
	. . . . S SUPCNT=SUPCNT+1
	. . . I $Y>(PGLENGTH-SUPCNT) W !,DRUGSEP,@IOF D HD
	. S IDRUG=""
	. F  S IDRUG=$O(LIST(ITYPE,IDRUG)) Q:IDRUG=""  D
	. . S SIGCNT=0,SIGPOS=""
	. . F  S SIGPOS=$O(LIST(ITYPE,IDRUG,SIGPOS)) Q:SIGPOS=""  D
	. . . S SIGCNT=SIGCNT+1
	. . I $Y>(PGLENGTH-SIGCNT) W !,DRUGSEP,@IOF D HD
	. . W:'SUPTYPE !,DRUGSEP,@EMPTYLN
	. . W !,"|",IDRUG_$E(BLNKLN,$L(IDRUG),PGWIDTH-3)_"|"
	. . Q:SUPTYPE
	. . S ISIG=0
	. . F  S ISIG=$O(LIST(ITYPE,IDRUG,ISIG)) Q:ISIG<1  D
	. . . W !,"|     ",LIST(ITYPE,IDRUG,ISIG),$E(BLNKLN,$L(LIST(ITYPE,IDRUG,ISIG)),PGWIDTH-8),"|"
	. . W !,INSTSEP1,!,INSTSEP2
NVA	;
	I $D(NVA) D
	. N NVACNT,NVADRUG
	. W !,DRUGSEP
	. W @EMPTYLN
	. W !,"|","NON-VA Medications:"_$E(BLNKLN,20,PGWIDTH-2)_"|"
	. W @EMPTYLN
	. S NVACNT=0
	. S NVADRUG=""
	. F  S NVADRUG=$O(NVA(NVADRUG)) Q:NVADRUG=""  D
	. . S NVACNT=NVACNT+1
	. . I $Y>(PGLENGTH-NVACNT) W !,DRUGSEP,@IOF D HD
	. . W !,"|",NVADRUG_$E(BLNKLN,$L(NVADRUG),PGWIDTH-3)_"|"
	K NVACNT,NVADRUG
	W !,INSTSEP1
	D
	. Q:'$G(PSOQPEND)
	. W !!,"Any medication items listed as ""pending"" are those that have just been" D CKP^GMTSUP Q:$D(GMTSQIT)
	. W !,"written by your provider(s).  These medication orders will be reviewed" D CKP^GMTSUP Q:$D(GMTSQIT)
	. W !,"by your pharmacist, prior to the prescription(s) being dispensed.  When" D CKP^GMTSUP Q:$D(GMTSQIT)
	. W !,"you receive your new prescription(s), by mail or from the pharmacy window," D CKP^GMTSUP Q:$D(GMTSQIT)
	. W !,"be sure to follow the instructions on the prescription label.  If you" D CKP^GMTSUP Q:$D(GMTSQIT)
	. W !,"have any question about your medication, please call your provider or " D CKP^GMTSUP Q:$D(GMTSQIT)
	. W !,"your pharmacist." D CKP^GMTSUP Q:$D(GMTSQIT)
	Q
GETOPORD(ORDLIST)	;
	N LISTIEN,KILLORD
	S LISTIEN=0
	F  S LISTIEN=$O(ORDLIST(LISTIEN)) Q:LISTIEN<1  D
	. S KILLORD=$$IPORD(ORDLIST(LISTIEN))
	. I 'KILLORD S KILLORD=$$CKSTATUS(ORDLIST(LISTIEN))
	. K:KILLORD ORDLIST(LISTIEN)
	Q
IPORD(LISTNODE)	;
	N RETURN,PKG
	S RETURN=0
	S PKG=$P($P(LISTNODE,"^",1),";",2)
	I "UI"[PKG S RETURN=1
	I $P(LISTNODE,"^",1)["N;" D
	. S:$P(LISTNODE,"^",4)="ACTIVE" NVA($P(LISTNODE,"^",2),+LISTNODE)=LISTNODE
	. S RETURN=1
	Q RETURN
CKSTATUS(LISTNODE)	;
	N RETURN,RXIEN
	S RETURN=0 ; ASSUME ACTIVE AND NOT PASS MED
	S:$P(LISTNODE,"^",4)["DISCONTINUED" RETURN=1
	S:$P(LISTNODE,"^",4)["EXPIRED" RETURN=1
	Q RETURN
GETRXDAT(RXS)	;
	N RXSIEN,DRUGNAME,FSIG,RXTYPE
	S RXSIEN=0
	F  S RXSIEN=$O(RXS(RXSIEN)) Q:RXSIEN<1  D
	. I $P(RXS(RXSIEN),";")["P" D GETPEND(RXSIEN) S PSOQPEND=1 Q  ;-> 
	. S RXIEN=+RXS(RXSIEN)
	. K FSIG
	. S DRUGNAME=$$DRUGNAME(RXIEN)
	. I $P(RXS(RXSIEN),U,4)="HOLD" S DRUGNAME=DRUGNAME_" (**Rx Status=HOLD**)"
	. S RXTYPE=$$GETTYPE(RXIEN)
	. N SIGLINE,DIWF,DIWL,X
	. K ^UTILITY($J,"W")
	. S DIWF="C"_(PGWIDTH-8),DIWL=1
	. S SIGLINE=0 F  S SIGLINE=$O(^TMP($J,"GMTSPSRX",DFN,RXIEN,"M",SIGLINE)) Q:'+SIGLINE  D
	.. S X=^TMP($J,"GMTSPSRX",DFN,RXIEN,"M",SIGLINE,0)
	.. D ^DIWP
	. S SIGLINE=0 F  S SIGLINE=$O(^UTILITY($J,"W",1,SIGLINE)) Q:'+SIGLINE  D
	.. S FSIG(SIGLINE)=^UTILITY($J,"W",1,SIGLINE,0)
	. M RXS(RXTYPE,DRUGNAME)=FSIG
	. N PSOQSUB,REFILLS
	. S PSOQSUB=$O(RXS(RXTYPE,DRUGNAME,":"),-1)+1
	. S REFILLS=^TMP($J,"GMTSPSRX",DFN,RXIEN,9)-($S(^TMP($J,"GMTSPSRX",DFN,RXIEN,"RF",0)>0:^TMP($J,"GMTSPSRX",DFN,RXIEN,"RF",0),1:0))
	. S RXS(RXTYPE,DRUGNAME,PSOQSUB)=REFILLS_" refill(s) remaining prior to "_$$FMTE^XLFDT(^TMP($J,"GMTSPSRX",DFN,RXIEN,26))_" (Rx #"_^TMP($J,"GMTSPSRX",DFN,RXIEN,.01)_")"
	. K ^TMP($J,"GMTSPSRX"),^UTILITY($J,"W"),REFILLS
	Q
DRUGNAME(RXIEN)	;
	N DRUGIEN,DRUGNM,DRUGND1,DRUGND3,DRUGVAPN
	D RX^PSO52API(DFN,"GMTSPSRX",RXIEN,,"0,2,3,R,M")
	I ^TMP($J,"GMTSPSRX",DFN,RXIEN,6.5)]"" Q ^TMP($J,"GMTSPSRX",DFN,RXIEN,6.5)
	S DRUGIEN=+^TMP($J,"GMTSPSRX",DFN,RXIEN,6)
	S DRUGNM=$P(^TMP($J,"GMTSPSRX",DFN,RXIEN,6),U,2)
	D NDF^PSS50(DRUGIEN,,,,,"GMTSNDF")
	S DRUGND1=+^TMP($J,"GMTSNDF",DRUGIEN,20)
	S DRUGND3=+^TMP($J,"GMTSNDF",DRUGIEN,22)
	I DRUGND1,DRUGND3 S DRUGVAPN=$P($$PROD2^PSNAPIS(DRUGND1,DRUGND3),U)
	K ^TMP($J,"GMTSNDF")
	I $G(DRUGVAPN)]"" Q DRUGVAPN
	Q DRUGNM
GETPEND(RXSIEN)	;
	N PSOQPDN,PSOQDIND,PSOQ100,PSOQSCT,GMTSPST2
	S PSOQ100=$P(RXS(RXSIEN),U,3) Q:'+PSOQ100
	S PSOQPDN=$P($$OI^ORX8(PSOQ100),U,2)
	S PSOQDIND=$$VALUE^ORCSAVE2(PSOQ100,"DRUG") D
	. Q:'+PSOQDIND
	. D DATA^PSS50(PSOQDIND,,,,,"GMTSPST2")
	. S PSOQPDN=$G(^TMP($J,"GMTSPST2",PSOQDIND,.01))
	D TEXT^ORQ12(.GMTSPST2,PSOQ100,65)
	F PSOQSCT=2:1:$O(GMTSPST2(":"),-1) S RXS("D","**PENDING** "_PSOQPDN,PSOQSCT)=GMTSPST2(PSOQSCT)
	K ^TMP($J,"GMTSPST2")
	Q
GETTYPE(RXIEN)	;
	N RETURN,CLASS,DRUG
	S RETURN="D"
	S DRUG=+^TMP($J,"GMTSPSRX",DFN,RXIEN,6)
	D DATA^PSS50(DRUG,,,,,"GMTSPS50")
	S CLASS=^TMP($J,"GMTSPS50",DRUG,2)
	K ^TMP($J,"GMTSPS50")
	S:$E(CLASS,1,1)="X" RETURN="S"
	S:$E(CLASS,1,2)="DX" RETURN="S"
	Q RETURN
PSOSITE()	;DETERMINE APPROPRIATE 'OUTPATIENT SITE' (FILE #59) ENTRY
	K ^TMP($J,"GMTSA59")
	D PSS^PSO59(,"??","GMTSA59")
	N GMTS59,STANUM
	S GMTS59=0
	I $G(DUZ(2))]"" D
	. S STANUM=$$GET1^DIQ(4,DUZ(2),99)
	. S GMTS59=$$GETDIV(STANUM,"ST")
	I 'GMTS59 S GMTS59=$$GETDIV($$SITE^VASITE,"IN")
	I 'GMTS59 S GMTS59=$O(^TMP($J,"GMTSA59",0))
	Q GMTS59
GETDIV(STIN,TYPE)	;
	I $G(STIN)']"" Q 0
	N DIV,GETDIV
	S (DIV,GETDIV)=0
	F  S DIV=$O(^TMP($J,"GMTSA59",DIV)) Q:'+DIV  D
	. I TYPE="ST",^TMP($J,"GMTSA59",DIV,.06)=STIN S GETDIV=DIV
	. I TYPE="IN",^TMP($J,"GMTSA59",DIV,100)=STIN S GETDIV=DIV
	Q GETDIV
HD	;
	D 4^VADPT
	D PSS^PSO59(GMTS59,,"GMTSSITE")
	W !,"Date: ",RPTDATE,?XPOS1,"PATIENT MEDICATION INFORMATION"
	W ?XPOS2,"Page: ",PAGE
	S PAGE=PAGE+1
	W !,?XPOS4,"PRINTED BY THE VA MEDICAL CENTER AT: "_$P(^TMP($J,"GMTSSITE",GMTS59,100),U,2)
	W !,?XPOS4,"FOR PRESCRIPTION REFILLS CALL ("_^TMP($J,"GMTSSITE",GMTS59,.03)_") "_^TMP($J,"GMTSSITE",GMTS59,.04)
	W !!,"Name: ",$E(VADM(1),1,28)
	W ?30," PHARMACY - "_^TMP($J,"GMTSSITE",GMTS59,.01)_" DIVISION"
	I ^TMP($J,"GMTSSITE",GMTS59,.01)'=^TMP($J,"GMTSSITE",GMTS59,.07) W " ("_^TMP($J,"GMTSSITE",GMTS59,.07)_")"
	W !!,INSTSEP1,!,DRUGHDR1
	D KVA^VADPT
	K ^TMP($J,"GMTSSITE")
	Q
