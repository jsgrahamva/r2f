EC725U38 ;ALB/GTS/JAP/GT - EC National Procedure Update; 1/30/2006
 ;;2.0; EVENT CAPTURE ;**80**;8 May 96
 ;
 ;this routine is used as a post-init in a KIDS build 
 ;to modify the EC National Procedure file #725
 ;
ADDPROC ;* add national procedures
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
FILPROC ;File national procedures
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
NEW ;national procedures to add;;descript^nation #^CPT code^beg seq^end seq
 ;;FOOT EXAM EA 10MIN^NU157
 ;;AUD REHAB STATUS, 1ST HR^SP541^92626
 ;;AUD REHAB STATUS, ADD 15 MIN^SP542^92627
 ;;AUD REHAB TRMT, POSTT LING HL^SP543^92633
 ;;L8699 PROSTHETIC IMPLANT, NOS^SP544^L8699
 ;;QUIT
NAMECHG ;* change national procedure names
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
CHNG ;name changes -national code #^new procedure name
 ;;NU022^PHONE-BRIEF W/OTHER PROV
 ;;NU023^PHONE INTRM W/OTHER PROV
 ;;NU024^PHONE LENGTHY W/OTHER PROV
 ;;NU025^INTERDISC GP,2-5PT,15M
 ;;NU026^INTERDISC GP,6-10PT,15M
 ;;NU027^INTERDISC GP,11-20PT,15M
 ;;NU028^INTERDISC GP,>20PT,15M
 ;;NU033^IP NUTR ED GP,2-5PT,30M
 ;;NU034^IP NUTR ED GP,6-10PT,30M
 ;;NU035^IP NUTR EDGP,11-20PT,30M
 ;;NU036^IP NUTR ED GP,>20PT,30M
 ;;NU044^MNT NUTR GP,2-5 PT,30M
 ;;NU045^MNT NUTR GP,6-10 PT,30M
 ;;NU046^MNT NUTR GP,11-20 PT,30M
 ;;NU047^MNT NUTR GP,>20PT,30M
 ;;NU052^MNT GP 2ND REF,2-5PT,30M
 ;;NU053^MNT GP 2ND REF,6-10PT,30M
 ;;NU054^MNT GP 2ND REF,11-20PT,30M
 ;;NU055^MNT GP 2ND REF>20PT,30M
 ;;NU060^DSMT GP,2-5PT,30M
 ;;NU061^DSMT GP,6-10PT,30M
 ;;NU062^DSMT GP,11-20PT,30M
 ;;NU063^DSMT GP,>20PT,30M
 ;;NU069^WT MGT, 2-5PT, 1st 30M
 ;;NU070^WT MGT, 6-10PT, 1st 30M
 ;;NU071^WT MGT, 11-20PT, 1st 30M
 ;;NU072^WT MGT, >20PT, 1st 30M
 ;;NU077^NUTR ED, 2-5 PT 1st 30M
 ;;NU078^NUTR ED, 6-10 PT 1st 30M
 ;;NU079^NUTR ED, 11-20 PT 1st 30M
 ;;NU080^NUTR ED, >20 PT 1st 30M
 ;;NU085^DIAB MGMT GP,2-5 PT,1st 30M
 ;;NU086^DIAB MGMT GP,6-10 PT, 1st 30M
 ;;NU087^DIAB MGMT GP,11-20 PT, 1st 30M
 ;;NU088^DIAB MGMT GP,>20 PT, 1st 30M
 ;;NU093^PT ED GP, 2-5PT, 1st 30M
 ;;NU094^PT ED GP, 6-10PT, 1st 30M
 ;;NU095^PT ED GP, 11-20PT, 1st 30M
 ;;NU096^PT ED GP, >20PT, 1st 30M
 ;;NU101^SMOK CESS, 2-5 PT, 1st 30M
 ;;NU102^SMOK CESS, 6-10 PT, 1st 30M
 ;;NU103^SMOK CESS, 11-20 PT, 1st 30M
 ;;NU104^SMOK CESS, >20 PT, 1st 30M
 ;;NU109^NUTR GP, 2-5 PT, EA AD'L 30M
 ;;NU110^NUTR GP, 6-10 PT, EA AD'L 30M
 ;;NU111^NUTR GP, 11-20 PT, EA AD'L 30M
 ;;NU112^NUTR GP, >20 PT, EA AD'L 30M
 ;;NU117^WT MGT, 2-5 PT, EA AD'L 30M
 ;;NU118^WT MGT, 6-10 PT, EA AD'L 30M
 ;;NU119^WT MGT, 11-20 PT, EA AD'L 30M
 ;;NU120^WT MGT, >20 PT, EA AD'L 30M
 ;;NU125^DIAB MGT,2-5PT, EA AD'L 30M
 ;;NU126^DIAB MGT,6-10PT, EA AD'L 30M
 ;;NU127^DIAB MGT,11-20PT, EA AD'L 30M
 ;;NU128^DIAB MGT,>20PT, EA AD'L 30M
 ;;NU133^PT ED GP, 2-5 PT, EA AD'L 30M
 ;;NU134^PT ED GP, 6-10 PT, EA AD'L 30M
 ;;NU135^PT ED GP, 11-20 PT, EA AD'L 30M
 ;;NU136^PT ED GP, >20 PT, EA AD'L 30M
 ;;NU141^SMOK CESS, 2-5PT, EA AD'L 30M
 ;;NU142^SMOK CESS, 6-10, EA AD'L 30M
 ;;NU143^SMOK CESS, 11-20, EA AD'L 30M
 ;;NU144^SMOK CESS, >20PT, EA AD'L 30M
 ;;SP001^CERUMEN MANAGEMENT
 ;;SP004^ACOUSTIC DEVICE EVAL/SELECTION
 ;;SP013^FOCUSED ARTIC/PHONOLOGY EVAL
 ;;SP015^FOCUSED DYSARTH/MOTOR SP EVAL 
 ;;SP018^FOCUSED RECEPT/EXPRESS LANG EVAL
 ;;SP021^FOCUSED FLUENCY EVAL
 ;;SP022^FOCUSED VOICE EVAL
 ;;SP023^AUDITORY PROCESSING ASSESSMENT
 ;;SP024^OTHER NONINVASIVE INSTRUM EXAM
 ;;SP028^NONSPOKEN LANGUAGE TREATMENT
 ;;SP029^RECEPT/EXPRESS LANG TREATMENT
 ;;SP030^VOICE TREATMENT
 ;;SP031^ARTIC/PHONOLOGY TREATMENT
 ;;SP032^MOTOR SPEECH TREATMENT
 ;;SP033^APHASIA TREATMENT
 ;;SP034^FLUENCY TREATMENT
 ;;SP036^AUDITORY PROCESSING TREATMENT
 ;;SP038^INITIAL ACOUSTIC DEV FIT/ORIENT
 ;;SP051^COCHLEAR IMPLANT REHAB
 ;;SP055^LARYNGEAL FUNCTION STUDY
 ;;SP057^SWALLOWING TREATMENT
 ;;SP097^AUDITORY EVOKED POT, LIMITED
 ;;SP103^HEARING AID ASSESSMENT, MON
 ;;SP104^HEARING AID ASSESSMENT, BIN
 ;;SP105^HEARING AID CHECK, MON
 ;;SP106^HEARING AID CHECK, BIN
 ;;SP112^VOICE PROSTHESIS EVAL/FITTING
 ;;SP113^VOICE PROSTHESIS TREATMENT
 ;;SP228^SPEECH/LANG EVAL
 ;;SP229^SPEECH/LANG TREATMENT
 ;;SP230^CLINICAL SWALLOWING EVAL
 ;;SP245^FOCUSED NASALITY EVAL
 ;;SP246^FOCUSED ALARYNGEAL SPEECH EVAL
 ;;SP247^FOCUSED PROSODY EVAL
 ;;SP248^ALARYNGEAL SPEECH TREATMENT
 ;;SP249^NASALITY TREATMENT 
 ;;SP315^AUDITORY EVOKED POT, DIAGNOSTIC
 ;;SP478^EVAL NON SPEECH GEN AAC DEVICE
 ;;SP481^THERAPEUTIC SERV NON SP GEN DEV
 ;;SP488^REMOVE FOREIGN BODY
 ;;SP491^DIAG ANALYSIS COCHLEAR IMPLANT
 ;;SP494^SUBSEQUENT PROGRAMMING
 ;;SP521^A9280 ALERTING DEVICE, NOC
 ;;QUIT
