PXCEVFI1	;ISL/dee,esw - Routine to edit a visit or v-file entry ;06/22/2016
	;;1.0;PCE PATIENT CARE ENCOUNTER;**23,73,112,136,143,124,184,185,210,215,216**;Aug 12, 1996;Build 11
	Q
	;
EDIT	; -- edit the V-File stored in "AFTER"
	N DIR,DA,X,Y,C,PXCEINP,PXCEIN01,PXCEEND,PXD,PXCONTRA,PXJUST,PXVACK
	N PXCELINE,PXCETEXT,PXCEDIRB,PXCEMOD,PXVMISS,PXVRT,PXALERGY ; PX*1*216
	N PXCEKEY,PXCEIKEY,PXCENKEY,PXMDCNT
	W !
	G:PXCECAT="VST"!(PXCECAT="APPM")!(PXCECAT="CSTP") REST
	;
EDIT01	;
	I PXCECAT="CPT"!(PXCECAT="POV")!(PXCECAT="SK")!(PXCECAT="IMM") D SC^PXCEVFI2($P(^AUPNVSIT(PXCEVIEN,0),U,5))
	S PXCETEXT=$P($T(FORMAT+1^@PXCECODE),";;",2)
	K DIR,DA,X,Y,C,PXCEDIRB
	I $P(PXCEAFTR(0),"^",1) D
	. N DIEER,PXCEDILF,PXCEEXT
	. S PXCEEXT=$$EXTERNAL^DILFD(PXCEFILE,.01,"",$P(PXCEAFTR(0),"^",1),"PXCEDILF")
	. S PXCEDIRB=$S('$D(DIERR):PXCEEXT,1:$P(PXCEAFTR(0),"^",1))
	E  S PXCEDIRB=""
	I $P(PXCETEXT,"~",7)]"" D
	. D @$P(PXCETEXT,"~",7)
	E  D
	. I PXCEDIRB'="" S DIR("B")=PXCEDIRB
	. S DIR(0)=PXCEFILE_",.01OA"
	. S DIR("A")=$P(PXCETEXT,"~",4)
	. S:$P(PXCETEXT,"~",8)]"" DIR("?")=$P(PXCETEXT,"~",8)
	. I PXCECAT="IMM" D
	. . S DIR(0)="PAO^9999999.14:QEM"
	. . S DIR("S")="I $$IMMSEL^PXVUTIL(Y,$G(PXCEVIEN))"
	. D ^DIR
	I X="@" D  G ENDEDIT
	. N DIRUT
	. I $P(PXCEAFTR(0),"^",1)="" D
	.. W !,"There is no entry to delete."
	.. D WAIT^PXCEHELP
	. E  D DEL^PXCEVFI2(PXCECAT)
	I $D(DIRUT),$P(PXCEAFTR(0),"^",1)="" S PXCELOOP=1
	I $D(DIRUT) S PXCEQUIT=1 Q
	S (PXCEINP,PXD)=Y
	S PXCEIN01=X
	I $P(Y,"^",2)'=PXCEDIRB,$$DUP(PXCEINP) G EDIT01
	I PXCECAT="IMM" D  Q:PXCEQUIT  ; PX*1*215
	. S (PXCONTRA,PXVACK)=0,PXJUST="" D CONTRA^PXCEICR
	. I 'PXCONTRA S $P(PXCEAFTR(12),"^",20)="@",$P(PXCEAFTR(16),"^",1)="@" Q
	. I PXCONTRA,'PXVACK S PXCEQUIT=1 Q
	. I PXCONTRA,PXVACK D
	..S $P(PXCEAFTR(12),"^",20)=1
	..S $P(PXCEAFTR(16),"^",1)=PXJUST
	; for non-historicals stuff info source and require dose, dose unit, route or site ; PX*1*216
	I PXCECAT="IMM",'$$HIST,PXCEFIEN="" S $P(PXCEAFTR(13),"^")=1,PXVMISS=0 D REQ I PXVMISS S PXCEQUIT=1 Q  ; PX*1*216
	; send Adverse Reaction Tracking (ART) alert if allergy type in ^PXV(920.4 is selected ; PX*1*216
	I PXCECAT="ICR" I $P($P(PXCEINP,";",2),",")="PXV(920.4" S PXALERGY=($P($P(PXCEINP,";"),",")) I $$ARTAPI^PXVUTIL(PXALERGY) D ARTALERT ; PX*1*216
	;--File new CPT code and retrieve IEN
	I PXCECAT="CPT" D
	. S PXMDCNT=$$CODM^ICPTCOD(+Y,"^TMP(""PXMODARR"",$J",PXCESOR,+^TMP("PXK",$J,"VST",1,0,"AFTER"))
	. K ^TMP("PXMODARR",$J)
	. I $P(PXCEAFTR(0),"^",1)'=""!(PXMDCNT'>0) Q
	. N PXCEFIEN
	. D NEWCODE^PXCECPT
	. S ^TMP("PXK",$J,PXCECATS,1,"IEN")=PXCEFIEN
	I PXCECAT="PRV",$P(PXCEAFTR(0),"^",1)>0,PXCEDIRB]"" S $P(PXCEAFTR(0),"^",6)=""
	S $P(PXCEAFTR(0),"^",1)=$P(PXCEINP,"^")
	K DIR,DA
	;following code added per PX*185
	I $D(XQORNOD(0)) I $P(XQORNOD(0),U,4)="HF" D
	.N HFIEN,NODE
	.S HFIEN=$P(PXCEINP,U),NODE=$G(^AUTTHF(HFIEN,0))
	.Q:'$D(NODE)
	.I $P(NODE,U,8)'="Y" W !!,"WARNING:  This Health Factor is currently not set to",!?10,"display on a Health Summary report.",!!
	.K HFIEN,NODE
	.Q
	;
REST	S PXCEEND=0
	F PXCELINE=2:1 S PXCETEXT=$P($T(FORMAT+PXCELINE^@PXCECODE),";;",2) Q:PXCETEXT']""  D  Q:PXCEEND
	. I $P(PXCETEXT,"~",3)=.06,PXCECAT="ICR" Q  ; PX*1*215
	. I $P(PXCETEXT,"~",3)=1301,PXCECAT="IMM",'$$HIST Q  ; PX*1*215
	. I $P(PXCETEXT,"~",3)=1220,PXCECAT="IMM" Q  ; PX*1*215
	. I $P(PXCETEXT,"~",3)=1601,PXCECAT="IMM" Q  ; PX*1*215
	. I $P(PXCETEXT,"~",3)=1214,PXCECAT="SK" Q  ; PX*1*210
	. I $P(PXCETEXT,"~",3)=1406,PXCECAT="IMM" Q  ; PX*1*210
	. I $P(PXCETEXT,"~",3)=1207,PXCECAT="IMM",$$HIST Q  ; PX*1*216
	. I ($P(PXCETEXT,"~",3)=1302!($P(PXCETEXT,"~",3)=1303)!($P(PXCETEXT,"~",3)=1312)!($P(PXCETEXT,"~",3)=1313)),PXCECAT="IMM",PXCEFIEN="",'$$HIST Q  ; PX*1*216
	. I $P(PXCETEXT,"~",3)=1403 D  Q:PXCEEND  ; PX*1*210
	.. I PXCECAT'="IMM" S PXCEEND=1 Q  ; PX*1*210
	.. I +$G(PXD),'$P($G(^AUTTIMM(+PXD,.5)),"^") S PXCEEND=1 Q  ; PX*1*210
	. I $P(PXCETEXT,"~",9)]"",$P(PXCETEXT,"~",3)'=80201 S PXCEKEY="" D  Q:PXCEKEY'=1
	.. S PXCENKEY=$L($P(PXCETEXT,"~",9))
	.. F PXCEIKEY=1:1:PXCENKEY I PXCEKEYS[$E($P(PXCETEXT,"~",9),PXCEIKEY) S PXCEKEY=1 Q
	. K DIR,DA,X,Y,C
	. I $P(PXCETEXT,"~",7)]"" D
	.. D @$P(PXCETEXT,"~",7)
	. E  D
	.. I PXCECAT="IMM",$P(PXCETEXT,"~",3)=1303 S PXVRT=$P(PXCEAFTR(13),"^",2) D  Q:PXVRT=5  ; PX*1*216
	... I PXVRT=5,$P(PXCEAFTR(13),"^",3)'="" S $P(PXCEAFTR(13),"^",3)="@"
	.. I $P(PXCEAFTR($P(PXCETEXT,"~",1)),"^",$P(PXCETEXT,"~",2))'="" D
	... N DIERR,PXCEDILF,PXCEINT,PXCEEXT
	... S PXCEINT=$P(PXCEAFTR($P(PXCETEXT,"~",1)),"^",$P(PXCETEXT,"~",2))
	... S PXCEEXT=$$EXTERNAL^DILFD(PXCEFILE,$P(PXCETEXT,"~",3),"",PXCEINT,"PXCEDILF")
	... S DIR("B")=$S('$D(DIERR):PXCEEXT,1:PXCEINT)
	.. S DIR(0)=PXCEFILE_","_$P(PXCETEXT,"~",3)_"A"
	.. S DIR("A")=$P(PXCETEXT,"~",4)
	.. I PXCECAT="IMM",$G(DIR("B"))="" D DEF ; PX*1*215
	.. S:$P(PXCETEXT,"~",8)]"" DIR("?")=$P(PXCETEXT,"~",8)
	.. I PXCECAT="IMM",'$$HIST,$P(PXCETEXT,"~",3)=1303 D SITE Q  ; PX*1*216
	.. D ^DIR
	.. I PXCECAT="IMM",'$$HIST,$$REQF D MUST  ; PX*1*216
	.. K DIR,DA
	.. I X="@" S Y="@"
	.. E  I $D(DTOUT)!$D(DUOUT) S PXCEEND=1 S:PXCECAT="SIT"!(PXCECAT="APPM")!(PXCECAT="HIST")!(PXCECAT="CPT") PXCEQUIT=1 Q
	.. S $P(PXCEAFTR($P(PXCETEXT,"~",1)),"^",$P(PXCETEXT,"~",2))=$P(Y,"^")
	. I ($P(PXCETEXT,"~",3)=1202!($P(PXCETEXT,"~",3)=1204)) D:+Y>0 PROVIDER^PXCEVFI4(+Y)
	;
ENDEDIT	;
	Q
REQ	; prompt for dose, dose units, route and site for non-historical administrations ; PX*1*216
	N PXEXT,PXVF,PXVP
	K DIR S PXVP=12,PXVF=1312 D EXTB S DIR("A")="Dose",DIR(0)="9000010.11,1312" D ^DIR,MUST K DIR Q:PXVMISS
	S $P(PXCEAFTR(13),"^",12)=$P(Y,"^")
	S PXVP=13,PXVF=1313 D EXTB S DIR("A")="Dose Units",DIR(0)="9000010.11,1313" D ^DIR,MUST K DIR Q:PXVMISS
	S $P(PXCEAFTR(13),"^",13)=$P(Y,"^")
	S PXVP=2,PXVF=1302 D EXTB S DIR("A")="Route of Administration",DIR(0)="9000010.11,1302" D ^DIR,MUST K DIR Q:PXVMISS
	S ($P(PXCEAFTR(13),"^",2),PXVRT)=$P(Y,"^")
	Q:PXVRT=5
SITE	S PXVP=3,PXVF=1303 D EXTB
	I '$D(^PXV(920.6,PXVRT,0)) S DIR("A")="Site of Administration",DIR(0)="9000010.11,1303" D ^DIR,MUST K DIR Q:PXVMISS  S $P(PXCEAFTR(13),"^",3)=$P(Y,"^")
	I $D(^PXV(920.6,PXVRT,0)) D  D ^DIR,MUST K DIR,DA Q:PXVMISS  S $P(PXCEAFTR(13),"^",3)=$P(Y,"^",2)
	.S DA(1)=PXVRT,DIR("A")="Site of Administration",DIR(0)="P^PXV(920.6,"_PXVRT_",1,:QEMZ"
	.S DIR("?")="Select the site the vaccine was administered."
	Q
REQF()	; check if field is dose, dose unit, route or site ; PX*1*216
	N PXV294,PXVF
	S PXV294=0,PXVF=$P(PXCETEXT,"~",3)
	I PXVF=1312!(PXVF=1313)!(PXVF=1302)!(PXVF=1303) S PXV294=1
	Q PXV294
	;
MUST	; prompt for required entries if not entered ; PX*1*216
	S PXVMISS=0
	I X="@"!((Y="")) N PXVX S PXVX=$C(7)_"This is a required response. Enter '^' to exit." D EN^DDIOL(PXVX) D ^DIR
	I $D(DTOUT)!$D(DUOUT) S PXVMISS=1 Q
	I X="@"!((Y="")) D MUST
	Q
EXTB	; get external value for DIR("B") ; PX*1*216
	N PXVDEF,PXVFAC,PXVIMM
	Q:'$D(PXCEVIEN)
	S PXVFAC=$$INST^PXVRESP(PXCEVIEN) Q:'PXVFAC
	S PXVIMM=+$G(PXD) Q:'PXVIMM
	S PXVDEF=$P($G(^PXV(920.05,PXVFAC,1,PXVIMM,13)),"^",PXVP)
	S PXEXT=$$EXTERNAL^DILFD(PXCEFILE,PXVF,"",PXVDEF,"PXCEDILF")
	I PXEXT'="" S DIR("B")=PXEXT
	Q
DUP(PXCEINP)	; -- Check for dup entries.
	Q:PXCECAT="SIT"!(PXCECAT="APPM")!(PXCECAT="HIST") 0
	;
	N PXCEDUP,PXCEINDX,X,Y
	S PXCEDUP=0
	S PXCEINDX=""
	F  S PXCEINDX=$O(@(PXCEAUPN_"(""AD"",PXCEVIEN,PXCEINDX)")) Q:'PXCEINDX!PXCEDUP  S:+@(PXCEAUPN_"(PXCEINDX,0)")=+PXCEINP&(PXCEINDX'=PXCEFIEN) PXCEDUP=1
	I PXCEDUP D
	. I PXCEDUP
	. W !,$P(PXCEINP,"^",2)," is already a "_PXCECATT_" for this Encounter."
	. I PXCECAT="POV" W !!,"Duplicate Diagnosis Not Allowed." Q  ;PX/112
	. I PXCECAT="CPT",$$GET1^DIQ(357.69,$P(PXCEINP,"^",2),.01)>0 D  Q
	. . W !,"No duplicate E&M codes allowed."   ;PX/136
	. I $P($T(FORMAT^@PXCECODE),"~",4) D
	.. N DIR,DA
	.. S DIR(0)="Y"
	.. S DIR("A")="Do you want to add another "_$P(PXCEINP,"^",2)_""
	.. S DIR("B")="NO"
	.. D ^DIR
	.. S PXCEDUP='+Y
	Q PXCEDUP
	;
DEF	; get default response from file #920.05; PX*1*215
	N PXVDEF,PXVFAC,PXVIMM,PXCEEXT
	Q:'$D(PXCEVIEN)
	S PXVFAC=$$INST^PXVRESP(PXCEVIEN) Q:'PXVFAC
	S PXVIMM=+$G(PXD) Q:'PXVIMM
	S PXVDEF=$P($G(^PXV(920.05,PXVFAC,1,PXVIMM,$P(PXCETEXT,"~",1))),"^",$P(PXCETEXT,"~",2))
	S PXCEEXT=$$EXTERNAL^DILFD(PXCEFILE,$P(PXCETEXT,"~",3),"",PXVDEF,"PXCEDILF")
	I PXCEEXT'="" S DIR("B")=PXCEEXT
	Q
HIST()	; check if historical encounter; PX*1*215
	N PXVHIST S PXVHIST=0
	I $G(PXCEVIEN),$P(^AUPNVSIT(PXCEVIEN,0),"^",7)="E" S PXVHIST=1
	Q PXVHIST
ARTALERT	; Alert for Adverse Reaction Tracking (ART) ; PX*1*216
	Q:('$D(PXCEPAT("NAME")))!('$D(PXCEPAT("SSN_BRIEF")))  ; PX*1*216
	N XQA,XQAID,XQADATA,XQAMSG,XQATEXT,PXVVAR ; PX*1*216
	S XQA(DUZ)="" ; PX*1*216
	S XQAID="PX VIMM" ; PX*1*216
	S XQADATA=$E(PXCEPAT("NAME"))_PXCEPAT("SSN_BRIEF") ; PX*1*216
	S XQAMSG=XQADATA_"  allergy should be recorded in Adverse Reaction Tracking." ; PX*1*216
	S XQATEXT(1)="" ; PX*1*216
	S XQATEXT(2)="You have recorded an allergy/adverse reaction contraindication reason. This" ; PX*1*216
	S XQATEXT(3)="information should also be recorded in the Adverse Reaction Tracking package" ; PX*1*216
	S XQATEXT(4)="if it is not already present there." ; PX*1*216
	S PXVVAR=$$SETUP1^XQALERT ; PX*1*216
	Q   ; PX*1*216
