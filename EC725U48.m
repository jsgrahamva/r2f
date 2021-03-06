EC725U48	;ALB/GTS/JAP/GT - EC National Procedure Update; 02/27/2008
	;;2.0; EVENT CAPTURE ;**96**;8 May 96;Build 5
	;
	;this routine is used as a post-init in a KIDS build 
	;to modify the EC National Procedure file #725
	;
ADDPROC	;* add national procedures
	;
	;  ECXX is in format:
	;   NAME^NATIONAL NUMBER^CPT CODE^FIRST NATIONAL NUMBER SEQUENCE
	;   LAST NATIONAL NUMBER SEQUENCE
	;
	N ECX,ECXX,ECDINUM,NAME,CODE,CPT,COUNT,X,Y,DIC,DIE,DA,DR,DLAYGO,DINUM
	N ECADD,ECBEG,ECEND,CODX,NAMX,ECSEQ,LIEN,STR,CPTN,STR
	D MES^XPDUTL(" ")
	D BMES^XPDUTL("Adding new procedures to EC NATIONAL PROCEDURE File (#725)...")
	D MES^XPDUTL(" ")
	S ECDINUM=$O(^EC(725,9999),-1),COUNT=$P(^EC(725,0),U,4)
	F ECX=1:1 S ECXX=$P($T(NEW+ECX),";;",2) Q:ECXX="QUIT"  D
	.S NAME=$P(ECXX,U,1),CODE=$P(ECXX,U,2),CPTN=$P(ECXX,U,3),CODX=CODE
	.S CPT=""
	.I CPTN'="" S CPT=$$FIND1^DIC(81,"","X",CPTN) I +CPT<1 D  Q
	..S STR="   CPT code "_CPTN_" not a valid code in CPT File."
	..D MES^XPDUTL(" ")
	..D BMES^XPDUTL("   ["_CODE_"] "_STR)
	.S ECBEG=$P(ECXX,U,4),ECEND=$P(ECXX,U,5),NAMX=NAME
	.I ECBEG="" S X=NAME D FILPROC Q
	.F ECSEQ=ECBEG:1:ECEND D
	..S ECADD="000"_ECSEQ,ECADD=$E(ECADD,$L(ECADD)-2,$L(ECADD))
	..;S NAME=NAMX_ECADD,X=NAME,CODE=CODX_ECADD
	..I $E(CODX,1,3)'="RCM" S NAME=NAMX_ECSEQ,X=NAME,CODE=CODX_ECADD
	..E  S NAME=NAMX_$E(ECADD,2,99),X=NAME,CODE=CODX_$E(ECADD,2,99)
	..D FILPROC
	S $P(^EC(725,0),U,4)=COUNT,X=$O(^EC(725,999999),-1),$P(^EC(725,0),U,3)=X
	Q
	;
FILPROC	;File national procedures
	I '$D(^EC(725,"D",CODE)) D
	.S ECDINUM=ECDINUM+1,DINUM=ECDINUM,DIC(0)="L",DLAYGO=725,DIC="^EC(725,"
	.S DIC("DR")="1////^S X=CODE;4////^S X=CPT"
	.D FILE^DICN
	.I +Y>0 D
	..S COUNT=COUNT+1
	..D MES^XPDUTL(" ")
	..S STR="   Entry #"_+Y_" for "_$P(Y,U,2)
	..S STR=STR_$S(CPT'="":" [CPT: "_CPT_"]",1:"")_" ("_CODE_")"
	..D BMES^XPDUTL(STR_"  ...successfully added.")
	.I Y=-1 D
	..D MES^XPDUTL(" ")
	..D BMES^XPDUTL("ERROR when attempting to add "_NAME_" ("_CODE_")")
	I $D(^EC(725,"DL",CODE)) D
	.S LIEN=$O(^EC(725,"DL",CODE,""))
	.D MES^XPDUTL(" ")
	.D BMES^XPDUTL("   Your site has a local procedure (entry #"_LIEN_") in File #725")
	.D BMES^XPDUTL("   which uses "_CODE_" as its National Number.")
	.D BMES^XPDUTL("   Please inactivate this local procedure.")
	.K Y
	Q
NEW	;national procedures to add;;descript^nation #^CPT code^beg seq^end seq
	;;97001 REFER/CONS/SCREEN^RC001^97001
	;;97001 RECORD REVIEW^RC002^97001
	;;97001 ASMNT INIT 30M^RC003^97001
	;;97002 ASMNT UPREVDISC 30M^RC004^97002
	;;97001 ASMNT PROG NOTE^RC005^97001
	;;97001 ASMNT PROG NOTE 15M^RC006^97001
	;;97001 DISCH/COMM REF 15M^RC007^97001
	;;97001 DISCH/COMM REF 30M^RC008^97001
	;;98961 TEAMEETCAREPLAN 15M^RC009^98961
	;;98961 TEAMEETCAREPLAN 30M^RC010^98961
	;;98962 IDT GRP 2-4 30M^RC011^98962
	;;98962 IDT GRP 5-10 30M^RC012^98962
	;;97530 REC CREATARTIND 15M^RC013^97530
	;;99499 REC CREATARTGRP 2-4^RC014^99499
	;;99499 REC CREATARTGRP 5-20^RC015^99499
	;;99499 REC CREATARTGRP >20^RC016^99499
	;;97532 RECTHER EMOT IND 15M^RC017^97532
	;;97530 RECTHER COG IND 15M^RC018^97530
	;;97112 RECTHER PHY IND 15M^RC019^97112
	;;97532 RECTHER SOC IND 15M^RC020^97532
	;;97150 RECTHER SOC GRP 2-4^RC021^97150
	;;97150 RECTHER SOC GRP 5-20^RC022^97150
	;;97150 RECTHER SOC GRP>20^RC023^97150
	;;97150 RECTHER COG GRP 2-4^RC024^97150
	;;97150 RECTHER COG GRP 5-20^RC025^97150
	;;97150 RECTHER COG GRP >20^RC026^97150
	;;97150 RECTHER PHY GRP 2-4^RC027^97150
	;;97150 RECTHER PHY GRP 5-20^RC028^97150
	;;97150 RECTHER PHY GRP >20^RC029^97150
	;;97150 RECTHER EMOT GRP 2-4^RC030^97150
	;;97150 RECTHER EMOTGRP 5-20^RC031^97150
	;;97150 RECTHER EMOTGRP >20^RC032^97150
	;;97530 ARTTHER SOC IND 15M^RC033^97530
	;;97532 ARTTHER COG IND 15M^RC034^97532
	;;97533 ARTTHER EMOTIND 15M^RC035^97533
	;;97150 ARTTHER SOC GRP 2-4^RC036^97150
	;;97150 ARTTHER SOC GRP 5-20^RC037^97150
	;;97150 ARTTHER SOC GRP >20^RC038^97150
	;;97150 ARTTHER COG GRP 2-4^RC039^97150
	;;97150 ARTTHER COG GRP 5-20^RC040^97150
	;;97150 ARTTHER COG GRP >20^RC041^97150
	;;97150 ARTTHER EMOTGRP 2-4^RC042^97150
	;;97150 ARTTHER EMOTGRP 5-20^RC043^97150
	;;97150 ARTTHER EMOTGRP >20^RC044^97150
	;;97530 DANCETHER IND15M^RC045^97530
	;;97530 DANCETHER GRP 2-4^RC046^97150
	;;97530 DANCETHER GRP 5-20^RC047^97150
	;;97530 DANCETHER GRP >20^RC048^97150
	;;97150 DRAMA THER IND^RC049^97530
	;;97530 DRAMA THER GRP 2-4^RC050^97150
	;;97530 DRAMA THER GRP 5-20^RC051^97150
	;;97530 DRAMA THER GRP >20^RC052^97150
	;;92506 MUSTHER SOC IND 15M^RC053^92506
	;;92507 MUSTHER COG IND 15M^RC054^92507
	;;97112 MUSTHER PHYIND 15M^RC055^97112
	;;91533 MUSTHER EMOTIND 15M^RC056^97533
	;;97150 MUSTHER SOCGRP 2-4^RC057^97150
	;;97150 MUSTHER SOCGRP 5-20^RC058^97150
	;;97150 MUSTHER SOCGRP >20^RC059^97150
	;;97150 MUSTHER COGGRP 2-4^RC060^97150
	;;97150 MUSTHER COGGRP 5-20^RC061^97150
	;;97150 MUSTHER COGGRP >20^RC062^97150
	;;97150 MUSTHER PHYGRP 2-4^RC063^97150
	;;97150 MUSTHER PHYGRP 5-20^RC064^97150
	;;97150 MUSTHER PHYGRP >20^RC065^97150
	;;97150 MUSTHER EMOTGRP 2-4^RC066^97150
	;;97150 MUSTHER EMOTGRP 5-20^RC067^97150
	;;97150 MUSTHER EMOTGRP >20^RC068^97150
	;;97110 AQUATIC ACT IND 30M^RC069^97110
	;;S9454 AQUATIC ACT GRP 2-4^RC070^S9454
	;;S9454 AQUATIC ACT GRP 5-20^RC071^S9454
	;;S9454 AQUATIC ACT GRP >20^RC072^S9454
	;;97113 AQUATICTHER IND 30M^RC073^97113
	;;97150 AQUATICTHER GRP 2-4^RC074^97150
	;;97150 AQUATICTHER GRP5-20^RC075^97150
	;;97150 AQUATICTHER GRP >20^RC076^97150
	;;97537 COMMIINTEGRT IND^RC077^97537
	;;97537 COMMINTEGRTGRP 2-4^RC078^97537
	;;97537 COMM INTEGRTGRP 5-20^RC079^97537
	;;97537 COMM INTEGRTGRP >20^RC080^97537
	;;S9446 LEIS EDUC IND 15M^RC081^S9446
	;;S9446 LEIS EDUCGRP2-4 15M^RC082^S9446
	;;S9446 LEIS EDUCGRP 5-20 15M^RC083^S9446
	;;S9446 LEIS EDUCGRP>20 15M^RC084^S9446
	;;98966 TELEPHONE SHORT^RC085^98966
	;;98967 TELEPHONE MED^RC086^98967
	;;98968 TELEPHONE LONG^RC087^98968
	;;T2001 PAT ESCORT GRP 2-4^RC088^T2001
	;;T2001 PAT ESCORT GRP 5-20^RC089^T2001
	;;T2001 PAT ESCORT GRP >20^RC090^T2001
	;;CNH PHONE OVERSIGHT^HH142^
	;;CNH FAX REVIEW ONLY^HH143^
	;;NU162/MNT F/U EA 15M^NU162^97803
	;;NU163/MNT SUBSEQ EA 15M^NU163^G0270
	;;NU164/NUT CNSG IND,1ST15M^NU164^S9470
	;;NU165/CASE MGT,W/PT EA15M^NU165^T1017
	;;NU166/NUT SCREENING 10M^NU166^T1023
	;;NU167/OTHER OPT VISIT^NU167^99211
	;;NU168/PT EDUC 1ST 15M^NU168^S9445
	;;NU169/INSLN PMP ED 1ST15M^NU169^S9145
	;;NU170/GLUC FINGER STICK^NU170^82962
	;;NU171/PHONE 5-10 MIN^NU171^98966
	;;NU172/PHONE 11-20 MIN^NU172^98967
	;;NU173/PHONE 21-30 MIN^NU173^98968
	;;NU174/DSMT ACCRED IND 30M^NU174^G0108
	;;NU175/DSMT NONACD 1ST15M^NU175^S9465
	;;NU176/DSMT NONACD FU1ST15^NU176^S9140
	;;NU177/CBGM^NU177^95250
	;;NU178/SELF-MGT ED IND,30M^NU178^98960
	;;NU179/SELF MGT GP2-4,30M^NU179^98961
	;;NU180/SELF MGT GP5-8,30M^NU180^98962
	;;NU181/COLL RVW ELEC DATA^NU181^99091
	;;NU182/MNT INIT EA 15M^NU182^97802
	;;NON-PHYS TM CNF, PT PRSNT^SP551^99366
	;;NON-PHYS TM CNF, PT NOT PRSNT^SP552^99368
	;;98969 ONLINE SERVICE^SP553^98969
	;;QUIT
NAMECHG	;* change national procedure names
	;
	;  ECXX is in format:
	;   NATIONAL NUMBER^NEW NAME
	;
	N ECX,ECXX,ECDA,DA,DR,DIC,DIE,X,Y,STR
	D MES^XPDUTL(" ")
	D BMES^XPDUTL("Changing names in EC NATIONAL PROCEDURE File (#725)...")
	D MES^XPDUTL(" ")
	F ECX=1:1 S ECXX=$P($T(CHNG+ECX),";;",2) Q:ECXX="QUIT"  D
	.I $D(^EC(725,"D",$P(ECXX,U,1))) D
	..S ECDA=+$O(^EC(725,"D",$P(ECXX,U,1),0))
	..I $D(^EC(725,ECDA,0)) D
	...S DA=ECDA,DR=".01////^S X=$P(ECXX,U,2)",DIE="^EC(725," D ^DIE
	...D MES^XPDUTL(" ")
	...D MES^XPDUTL("   Entry #"_ECDA_" for "_$P(ECXX,U,1))
	...D BMES^XPDUTL("      ... field (#.01) updated to  "_$P(ECXX,U,2)_".")
	.I '$D(^EC(725,"D",$P(ECXX,U,1))) D
	..D MES^XPDUTL(" ")
	..S STR="Can't find entry for "_$P(ECXX,U,1)
	..D BMES^XPDUTL(STR_" ...field (#.01) not updated.")
	Q
	;
CHNG	;name changes -national code #^new procedure name
	;;NU019^NU019/PHONE 5-10M NO PT 
	;;NU020^NU020/PHONE 11-20M NO PT
	;;NU021^NU021/PHONE 21-30M NO PT
	;;NU022^NU022/PHONE 5-10M PROV
	;;NU023^NU023/PHONE 11-20M PROV
	;;NU024^NU024/PHONE 21-30M  PROV
	;;SP350^STANDARDIZED COGNITIVE TESTING
	;;SW010^PHONE CONTACT 5-10 MIN
	;;SW012^PHONE D/C NONMH F/U 15MIN
	;;SW044^PHONE CONTACT 11-20 MIN
	;;SW045^PHONE CONTACT 21-30 MIN
	;;SW054^PHONE D/C NONMH F/U 45MIN
	;;SW089^PHONE D/C MH F/U 15 MIN
	;;SP196^98966 TELEPHONE SERVICE, 5-10 MIN
	;;SP197^98967 TELEPHONE SERVICE, 11-20 MIN
	;;SP198^98968 TELEPHONE SERVICE, 21-30 MIN
	;;QUIT
