PSN542D ;BIR/DMA-post install routine to load data ; 05 Dec 2017  2:44 PM
 ;;4.0;NATIONAL DRUG FILE;**542**; 30 Oct 98;Build 132
 ;
 ; Reference to ^PSDRUG supported by DBIA #2192
 ; Reference to PSN^PSSHUIDG supported by DBIA #3621
 ; Reference to ^GMR(120.8) supported by DBIA #4606
 ;
 N CL,CLA,CMOP,CT,DA,DA1,DIA,DIC,DIE,DIK,DINUM,DR,FDA,FILE,FLDS,GE,GROOT,GROOT1,IENS,IN,INA,IND,INDX,INV,J,JJ,K,LI,LINE,NA,NAME,ND,NEW,NFI,POST,PR,PSN,PSN1,PSN11,PSN21,PSNDF,R1,ROOT,ROOT1,ROOT2,ROOT3,SUBS,VAC,VAIN,VAPN
 N X,XMDUZ,XMSUB,XMTEXT,XMY,XMZ,XUMF,TREC
 N ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,PSNMULTI,MJJ,MIENS,MFLDS,OFLDS,OIENS,PSNVAPN
 K ^TMP($J),^TMP("PSN",$J),^TMP("PSNN",$J),^TMP("PPSN.WP",$J),^TMP("PPSN.WPXRF",$J)
 ;
 S PSNDF=1,XPDIDTOT=+$G(@XPDGREF@("TREC")),TREC=0
 S XUMF=1
 ;TO ALLOW ADDS TO 56 ,50.416,50.605,50.606, AND 50.6
 ;MORE ELEGANT CHANGE LATER
 ;
 S FILE=0,GROOT=$NA(@XPDGREF@("DATANT"))
 ;load new entries first
 F  S FILE=$O(@GROOT@(FILE)) Q:'FILE  S ROOT=$$ROOT^DILFD(FILE) I ROOT]"" S GROOT1=$NA(@GROOT@(FILE)) F JJ=1:2 Q:'$D(@GROOT1@(JJ))  S DIA=@GROOT1@(JJ),NEW=@GROOT1@(JJ+1) D
 .S DA=+DIA K FDA,IENS
 .I $$GET1^DIQ(FILE,DA,.01)]"" S FDA(FILE,DA_",",.01)=NEW D FILE^DIE("","FDA") Q
 .S DINUM=DA,X=NEW,DIC=ROOT,DIC(0)="L",DIC("DR")="S Y=0" K DD,DO D FILE^DICN
 .S TREC=TREC+1 I '(TREC#500) D UPDATE^XPDID(TREC)
 ;
 S FILE=0,GROOT=$NA(@XPDGREF@("DATAN"))
 ;load new multiple entries next
 F  S FILE=$O(@GROOT@(FILE)) Q:'FILE  S ROOT=$$ROOT^DILFD(FILE) I ROOT]"" S GROOT1=$NA(@GROOT@(FILE)) F JJ=1:2 Q:'$D(@GROOT1@(JJ))  S DIA=@GROOT1@(JJ),NEW=@GROOT1@(JJ+1) D
 .S IENS=$P(DIA,"^")_",",FLDS=$P(DIA,"^",3),ROOT=FILE K FDA,IEN
 .; *** Removing old COPAY TIER
 .I FILE=50.68 D
 ..I (FLDS="45,.01")&(IENS[",1") I $D(^PSNDF(50.68,+DIA,10,0)) S PSNCPCNT=0 D
 ...F  S PSNCPCNT=$O(^PSNDF(50.68,+DIA,10,PSNCPCNT)) Q:PSNCPCNT=""  S DIK="^PSNDF(50.68,"_+DIA_",10,",DA=PSNCPCNT,DA(1)=+DIA D ^DIK
 ..I $P(DIA,"^",3)=102,NEW=0 D HAZWASTE
 ..;RxNorm - remove deleted data
 ..I $P(DIA,"^",3)="43,.01",(NEW["DELETE"!(NEW="")) D RXNORMD1(DIA) Q
 ..I $P(DIA,"^",3)="43,.02,.01",(NEW["DELETE"!(NEW="")) D RXNORMD1(DIA) Q
 ..;RxNorm - Because the RXCUI is a multiple .01 field, KIDS puts it in a DATAN record.  However, edits may come over as DATAO record from PPS-N
 ..;     so the entry needs to be deleted prior to setting the new value.  There should only be one RXCUI defined
 ..I FLDS="43,.02,.01" D
 ...S SS1="",SS1=$O(^PSNDF(50.68,+DIA,11,"B","RxNorm",SS1))
 ...Q:SS1=""
 ...S (SS3,SS2)=0 F  S SS2=$O(^PSNDF(50.68,+DIA,11,SS1,1,SS2)) Q:'SS2  S SS3=1
 ...Q:'SS3
 ...D RXNORMD2(DIA)
 .;
 .I $G(PSNMULTI) D
 ..S (MIENS,MFLDS)="",MIENS=$P(DIA,"^")_",",MFLDS=$P(DIA,"^",3)
 ..I MFLDS'=""&($P(NEW,"^")'=MIENS) S PSNMULTI=0,^TMP("PPSN.WPXRF",$J,FILE,OIENS,OFLDS)=""
 .S IENS=$P(DIA,"^")_",",FLDS=$P(DIA,"^",3),ROOT=FILE K FDA,IEN
 .; ***
 .K RES1
 .I '$G(PSNMULTI) D FIELD^DID(FILE,FLDS,"","TYPE","RES1")
 .I $G(RES1("TYPE"))="WORD-PROCESSING"!$G(PSNMULTI) D  Q
 ..I '$G(PSNMULTI) D
 ...S MJJ=JJ,OIENS=IENS,OFLDS=FLDS
 ...I $D(^TMP("PPSN.WPXRF",$J,FILE,IENS,FLDS)) K ^TMP("PPSN.WP",$J,FILE,OIENS,OFLDS),^TMP("PPSN.WPXRF",$J,FILE,IENS,FLDS)
 ..I '$P(DIA,"^",3) S ^TMP("PPSN.WP",$J,FILE,OIENS,OFLDS,MJJ)=$$STRIP(DIA),MJJ=MJJ+1
 ..I '$P(NEW,"^",3) S ^TMP("PPSN.WP",$J,FILE,OIENS,OFLDS,MJJ)=$$STRIP(NEW),PSNMULTI=1,MJJ=MJJ+1
 ..I $P(NEW,"^",3)'="" S JJ=JJ-1
 .;
 .I FLDS["," D
 ..;it should, but
 ..S LI=$P(DIA,"^",3) F J=1:1:$L(LI,",")-1 S ROOT=+$P(^DD(ROOT,+$P(LI,",",J),0),"^",2)
 ..S LI=$P(DIA,"^"),IENS="" F J=$L(LI,","):-1:1 S IENS=IENS_$P(LI,",",J)_","
 ..S DA=+IENS
 .;I $$GET1^DIQ(ROOT,IENS,.01)]"" S FDA(ROOT,IENS,.01)=NEW D FILE^DIE("","FDA") Q
 .S FDA(ROOT,"+"_IENS,.01)=NEW,IEN(DA)=DA D UPDATE^DIE("","FDA","IEN")
 .S TREC=TREC+1 I '(TREC#500) D UPDATE^XPDID(TREC)
 .I FILE=50.68,$P(DIA,"^",3)="14,.01" S ^TMP("PSNN",$J,$P(DIA,"^"))=""
 ;
 S FILE=0,GROOT=$NA(@XPDGREF@("DATAO"))
 ;now load the rest of the data
 F  S FILE=$O(@GROOT@(FILE)) Q:'FILE  S ROOT=$$ROOT^DILFD(FILE) I ROOT]"" S GROOT1=$NA(@GROOT@(FILE)) F JJ=1:2 Q:'$D(@GROOT1@(JJ))  S DIA=@GROOT1@(JJ),NEW=@GROOT1@(JJ+1) D
 .S IENS=$P(DIA,"^")_",",FLDS=$P(DIA,"^",3),ROOT=FILE K FDA,IEN
 .I FILE=50.68,($P(DIA,"^",3)=102),NEW=0 D HAZWASTE
 .I FLDS["," D
 ..S LI=$P(DIA,"^",3) F J=1:1:$L(LI,",")-1 S ROOT=+$P(^DD(ROOT,+$P(LI,",",J),0),"^",2)
 ..S LI=$P(DIA,"^"),IENS="" F J=$L(LI,","):-1:1 S IENS=IENS_$P(LI,",",J)_","
 ..S FLDS=$P(FLDS,",",$L(FLDS,","))
 .S FDA(ROOT,IENS,FLDS)=NEW D FILE^DIE("","FDA")
 .S TREC=TREC+1 I '(TREC#500) D UPDATE^XPDID(TREC)
 S JJ=0 F  S JJ=$O(^TMP("PSNN",$J,JJ)) Q:'JJ  S DA=$P(JJ,",",2),DA(1)=+JJ D ING^PSNXREF
 ;
WP ;
 S FILE="" F  S FILE=$O(^TMP("PPSN.WP",$J,FILE)) Q:FILE=""  D
 . S IENS="" F  S IENS=$O(^TMP("PPSN.WP",$J,FILE,IENS)) Q:IENS=""  D
 .. S FLDS="" F  S FLDS=$O(^TMP("PPSN.WP",$J,FILE,IENS,FLDS)) Q:FLDS=""  D
 ... K TMP,ERR
 ... S JJ=0 F  S JJ=$O(^TMP("PPSN.WP",$J,FILE,IENS,FLDS,JJ)) Q:'JJ  D
 .... S TMP(JJ)=^TMP("PPSN.WP",$J,FILE,IENS,FLDS,JJ)
 ... D WP^DIE(FILE,IENS,FLDS,"","TMP","ERR")
 K ^TMP("PPSN.WP",$J)
 ;
WORD ;
 S ROOT1=$NA(@XPDGREF@("WORD")),CT=0,ROOT2=$NA(@ROOT1@(0))
 F  S CT=$O(@ROOT2) Q:'CT  S ROOT2=$NA(@ROOT1@(CT)),NAME=@ROOT2,ROOT3=$NA(@ROOT2@("D")) K @NAME M @NAME=@ROOT3
 ;
 ;
MESSAGE ;
 K ^TMP($J) M ^TMP($J)=@XPDGREF@("MESSAGE") K ^TMP($J,0)
 ;
GROUP ;
 K XMY S X=$G(@XPDGREF@("GROUP")) I X]"" S XMY("G."_X_"@"_^XMB("NETNAME"))=""
 S DA=0 F  S DA=$O(^XUSEC("PSNMGR",DA)) Q:'DA  S XMY(DA)=""
 I $D(DUZ) S XMY(DUZ)=""
 ;
 S XMSUB="DATA UPDATE FOR NDF"
 S XMDUZ="NDF MANAGER"
 S XMTEXT="^TMP($J," N DIFROM D ^XMD
 ;
 K ^TMP($J) M ^TMP($J)=@XPDGREF@("MESSAGE2") K ^TMP($J,0)
 ;
 K XMY S X=$G(@XPDGREF@("GROUP")) I X]"" S XMY("G."_X_"@"_^XMB("NETNAME"))=""
 S DA=0 F  S DA=$O(^XUSEC("PSNMGR",DA)) Q:'DA  S XMY(DA)=""
 I $D(DUZ) S XMY(DUZ)=""
 ;
 S XMSUB="UPDATED INTERACTIONS"
 S XMDUZ="NDF MANAGER"
 S XMTEXT="^TMP($J," N DIFROM D ^XMD
DRUGFILE ;
 ;NOW UPDATE LOCAL DRUG FILE
 K ^TMP($J)
 S PSN=$$PATCH^XPDUTL("PSS*1.0*34"),PSN1=$$PATCH^XPDUTL("PSS*1.0*42")
 S ROOT1=$NA(@XPDGREF@("GENERIC")),ROOT2=$NA(@XPDGREF@("PRODUCT")),ROOT3=$NA(@XPDGREF@("POE")),DA=0
 S DA=0 F  S DA=$O(^PSDRUG(DA)) Q:'DA  S X=$G(^PSDRUG(DA,0)) I X]"" S NA=$P(X,"^"),CLA=$P(X,"^",2),INV=$P(X,"^",3)["I",X=$G(^("ND")),IN=$P($G(^("I"),9999999),"^"),INA=IN'>DT,GE=+X,PR=+$P(X,"^",3),CMOP=$P(X,"^",10),VAPN=$P(X,"^",2) I GE I PR D
 .S VAIN=$P($G(^PSNDF(50.68,PR,7)),"^",3)
 .I $D(@ROOT1@(GE))!$D(@ROOT2@(PR))!VAIN S X="" S:CMOP]"" X="    (CMOP "_CMOP_")" S $E(X,30)=VAPN,$E(X,65)=$$FMTE^XLFDT(VAIN,5),INDX=$S(INA:"I",INV:"X",1:"A") S:IN=9999999 IN="" S ^TMP($J,INDX,NA_"^"_DA_"^"_IN,1)=X,^TMP($J,"^",DA)="" D
 ..S DIE="^PSDRUG(",DR="20////@;21////@;22////@;23////@;24////@;27////@;29////@;" D ^DIE K DIE,DR
 ..I PSN I $P($G(^PSDRUG(DA,"DOS")),"^")]""!$O(^("DOS1",0))!$O(^PSDRUG(DA,"DOS2",0)) D LOAD K ^PSDRUG(DA,"DOS"),^("DOS1"),^("DOS2")
 ..I $P($G(^PSDRUG(DA,3)),"^") S DIE=50,DR="213////0;" D ^DIE K DIE,DR I PSN1 S IND=$O(^PSDRUG(DA,4," "),-1),$P(^(IND,0),"^",6)="NDF Update"
 .I PSN,$D(@ROOT3@(PR)) K ^PSDRUG(DA,"DOS"),^("DOS1"),^("DOS2")
 .S ND=$G(^PSDRUG(DA,"ND")),PR=$P(ND,"^",3) I PR D
 ..S NFI=$P($G(^PSNDF(50.68,PR,5)),"^") I $P(ND,"^",11)'=NFI S DIE=50,DR="29////"_NFI_";" D ^DIE
 ..S VAC=$P($G(^PSNDF(50.68,PR,3)),"^") I VAC S VAC=$P(^PS(50.605,VAC,0),"^"),DIE=50,DR="2////"_VAC_";" D ^DIE
 ..I $P($G(^PSDRUG(DA,3)),"^"),'$P($G(^PSNDF(50.68,PR,1)),"^",3) S DIE=50,DR="213////0;" D ^DIE K DIE,DR S IND=$O(^PSDRUG(DA,4," "),-1),$P(^(IND,0),"^",6)="NDF Update"
 .S TREC=TREC+1 I '(TREC#500) D UPDATE^XPDID(TREC)
 ;
 K ^TMP("PSN",$J) S LINE=1 F INDX="A","X","I" D LOAD1
 S XMDUZ="NDF MANAGER",XMSUB="DRUGS UNMATCHED FROM NATIONAL DRUG FILE",XMTEXT="^TMP(""PSN"",$J,"
 K XMY S X=$G(@XPDGREF@("GROUP")) I X]"" S XMY("G."_X_"@"_^XMB("NETNAME"))=""
 S DA=0 F  S DA=$O(^XUSEC("PSNMGR",DA)) Q:'DA  S XMY(DA)=""
 I $D(DUZ) S XMY(DUZ)=""
 N DIFROM D ^XMD I $D(XMZ) S DA=XMZ,DIE=3.9,DR="1.7///P;" D ^DIE
 ;package specific post install
 I $D(@XPDGREF@("POST")) S POST=^("POST") S:POST'["^" POST="^"_POST I @("$T("_POST_")]]""""") D @POST
 ;
 ;call to HL7 drug update message
 I $T(PSN^PSSHUIDG)]"" I $O(^TMP($J,"^",0)) S ZTRTN="PSN^PSSHUIDG",ZTIO="",ZTDTH=$H,ZTDESC="DRUG UPDATE MESSAGE",ZTSAVE("^TMP($J,""^"",")="" D ^%ZTLOAD
 ;
REINDEX ;Make sure APC xref is correct
 I $T(EN2^GMRAUIX0)']"" G MORE
 N SUB,DA,DIK,GMRAIEN,CLASS
 S SUB=0 F  S SUB=$O(^GMR(120.8,SUB)) Q:'+SUB  I $D(^GMR(120.8,SUB,3)) D
 .S GMRAIEN=+$P($G(^GMR(120.8,SUB,0)),U) Q:'GMRAIEN
 .S CLASS="" F  S CLASS=$O(^GMR(120.8,"APC",GMRAIEN,CLASS)) Q:CLASS=""  K ^GMR(120.8,"APC",GMRAIEN,CLASS,SUB)
 .S DA(1)=SUB
 .S DIK="^GMR(120.8,DA(1),3,"
 .S DIK(1)=".01^ADRG3"
 .D ENALL^DIK ;Reset the drug class xref
 ;
MORE ;REINDEXING
 ;now the APD
 K ^PS(50.416,"APD") S DA=0 F  S DA=$O(^PS(50.416,DA)),K=0 Q:'DA  F  S K=$O(^PS(50.416,DA,1,K)) Q:'K  S X=^(K,0),^PS(50.416,"APD",X,DA)=""
 ;now the interactions
 K ^PS(56,"APD") S DA=0 F  S DA=$O(^PS(56,DA)) Q:'DA  K PSN1,PSN2 S PSN1=$P(^(DA,0),"^",2),PSN2=$P(^(0),"^",3) D
 .S NA="" F  S NA=$O(^PS(50.416,PSN1,1,"B",NA)) Q:NA=""  S PSN1(NA)=""
 .S PSN11=0 F  S PSN11=$O(^PS(50.416,"APS",PSN1,PSN11)),NA="" Q:'PSN11  F  S NA=$O(^PS(50.416,PSN11,1,"B",NA)) Q:NA=""  S PSN1(NA)=""
 .S NA="" F  S NA=$O(^PS(50.416,PSN2,1,"B",NA)) Q:NA=""  S PSN2(NA)=""
 .S PSN21=0 F  S PSN21=$O(^PS(50.416,"APS",PSN2,PSN21)),NA="" Q:'PSN21  F  S NA=$O(^PS(50.416,PSN21,1,"B",NA)) Q:NA=""  S PSN2(NA)=""
 .S PSN1="" F  S PSN1=$O(PSN1(PSN1)),PSN2="" Q:PSN1=""  F  S PSN2=$O(PSN2(PSN2)) Q:PSN2=""  S ^PS(56,"APD",PSN1,PSN2,DA)="",^PS(56,"APD",PSN2,PSN1,DA)=""
 ;
 D ^PSNCLEAN
 ;
QUIT ;
 D UPDATE^XPDID(XPDIDTOT)
 K CL,CLA,CMOP,CT,DA,DA1,DIA,DIC,DIE,DIK,DINUM,DR,FDA,FILE,FLDS,GE,GROOT,GROOT1,IENS,IN,INA,IND,INDX,INV,J,JJ,K,LI,LINE,NA,NAME,ND,NEW,NFI,POST,PR,PSN,PSN1,PSN11,PSN21,PSNDF,R1,ROOT,ROOT1,ROOT2,ROOT3,SUBS,VAC,VAIN,VAPN
 K X,XMDUZ,XMSUB,XMTEXT,XMY,XMZ,XUMF,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
 K ^TMP($J),^TMP("PSN",$J),^TMP("PSNN",$J)
 Q
 ;
LOAD ;GET DOSE STUFF
 S J=2,X=$G(^PSDRUG(DA,"DOS")) I $P(X,"^"),$D(^PS(50.607,+$P(X,"^",2),0)) S ^TMP($J,INDX,NA_"^"_DA_"^"_IN,J)="    STRENGTH: "_+X_"UNITS: "_$P(^PS(50.607,+$P(X,"^",2),0),"^"),J=J+1
 I $O(^PSDRUG(DA,"DOS1",0)) S ^TMP($J,INDX,NA_"^"_DA_"^"_IN,J)="    POSSIBLE DOSES",^(J+1)="    DISP UNITS/DOSE     DOSE    PACKAGE   BCMA UNITS/DOSE",DA1=0,J=J+2 D
 .F  S DA1=$O(^PSDRUG(DA,"DOS1",DA1)) Q:'DA1  S X=^(DA1,0),^TMP($J,INDX,NA_"^"_DA_"^"_IN,J)="    "_$J($P(X,"^"),4),$E(^(J),25)=$J($P(X,"^",2),4),$E(^(J),35)=$P(X,"^",3),$E(^(J),43)=$P(X,"^",4),J=J+1
 I $O(^PSDRUG(DA,"DOS2",0)) S ^TMP($J,INDX,NA_"^"_DA_"^"_IN,J)="    LOCAL POSSIBLE DOSES",^(J+1)="    DOSE                                            PACKAGE   BCMA UNITS/DOSE",DA1=0,J=J+2 D
 .F  S DA1=$O(^PSDRUG(DA,"DOS2",DA1)) Q:'DA1  S X=^(DA1,0),^TMP($J,INDX,NA_"^"_DA_"^"_IN,J)="    "_$P(X,"^"),$E(^(J),55)=$P(X,"^",2),$E(^(J),71)=$P(X,"^",3),J=J+1
 Q
 ;
LOAD1 ;BUILD THE MESSAGE
 S ^TMP("PSN",$J,LINE,0)=" ",LINE=LINE+1
 S ^TMP("PSN",$J,LINE,0)="The following "_$S(INDX="A":"active",INDX="X":"investigational",1:"inactive")_" entries in your DRUG file (#50) have been",LINE=LINE+1
 S J=0 F  S J=$O(@XPDGREF@("TEXT",J)) Q:'J  S ^TMP("PSN",$J,LINE,0)=@XPDGREF@("TEXT",J),LINE=LINE+1
 ;I INDX'="I" S LINE=LINE-1,^(0)=$P(^TMP("PSN",$J,LINE-2,0),"IN"),^TMP("PSN",$J,LINE-1,0)=" "
 S NA="" I $O(^TMP($J,INDX,NA))="" S ^TMP("PSN",$J,LINE,0)="  NONE",LINE=LINE+1 Q
 F  S NA=$O(^TMP($J,INDX,NA)) Q:NA=""  S X=^(NA,1),^TMP("PSN",$J,LINE,0)=$P(NA,"^"),$E(^(0),55)=$P(NA,"^",2) S:INDX="I" $E(^(0),62)=$$FMTE^XLFDT($P(NA,"^",3),5) S LINE=LINE+1,^TMP("PSN",$J,LINE,0)=$P(X,"^"),LINE=LINE+1 S J=1 D
 .F  S J=$O(^TMP($J,INDX,NA,J)) Q:'J  S ^TMP("PSN",$J,LINE,0)=^(J),LINE=LINE+1
 Q
 ;
HAZWASTE ;
 ;HAZARDOUS TO DISPOSE FIELD 102 = ZERO; KILL FIELDS 103,104,105
 N DA,DIE S (DA,DIE)=""
 S DA=+$P(DIA,"^"),DIE="^PSNDF(50.68,",DR="103///@;104///@;105///@" D ^DIE
 Q
 ;
STRIP(X) ; Strip control characters
 N I,Y
 S Y="" F I=1:1:$L(X) I $A(X,I)>31,$A(X,I)<127 S Y=Y_$E(X,I)
 Q Y
 ;
RXNORMD1(DIA) ;RxNorm deleted
 N DIK,DA,X
 S DA=$P($P(DIA,"^"),",",2),DA(1)=$P($P(DIA,"^"),",")
 S X="",X=$G(^PSNDF(50.68,DA(1),11,DA,0))
 Q:X'="RxNorm"
 S DIK="^PSNDF(50.68,"_DA(1)_",11,"
 D ^DIK
 Q
 ;
RXNORMD2(DIA) ;RxNorm deleted
 N DIK,DA,OVAL,CNT,CNT2,PSNVAPN
 S PSNVAPN=+DIA
 S (CNT2,DA)=$P($P(DIA,"^"),",",3),(CNT,DA(1))=$P($P(DIA,"^"),",",2),DA(2)=$P($P(DIA,"^"),",")
 S OVAL=$G(^PSNDF(50.68,PSNVAPN,11,DA(1),1,DA,0))
 S DIK="^PSNDF(50.68,"_PSNVAPN_",11,"_DA(1)_",1,",DA=CNT2,DA(1)=CNT,DA(2)=PSNVAPN
 D ^DIK
 I OVAL'="" K ^PSNDF(50.68,PSNVAPN,11,CNT,CNT2,"B",OVAL)
 Q
