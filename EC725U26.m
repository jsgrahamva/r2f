EC725U26 ;ALB/GTS/JAP/GT - EC National Procedure Update; 9/11/2003
 ;;2.0; EVENT CAPTURE ;**67**;8 May 96
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
 ;;TELEMETRY BEDDAY WARD 1^CA001
 ;;TELEMETRY BEDDAY WARD 2^CA002
 ;;TELEMETRY BEDDAY WARD 3^CA003
 ;;TELEMETRY BEDDAY WARD 4^CA004
 ;;TELEMETRY BEDDAY WARD 5^CA005
 ;;TELEMETRY BEDDAY WARD 6^CA006
 ;;TELEMETRY BEDDAY WARD 7^CA007
 ;;TELEMETRY BEDDAY WARD 8^CA008
 ;;TELEMETRY BEDDAY WARD 9^CA009
 ;;TELEMETRY BEDDAY WARD 10^CA010
 ;;TELEMETRY BEDDAY WARD 11^CA011
 ;;TELEMETRY BEDDAY WARD 12^CA012
 ;;TELEMETRY BEDDAY WARD 13^CA013
 ;;TELEMETRY BEDDAY WARD 14^CA014
 ;;TELEMETRY BEDDAY WARD 15^CA015
 ;;TELEMETRY BEDDAY WARD 16^CA016
 ;;TELEMETRY BEDDAY WARD 17^CA017
 ;;TELEMETRY BEDDAY WARD 18^CA018
 ;;TELEMETRY BEDDAY WARD 19^CA019
 ;;TELEMETRY BEDDAY WARD 20^CA020
 ;;TELEMETRY BEDDAY WARD 21^CA021
 ;;TELEMETRY BEDDAY WARD 22^CA022
 ;;TELEMETRY BEDDAY WARD 23^CA023
 ;;TELEMETRY BEDDAY WARD 24^CA024
 ;;TELEMETRY BEDDAY WARD 25^CA025
 ;;MH CWT/TWE <4 HR WRKDY^MH066^97799
 ;;MH CWT/TWE 4 TO <8 HR WRKDY^MH067^97799
 ;;MH CWT/TWE 8 HRS/MORE WRKDY^MH068^97799
 ;;MH CWT/SE <4 HR WRKDY^MH069^97799
 ;;MH CWT/SE 4 TO <8 HR WRKDY^MH070^97799
 ;;MH CWT/SE 8 HRS/MORE WRKDY^MH071^97799
 ;;PM CWT/TWE <4 HR WRKDY^PM504^97799
 ;;PM CWT/TWE 4 TO <8 HR WRKDY^PM505^97799
 ;;PM CWT/TWE 8 HRS/MORE WRKDY^PM506^97799
 ;;PM CWT/SE <4 HR WRKDY^PM507^97799
 ;;PM CWT/SE 4 TO <8 HR WRKDY^PM508^97799
 ;;PM CWT/SE 8 HRS/MORE WRKDY^PM509^97799
 ;;ARTIFICIAL AIRWAY CHANGE^RT018
 ;;EXTUBATION OF AIRWAY^RT019
 ;;NASOTRACHEAL SUCTIONING^RT020
 ;;ENDOTRACHEAL SUCTIONING^RT021
 ;;TRACHEOSTOMY TUBE CARE^RT022
 ;;ENDOTRACHEAL TUBE ACRE^RT023
 ;;PLACE ASSISTIVE SPCH VALVE^RT024
 ;;INTUBATION OF AIRWAY^RT025
 ;;INTUBATION ASSIST^RT026
 ;;ADJUNCT AIRWAY DEVICE^RT027
 ;;MECH VENTILATION - INVASIVE^RT028
 ;;MECH VENTILATION -NONINVASIVE^RT029
 ;;CPAP SETUP^RT030
 ;;BIPAP SET UP^RT031
 ;;CPAP/BIPAP TROUBLESHOOT^RT032
 ;;MANUAL VENTILATION^RT033
 ;;SYSTEM CHECK^RT034
 ;;WEANING PARAMETERS^RT035
 ;;SETTING ADJUSTMENT^RT036
 ;;VENTILATOR CIRCUIT CHNG^RT037
 ;;VENTILATOR TRANSPORT^RT038
 ;;CHEST PHYIOTHERAPY^RT039
 ;;FLUTTER^RT040
 ;;INCENTIVE SPIROMETRY^RT041
 ;;SMALL VOLUME NEBULIZER^RT042
 ;;IPPB - INITIAL^RT043
 ;;IPPB - SUBSEQUENT^RT044
 ;;METERED DOES INHALER^RT045
 ;;CONT. NEBULIZER SET-UP^RT046
 ;;CONT. NEBULIZER CHECK, 5M INTERVALS^RT047
 ;;ULTRASONIC NEBULZATION CHECK, 5 MIN INTERVALS^RT048
 ;;BRONCHOSCOPY ASSIST^RT049
 ;;PENTAMINDINE RX^RT050
 ;;THORACENTESIS ASSIST^RT051
 ;;PATIENT EDUCATION/INSTRUCTION 15M INTERVALS^RT052
 ;;PATIENT ASSESSMENT^RT053
 ;;PULSE OXIMETRY SPOT CHECK^RT054
 ;;CONTINUOUS MONITORING SET-UP^RT055
 ;;EXERCISE PULSE OXIMETRY^RT056
 ;;SPONTANEOUS MECHANICS^RT057
 ;;PEAK FLOW MEASUREMENT WITH PEAK FLOW METER^RT058
 ;;SPUTUM INDUCTION^RT059
 ;;ABG ANALYSIS^RT060
 ;;ABG QUALITY CONTROL^RT061
 ;;ABG PROFICIENCY TESTING^RT062
 ;;ARTERIAL PUNCTURE^RT063
 ;;ARTERIAL LINE SPECIMEN^RT064
 ;;SUPPLEMENTAL OXYGEN THERAPY - HIGH FLOW^RT065
 ;;SUPPLEMENTAL OXYGEN THERAPY - LOW FLOW^RT066
 ;;PATIENT SYSTEM CHECK^RT067
 ;;EQUIPMENT CHANGE^RT068
 ;;CONTINUOUS AEROSOL THERAPY SYSTEM CHECK^RT069
 ;;PORTABLE OXYGEN CYLINDER SET-UP^RT070
 ;;TRANSTRACHEAL OXYGEN CATHETER MAINTENANCE^RT071
 ;;POSITIVE EXPIRATORY PRESSURE (PEP) THERAPY^RT072
 ;;CARDIOPULMONARY RESUSCITATION (CPR)^RT073
 ;;PATIENT TRANSPORT - OUTPATIENT^RT074
 ;;RESTING METABOLIC RATE^RT075
 ;;HELIOX & NITRIC OXIDE USE IN SPECIAL SITUATIONS^RT076
 ;;CUFF PRESSURE MEASUREMENT^RT077
 ;;CALL TO BEDSIDE/STAND-BY^RT078
 ;;IPV THERAPY^RT079
 ;;VEST THERAPY^RT080
 ;;SPAG SYSTEM - SYSTEM SET-UP^RT081
 ;;SPAG SYSTEM - PATIENT/SYSTEM CHECK^RT082
 ;;HOME OXYGEN VISIT^RT083
 ;;HOME OXYGEN EVALUATION - INITIAL^RT084
 ;;HOME OXYGEN EVALUATION - FOLLOW-UP/RENEWAL^RT085
 ;;PATIENT NOT AVAILABLE/REFUSAL OF TREATMENT^RT086
 ;;CHECK STAND-BY EQUIPMENT^RT087
 ;;SPEECH GEN DEV, DIG MSG >20 <=40M^SP501^E2504
 ;;SPEECH GEN DEV, DIG MSG >40M^SP502^E2506
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
 ;;SP456^SPEECH GEN DEV, DIG MSG <=8M^E2500
 ;;SP457^SPEECH GEN DEV, DIG MSG >8 <=20M^E2502
 ;;SP458^SPEECH GEN DEV, SYNTH, PHYS CONTACT^E2508
 ;;SP459^SPEECH GEN DEV, MULT FORMULATION^E2510
 ;;SP460^SPEECH GEN DEV, SFTWRE PC/PDA^E2511
 ;;SP461^ACCESSORY FOR SGD, MOUNTING SYSTEM^E2512
 ;;SP462^ACCESSORY FOR SGD, NOT OTHERWISE CLASSIFIED^E2599
 ;;QUIT
