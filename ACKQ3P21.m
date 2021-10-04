ACKQ3P21	 ;ALB/CLA - IMPORT WIZARD FOR ICD-10 CODES INTO FILE 509850.1;31 Mar 2014  9:55 AM
	;;3.0;QUASAR;**21**;Feb 11, 2000;Build 40
	;
	; Reference/IA
	;  $$CODEN^ICDEX - 5747
	;  $$CSI^ICDEX - 5747
	;
%	; - Top level entry point
	N COUNT,COUNT2
	D BMES^XPDUTL("Adding Entries to A&SP DIAGNOSTIC CONDITION FILE")
	D SETVER,EN
	I COUNT=0 D  Q
	. D BMES^XPDUTL("ICD-10 Entries Already in File...Install Step to Add Entries Skipped")
	D MES^XPDUTL("     Total Diagnosis Entries added to A&SP DIAGNOSTIC CONDITION FILE: "_COUNT)
	I COUNT=1150 D BMES^XPDUTL("ALL ENTRIES ADDED FROM SCRATCH SUCCESSFULY")
	I COUNT'=1150,COUNT'=0 D BMES^XPDUTL("Entry totals not equal 1150 - Please check all Entries Loaded")
	Q
	;
SETVER	; Set ICD version on first entries
	N IEN,ICDVER
	F IEN=0:0 S IEN=$O(^ACK(509850.1,IEN)) Q:'IEN  D
	. S ICDVER=$$CSI^ICDEX(80,IEN)
	. S $P(^ACK(509850.1,IEN,0),"^",7)=ICDVER Q
	Q
	;
EN	; - Store Diagnosis DATA in file 509850.1
	N ACKLAYGO,DGI,TEXT,TYPE,ICDCODE,ICDIEN,DESC,DIC,DA,X,Y,IEN,OKAY,ERR
	S Y=1,COUNT=0
	N ROU F ROU="ACKQ3P22","ACKQ3P23","ACKQ3P24","ACKQ3P25","ACKQ3P26","ACKQ3P27","ACKQ3P28","ACKQ3P29","ACKQ3P30","ACKQ3P31" F DGI=1:1 S TEXT=$P($T(@("DIAG+"_DGI_"^"_ROU)),";;",2,3) Q:TEXT=""  D
	.  S TYPE=$P(TEXT,"^",1)
	.  S ICDCODE=$P(TEXT,"^",2)
	.  S DESC=$P(TEXT,"^",3)
	.  S ICDIEN=+$$CODEN^ICDEX(ICDCODE,80)
	.  I ICDIEN<1 W !,ICDCODE Q
	.  I '$O(^ACK(509850.1,"B",ICDIEN,0)) D
	..  K DIC,DA,DR,DD,DO,X,DINUM
	..  S DINUM=ICDIEN
	..  S DIC=509850.1,DIC(0)="LEFZ",X=ICDIEN,ACKLAYGO=1
	..  ;S DIC("DR")="1///"_$E(TYPE,1)_";8////"_ICDCODE_";10////"_DESC_";3///"_ICDCODE_";9////30"
	..  S DIC("DR")=".04///SA;.06///1"
	..  D FILE^DICN S IEN=+Y
	..  I +Y>0 W "." S COUNT=COUNT+1
	..  I Y=-1 S ERR=$G(ERR)+1
	Q
	;
PURG	; -- CLEAN OUT ENTRIES TO TRY AGAIN
	;  - FOR development and testing only
	N CNT,CNT2
	S CNT=0
	D PURGV,PURGD
	W !,"Entries Deleted - Diagnosis=",$G(CNT)
	Q
PURGV	; delete version from entries
	N IEN,ICDVER
	F IEN=0:0 S IEN=$O(^ACK(509850.1,IEN)) Q:'IEN  I $G(^ACK(509850.1,IEN,0))'="" S $P(^ACK(509850.1,IEN,0),"^",7)=""
	Q
PURGD	; clear out data added to retest
	N DIC,DIE,TEXT,ICDCODE,DA,DR,IEN,DIK
	;F DGI=1:1 S TEXT=$P($T(DIAG+DGI^ACKQ3P22),";;",2,3) Q:TEXT=""  D
	N DGI,ROU F ROU="ACKQ3P22","ACKQ3P23","ACKQ3P24","ACKQ3P25","ACKQ3P26","ACKQ3P27","ACKQ3P28","ACKQ3P29","ACKQ3P30","ACKQ3P31" F DGI=1:1 S TEXT=$P($T(@("DIAG+"_DGI_"^"_ROU)),";;",2,3) Q:TEXT=""  D
	. S ICDCODE=$P(TEXT,"^",2)
	. S IEN=+$$CODEN^ICDEX(ICDCODE,80)
	. ;S DIC=509850.1,DIC(0)="EMN",X=ICDCODE D ^DIC S IEN=+Y
	. ;K DIC(0)
	. Q:'$D(^ACK(509850.1,IEN,0))
	. S DIK="^ACK(509850.1,",DA=IEN D ^DIK
	. S CNT=$G(CNT)+1
	. W "."
	Q
