PXRMDBL3	; SLC/PJH - Reminder Dialog Generation. (overflow) ;06/08/2009
	;;2.0;CLINICAL REMINDERS;**6,12**;Feb 04, 2005;Build 73
	;
	; Called from PXRMDBL1
	;
	;Set number range for site
START	;
	D SETSTART^PXRMCOPY("^PXRMD(801.41,")
	;Update dialog file for individual dialog items
	D UPDATE(.ARRAY,.WPTXT,"E")
	;Create reminder dialog
	D UPDATE(.DSET,"","R")
	;
	W !!,"Dialog build complete" H 3
END	Q
	;
	;Error Handler
	;-------------
ERR(DESC)	;
	N ERROR,IC,REF
	S ERROR(1)="Unable to update dialog file : "_DESC
	S ERROR(2)="Error in UPDATE^DIE, needs further investigation"
	;Move MSG into ERROR
	S REF="MSG"
	F IC=3:1 S REF=$Q(@REF) Q:REF=""  S ERROR(IC)=REF_"="_@REF
	;Screen message
	D BMES^XPDUTL(.ERROR)
	Q
	;
	;Check if dialog element already exists
	;--------------------------------------
EXISTS(NAME)	;
	N IEN S IEN=$O(^PXRMD(801.41,"B",NAME,""))
	I IEN S DSET(1,CNT*5)=IEN Q 1
	Q 0
	;
	;Update edit history
	;-------------------
HIS(IENN)	;
	;First delete any existing history entries.
	N ENTRY,IND,IENS,FDA,FDAIEN,MSG,WP
	S ENTRY="^PXRMD(801.41,"_IENN_",110)"
	S IND=0
	F  S IND=$O(@ENTRY@(IND)) Q:+IND=0  D
	. S IENS=IND_","_IENN_","
	. S FDA(801.44,IENS,.01)="@"
	I $D(FDA(801.44)) D
	.D FILE^DIE("K","FDA","MSG") I $D(MSG) D AWRITE^PXRMUTIL("MSG")
	;Establish an initial entry in the edit history.
	K FDA,MSG
	S IENS="+1,"_IENN_","
	S FDAIEN(IENN)=IENN
	S FDA(801.44,IENS,.01)=$$FMTE^XLFDT($$NOW^XLFDT,"5Z")
	S FDA(801.44,IENS,1)=$$GET1^DIQ(200,DUZ,.01)
	S FDA(801.44,IENS,2)="WP(1,1)"
	S WP(1,1,1)="Autogenerated"
	D UPDATE^DIE("E","FDA","FDAIEN","MSG")
	I $D(MSG) D AWRITE^PXRMUTIL("MSG")
	Q
	;
	;Mental Health
	;-------------
MHOK(IEN)	;
	N DSHORT,RNAME,TEST,YT S YT=""
	;Convert ien to name
	;DBIA #5044
	S YT("CODE")=$P($G(^YTT(601.71,IEN,0)),U)
	;Quit if no code found
	I YT("CODE")="" Q 0
	I '$$OK^PXRMDLL(IEN) Q 0
	;Check if valid
	;I TEST(1)["[ERROR]" Q 0
	;
	S DNAME=FTYP_" "_YT("CODE")
	;Create arrays
	S CNT=CNT+1
	;Convert dialog item name to UC
	S DNAME=$TR(DNAME,LOWER,UPPER)
	;Truncate the item name - without finesse
	S DSHORT=DNAME
	I $L(DSHORT)>40 S DSHORT=$E(DNAME,1,40)
	;Dialog item name, finding item and result 
	S ARRAY(CNT)=DSHORT_U_U_RESN_U
	;Commented out Result Group Patch 6 until a decision can be made
	;Result group name
	;S RNAME="PXRM "_YT("CODE")_" RESULT GROUP"
	;Result pointer
	;S $P(ARRAY(CNT),U,7)=$O(^PXRMD(801.41,"B",RNAME,""))
	;If aims exclude from p/n
	I YT("CODE")="AIMS" S $P(ARRAY(CNT),U,6)=1
	;Prompt text
	S WPTXT(CNT,1)=YT("CODE")_" (Mental Health Instrument)"
	;test
	W !!,CNT,?5,WPTXT(CNT,1)
	Q 1
	;
	;Sub-routine to update dialog file #801.41
	;-----------------------------------------
UPDATE(INP,WPTXT,DTYPE)	;
	N CNT,DATA,DESC,IEN,STRING,SUB,TEXT
	N FDA,FDAIEN,MSG
	;Get each dialog line in turn
	S STRING="Updating "_$S(DTYPE="E":"Dialog Elements",1:"Reminder Dialog")
	D BMES^XPDUTL(STRING)
	;
	;Create FDA for each entry in array
	S CNT=""
	F  S CNT=$O(INP(CNT)) Q:CNT=""  D  Q:$D(MSG)
	.;If finding is a finding item parameter no need to build an element
	.I DTYPE="E",$P(INP(CNT),U)=801.43 D  Q
	..S DSET(1,CNT)=$P(INP(CNT),U,2)
	.;Build FDA array
	.K FDAIEN,FDA
	.;If existing element and not in replace mode don't update FDA
	.I DTYPE="E",'PXRMREPL Q:$$EXISTS($P(INP(CNT),U))
	.;Name
	.S FDA(801.41,"?+1,",.01)=$P(INP(CNT),U)
	.;Dialog type
	.S FDA(801.41,"?+1,",4)=DTYPE
	.;Class
	.S FDA(801.41,"?+1,",100)="L"
	.;Sponsor
	.S FDA(801.41,"?+1,",101)=""
	.;Prompt text/finding entries
	.I DTYPE="E" D
	..S FDA(801.41,"?+1,",13)=$P(INP(CNT),U,2)
	..S FDA(801.41,"?+1,",15)=$P(INP(CNT),U,3)
	..S FDA(801.41,"?+1,",17)=$P(INP(CNT),U,4)
	..S FDA(801.41,"?+1,",25)="WPTXT("_CNT_")"
	..;MH fields (exclude from P/N and results pointer)
	..S:$P(INP(CNT),U,6) FDA(801.41,"?+1,",54)=$P(INP(CNT),U,6)
	..;S:$P(INP(CNT),U,7) FDA(801.41,"?+1,",55)=$P(INP(CNT),U,7)
	.;Reminder dialog associated reminder/DISABLE
	.I DTYPE="R" D
	..S FDA(801.41,"?+1,",2)=REM
	..I PXRMENAB'="Y" S FDA(801.41,"?+1,",3)=1
	.;Dialog items point to prompts and actions, Sets point to dialog items
	.N ACNT,SUB
	.;S ACNT=0,SUB=2
	.S ACNT=0,SUB=1
	.F  S ACNT=$O(INP(CNT,ACNT)) Q:ACNT=""  D
	..S SUB=SUB+1,FDA(801.412,"?+"_SUB_",?+1,",.01)=ACNT
	..S FDA(801.412,"?+"_SUB_",?+1,",2)=$P(INP(CNT,ACNT),U)
	..S FDA(801.412,"?+"_SUB_",?+1,",6)=$P(INP(CNT,ACNT),U,2)
	..S FDA(801.412,"?+"_SUB_",?+1,",7)=$P(INP(CNT,ACNT),U,3)
	..S FDA(801.412,"?+"_SUB_",?+1,",8)=$P(INP(CNT,ACNT),U,4)
	..S FDA(801.412,"?+"_SUB_",?+1,",9)=$P(INP(CNT,ACNT),U,5)
	.;Update #801.41
	.D UPDATE^DIE("","FDA","FDAIEN","MSG")
	.I $D(MSG) D ERR($G(INP(CNT))) Q
	.;Save IEN of dialog created/used for later use in building dialog set 
	.I DTYPE="E" S DSET(1,CNT*5)=FDAIEN(1)
	.;Insert link to reminder
	.I DTYPE="R",PXRMLINK="Y" D
	..S $P(^PXD(811.9,REM,51),U)=FDAIEN(1),^PXD(811.9,"AG",FDAIEN(1),REM)=""
	.;Update Edit History
	.D HIS(FDAIEN(1))
	Q
