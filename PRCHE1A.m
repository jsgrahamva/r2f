PRCHE1A ;WISC/DJM-IFCAP EDIT VENDOR FILE ;4/17/96  3:18 PM
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ; NEW ENTER/EDIT VENDOR FILE CALLED FROM FISCAL OPTION
VEDIT(Y,SITE) ;
 N DA,PRCHV3,FLAG,FISCAL,DIE,DR
 S DA=+Y D  Q:FLAG=0
 .S PRCHV3=$G(^PRC(440,DA,3)),FLAG=0
 .I $P(PRCHV3,U,4)="" S FLAG=1 Q  ;NO FMS VENDOR CODE - DO 'ADD' VENDOR REQUEST
 .I $P(PRCHV3,U,4)]"" S FLAG=2 Q  ;FMS VENDOR CODE - DO 'CHANGE' VENDOR REQUEST
 S FISCAL=$G(^PRC(411,SITE,9))
 I $P(FISCAL,U,3)="Y",'$D(^XUSEC("PRCFA VENDOR EDIT",DUZ)) D  Q
 .  Q:$$NEW^PRCOVTST(DA,SITE,FLAG)
 .  S DIE="^PRC(440.3,"
 .  S DR="47///^S X=FLAG;48///^S X=DA;49///^S X=SITE"
 .  D ^DIE
 .  Q
 I FLAG=1 D NEW^PRCOVRQ(DA,SITE) QUIT
 I FLAG=2 D UPDATE^PRCOVRQ1(DA,SITE) QUIT
 QUIT
 ;
