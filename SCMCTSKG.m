SCMCTSKG	;bpoifo/dmr PCMM Inactivation GUI Rpt.;3/18/08
	;;5.3;Scheduling;**504**;AUG 13, 1993;Build 21
	;;
EN(SCRESULT,SCARRAY)	;
	S (STAT,TN,IEN,INST,INSTN,UNDATE,UNREA,TEAMPN,SSN,SSNN)="" S NUM=0
	S (TEAM,TEAMP,PROVN,PROV,BDATE,EDATE,PAT,INAME,HOLD)="" S NN=0,CC=0,CT=0
	K ^TMP("SCARRAY")
	M ^TMP("SCARRAY")=SCARRAY
	D DATE
	K ^TMP("SCRESULT","B")
	D FINAL
	S SCRESULT=$NA(^TMP("SCRESULT"))
	D EXIT
	Q
DATE	;
	S BDATE=$G(^TMP("SCARRAY","AA")) S X=$P(BDATE,"""",2) D ^%DT S BDATE=Y
	S EDATE=$G(^TMP("SCARRAY","AB")) S X=$P(EDATE,"""",2) D ^%DT S EDATE=Y
	D START
	Q
START	;
	S STAT="" F  S STAT=$O(^SCPT(404.43,"ASTATB",STAT)) Q:STAT=""  D
	.S IEN=""  F  S IEN=$O(^SCPT(404.43,"ASTATB",STAT,IEN)) Q:'IEN  D
	..S UNDATE="" S UNDATE=$$GET1^DIQ(404.43,IEN_",",.04,"I") IF $D(UNDATE) D
	...I (UNDATE<BDATE)!(UNDATE>EDATE) Q
	...S PAT="" S PAT=$$GET1^DIQ(404.43,IEN_",",.01)
	...S (SN,SSN,SSNN)="" S SN=$$GET1^DIQ(404.43,IEN_",",.01,"I")
	...S SSNN=$$GET1^DIQ(404.42,SN_",",.01,"I") S SSN=$$GET1^DIQ(2,SSNN_",",.09)
	...D TEAMP
	...Q
	Q
TEAMP	;
	S (TEAMP,TPN,TPN2)=""
	S TPN=$$GET1^DIQ(404.43,IEN_",",.02,"I")
	S TEAMP=$$GET1^DIQ(404.43,IEN_",",.02)
	I $G(^TMP("SCARRAY","TP^0"))="""ALL^0""" D TEAM Q
	I '$D(^TMP("SCARRAY","TP^0")) D
	.S TPN2=$G(^TMP("SCARRAY","TP^"_TPN)) I TPN2'="" D
	..S TPN2=$P(TPN2,"""",2) I $P(TPN2,"^",1)=TEAMP D TEAM
	Q
TEAM	;
	S (TEAMN,TN,TN2,PREC)=""
	S TN=$$GET1^DIQ(404.57,TPN_",",.02,"I")
	S TEAMN=$$GET1^DIQ(404.57,TPN_",",.02)
	S PREC=$$GET1^DIQ(404.57,TPN_",",.1)
	I $G(^TMP("SCARRAY","T^0"))="""ALL^0""" D INST
	I '$D(^TMP("SCARRAY","T^0")) D
	.S TN2=$G(^TMP("SCARRAY","T^"_TN)) I TN2'="" D
	..S TN2=$P(TN2,"""",2),TN2=$P(TN2,"^",1)
	..I TN2=TEAMN D INST
	Q
INST	;
	S (INST,INSTN,INUM)=""
	S INSTN=$$GET1^DIQ(404.51,TN_",",.07,"I")
	I $G(^TMP("SCARRAY","D^0"))="""ALL^0""" D
	.S INST=$$GET1^DIQ(404.51,TN_",",.07)
	.D PROV
	.Q
	I $G(^TMP("SCARRAY","D^0"))'="""ALL""" D
	.S INUM=$G(^TMP("SCARRAY","D^"_INSTN)) I INUM'="" D
	..S INUM=$P(INUM,"""",2)
	..I $P(INUM,"^",2)=INSTN D
	...S INST=$$GET1^DIQ(404.51,TN_",",.07)
	...D PROV
	...Q
	Q
PROV	;
	S (PROV,PROVN,J,JJ,PDATE,EFFD,SCLIST,ERROR,FILE,ST,P1,P2,P3)=""
	I $G(^TMP("SCARRAY","P^0"))'="""ALL^0""" D
	.S J="N" F  S J=$O(^TMP("SCARRAY",J)) Q:J=""  D
	..Q:$P(J,"^",1)'="P"  D
	...S PROVN="" S PROVN=+$P(^TMP("SCARRAY",J),"^",2) D
	....S JJ="" F  S JJ=$O(^SCTM(404.52,"C",PROVN,JJ)) Q:'JJ  D
	.....S POS="" S POS=$$GET1^DIQ(404.52,JJ_",",.01) I POS=TEAMP D
	......S (PDATE,ST)="" S PDATE=$$GET1^DIQ(404.52,JJ_",",.02,"I"),ST=$$GET1^DIQ(404.52,JJ_",",.04,"I") D
	.......I PDATE>UNDATE Q
	.......I ST=0&(PDATE<UNDATE) Q
	.......S PROV="" S PROV=$$GET1^DIQ(404.52,JJ_",",.03)
	.......D UNREA,SAVE
	.......Q
	I $G(^TMP("SCARRAY","P^0"))="""ALL^0""" D
	.S PROVN="" F  S PROVN=$O(^SCTM(404.52,"C",PROVN)) Q:PROVN=""  D
	..S JJ="" F  S JJ=$O(^SCTM(404.52,"C",PROVN,JJ)) Q:'JJ  D
	...S POS="" S POS=$$GET1^DIQ(404.52,JJ_",",.01) I POS=TEAMP D
	....S (PDATE,ST)="" S PDATE=$$GET1^DIQ(404.52,JJ_",",.02,"I"),ST=$$GET1^DIQ(404.52,JJ_",",.04,"I") D
	.....I PDATE>UNDATE Q
	.....I ST=0&(PDATE<UNDATE) Q
	.....S PROV="" S PROV=$$GET1^DIQ(404.52,JJ_",",.03)
	.....D UNREA,SAVE
	.....Q
	Q
UNREA	;Unassign Reason
	S UNREA=""
	S UNREA=$$GET1^DIQ(404.43,IEN_",",.12,"I")
	Q
SAVE	;
	I $G(^TMP("SCARRAY","S1"))="""ALL""" D SAVE1 Q
	I $G(^TMP("SCARRAY","S1"))'="""ALL""" D SAVE2,SAVE3
	Q
SAVE1	;
	S Y=UNDATE D DD^%DT S UNDATE=Y
	S NUM=NUM+1
	S ^TMP("SCRESULT",INST,PAT,NUM)=PAT_"^"_SSN_"^"_INST_"^"_TEAMN_"^"_PROV_"^"_TEAMP_"^"_PREC_"^"_UNDATE_"^"_UNREA
	Q
SAVE2	;
	S (S1,S2,S3,S4,S5,S6,S7)="",CC="",SORT=""
	F NN=1:1:7 S SORT=$G(^TMP("SCARRAY","S"_NN)) Q:SORT=""  D
	.S SORT=$P(SORT,"""",2)
	.S XX=$S(SORT="Patient":PAT,SORT="Institution":INST,SORT="Team":TEAMN,SORT="Provider":PROV,SORT="Team Position":TEAMP,SORT="Date":UNDATE,SORT="Reason":UNREA,1:"")
	.S HOLD=NN
	.I NN=1 S S1=XX,^TMP("SCRESULT",S1)=""
	.I NN=2 S S2=XX,^TMP("SCRESULT",S1,S2)=""
	.I NN=3 S S3=XX,^TMP("SCRESULT",S1,S2,S3)=""
	.I NN=4 S S4=XX,^TMP("SCRESULT",S1,S2,S3,S4)=""
	.I NN=5 S S5=XX,^TMP("SCRESULT",S1,S2,S3,S4,S5)=""
	.I NN=6 S S6=XX,^TMP("SCRESULT",S1,S2,S3,S4,S5,S6)=""
	.I NN=7 S S7=XX,^TMP("SCRESULT",S1,S2,S3,S4,S5,S6,S7)=""
	Q
SAVE3	;
	S CC=$S(HOLD=1:"SORT1",HOLD=2:"SORT2",HOLD=3:"SORT3",HOLD=4:"SORT4",HOLD=5:"SORT5",HOLD=6:"SORT6",HOLD=7:"SORT7",1:"")
	S UNDATE2="" S UNDATE2=UNDATE
	S Y=UNDATE2 D DD^%DT S UNDATE2=Y
	D @CC
	Q
SORT1	;
	I $D(^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)) Q
	S CT=CT+1
	S ^TMP("SCRESULT",S1,CT)=PAT_"^"_SSN_"^"_INST_"^"_TEAMN_"^"_PROV_"^"_TEAMP_"^"_PREC_"^"_UNDATE2_"^"_UNREA
	S ^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)=""
	Q
SORT2	;
	I $D(^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)) Q
	S CT=CT+1
	S ^TMP("SCRESULT",S1,S2,CT)=PAT_"^"_SSN_"^"_INST_"^"_TEAMN_"^"_PROV_"^"_TEAMP_"^"_PREC_"^"_UNDATE2_"^"_UNREA
	S ^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)=""
	Q
SORT3	;
	I $D(^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)) Q
	S CT=CT+1
	S ^TMP("SCRESULT",S1,S2,S3,CT)=PAT_"^"_SSN_"^"_INST_"^"_TEAMN_"^"_PROV_"^"_TEAMP_"^"_PREC_"^"_UNDATE2_"^"_UNREA
	S ^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)=""
	Q
SORT4	;
	I $D(^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)) Q
	S CT=CT+1
	S ^TMP("SCRESULT",S1,S2,S3,S4,CT)=PAT_"^"_SSN_"^"_INST_"^"_TEAMN_"^"_PROV_"^"_TEAMP_"^"_PREC_"^"_UNDATE2_"^"_UNREA
	S ^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)=""
	Q
SORT5	;
	I $D(^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)) Q
	S CT=CT+1
	S ^TMP("SCRESULT",S1,S2,S3,S4,S5,CT)=PAT_"^"_SSN_"^"_INST_"^"_TEAMN_"^"_PROV_"^"_TEAMP_"^"_PREC_"^"_UNDATE2_"^"_UNREA
	S ^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)=""
	Q
SORT6	;
	I $D(^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)) Q
	S CT=CT+1
	S ^TMP("SCRESULT",S1,S2,S3,S4,S5,S6,CT)=PAT_"^"_SSN_"^"_INST_"^"_TEAMN_"^"_PROV_"^"_TEAMP_"^"_PREC_"^"_UNDATE2_"^"_UNREA
	S ^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)=""
	Q
SORT7	;
	I $D(^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)) Q
	S CT=CT+1
	S ^TMP("SCRESULT",S1,S2,S3,S4,S5,S6,S7,CT)=PAT_"^"_SSN_"^"_INST_"^"_TEAMN_"^"_PROV_"^"_TEAMP_"^"_PREC_"^"_UNDATE2_"^"_UNREA
	S ^TMP("SCRESULT","B",PAT,SSN,INST,TEAMN)=""
	Q
FINAL	;
	I $G(^TMP("SCARRAY","S1"))="""ALL""" D
	.S (INST,PAT,NUM)="" S CC=0,C=0
	.S INST="" F  S INST=$O(^TMP("SCRESULT",INST)) Q:INST=""  D
	..S PAT="" F  S PAT=$O(^TMP("SCRESULT",INST,PAT)) Q:PAT=""  D
	...S NUM="" F  S NUM=$O(^TMP("SCRESULT",INST,PAT,NUM)) Q:NUM=""  D
	....S CC=CC+1 S ^TMP("SCRESULT",CC)=^TMP("SCRESULT",INST,PAT,NUM)
	....K ^TMP("SCRESULT",INST,PAT,NUM)
	I $G(^TMP("SCARRAY","S1"))'="""ALL""" D
	.S (S1,S2,S3,S4,S5,S6,S7)="",CT=0,C=0
	.IF CC="SORT1" D
	..S S1="" F  S S1=$O(^TMP("SCRESULT",S1)) Q:S1=""  D
	...S C="" F  S C=$O(^TMP("SCRESULT",S1,C)) Q:C=""  D
	....S CT=CT+1 S ^TMP("SCRESULT",CT)=^TMP("SCRESULT",S1,C)
	....K ^TMP("SCRESULT",S1,C)
	.I CC="SORT2" D
	..S S1="" F  S S1=$O(^TMP("SCRESULT",S1)) Q:S1=""  D
	...S S2="" F  S S2=$O(^TMP("SCRESULT",S1,S2)) Q:S2=""  D
	....S C="" F  S C=$O(^TMP("SCRESULT",S1,S2,C)) Q:C=""  D
	.....S CT=CT+1 S ^TMP("SCRESULT",CT)=^TMP("SCRESULT",S1,S2,C)
	.....K ^TMP("SCRESULT",S1,S2,C)
	.I CC="SORT3" D
	..S S1="" F  S S1=$O(^TMP("SCRESULT",S1)) Q:S1=""  D
	...S S2="" F  S S2=$O(^TMP("SCRESULT",S1,S2)) Q:S2=""  D
	....S S3="" F  S S3=$O(^TMP("SCRESULT",S1,S2,S3)) Q:S3=""  D
	.....S C="" F  S C=$O(^TMP("SCRESULT",S1,S2,S3,C)) Q:C=""  D
	......S CT=CT+1 S ^TMP("SCRESULT",CT)=^TMP("SCRESULT",S1,S2,S3,C)
	......K ^TMP("SCRESULT",S1,S2,S3,C)
	.I CC="SORT4" D
	..S S1="" F  S S1=$O(^TMP("SCRESULT",S1)) Q:S1=""  D
	...S S2="" F  S S2=$O(^TMP("SCRESULT",S1,S2)) Q:S2=""  D
	....S S3="" F  S S3=$O(^TMP("SCRESULT",S1,S2,S3)) Q:S3=""  D
	.....S S4="" F  S S4=$O(^TMP("SCRESULT",S1,S2,S3,S4)) Q:S4=""  D
	......S C="" F  S C=$O(^TMP("SCRESULT",S1,S2,S3,S4,C)) Q:C=""  D
	.......S CT=CT+1 S ^TMP("SCRESULT",CT)=^TMP("SCRESULT",S1,S2,S3,S4,C)
	.......K ^TMP("SCRESULT",S1,S2,S3,S4,C)
	.I CC="SORT5" D
	..S S1="" F  S S1=$O(^TMP("SCRESULT",S1)) Q:S1=""  D
	...S S2="" F  S S2=$O(^TMP("SCRESULT",S1,S2)) Q:S2=""  D
	....S S3="" F  S S3=$O(^TMP("SCRESULT",S1,S2,S3)) Q:S3=""  D
	.....S S4="" F  S S4=$O(^TMP("SCRESULT",S1,S2,S3,S4)) Q:S4=""  D
	......S S5="" F  S S5=$O(^TMP("SCRESULT",S1,S2,S3,S4,S5)) Q:S5=""  D
	.......S C="" F  S C=$O(^TMP("SCRESULT",S1,S2,S3,S4,S5,C)) Q:C=""  D
	........S CT=CT+1 S ^TMP("SCRESULT",CT)=^TMP("SCRESULT",S1,S2,S3,S4,S5,C)
	........K ^TMP("SCRESULT",S1,S2,S3,S4,S5,C)
	.I CC="SORT6" D
	..S S1="" F  S S1=$O(^TMP("SCRESULT",S1)) Q:S1=""  D
	...S S2="" F  S S2=$O(^TMP("SCRESULT",S1,S2)) Q:S2=""  D
	....S S3="" F  S S3=$O(^TMP("SCRESULT",S1,S2,S3)) Q:S3=""  D
	.....S S4="" F  S S4=$O(^TMP("SCRESULT",S1,S2,S3,S4)) Q:S4=""  D
	......S S5="" F  S S5=$O(^TMP("SCRESULT",S1,S2,S3,S4,S5)) Q:S5=""  D
	.......S S6="" F  S S6=$O(^TMP("SCRESULT",S1,S2,S3,S4,S5,S6)) Q:S6=""  D
	........S C="" F  S C=$O(^TMP("SCRESULT",S1,S2,S3,S4,S5,S6,C)) Q:C=""  D
	.........S CT=CT+1 S ^TMP("SCRESULT",CT)=^TMP("SCRESULT",S1,S2,S3,S4,S5,S6,C)
	.........K ^TMP("SCRESULT",S1,S2,S3,S4,S5,S6,C)
	.I CC="SORT7" D
	..S S1="" F  S S1=$O(^TMP("SCRESULT",S1)) Q:S1=""  D
	...S S2="" F  S S2=$O(^TMP("SCRESULT",S1,S2)) Q:S2=""  D
	....S S3="" F  S S3=$O(^TMP("SCRESULT",S1,S2,S3)) Q:S3=""  D
	.....S S4="" F  S S4=$O(^TMP("SCRESULT",S1,S2,S3,S4)) Q:S4=""  D
	......S S5="" F  S S5=$O(^TMP("SCRESULT",S1,S2,S3,S4,S5)) Q:S5=""  D
	.......S S6="" F  S S6=$O(^TMP("SCRESULT",S1,S2,S3,S4,S5,S6)) Q:S6=""  D
	........S S7="" F  S S7=$O(^TMP("SCRESULT",S1,S2,S3,S4,S5,S6,S7)) Q:S7=""  D
	.........S C="" F  S C=$O(^TMP("SCRESULT",S1,S2,S3,S4,S5,S6,S7,C)) Q:C=""  D
	..........S CT=CT+1 S ^TMP("SCRESULT",CT)=^TMP("SCRESULT",S1,S2,S3,S4,S5,S6,S7,C)
	..........K ^TMP("SCRESULT",S1,S2,S3,S4,S5,S6,S7,C)
	Q
EXIT	;
	K STAT,TN,TPN,IEN,INST,INSTN,UNDATE,UNREA,TEAMPN,SSN,SSNN,S1,S2,S3,S4,S5,S6,S7,S8
	K TEAM,TEAMN,TEAMP,PROVN,PROV,BDATE,EDATE,PAT,INAME,HOLD,NUM,NU,CC,C,CT,XX,ST
	K TN2,TPN2,UNDATE2,DATE2,EFFD,ERROR,SORT,SN,PDATE,POS,PREC,JJ,J,INUM,NN,P1,P2,P3
	K ^TMP("SCARRAY")
	Q
