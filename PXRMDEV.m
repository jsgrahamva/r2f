PXRMDEV	;SLC/PKR - This is a driver for testing Clinical Reminders. ;05/13/2016
	;;2.0;CLINICAL REMINDERS;**4,6,11,16,18,24,26,47**;Feb 04, 2005;Build 291
	;
	;==================================================
DEB	;Prompt for patient and reminder by name input component.
	N DATE,DFN,DIC,DIR,DIROUT,DTOUT,DUOUT,HASFF,HASTERM,IND
	N PXRHM,PXRMFFSS,PXRMITEM,PXRMTDEB,X,Y
	S DIC=2,DIC("A")="Select Patient: "
	S DIC(0)="AEQMZ"
GPAT1	D ^DIC
	I $D(DIROUT)!$D(DIRUT) Q
	I $D(DTOUT)!$D(DUOUT) Q
	S DFN=+$P(Y,U,1)
	I DFN=-1 G GPAT1
	S DIC=811.9,DIC("A")="Select Reminder: "
GREM1	D ^DIC
	I $D(DIROUT)!$D(DIRUT) Q
	I $D(DTOUT)!$D(DUOUT) Q
	S PXRMITEM=+$P(Y,U,1)
	I PXRMITEM=-1 G GREM1
	S DIR(0)="LA"_U_"0"
	S DIR("A")="Enter component number 0, 1, 5, 10, 11, 12, 55: "
	D ^DIR
	I $D(DIROUT)!$D(DIRUT) Q
	I $D(DTOUT)!$D(DUOUT) Q
	I X="" S X=5
	S PXRHM=X
	S DIR(0)="DA^"_0_"::ETX"
	S DIR("A")="Enter date for reminder evaluation: "
	S DIR("B")=$$FMTE^XLFDT($$DT^XLFDT,"D")
	S DIR("PRE")="S X=$$DCHECK^PXRMDATE(X) K:X=-1 X"
	W !
	D ^DIR K DIR
	I $D(DIROUT)!$D(DIRUT) Q
	I $D(DTOUT)!$D(DUOUT) Q
	S DATE=Y
	S (HASFF,HASTERM,PXRMFFSS,PXRMTDEB)=0
	I $D(^PXD(811.9,PXRMITEM,25,"B")) S HASFF=1
	I HASFF S PXRMFFSS=$$ASKYN^PXRMEUT("N","Display step-by-step function finding evaluation","","")
	I $D(^PXD(811.9,PXRMITEM,20,"E","PXRMD(811.5,")) S HASTERM=1
	I 'HASTERM D
	. S IND=0
	. F  S IND=+$O(^PXD(811.9,PXRMITEM,20,"EDEP",IND)) Q:IND=0  D
	.. I $D(^PXD(811.9,PXRMITEM,20,"EDEP",IND,"PXRMD(811.5,")) S HASTERM=1
	I HASTERM S PXRMTDEB=$$ASKYN^PXRMEUT("N","Display all term findings","","")
	D DOREM(DFN,PXRMITEM,PXRHM,DATE)
	Q
	;
	;==================================================
DEV	;Prompt for patient and reminder by name and evaluation date.
	N DATE,DFN,DIC,DIROUT,DIRUT,DTOUT,DUOUT,HASFF,HASTERM,IND
	N PXRHM,PXRMFFSS,PXRMITEM,PXRMTDEB,REF,X,Y
	S DIC=2,DIC("A")="Select Patient: "
	S DIC(0)="AEQMZ"
GPAT2	D ^DIC
	I $D(DIROUT)!$D(DIRUT) Q
	I $D(DTOUT)!$D(DUOUT) Q
	S DFN=+$P(Y,U,1)
	I DFN=-1 G GPAT2
	S DIC=811.9,DIC("A")="Select Reminder: "
GREM2	D ^DIC
	I $D(DIROUT)!$D(DIRUT) Q
	I $D(DTOUT)!$D(DUOUT) Q
	S PXRMITEM=+$P(Y,U,1)
	I PXRMITEM=-1 G GREM2
	S PXRHM=5
	S DIR(0)="DA^"_0_"::ETX"
	S DIR("A")="Enter date for reminder evaluation: "
	S DIR("B")=$$FMTE^XLFDT($$DT^XLFDT,"D")
	S DIR("PRE")="S X=$$DCHECK^PXRMDATE(X) K:X=-1 X"
	W !
	D ^DIR K DIR
	I $D(DIROUT)!$D(DIRUT) Q
	I $D(DTOUT)!$D(DUOUT) Q
	S DATE=Y
	S (HASFF,HASTERM,PXRMFFSS,PXRMTDEB)=0
	I $D(^PXD(811.9,PXRMITEM,25,"B")) S HASFF=1
	I HASFF S PXRMFFSS=$$ASKYN^PXRMEUT("N","Display step-by-step function finding evaluation","","")
	I $D(^PXD(811.9,PXRMITEM,20,"E","PXRMD(811.5,")) S HASTERM=1
	I 'HASTERM D
	. S IND=0
	. F  S IND=+$O(^PXD(811.9,PXRMITEM,20,"EDEP",IND)) Q:IND=0  D
	.. I $D(^PXD(811.9,PXRMITEM,20,"EDEP",IND,"PXRMD(811.5,")) S HASTERM=1
	I HASTERM S PXRMTDEB=$$ASKYN^PXRMEUT("N","Display all term findings","","")
	D DOREM(DFN,PXRMITEM,PXRHM,DATE)
	Q
	;
	;==================================================
DOREM(DFN,PXRMITEM,PXRHM,DATE)	;Do the reminder
	N BOP,DEFARR,FIEVAL,FINDING,IND,JND,NL,NOUT,OUTPUT,PNAME
	N PXRMDEBG,PXRMID
	N REF,RIEN,RNAME,STATUS,TEXT,TEXTOUT,TFIEVAL,TTEXT,X
	;This is a debugging run so set PXRMDEBG.
	S NL=0,PXRMDEBG=1
	D DEF^PXRMLDR(PXRMITEM,.DEFARR)
	I +$G(DATE)=0 D EVAL^PXRM(DFN,.DEFARR,PXRHM,1,.FIEVAL)
	I +$G(DATE)>0 D EVAL^PXRM(DFN,.DEFARR,PXRHM,1,.FIEVAL,DATE)
	;
	I $D(^TMP(PXRMID,$J,"FFDEB")) M FIEVAL=^TMP(PXRMID,$J,"FFDEB") K ^TMP(PXRMID,$J,"FFDEB")
	;
	S TTEXT=^PXD(811.9,PXRMITEM,0)
	S PNAME=$P(TTEXT,U,2)
	I PNAME="" S PNAME=$P(TTEXT,U,1)
	S NL=NL+1,OUTPUT(NL)="Reminder: "_PNAME
	S NL=NL+1,OUTPUT(NL)="Patient: "_$$GET1^DIQ(2,DFN,.01)
	S NL=NL+1,OUTPUT(NL)=" "
	S NL=NL+1,OUTPUT(NL)="The elements of the FIEVAL array are:"
	S REF="FIEVAL"
	D ACOPY^PXRMUTIL(REF,"TTEXT()")
	S IND=0
	F  S IND=$O(TTEXT(IND)) Q:IND=""  D
	. I $L(TTEXT(IND))<79 S NL=NL+1,OUTPUT(NL)=TTEXT(IND) Q
	. D FORMATS^PXRMTEXT(1,79,TTEXT(IND),.NOUT,.TEXTOUT)
	. F JND=1:1:NOUT S NL=NL+1,OUTPUT(NL)=TEXTOUT(JND)
	;
	I $G(PXRMFFSS) D
	. N FFN,STEP
	. S NL=NL+1,OUTPUT(NL)="",NL=NL+1,OUTPUT(NL)=""
	. S NL=NL+1,OUTPUT(NL)="Step-by-step function finding evaluation:"
	. S FFN=""
	. F  S FFN=$O(^TMP("PXRMFFSS",$J,FFN)) Q:FFN=""  D
	.. S NL=NL+1,OUTPUT(NL)=""
	.. S NL=NL+1,OUTPUT(NL)=" Function finding "_FFN_"="_FIEVAL(FFN)
	.. D FORMATS^PXRMTEXT(1,79,$P(FIEVAL(FFN,"DETAIL"),U,2),.NOUT,.TEXTOUT)
	.. F JND=1:1:NOUT S NL=NL+1,OUTPUT(NL)=TEXTOUT(JND)
	.. S NL=NL+1,OUTPUT(NL)=" = "_^TMP("PXRMFFSS",$J,FFN,0)
	.. S NL=NL+1,OUTPUT(NL)="Step  Result"
	.. S STEP=0
	.. F  S STEP=$O(^TMP("PXRMFFSS",$J,FFN,STEP)) Q:STEP=""  D
	... S NL=NL+1,OUTPUT(NL)=$$RJ^XLFSTR(STEP_".",4," ")_"  "_^TMP("PXRMFFSS",$J,FFN,STEP)
	. K ^TMP("PXRMFFSS",$J)
	I $G(PXRMTDEB) D
	. S NL=NL+1,OUTPUT(NL)="",NL=NL+1,OUTPUT(NL)=""
	. S NL=NL+1,OUTPUT(NL)="Term findings:"
	. S REF="TFIEVAL"
	. S FINDING=0
	. F  S FINDING=$O(^TMP("PXRMTDEB",$J,FINDING)) Q:FINDING=""  D
	.. K TFIEVAL M TFIEVAL(FINDING)=^TMP("PXRMTDEB",$J,FINDING)
	.. S NL=NL+1,OUTPUT(NL)="Finding "_FINDING_":"
	.. K TTEXT
	.. D ACOPY^PXRMUTIL(REF,"TTEXT()")
	.. S IND=0
	.. F  S IND=$O(TTEXT(IND)) Q:IND=""  S NL=NL+1,OUTPUT(NL)=TTEXT(IND)
	. K ^TMP("PXRMTDEB",$J)
	;
	I $D(^TMP(PXRMID,$J)) D
	. S NL=NL+1,OUTPUT(NL)="",NL=NL+1,OUTPUT(NL)=""
	. S NL=NL+1,OUTPUT(NL)="The elements of the ^TMP(PXRMID,$J) array are:"
	. S REF="^TMP(PXRMID,$J)"
	. K TTEXT
	. D ACOPY^PXRMUTIL(REF,"TTEXT()")
	. S IND=0
	. F  S IND=$O(TTEXT(IND)) Q:IND=""  S NL=NL+1,OUTPUT(NL)=TTEXT(IND)
	. K ^TMP(PXRMID,$J)
	;
	I $D(^TMP("PXRHM",$J)) D
	. S NL=NL+1,OUTPUT(NL)="",NL=NL+1,OUTPUT(NL)=""
	. S NL=NL+1,OUTPUT(NL)="The elements of the ^TMP(""PXRHM"",$J) array are:"
	. S REF="^TMP(""PXRHM"",$J)"
	. K TTEXT
	. D ACOPY^PXRMUTIL(REF,"TTEXT()")
	. S IND=0
	. F  S IND=$O(TTEXT(IND)) Q:IND=""  S NL=NL+1,OUTPUT(NL)=TTEXT(IND)
	;
	I (PXRHM=0)!(PXRHM=1)!(PXRHM=5)!(PXRHM=55) D
	. S TEXT=$S(PXRHM=0:"Due Now ",PXRHM=1:"Summary ",PXRHM=5:"Maintenance ",PXRHM=55:"Order Check ",1:"")
	. S NL=NL+1,OUTPUT(NL)="",NL=NL+1,OUTPUT(NL)=""
	. S NL=NL+1,OUTPUT(NL)=TEXT_"Output:"
	. D FMTOUT^PXRMFMTO("PXRHM",.NL,.OUTPUT)
	I (PXRHM=10)!(PXRHM=11) D
	. S NL=NL+1,OUTPUT(NL)="",NL=NL+1,OUTPUT(NL)=""
	. S NL=NL+1,OUTPUT(NL)="MHV "_$S(PXRHM=10:"Summary",PXRHM=11:"Detailed")_" Output:"
	. S RIEN=$O(^TMP("PXRHM",$J,""))
	. S RNAME=$O(^TMP("PXRHM",$J,RIEN,""))
	. S STATUS=$P($G(^TMP("PXRHM",$J,RIEN,RNAME)),U,1)
	. I STATUS="" S STATUS="UNKNOWN"
	. M ^TMP("PXRMHV",$J,STATUS,RNAME,RIEN)=^TMP("PXRHM",$J,RIEN,RNAME)
	. D MHVOUT^PXRMFMTO("PXRMHV",STATUS,RNAME,RIEN,.NL,.OUTPUT)
	I PXRHM=12 D
	. S NL=NL+1,OUTPUT(NL)="",NL=NL+1,OUTPUT(NL)=""
	. S NL=NL+1,OUTPUT(NL)="MHV Combined Output:"
	. D MHVCOUT^PXRMFMTO("PXRMMHVC",.NL,.OUTPUT)
	K ^TMP("PXRM",$J),^TMP("PXRHM",$J),^TMP("PXRMMHVC",$J)
	S BOP=$$BORP^PXRMUTIL("P")
	I BOP="B" D
	. S X="IORESET"
	. D ENDR^%ZISS
	. D BROWSE^DDBR("OUTPUT","NR","Reminder Test")
	. W IORESET
	. D KILL^%ZISS
	I BOP="P" D GPRINT^PXRMUTIL("OUTPUT")
	Q
	;
