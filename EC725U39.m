EC725U39 ;ALB/GTS/JAP/GT - EC National Procedure Update; 1/31/2006
 ;;2.0; EVENT CAPTURE ;**80**;8 May 96
 ;
 ;this routine is used as a post-init in KIDS build 
 ;to modify the the EC National Procedure file #725
 ;
INACT ;* inactivate national procedures
 ;
 ;  ECXX is in format:
 ;   NATIONAL NUMBER^INACTIVATION DATE^FIRST NATIONAL NUMBER SEQUENCE^
 ;   LAST NATIONAL NUMBER SEQUENCE
 ;
 N ECX,ECXX,ECEXDT,ECINDT,ECDA,DIC,DIE,DA,DR,X,Y,%DT,ECBEG,ECEND,ECADD
 N ECSEQ,CODE,CODX
 D MES^XPDUTL(" ")
 D BMES^XPDUTL("Inactivating procedures EC NATIONAL PROCEDURE File (#725)...")
 D MES^XPDUTL(" ")
 F ECX=1:1 K DD,DO,DA S ECXX=$P($T(OLD+ECX),";;",2) Q:ECXX="QUIT"  D
 .S ECEXDT=$P(ECXX,U,2),X=ECEXDT,%DT="X" D ^%DT S ECINDT=$P(Y,".",1)
 .S CODE=$P(ECXX,U),ECBEG=$P(ECXX,U,3),ECEND=$P(ECXX,U,4),CODX=CODE
 .I ECBEG="" D UPINACT Q
 .F ECSEQ=ECBEG:1:ECEND D
 ..S ECADD="000"_ECSEQ,ECADD=$E(ECADD,$L(ECADD)-2,$L(ECADD))
 ..S CODE=CODX_ECADD
 ..D UPINACT
 Q
UPINACT ;Update codes as inactive
 ;
 S ECDA=+$O(^EC(725,"D",CODE,0))
 I $D(^EC(725,ECDA,0)) D
 .S DA=ECDA,DR="2////^S X=ECINDT",DIE="^EC(725," D ^DIE
 .D MES^XPDUTL(" ")
 .D BMES^XPDUTL("   "_CODE_" inactivated as of "_ECEXDT_".")
 Q
 ;
OLD ;national procedures to be inactivated - national code #^inact. date
 ;;NU029^1/01/2006
 ;;NU030^1/01/2006
 ;;NU031^1/01/2006
 ;;NU032^1/01/2006
 ;;NU037^1/01/2006
 ;;NU038^1/01/2006
 ;;NU039^1/01/2006
 ;;NU040^1/01/2006
 ;;NU048^1/01/2006
 ;;NU049^1/01/2006
 ;;NU050^1/01/2006
 ;;NU051^1/01/2006
 ;;NU056^1/01/2006
 ;;NU057^1/01/2006
 ;;NU058^1/01/2006
 ;;NU059^1/01/2006
 ;;NU064^1/01/2006
 ;;NU065^1/01/2006
 ;;NU066^1/01/2006
 ;;NU067^1/01/2006
 ;;NU073^1/01/2006
 ;;NU074^1/01/2006
 ;;NU075^1/01/2006
 ;;NU076^1/01/2006
 ;;NU081^1/01/2006
 ;;NU082^1/01/2006
 ;;NU083^1/01/2006
 ;;NU084^1/01/2006
 ;;NU089^1/01/2006
 ;;NU090^1/01/2006
 ;;NU091^1/01/2006
 ;;NU092^1/01/2006
 ;;NU097^1/01/2006
 ;;NU098^1/01/2006
 ;;NU099^1/01/2006
 ;;NU100^1/01/2006
 ;;NU105^1/01/2006
 ;;NU106^1/01/2006
 ;;NU107^1/01/2006
 ;;NU108^1/01/2006
 ;;NU113^1/01/2006
 ;;NU114^1/01/2006
 ;;NU115^1/01/2006
 ;;NU116^1/01/2006
 ;;NU121^1/01/2006
 ;;NU122^1/01/2006
 ;;NU123^1/01/2006
 ;;NU124^1/01/2006
 ;;NU129^1/01/2006
 ;;NU130^1/01/2006
 ;;NU131^1/01/2006
 ;;NU132^1/01/2006
 ;;NU137^1/01/2006
 ;;NU138^1/01/2006
 ;;NU139^1/01/2006
 ;;NU140^1/01/2006
 ;;NU145^1/01/2006
 ;;NU146^1/01/2006
 ;;NU147^1/01/2006
 ;;NU148^1/01/2006
 ;;SP266^1/01/2006
 ;;SP267^1/01/2006
 ;;SP268^1/01/2006
 ;;SP269^1/01/2006
 ;;SP271^1/01/2006
 ;;SP272^1/01/2006
 ;;SP273^1/01/2006
 ;;SP274^1/01/2006
 ;;SP275^1/01/2006
 ;;SP276^1/01/2006
 ;;SP279^1/01/2006
 ;;SP280^1/01/2006
 ;;SP281^1/01/2006
 ;;SP282^1/01/2006
 ;;SP283^1/01/2006
 ;;SP284^1/01/2006
 ;;SP285^1/01/2006
 ;;SP286^1/01/2006
 ;;SP287^1/01/2006
 ;;SP288^1/01/2006
 ;;SP291^1/01/2006
 ;;SP292^1/01/2006
 ;;SP293^1/01/2006
 ;;SP294^1/01/2006
 ;;SP295^1/01/2006
 ;;SP296^1/01/2006
 ;;SP297^1/01/2006
 ;;SP298^1/01/2006
 ;;SP299^1/01/2006
 ;;SP300^1/01/2006
 ;;SP301^1/01/2006
 ;;SP302^1/01/2006
 ;;SP303^1/01/2006
 ;;SP304^1/01/2006
 ;;SP305^1/01/2006
 ;;SP306^1/01/2006
 ;;SP307^1/01/2006
 ;;SP308^1/01/2006
 ;;SP309^1/01/2006
 ;;SP310^1/01/2006
 ;;SP311^1/01/2006
 ;;SP312^1/01/2006
 ;;SP316^1/01/2006
 ;;SP319^1/01/2006
 ;;SP320^1/01/2006
 ;;SP321^1/01/2006
 ;;SP322^1/01/2006
 ;;SP323^1/01/2006
 ;;SP324^1/01/2006
 ;;SP325^1/01/2006
 ;;SP326^1/01/2006
 ;;SP327^1/01/2006
 ;;SP328^1/01/2006
 ;;SP329^1/01/2006
 ;;SP330^1/01/2006
 ;;SP331^1/01/2006
 ;;SP332^1/01/2006
 ;;SP333^1/01/2006
 ;;SP334^1/01/2006
 ;;SP335^1/01/2006
 ;;SP336^1/01/2006
 ;;SP337^1/01/2006
 ;;SP338^1/01/2006
 ;;SP339^1/01/2006
 ;;SP340^1/01/2006
 ;;SP341^1/01/2006
 ;;SP342^1/01/2006
 ;;SP343^1/01/2006
 ;;SP344^1/01/2006
 ;;SP345^1/01/2006
 ;;SP346^1/01/2006
 ;;SP347^1/01/2006
 ;;SP440^1/01/2006
 ;;SP441^1/01/2006
 ;;SP479^1/01/2006
 ;;SP480^1/01/2006
 ;;SP482^1/01/2006
 ;;SP483^1/01/2006
 ;;SP489^1/01/2006
 ;;SP490^1/01/2006
 ;;SP492^1/01/2006
 ;;SP493^1/01/2006
 ;;SP495^1/01/2006
 ;;SP496^1/01/2006
 ;;QUIT
 ;
REACT ;* reactivate national procedures
 ;
 ;  ECXX is in format:
 ;   NATIONAL NUMBER^DATE (FUTURE)^FIRST NATIONAL NUMBER SEQUENCE^
 ;   LAST NATIONAL NUMBER SEQUENCE
 ;
 N ECX,ECXX,ECEXDT,ECINDT,ECDA,DIC,DIE,DA,DR,X,Y,%DT,ECBEG,ECEND,ECADD
 N ECSEQ,CODE,CODX,ECDES
 D MES^XPDUTL(" ")
 D BMES^XPDUTL("Reactivating procedures EC NATIONAL PROCEDURE File (#725)...")
 D MES^XPDUTL(" ")
 F ECX=1:1 K DD,DO,DA S ECXX=$P($T(ACT+ECX),";;",2) Q:ECXX="QUIT"  D
 .S ECDES=$P(ECXX,U,5)
 .S CODE=$P(ECXX,U),ECBEG=$P(ECXX,U,3),ECEND=$P(ECXX,U,4),CODX=CODE
 .I ECBEG="" D UPREACT Q
 .F ECSEQ=ECBEG:1:ECEND D
 ..S ECADD="000"_ECSEQ,ECADD=$E(ECADD,$L(ECADD)-2,$L(ECADD))
 ..S CODE=CODX_ECADD
 ..D UPREACT
 Q
UPREACT ;Update codes as reactive
 ;
 S ECDA=+$O(^EC(725,"D",CODE,0))
 I $D(^EC(725,ECDA,0)) D
 .S DA=ECDA,DR="2///@",DIE="^EC(725," D ^DIE
 .D BMES^XPDUTL("   "_CODE_" "_ECDES_" reactivated.")
 Q
 ;
ACT ;national procedures to be reactivated - national number^date
 ;;QUIT
 ;
CPTCHG ;* change cpt codes
 ;
 ;  ECXX is in format:
 ;  NATIONAL NUMBER^NEW CPT^FIRST NATIONAL NUMBER SEQUENCE^LAST NATIONAL
 ;  NUMBER SEQUENCE
 ;
 N ECX,ECXX,CPT,DIC,DIE,DA,DR,X,Y,ECBEG,ECEND,ECADD,NAME,ECSEQ,STR,CPTIEN
 D MES^XPDUTL(" ")
 D BMES^XPDUTL("Changing CPT Codes in EC NATIONAL PROCEDURE file (#725)")
 D MES^XPDUTL(" ")
 F ECX=1:1 S ECXX=$P($T(CPT+ECX),";;",2) Q:ECXX="QUIT"  D
 .S ECBEG=$P(ECXX,U,3),ECEND=$P(ECXX,U,4),CPTIEN=$P(ECXX,U,2)
 .S CPTIEN=$S(CPTIEN="":"@",1:$$FIND1^DIC(81,"","X",CPTIEN))
 .I CPTIEN'="@",+CPTIEN<1 D  Q
 ..S STR=$P(ECXX,U)_":  CPT code "_$P(ECXX,U,2)_" is invalid."
 ..D MES^XPDUTL(" ")
 ..D BMES^XPDUTL("   "_STR)
 .I ECBEG="" S CPT($P(ECXX,U))=CPTIEN_U_$P(ECXX,U,2) Q
 .F ECSEQ=ECBEG:1:ECEND D
 ..S ECADD="000"_ECSEQ,ECADD=$E(ECADD,$L(ECADD)-2,$L(ECADD))
 ..S CPT($P(ECXX,U)_ECADD)=CPTIEN_U_$P(ECXX,U,2)
 S ECXX=""
 F  S ECXX=$O(CPT(ECXX)) Q:ECXX=""  D
 .S ECX=$O(^EC(725,"D",ECXX,0))
 .Q:+ECX=0
 .I '$D(^EC(725,ECX,0))!(+ECX=0) D  Q
 ..D MES^XPDUTL(" ")
 ..D BMES^XPDUTL("   Can't find entry for "_ECXX_",CPT cde not updated.")
 .S CPT=$P(CPT(ECXX),U),DA=ECX,DR="4////"_CPT,DIE="^EC(725," D ^DIE
 .D MES^XPDUTL(" ")
 .S STR="   Entry #"_ECX_" for "_ECXX
 .D BMES^XPDUTL(STR_" updated to use CPT code "_$P(CPT(ECXX),U,2))
 Q
 ;
CPT ;cpt codes to be changed - national #^new CPT code
 ;;SP038^97762
 ;;SP107^97762
 ;;SP108^97762
 ;;SP350^92506
 ;;SP449^97762
 ;;SP450^97762
 ;;SP451^97762
 ;;SP467^97762
 ;;QUIT