GMRVXCH2 ;HIRMFO/YH,RM-GMRV VITAL QUALIFIER FILE CONVERSION ;8/1/96
 ;;4.0;Vitals/Measurements;;Apr 25, 1997
CONV52 ; Loop through 120.52 to convert
 S GMRVDA=0 F  S GMRVDA=$O(^GMRD(120.52,GMRVDA)) Q:GMRVDA'>0  D
 .  K GMRVVTYP S GMRVCHAR=$P($G(^GMRD(120.52,GMRVDA,0)),"^")
 . I '$D(^TMP($J,"GMRVCHAR",GMRVCHAR)) S ^TMP($J,"GMRVCHAR",GMRVCHAR)=""
 .  S GMRVCNV=$G(^TMP($J,"GMRVCHAR",GMRVCHAR))
 .  S GMRVCNV=$S(GMRVCNV]"":GMRVCNV,1:GMRVDA_";GMRD(120.52,")
 .  S $P(^GMRD(120.52,GMRVDA,"CONV"),"^")=GMRVCNV
 .  S GMRVTDA=0
 .  F  S GMRVTDA=$O(^GMRD(120.52,GMRVDA,1,GMRVTDA)) Q:GMRVTDA'>0  D
 .  .  S GMRVTYP=$P($G(^GMRD(120.52,GMRVDA,1,GMRVTDA,0)),"^")
 .  .  Q:GMRVTYP'>0  S GMRVVTYP(GMRVTYP)=GMRVTDA
 .  .  I '$D(^TMP($J,"GMRVCHAR",GMRVCHAR,GMRVTYP)) S ^TMP($J,"GMRVCHAR",GMRVCHAR,GMRVTYP)=$$QUAL(GMRVTYP,120.52,GMRVCHAR)
 .  .  Q
 .  S GMRVTYP=0
 .  F  S GMRVTYP=$O(^TMP($J,"GMRVCHAR",GMRVCHAR,GMRVTYP)) Q:GMRVTYP'>0  D
 .  .  S GMRVTDA=$G(GMRVVTYP(GMRVTYP))
 .  .  I GMRVTDA'>0 D  Q:GMRVTDA'>0
 .  .  .  S X=GMRVTYP,DA(1)=GMRVDA,DIC="^GMRD(120.52,"_DA(1)_",1,"
 .  .  .  S DIC(0)="L",DLAYGO=120.52
 .  .  .  K DO,DINUM,DD D FILE^DICN S GMRVTDA=+Y
 .  .  .  Q
 .  .  S GMRVCNV=$G(^TMP($J,"GMRVCHAR",GMRVCHAR,GMRVTYP))
 .  .  S GMRVCAT=$P(GMRVCNV,"^")
 .  .  I GMRVCAT]"" S GMRVCAT=$G(^TMP($J,"GMRVCAT",GMRVCAT))
 .  .  S $P(GMRVCNV,"^")=GMRVCAT
 .  .  S $P(^GMRD(120.52,GMRVDA,1,GMRVTDA,0),"^",2,4)=GMRVCNV
 .  .  Q
 .  Q
 K DA,DIC,DLAYGO,GMRVCHAR,GMRVCNV,GMRVDA,GMRVTDA,GMRVTYP,GMRVVTYP,X
 Q
MOVE53 ;  Loop through 120.53 and move data from that
 ;  file to the 120.52 file.
 S GMRVD0=0 F  S GMRVD0=$O(^GMRD(120.53,GMRVD0)) Q:GMRVD0'>0  D
 .  S GMRVCHAR=$P($G(^GMRD(120.53,GMRVD0,0)),"^") Q:GMRVCHAR=""
 .  K GMRVFDA,GMRVIEN S GMRVFDA(99,120.52,"+1,",.01)=GMRVCHAR
 .  D UPDATE^DIE("","GMRVFDA(99)","GMRVIEN") Q:GMRVIEN(1)'>0
 .  I '$D(^TMP($J,"GMRVCHAR",GMRVCHAR)) S ^(GMRVCHAR)=GMRVD0_";GMRD(120.53,"
 .  S GMRVDA=GMRVIEN(1),GMRVD1=0
 .  F  S GMRVD1=$O(^GMRD(120.53,GMRVD0,1,GMRVD1)) Q:GMRVD1'>0  D
 .  .  S GMRVTYP=$P($G(^GMRD(120.53,GMRVD0,1,GMRVD1,0)),"^")
 .  .  Q:$P($G(^GMRD(120.51,+GMRVTYP,0)),"^")'="BLOOD PRESSURE"
 .  .  K GMRVFDA,GMRVIEN
 .  .  S GMRVFDA(99,120.521,"+2,"_GMRVDA_",",.01)=GMRVTYP
 .  .  D UPDATE^DIE("","GMRVFDA(99)","GMRVIEN")
 .  .  I '$D(^TMP($J,"GMRVCHAR",GMRVCHAR,GMRVTYP)) S ^TMP($J,"GMRVCHAR",GMRVCHAR,GMRVTYP)=$$QUAL(GMRVTYP,120.53,GMRVCHAR)
 .  .  Q
 .  Q
 K GMRVCHAR,GMRVD0,GMRVD1,GMRVDA,GMRVFDA,GMRVTYP
 Q
QUAL(TYPE,FILE,CHAR) ; Given a Qualifier (CHAR), the Vital Type (TYPE)
 ; ptr and the file from which this which the qualifier is from
 ; (FILE), this function will return the generic Category (CAT).
 ;
 N CAT,GTYPE
 S GTYPE=$P($G(^GMRD(120.51,TYPE,0)),"^",2)
 I FILE=120.52 S CAT=$S(GTYPE="BP"!(GTYPE="P")!(GTYPE="T"):"LOCATION",GTYPE="R":"METHOD",GTYPE="WT":"QUALITY",1:"")
 I FILE=120.53 S CAT=$S(GTYPE="BP":"POSITION",1:"")
 Q CAT
 ;
TYP(TYPE) ; This function will return the external text for the Vital
 ; Type pointed to by TYPE.
 Q $P($G(^GMRD(120.51,TYPE,0)),"^")
