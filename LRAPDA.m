LRAPDA	;DALOI/STAFF - ANATOMIC PATH DATA ENTRY ;01/06/10  10:07
	;;5.2;LAB SERVICE;**72,73,91,121,248,259,295,317,365,350,422**;Sep 27, 1994;Build 29
	;
	; Reference to ^VA(200 supported by IA #10060
	;
	S LRDATA=0,LRAU=$S(LRSS'="AU":0,1:1)
	W !?20,LRO(68)," (",LRABV,")",!
	S:'$D(LRSOP) LRSOP=1 S:'$D(LRD(1)) LRD(1)="0"
	S:'$D(^LRO(69.2,LRAA,2,0)) ^(0)="^69.23A^0^0"
	;
SEL	K LR(1)
	I $D(LR(2)) D  G:%<1 END S:%=1 LR(1)=1
	. W !!,"Enter Etiology, Function, Procedure & Disease "
	. S %=2 D YN^LRU
	;
	;
AK	; from LRAPD1
	N CORRECT
	S:'$D(LRSFLG) LRSFLG=""
	W !!,"Data entry for ",LRH(0)," "
	S %=1 D YN^LRU G:%<1 END
	I %=2 D  G:Y<1 END S LRAD=$E(Y,1,3)_"0000",LRH(0)=$E(Y,1,3)+1700
	.S %DT="AE",%DT(0)="-N",%DT("A")="Enter YEAR: " D ^%DT K %DT
	I '$O(^LRO(68,LRAA,1,LRAD,1,0)) D  Q
	. W $C(7),!!,"NO ",LRO(68)," ACCESSIONS IN FILE FOR ",LRH(0),!!
W	;
	D LOOKUP^LRAPUTL(.LRDATA,LRH(0),LRO(68),LRSS,LRAD,LRAA)
	I LRDATA=-1!('$G(LRSEL))!('$D(LRI)) S LREND=1 Q
	S LRIDT=LRI
	I LRSEL=2 G:LRUID="" W D REST,OERR^LR7OB63D G W
	I LRSEL=3 D REST,OERR^LR7OB63D G W
	I LRSEL=1 D REST S:$D(DR(1))#2 DR=DR(1) D OERR^LR7OB63D G W
	;
	;
REST	;
	N LRXSTOP,LRX,LRX1
	;W "  for ",LRH(0)
	I '$D(^LRO(68,LRAA,1,LRAD,1,LRAN,0)) D  Q
	. W $C(7),!!,"Accession # ",LRAN," for ",LRH(0)," not in ",LRO(68),!!
	S X=^LRO(68,LRAA,1,LRAD,1,LRAN,0),LRLLOC=$P(X,"^",7),LRDFN=+X,LRODT=$P(X,"^",4),LRSN=$P(X,"^",5)
	Q:'$D(^LR(LRDFN,0))  S X=^(0) D ^LRUP
	;W !,LRP,"  ID: ",SSN
	S (LRIDT,LRI)=+$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),"^",5)
	I LRSS'="AU",'$D(^LR(LRDFN,LRSS,LRI,0)) D  Q
	. W $C(7),!,"Inverse date missing or incorrect in Accession Area file "
	. W "for",!,LRO(68),"  Year: ",$E(LRAD,2,3),"  Accession: ",LRAN
	;I "SPCYEM"[LRSS,$O(^LR(LRDFN,LRSS,LRI,.1,0)) D
	;.W !,"Specimen(s):"
	;.S X=0 F  S X=$O(^LR(LRDFN,LRSS,LRI,.1,X)) Q:'X  D
	;..W !,$P($G(^LR(LRDFN,LRSS,LRI,.1,X,0)),"^")
	;
	; Don't allow supp. report to be added to a released report if modifications are being added via MM option
	S LRXSTOP=0,(LRX,LRX1)=""
	I LRSS'="AU",LRD(1)="S" D
	. S LRX=$P($G(^LR(LRDFN,LRSS,LRI,0)),"^",11) ;release date/time
	. S LRX1=$P($G(^LR(LRDFN,LRSS,LRI,0)),"^",15) ;orig rel date/time
	I LRSS="AU",LRSOP="R" D
	. S LRX=$P($G(^LR(LRDFN,"AU")),"^",15)  ;release date/time
	. S LRX1=$P($G(^LR(LRDFN,"AU")),"^",3)  ;date report completed
	I 'LRX,LRX1 D
	. W $C(7),!!,"This "_$G(LRAA(1))_" report is currently being"
	. W !,"modified; it must first be released before Supplementary"
	. W !,"report can be added.",!
	. S LRXSTOP=1
	Q:LRXSTOP
	;
	;
DIE	;Edit
	I LRSS="AU" D  D AUE Q
	. S LRICDT=$P($G(^LR(LRDFN,"AU")),U,1),ICDFMT=1
	. S LRCDSYS=$S(LRICDT'<$$IMPDATE^LEXU("10D"):30,1:1),ICDSYS=LRCDSYS,LRDXV=LRDFN_";"_LRSS
	N LRRDT1,LRRDT2,LRIENS,LREL,LRQUIT,LRSNO,LRCPT,LRESCPT
	S (LREL,LRESCPT,LRQUIT,LRSNO,LRCPT)=0,LRIENS=LRI_","_LRDFN_","
	S LRRDT1=$$GET1^DIQ(LRSF,LRIENS,.11,"I")
	S LRRDT2=$$GET1^DIQ(LRSF,LRIENS,.15,"I")
	S LRICDT=$$GET1^DIQ(LRSF,LRIENS,.1,"I"),ICDFMT=1
	S LRCDSYS=$S(LRICDT'<$$IMPDATE^LEXU("10D"):30,1:1),ICDSYS=LRCDSYS,LRDXV=LRDFN_";"_LRSS_";"_LRI
	S:LRRDT1!LRRDT2 LREL=1
	; Determine if CPT activated
	I $T(ES^LRCAPES)'="" S LRESCPT=$$ES^LRCAPES()
	I LRSOP="G",LREL D  Q
	. W $C(7),!!,"Report verified.  Cannot edit with this option."
	I LRSOP'="","ABM"[LRSOP,LREL D  Q:LRQUIT
	.  ;Allow SNOMED and CPT coding even after release.
	. W $C(7),!!,"Report has been verified.  "
	. I 'LRESCPT,LRSOP'="B" D  Q
	. . W "Cannot edit with this option."
	. . S LRQUIT=1
	. W "Only "
	. I LRESCPT W "CPT " W:LRSOP="B" "and "
	. W:LRSOP="B" "SNOMED "
	. W "coding permitted.",!
	. I LRSOP="B" D
	. . K DIR S DIR(0)="Y",DIR("A")="Enter SNOMED coding",DIR("B")="NO"
	. . D ^DIR W !
	. . S LRSNO=+Y
	. Q:'LRESCPT
	. K DIR S DIR(0)="Y",DIR("A")="Enter CPT coding",DIR("B")="NO"
	. D ^DIR W !
	. S LRCPT=+Y
	. I "AM"[LRSOP,'LRCPT S LRQUIT=1 Q
	. I LRSOP="B",'LRCPT,'LRSNO S LRQUIT=1
	;
	;
RESET	; Reset DR string if altered by prior accession/patient
	; Reset DR to orig value in LRAPD1
	I LRSOP'="","AMBS"[LRSOP,$G(LRD)'="" D @LRD
	I LRSFLG="S",$G(LRD)'="" D @LRD  ;For CY,EM Supp entry
	S:LRSNO DR=10    ;Modify DR string if only SNOMED coding permitted
	I 'LRSNO,LRCPT S DR=""  ;Set DR string to null in only CPT coding
	; If adding supp rpt to released rpt, remove date rpt completed from DR
	I LRRDT1,LRSOP="S"!(LRSFLG="S") S DR=".09///^S X=LRWHO;10"
	;
EDIT	; Call to ^DIE
	W !
	S LRA=^LR(LRDFN,LRSS,LRI,0),LRRC=$P(LRA,"^",10)
	I LRCAPA,"SPCYEM"[LRSS D C^LRAPSWK
	S DIE="^LR(LRDFN,LRSS,",DA=LRI,DA(1)=LRDFN
	D CK^LRU Q:$D(LR("CK"))
	I LRSS="SP",LRSOP="B",$O(^LR(LRDFN,LRSS,LRI,1.3,0)) D
	. W $C(7),!!,"This accession has a FROZEN SECTION report."
	. W !,"Be sure 'FROZEN SECTION' is entered as a SNOMED code in the PROCEDURE field"
	. W !,"for the appropriate organ or tissue.",!!
	; Code S LRELSD is in DR string setup in LRAPR
	N LRELSD S LRELSD=0
	D ^DIE
	;
	; Ask for performing laboratory assignment
	I LRSFLG'="S" D EDIT^LRRPLU(LRDFN,LRSS,LRI)
	;
	; Update accession and order file, releasing facility and send CPRS alerts
	I LRELSD D
	. D ACCCOMP^LRAPRES
	. I LRSS'="AU" D
	. . D SETRL^LRVERA(LRDFN,LRSS,LRI,DUZ(2))
	. . D MAIN^LRAPRES1(LRDFN,LRSS,LRI,LRSF,LRP,$P(LRA,"^",6))
	;
	; Update clinical reminders
	D UPDATE^LRPXRM(LRDFN,LRSS,LRI)
	;
	D:LRSFLG="S"&('$D(Y)) ^LRAPDSR
	D FRE^LRU
	I LRSOP'="","ABM"[LRSOP D CPTCOD
	;
WKLD	; Capture Workload
	I LRSOP="Z","CYSP"[LRSS,LRCAPA D S^LRAPR Q
	I LRCAPA,"SPCYEM"[LRSS,LRD(1)'="","MBA"[LRD(1) D C1^LRAPSWK
	I LRCAPA,"SPCYEM"[LRSS,LRSOP="G" D C1^LRAPSWK
	;
QUEUES	; Update Queues
	S X=$P(^LR(LRDFN,LRSS,LRI,0),"^",4)
	I X,$D(^VA(200,X,0)) S LR("TR")=$P(^(0),"^")
	I "CYEMSP"[LRSS,$D(LR(6)),LRSOP="G" Q:$D(^LRO(69.2,LRAA,1,LRAN,0))  D  Q
	. L +^LRO(69.2,LRAA,1):DILOCKTM I '$T D  Q
	. . N MSG
	. . S MSG(1)="The preliminary reports queue is in use by another person.",MSG(1,"F")="!!"
	. . S MSG(2)="  You will need to add this accession to the queue later."
	. . D EN^DDIOL(.MSG)
	. S ^LRO(69.2,LRAA,1,LRAN,0)=LRDFN_"^"_LRI_"^"_LRH(0)
	. S X=^LRO(69.2,LRAA,1,0),^(0)=$P(X,"^",1,2)_"^"_LRAN_"^"_($P(X,"^",4)+1)
	. L -^LRO(69.2,LRAA,1)
	I "CYEMSP"[LRSS,$D(LR(7)),'$D(^LRO(69.2,LRAA,2,LRAN,0)),LRD(1)'="S" D
	. L +^LRO(69.2,LRAA,2):DILOCKTM I '$T D  Q
	. . N MSG
	. . S MSG(1)="The final reports queue is in use by another person.  ",MSG(1,"F")="!!"
	. . S MSG(2)="You will need to add this accession to the queue later."
	. . D EN^DDIOL(.MSG)
	. S ^LRO(69.2,LRAA,2,LRAN,0)=LRDFN_"^"_LRI_"^"_LRH(0)
	. S X=^LRO(69.2,LRAA,2,0),^(0)=$P(X,"^",1,2)_"^"_LRAN_"^"_($P(X,"^",4)+1)
	. L -^LRO(69.2,LRAA,2)
	D:LRSOP="M"!(LRSOP="B") EN^LRSPGD
	Q
	;
	;
NM	;
	I X'["@"!(X["@"&(Y(Z)="")) D  Q
	.W $C(7),!?4,"ENTER WHOLE NUMBERS ONLY",! K X
	I Y(Z)'="" W $C(7),?40,"OK TO DELETE" S %=2 D YN^LRU I %'=1 K X Q
	S Y(Z)="" Q
	;
	;
AUE	; Autopsy Data Entry
	W !
	N LREL,LRQUIT,LRSNO,LRESCPT,LRCPT
	S (LREL,LRQUIT,LRSNO,LRCPT)=0
	S LREL=+$$GET1^DIQ(63,LRDFN_",",14.7,"I")
	; Determine if CPT activated
	I $T(ES^LRCAPES)'="" S LRESCPT=$$ES^LRCAPES()
	; Allow supp report to be added on verified AU
	I LRSOP'="","AFIP"[LRSOP,LREL D  Q:LRQUIT
	. Q:LRESCPT&("AP"[LRSOP)
	. W $C(7),!!,"Report verified.  Cannot edit with this option!"
	. S LRQUIT=1
	I LRSOP'="","ABP"[LRSOP,LREL D  Q:LRQUIT
	. W $C(7),!!,"Report has been verified.  "
	. W "Only "
	. I LRESCPT W "CPT " W:LRSOP="B" "and "
	. W:LRSOP="B" "SNOMED "
	. W "coding permitted.",!
	. I LRSOP="B" D
	. . K DIR S DIR(0)="Y",DIR("A")="Enter SNOMED coding",DIR("B")="NO"
	. . D ^DIR W !
	. . S LRSNO=+Y
	. Q:'LRESCPT
	. K DIR S DIR(0)="Y",DIR("A")="Enter CPT coding",DIR("B")="NO"
	. D ^DIR W !
	. S LRCPT=+Y
	. I "AP"[LRSOP,'LRCPT S LRQUIT=1 Q
	. I LRSOP="B",'LRCPT,'LRSNO S LRQUIT=1
	;
AURESET	; Reset DR to orig value in LRAUDA
	I LRSOP'="","AP"[LRSOP D @(LRSOP_"DR^LRAUDA")
	I LRSOP="B" D BDR^LRAUDA
	S:LRSNO DR=32       ;Modify DR string if only SNOMED coding permitted
	I 'LRSNO,LRCPT S DR=""  ;Set DR string to null inf only CPT coding
	;                              ;
	; Not all of the autopsy fields are within the AU subscript.
	; Therefore, we must lock the entire LRDFN.
	L +^LR(LRDFN):DILOCKTM I '$T D  Q
	. S MSG="This record is locked by another user.  "
	. S MSG=MSG_"Please wait and try again."
	. D EN^DDIOL(MSG,"","!!") K MSG
	I LRSFLG'="S" D
	. N LRELSD S LRELSD=0
	. S DIE="^LR(",DA=LRDFN
	. D ^DIE
	. S LRA=^LR(LRDFN,"AU"),LRI=$P(LRA,U),LRAC=$P(LRA,U,6)
	. I LRELSD D MAIN^LRAPRES1(LRDFN,LRSS,LRI,LRSF,LRP,LRAC)
	;
	D:LRSFLG="S" ^LRAPDSR
	;
	; Ask for performing laboratory assignment
	W !! D EDIT^LRRPLU(LRDFN,LRSS,LRI)
	;
	D UPDATE^LRPXRM(LRDFN,"AU")
	L -^LR(LRDFN)
	D:"BAP"[LRSOP AU
	D:LRSOP="R" R
	I LRSOP'="","ABP"[LRSOP D CPTCOD
	Q
	;
	;
AU	I '$D(^LRO(69.2,LRAA,2,LRAN,0)) D
	.L +^LRO(69.2,LRAA,2):DILOCKTM I '$T D  Q
	..S MSG(1)="The final reports queue is in use by another person.  "
	..S MSG(1,"F")="!!"
	..S MSG(2)="You will need to add this accession to the queue later."
	..D EN^DDIOL(.MSG) K MSG
	.S ^LRO(69.2,LRAA,2,LRAN,0)=LRDFN
	.S X=^LRO(69.2,LRAA,2,0),^(0)=$P(X,"^",1,2)_"^"_LRAN_"^"_($P(X,"^",4)+1)
	.L -^LRO(69.2,LRAA,2)
	D AU^LRSPGD
	Q
	;
	;
R	I '$D(^LRO(69.2,LRAA,3,LRAN,0)) D
	. L +^LRO(69.2,LRAA,3):DILOCKTM I '$T D  Q
	. . S MSG(1)="The interim reports queue is in use by another person.  "
	. . S MSG(1,"F")="!!"
	. . S MSG(2)="You will need to add this accession to the queue later."
	. . D EN^DDIOL(.MSG) K MSG
	. S ^LRO(69.2,LRAA,3,LRAN,0)=LRDFN
	. S X=^LRO(69.2,LRAA,3,0),^(0)=$P(X,"^",1,2)_"^"_LRAN_"^"_($P(X,"^",4)+1)
	. L -^LRO(69.2,LRAA,3)
	Q
	;
	;
PNAME	; Patient Name Lookup
	; LRPFLG tells LRUPS to limit accessions to the chosen year.
	N LRPFLG
	S X=LRPNM,LRPFLG=1
	K LRPNM,DIC,VADM,VAIN,VA
	S DFN=-1,DIC(0)="EQM",(LRX,LRDPF)=""
	D:'$D(LRLABKY) LABKEY^LRPARAM
	D DPA1^LRDPA
	I DFN=-1 S LRAN=-1 Q
	D I^LRUPS
	Q
	;
	;
CPTCOD	; CPT Coding
	N LRPRO
	Q:$T(CPT^LRCAPES)=""
	Q:LREL&('LRCPT)
	I 'LREL D
	. K DIR S DIR(0)="Y",DIR("A")="Enter CPT coding",DIR("B")="NO"
	. D ^DIR W !
	. S LRCPT=+Y
	Q:'LRCPT
	; SET PROVIDER TO CURRENT USER, ALLOW UPDATES
	S LRPRO=DUZ
	D PROVIDR^LRAPUTL
	Q:LRQUIT
	D CPT^LRCAPES(LRAA,LRAD,LRAN,LRPRO)
	Q
	;
	;
END	K LRSFLG,LRICDT,LRCDSYS,ICDSYS,ICDFMT,LRDXV
	D:$T(CLEAN^LRCAPES)'="" CLEAN^LRCAPES
	D V^LRU
	Q
	;
