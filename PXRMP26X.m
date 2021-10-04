PXRMP26X	;SLC/AGP - Dialog Conversion Extra routine for PXRM*2.0*26. ;01/02/2014
	;;2.0;CLINICAL REMINDERS;**26**;Feb 04, 2005;Build 404
	Q
	;
	;build an XTMP value of dialogs that contains Taxonomy, ICD9 codes, and/or CPT codes.
	;if ICD9 or CPT deletes the values from file 801.41
BLDLIST(PXRMSKIP)	;
	K ^TMP($J,"DLG FIND"),^TMP($J,"DLG ORDER")
	D MES^XPDUTL("Building lists of dialogs to update")
	D BLDDLGTM^PXRMSTS("DLG FIND")
	N ADD,ADDFNDS,ADDFVPL,CNT,DIEN,FIND,FINDFVPL,IEN,NAME,NUM,TEMP,TYPE
	D BLDRLIST^PXRMVPTR(801.41,15,.FINDFVPL)
	D BLDRLIST^PXRMVPTR(801.4118,.01,.ADDFVPL)
	K ^TMP("PXRMXMZ",$J)
	S ^TMP("PXRMXMZ",$J,1,0)="Dialog pre-conversion report:"
	F TYPE="ICD9(","ICPT(","PXD(811.2," D
	.S IEN=0 F  S IEN=$O(^TMP($J,"DLG FIND",TYPE,IEN)) Q:IEN'>0  D
	..S DIEN=0 F  S DIEN=$O(^TMP($J,"DLG FIND",TYPE,IEN,DIEN)) Q:DIEN'>0  D
	...S NAME=$P($G(^PXRMD(801.41,DIEN,0)),U)
	...;If field is set assume conversion has already happen.
	...I TYPE="PXD(811.2,",$P($G(^PXRMD(801.41,DIEN,"TAX")),U)'="" Q
	...;If taxonomy is assigned as an additional finding assume conversion has already happen
	...I TYPE="PXD(811.2,",$D(^TMP($J,"DLG FIND",TYPE,IEN,DIEN,18)) Q
	...I '$D(PXRMSKIP(NAME)) D BLDXTMP(TYPE,DIEN,IEN,.FINDFVPL,.ADDFVPL)
	...I TYPE="PXD(811.2," Q
	...;
	...F FIND=15,18 D
	....I FIND=15,$D(^TMP($J,"DLG FIND",TYPE,IEN,DIEN,FIND)) S TEMP(15,DIEN)="" Q
	....S NUM=0 F  S NUM=$O(^TMP($J,"DLG FIND",TYPE,IEN,DIEN,FIND,NUM)) Q:NUM'>0  S TEMP(18,DIEN,NUM)=""
	I $D(^TMP($J,"DLG ORDER")) S DIEN=0 F  S DIEN=$O(^TMP($J,"DLG ORDER",DIEN)) Q:DIEN'>0  D BLDTXT(DIEN,.FINDFVPL,.ADDFVPL,0,1)
	I '$D(TEMP) G BLDLISTX
	F FIND=15,18 D
	.S DIEN="" F  S DIEN=$O(TEMP(FIND,DIEN)) Q:DIEN'>0  D
	..I FIND=15 D DELDATA(DIEN,FIND) Q
	..S NUM="" F  S NUM=$O(TEMP(FIND,DIEN,NUM)) Q:NUM'>0  D DELDATA(DIEN,FIND,NUM)
BLDLISTX	;
	I $O(^TMP("PXRMXMZ",$J,""),-1)>1 D SEND^PXRMMSG("PXRMXMZ","Clinical Reminder Patch 26 Pre-conversion dialog.")
	K ^TMP("PXRMXMZ",$J)
	Q
	;
BLDTXT(DIEN,FINDFVPL,ADDFVPL,TAXNEEDS,PRE)	;
	N ADD,CNT,CPTTEXT,NAME,NODE,NUM,POVTEXT,RES,TEXT,TEMP,TSEL
	S CNT=+$O(^TMP("PXRMXMZ",$J,""),-1)
	I CNT>0 S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=" "
	S NODE=$G(^PXRMD(801.41,DIEN,0))
	S NAME=$P(NODE,U)
	S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=NAME
	S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)="======================================================="
	;
	S TEMP=$P($G(^PXRMD(801.41,DIEN,1)),U,5)
	;S TEMP=$P($G(^PXRMD(801.41,DIEN,1)),U,5),RES=+$P($G(^PXRMD(801.41,DIEN,1)),U,3)
	I TAXNEEDS=1 D
	.S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)="PREVIOUSLY THE DIALOG WAS SET TO BOTH CURRENT AND HISTORICAL ENCOUNTERS."
	.S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)="DIALOG IS NOW SET TO CURRENT ENCOUNTER ONLY."
	.S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)="REVIEW THE DIALOG BEFORE USING IN CPRS."
	S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=$$RJ^XLFSTR("Resolution Type:",25)_" "_$$GET1^DIQ(801.41,DIEN,13)
	I TEMP'="" D
	.S TEXT=$$BLDTXTF(TEMP,.FINDFVPL)
	.S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=$$RJ^XLFSTR("Finding Item:",25)_" "_TEXT
	.D LISTCODE(DIEN,TEXT,TEMP,.CNT,0)
	.S TSEL=$$GET1^DIQ(801.41,DIEN,123)
	.I PRE=0 S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=$$RJ^XLFSTR("Taxonomy Pick List:",25)_" "_$G(TSEL)
	.S CPTTEXT="",POVTEXT=""
	.I "AD"[TSEL S POVTEXT=$$GET1^DIQ(801.41,DIEN,141)
	.I "AP"[TSEL S CPTTEXT=$$GET1^DIQ(801.41,DIEN,142)
	.I $G(POVTEXT)'="" S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=$$RJ^XLFSTR("Diagnosis Header:",25)_" "_POVTEXT
	.I $G(CPTTEXT)'="" S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=$$RJ^XLFSTR("Procedure Header:",25)_" "_CPTTEXT
	;
	I $D(^PXRMD(801.41,DIEN,3,0)) D
	.S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=" "
	.S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=$$RJ^XLFSTR("Additional Finding Items:",25)
	.S ADD="" F  S ADD=$O(^PXRMD(801.41,DIEN,3,"B",ADD)) Q:ADD=""  D
	..S TEXT=$$BLDTXTF(ADD,.ADDFVPL)
	..S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)="    Items: "_TEXT
	..D LISTCODE(DIEN,TEXT,ADD,.CNT,1)
	I $P($G(^PXRMD(801.41,DIEN,2)),U,5)=1 D
	.S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=" "
	.S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)="Suppress All Prompts: Yes"
	I $D(^PXRMD(801.41,DIEN,10)) D
	. S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=" "
	. S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=$$RJ^XLFSTR("Components:",15)
	. S NUM=0 F  S NUM=$O(^PXRMD(801.41,DIEN,10,NUM)) Q:NUM'>0  D
	. .S NODE=$G(^PXRMD(801.41,DIEN,10,NUM,0))
	. .D BLDTXTP(NODE,.CNT)
	Q
	;
BLDTXTP(NODE,CNT)	;
	N DNODE,IEN,LABEL,NAME,TEMP,TYPE,TYPEOUT,VALUE,X
	S IEN=$P(NODE,U,2) I +$G(IEN)'>0 Q
	S DNODE=$G(^PXRMD(801.41,IEN,0))
	S NAME=$P(DNODE,U),TYPE=$P(DNODE,U,4),TYPEOUT=$$BLDTXTT(TYPE)
	S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=$$RJ^XLFSTR("Sequence:",20)_" "_$P(NODE,U)_" "_TYPEOUT_" "_NAME
	I "FP"'[TYPE Q
	F X=6:1:10 D
	. S TEMP=$P(NODE,U,X) I TEMP="" Q
	. S LABEL=$S(X=6:"Prompt Caption:",X=7:"New Line:",X=8:"Exclude From PN Text:",X=9:"Required:",1:" ")
	. I $L(TEMP)>1 S VALUE=TEMP
	. I $L(TEMP)=1 S VALUE=$S(TEMP=1:"Yes",1:"No")
	. S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=$$RJ^XLFSTR(LABEL,20)_" "_VALUE
	Q
	;
BLDTXTT(T)	;
	N RESULT
	S RESULT=$S(T="E":"Element",T="G":"Group",T="P":"Prompt",T="F":"Forced Value",T="S":"Result Group",T="T":"Result Element","R":"Dialog",1:"")
	Q RESULT
	;
BLDTXTF(FIND,FVPL)	;
	N ABB,FNUM,GBL,IEN,NODE
	S IEN=$P(FIND,";"),GBL=$P(FIND,";",2) I IEN'>0!(GBL="") Q ""
	S NODE=$G(FVPL(GBL)) I NODE="" Q ""
	S ABB=$P(NODE,U,4),FNUM=$P(NODE,U)
	S FNAME=$$GET1^DIQ(FNUM,IEN,.01)
	Q ABB_"."_FNAME
	;
BLDXTMP(TYPE,DIEN,IEN,FINDVPL,ADDFVPL)	;
	I TYPE="PXD(811.2," D  G PRETEXT
	. S ^XTMP(PXRMXTMP,"DIALOG",DIEN)=""
	. S ^XTMP(PXRMXTMP,"DIALOG",DIEN,TYPE,IEN)=+$S($P($G(^PXRMD(801.41,DIEN,2)),U,5)="Y":0,1:1)
	;
	S ^XTMP(PXRMXTMP,"DIALOG",DIEN,TYPE,IEN)=""
PRETEXT	;
	S ^TMP($J,"DLG ORDER",DIEN)=""
	S ^XTMP(PXRMXTMP,"DIALOG",DIEN,"DONE")=0
	;D BLDTXT(DIEN,.FINDVPL,.ADDFVPL,0,1)
	Q
	;
DELDATA(DIEN,FIELD,NUM)	;
	N DA,DIE,DR
	S DIE="^PXRMD(801.41,"
	I FIELD=15 S DA=DIEN,DR="15///@"
	I FIELD=18 D
	.S DA(1)=DIEN,DA=NUM
	.S DIE=DIE_DA(1)_",3,",DR=".01///@"
	D ^DIE
	Q
	;
LISTCODE(DIEN,TEXT,FIND,CNT,ISADD)	;
	I $P(TEXT,".")'="TX" Q
	N CODES,HIST,NLINES,NODE,TDX,TPR
	S NODE="PXRM POST TEXT"
	K ^TMP(NODE,$J)
	S NLINES=0
	D TAXDISP^PXRMDTAX(FIND,0,DIEN,.NLINES,NODE,ISADD,1)
	S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=""
	S NLINES=0 F  S NLINES=$O(^TMP(NODE,$J,NLINES)) Q:NLINES'>0  D
	.S CNT=CNT+1,^TMP("PXRMXMZ",$J,CNT,0)=^TMP(NODE,$J,NLINES,0)
	K ^TMP(NODE,$J)
	Q
	;
	;
TEST(DIEN,FIND)	;
	N CNT,TEXT
	K ^TMP("PXRMXMZ",$J)
	S CNT=0,TEXT="TX.SOMETHING"
	D LISTCODE(DIEN,TEXT,FIND,.CNT,0)
	S CNT=0 F  S CNT=$O(^TMP("PXRMXMZ",$J,CNT)) Q:CNT'>0  D
	.W !,$G(^TMP("PXRMXMZ",$J,CNT,0))
	Q
