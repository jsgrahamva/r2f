ONCUTX1	;Hines OIFO/RTK; UNKNOWN TREATMENT STUFFING; 09/09/10
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;
NCDSATF	;SURG DX/STAGING PROC @FAC (165.5,58.4)
	S $P(^ONCO(165.5,D0,3.1),U,5)="09"
	S $P(^ONCO(165.5,D0,3.1),U,6)=9999999
	S DR="58.4;58.5" D DIQ1^ONCNTX
	W:$D(NTX) !,"SURG DX/STAGING PROC @FAC.....: "_ONC(165.5,DA,58.4,"E")
	W !,"SURG DX/STAGING PROC @FAC DATE: "_ONC(165.5,DA,58.5,"E")
	Q
	;
SURATFR	;SURGERY OF PRIMARY @FAC (R) (165.5,50.2)
	D SGRP
	I $E(SGRP,3,4)=77 S SGRP=67422
	F SPS=0:0 S SPS=$O(^ONCO(164,SGRP,"SPS",SPS)) Q:$P(^ONCO(164,SGRP,"SPS",SPS,0),U,1)["Unknown;"
	S $P(^ONCO(165.5,DA,3.1),U,7)=$S(DATEDX>2971231:SPS,1:"00")
	N DI K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
	S DR=50.2 D EN^DIQ1
	W:$D(NTX) !,"SURGERY OF PRIMARY @FAC.....(R): "_ONC(165.5,DA,50.2,"E")
	Q
	;
SURATF	;SURGERY OF PRIMARY @FAC (F) (165.5,58.7)
	D SGRP
	F SPS=0:0 S SPS=$O(^ONCO(164,SGRP,"SPS",SPS)) Q:$P(^ONCO(164,SGRP,"SPS",SPS,0),U,1)["Unknown;"
	S $P(^ONCO(165.5,DA,3.1),U,30)=SPS
	S $P(^ONCO(165.5,DA,3.1),U,8)=9999999
	S $P(^ONCO(165.5,DA,2.3),U,4)=9
	N DI K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
	S DR="58.7;50.3;234" D EN^DIQ1
	W:$D(NTX) !,"SURGERY OF PRIMARY @FAC.....(F): "_ONC(165.5,DA,58.7,"E")
	W !,"APPROACH.......................: "_ONC(165.5,DA,234,"E")
	W !,"MOST DEFINITIVE SURG @FAC DATE.: "_ONC(165.5,DA,50.3,"E")
	Q
	;
NODATFR	;SCOPE OF LN SURGERY @FAC (R) (165.5,138.1)
	D SGRP
	I ($E(TPG,3,4)=76)!(TPG=67809)!(TPG=67420)!(TPG=67421)!(TPG=67423)!(TPG=67424) S SGRP=67141
	F SC=0:0 S SC=$O(^ONCO(164,SGRP,"SC5",SC)) Q:SC="B"  S LAST=SC
	S $P(^ONCO(165.5,DA,3.1),U,9)=LAST
	S $P(^ONCO(165.5,D0,3.1),U,11)=99
	N DI K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
	S DR="138.1;140.1" D DIQ1^ONCNTX
	W:$D(NTX) !,"SCOPE OF LN SURGERY @FAC....(R): "_ONC(165.5,DA,138.1,"E")
	W !,"NUMBER OF LN REMOVED @FAC...(R): "_ONC(165.5,DA,140.1,"E")
	Q
	;
NODEATF	;SCOPE OF LN SURGERY @FAC (F) (165.5,138.5)
	D SGRP
	S $P(^ONCO(165.5,DA,3.1),U,32)=9
	S $P(^ONCO(165.5,DA,3.1),U,23)="0000000"
	N DI K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
	S DR="138.5;138.3" D DIQ1^ONCNTX
	W:$D(NTX) !,"SCOPE OF LN SURGERY @FAC....(F): "_ONC(165.5,DA,138.5,"E")
	W !,"SCOPE OF LN SURGERY @FAC DATE..: "_ONC(165.5,DA,138.3,"E")
	Q
	;
SOSATFR	;SURG PROC/OTHER SITE @FAC (R) (165.5,139.1)
	D SGRP
	F SO=0:0 S SO=$O(^ONCO(164,SGRP,"SO5",SO)) Q:SO="B"  S LAST=SO
	S $P(^ONCO(165.5,DA,3.1),U,10)=$S(DATEDX>2971231:LAST,1:"")
	S DR=139.1 D DIQ1^ONCNTX
	W:$D(NTX) !,"SURG PROC/OTHER SIT @FAC...(R): "_ONC(165.5,DA,139.1,"E")
	Q
	;
SOSNATF	;SURG PROC/OTHER SITE @FAC (F) (165.5,139.5)
	S $P(^ONCO(165.5,DA,3.1),U,34)=9
	S $P(^ONCO(165.5,D0,3.1),U,25)=9999999
	S DR="139.5;139.3" D DIQ1^ONCNTX
	W:$D(NTX) !,"SURGICAL PROC/OTHER SITE @FAC..: "_ONC(165.5,DA,139.5,"E")
	W !,"SURG PROC/OTHER SITE @FAC DATE.: "_ONC(165.5,DA,139.3,"E")
	Q
	;
RADATF	;RADIATION @FAC (165.5,51.4)
	S $P(^ONCO(165.5,DA,3.1),U,12)=9
	S $P(^ONCO(165.5,DA,3.1),U,13)=9999999
	S DR="51.4;51.5" D DIQ1^ONCNTX
	W:$D(NTX) !,"RADIATION @FAC.................: "_ONC(165.5,DA,51.4,"E")
	W !,"RADIATION @FAC DATE............: ",ONC(165.5,DA,51.5,"E")
	Q
	;
CHEMATF	;CHEMOTHERAPY @FAC (165.5,53.3)
	I $G(XX)=88 D
	.S $P(^ONCO(165.5,DA,3.1),U,14)=88
	.S $P(^ONCO(165.5,DA,3.1),U,15)=8888888
	I $G(XX)=99 D
	.S $P(^ONCO(165.5,DA,3.1),U,14)=99
	.S $P(^ONCO(165.5,DA,3.1),U,15)=9999999
	S DR="53.3;53.4" D DIQ1^ONCNTX
	W:$D(NTX) !,"CHEMOTHERAPY @FAC..............: "_ONC(165.5,DA,53.3,"E")
	W !,"CHEMOTHERAPY @FAC DATE.........: ",ONC(165.5,DA,53.4,"E")
	Q
	;
HTATF	;HORMONE THERAPY @FAC (165.5,54.3)
	I $G(XX)=88 D
	.S $P(^ONCO(165.5,DA,3.1),U,16)=88
	.S $P(^ONCO(165.5,DA,3.1),U,17)=8888888
	I $G(XX)=99 D
	.S $P(^ONCO(165.5,DA,3.1),U,16)=99
	.S $P(^ONCO(165.5,DA,3.1),U,17)=9999999
	S DR="54.3;54.4" D DIQ1^ONCNTX
	W:$D(NTX) !,"HORMONE THERAPY @FAC...........: "_ONC(165.5,DA,54.3,"E")
	W !,"HORMONE THERAPY @FAC DATE......: ",ONC(165.5,DA,54.4,"E")
	Q
	;
IMMATF	;IMMUNOTHERAPY @FAC (165.5,55.3)
	I $G(XX)=88 D
	.S $P(^ONCO(165.5,DA,3.1),U,18)=88
	.S $P(^ONCO(165.5,DA,3.1),U,19)=8888888
	I $G(XX)=99 D
	.S $P(^ONCO(165.5,DA,3.1),U,18)=99
	.S $P(^ONCO(165.5,DA,3.1),U,19)=9999999
	S DR="55.3;55.4" D DIQ1^ONCNTX
	W:$D(NTX) !,"IMMUNOTHERAPY @FAC.............: "_ONC(165.5,DA,55.3,"E")
	W !,"IMMUNOTHERAPY @FAC DATE........: ",ONC(165.5,DA,55.4,"E")
	Q
	;
OTHATF	;OTHE TREATMENT @FAC (165.5,57.3)
	I $G(X)'=8 S $P(^ONCO(165.5,DA,3.1),U,20)=9
	S $P(^ONCO(165.5,DA,3.1),U,21)=9999999
	S DR="57.3;57.4" D DIQ1^ONCNTX
	W:$D(NTX) !,"OTHER TREATMENT @FAC...........: "_ONC(165.5,DA,57.3,"E")
	W !,"OTHER TREATMENT @FAC DATE......: ",ONC(165.5,DA,57.4,"E")
	Q
	;
CHKPRIM	;If Primary Site UNKNOWN, BRAIN, HEMATOPOIETIC or LEUKEMIA,
	;stuff SCOPE OF LN SURGERY (R) (165.5,138) and
	;      SCOPE OF LN SURGERY (F) (165.5,138.4) with 9s
CHKPRMR	;ROADS
	S SITE=$P(^ONCO(165.5,DA,0),U,1)
	I (SITE=35)!(SITE=58)!(SITE=63)!(SITE=65)!($$LYMPHOMA^ONCFUNC(DA)=1) D
	.D SGRP
	.I ($E(TPG,3,4)=76)!(TPG=67809)!(TPG=67420)!(TPG=67421)!(TPG=67423)!(TPG=67424) S SGRP=67141
	.F SC=0:0 S SC=$O(^ONCO(164,SGRP,"SC5",SC)) Q:SC="B"  S LAST=SC
	.S $P(^ONCO(165.5,DA,3),U,40)=LAST
	.W !,"SCOPE OF LN SURGERY.........(R): ",$P(^ONCO(164,SGRP,"SC5",LAST,0),U)
	.D NODER^ONCUTX W !
	.S NTX=1 D NODATFR K NTX
	.S Y="@139"
	Q
	;
CHKPRMF	;SCOPE OF LN SURGERY (F) (165.5,138.4) Code 9 stuffing
	;FORDS pages 138-139
	S TOP=$P($G(^ONCO(165.5,DA,2)),U,1)
	S MO=$$HIST^ONCFUNC(DA)
	I ($E(TOP,1,4)=6770)!($E(TOP,1,4)=6771)!($E(TOP,1,4)=6772)!($E(TOP,1,4)=6776)!(($$LYMPHOMA^ONCFUNC(DA)=1)&($E(TOP,1,4)=6777))!($E(TOP,1,4)=6776)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424)!((MO'<97310)&(MO'>99899)) D
	.S $P(^ONCO(165.5,DA,3.1),U,31)=9
	.W !,"SCOPE OF LN SURGERY.........(F): Unknown/NA"
	.D NODE^ONCUTX W !
	.S NTX=1 D NODEATF K NTX
	.S Y="@46"
	Q
	;
SGRP	S TPG=$P($G(^ONCO(165.5,D0,2)),U,1)
	S SGRP=$P($G(^ONCO(164,TPG,0)),U,16)
	;pre-2003 C76.0-C76.8, C80.9 cases
	;see ROADS page D-cxliii
	I DATEDX<3030000,($E(TPG,3,4)=76)!(TPG=67809) S SGRP=67141
	Q
	;
CLEANUP	;Cleanup
	K D0,DA,DATEDX,DIC,DIQ,DR,LAST,MO,SC,SGRP,SITE,SO,SPS,TOP,TPG,X,XX,Y
