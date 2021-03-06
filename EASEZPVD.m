EASEZPVD	;ALB/AMA/CMF,LBD - GATHER VISTA DATA TO PRINT FROM DG OPTIONS ; 10/13/10 4:05pm
	;;1.0;ENROLLMENT APPLICATION SYSTEM;**57,66,70,81,92**;Mar 15, 2001;Build 20
	;
VISTA(EASDFN,EASMTIEN)	;GATHER VISTA DATA -- CALLED FROM EN^EASEZPDG
	;   INPUT:
	;      EASDFN - POINTER TO PATIENT FILE (#2)
	;      EASMTIEN - MeansTestIEN (408.31)
	;
	N X,KEY,VDATA,DISPOS,DGNT,ENROLL,RACE,ETHNC
	;
	;GET LAST ALIAS NAME
	S X=$O(^DPT(EASDFN,.01,""),-1)
	I +X D
	. S KEY=+$$KEY711^EASEZU1("APPLICANT OTHER NAME")
	. S VDATA=$$GET^EASEZC1(EASDFN_";"_+X,"2^2.01^.01")
	. Q:VDATA=-1  Q:VDATA=""
	. S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	;
	;GATHER MOST RECENT DISPOSITION DATA, IF IT EXISTS
	;OTHERWISE, PRINT "UNKNOWN" FOR THE FOLLOWING FIELDS
	D I2101^EASEZI(EASDFN,.DISPOS)
	I $D(DISPOS),$D(DISPOS(1)) I DISPOS(1)="NO DISPOSITION" Q
	I $D(DISPOS)>1 D  I 1
	. ;GET TYPE OF BENEFIT
	. S VDATA=$$GET^EASEZC1(DISPOS(1),"2^2.101^2")
	. I (VDATA'=-1),(VDATA'="") D
	. . I (VDATA="HOSPITAL")!(VDATA="OUTPATIENT MEDICAL") S VDATA="HEALTH SERVICES"
	. . I VDATA["DENTAL" S VDATA="DENTAL"
	. . I VDATA["NURSING" S VDATA="NURSING HOME"
	. . S KEY=+$$KEY711^EASEZU1("TYPE OF BENEFIT-"_VDATA)
	. . S ^TMP("EZDATA",$J,KEY,1,2)="YES"
	. ;GET FACILITY APPLYING TO
	. S KEY=+$$KEY711^EASEZU1("FACILITY TO RECEIVE 1010EZ")
	. S VDATA=$$GET^EASEZC1(DISPOS(1),"2^2.101^3")
	. I (VDATA'=-1),(VDATA'="") S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	. ;
	. ;GET NEED RELATED TO JOB INJURY OR ACCIDENT
	. S KEY=+$$KEY711^EASEZU1("NEED RELATED TO JOB INJURY")
	. S VDATA=$$GET^EASEZC1(DISPOS(1),"2^2.101^20")
	. I (VDATA'=-1),(VDATA'="") S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	. S KEY=+$$KEY711^EASEZU1("NEED RELATED TO ACCIDENT")
	. S VDATA=$$GET^EASEZC1(DISPOS(1),"2^2.101^23")
	. I (VDATA'=-1),(VDATA'="") S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	E  D
	. ;IF NO DISPOSITION DATA, PRINT "UNKNOWN" FOR ABOVE FIELDS
	. S KEY=+$$KEY711^EASEZU1("TYPE OF BENEFIT-HEALTH SERVICES")
	. S ^TMP("EZDATA",$J,KEY,1,2)="UNKNOWN"
	. S KEY=+$$KEY711^EASEZU1("FACILITY TO RECEIVE 1010EZ")
	. S ^TMP("EZDATA",$J,KEY,1,2)="UNKNOWN"
	. S KEY=+$$KEY711^EASEZU1("NEED RELATED TO JOB INJURY")
	. S ^TMP("EZDATA",$J,KEY,1,2)="UNKNOWN"
	. S KEY=+$$KEY711^EASEZU1("NEED RELATED TO ACCIDENT")
	. S ^TMP("EZDATA",$J,KEY,1,2)="UNKNOWN"
	;
	;GET DATA FROM FILE #2
	S KEY=0 F  S KEY=$O(^TMP("EZDATA",$J,KEY)) Q:'KEY  D
	. S X=^TMP("EZDATA",$J,KEY)
	. I $P(X,U,1,2)="2^2" D
	. . S VDATA=$$GET^EASEZC1(EASDFN,X)
	. . Q:VDATA=-1  Q:VDATA=""
	. . I $P(X,U,3)=.09 S VDATA=$$SSNOUT^EASEZT1(VDATA)
	. . I $P(X,U,3)=.117 D
	. . . N ST,CNTY,CNAME
	. . . S ST=$$GET1^DIQ(2,EASDFN,.115,"I")
	. . . S CNTY=$$GET1^DIQ(2,EASDFN,.117,"I")
	. . . S CNAME=$$GET1^DIQ(5.01,CNTY_","_ST,.01)
	. . . S VDATA=CNAME_" ("_VDATA_")"
	. . ;EAS*1.0*70
	. . I $P(X,U,3)=.1173 S VDATA=$$COUNTRY^EASEZT1(VDATA) Q:VDATA=-1
	. . I $P(X,U,3)=.3405 D
	. . . I VDATA="N" S VDATA="EMERGENCY CONTACT"
	. . . E  S VDATA="NEXT OF KIN"
	. . I $P(X,U,3)=.362 D
	. . . I VDATA'["IN LIEU OF" S VDATA="NO"
	. . . E  S VDATA="YES"
	. . S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	;CONVERT ANSWERS FOR SPINAL CORD INJURY
	S KEY=+$$KEY711^EASEZU1("SPINAL CORD INJURY")
	S VDATA=$$GET^EASEZC1(EASDFN,"2^2^57.4") D
	. I (VDATA=-1)!(VDATA="") S VDATA="UNKNOWN" Q
	. I VDATA="NOT APPLICABLE" S VDATA="NO" Q
	. S VDATA="YES"
	S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	;IF PURPLE HEART OR NOSE/THROAT RADIUM UNANSWERED, SET TO "UNKNOWN"
	S KEY=+$$KEY711^EASEZU1("PURPLE HEART")
	S VDATA=$G(^TMP("EZDATA",$J,KEY,1,2))
	I (VDATA=-1)!(VDATA="") S ^TMP("EZDATA",$J,KEY,1,2)="UNKNOWN"
	S KEY=+$$KEY711^EASEZU1("NOSE/THROAT RADIUM")
	S X=$$GETCUR^DGNTAPI(EASDFN,"DGNT")
	S VDATA=$E($G(DGNT("INTRP")))
	I (VDATA=-1)!(VDATA="") S VDATA="UNKNOWN"
	I (VDATA'=-1),(VDATA'="") S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	;
	;GET LAST MILITARY SERVICE EPISODE DATA FROM MSE SUB-FILE #2.3216
	;DG*5.3*797
	I '$D(^DPT(EASDFN,.3216)) D MOVMSE^DGMSEUTL(EASDFN)
	S X=$O(^DPT(EASDFN,.3216,"B",""),-1) S:X X=$O(^DPT(EASDFN,.3216,"B",X,""))
	I +X D
	. S KEY=+$$KEY711^EASEZU1("LAST ENTRY DATE")
	. S VDATA=$$GET^EASEZC1(EASDFN_";"_+X,"2^2.3216^.01")
	. I (VDATA=-1)!(VDATA="") S VDATA="UNKNOWN"
	. S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	. S KEY=+$$KEY711^EASEZU1("LAST DISCHARGE DATE")
	. S VDATA=$$GET^EASEZC1(EASDFN_";"_+X,"2^2.3216^.02")
	. I (VDATA=-1)!(VDATA="") S VDATA="UNKNOWN"
	. S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	. S KEY=+$$KEY711^EASEZU1("LAST BRANCH OF SERVICE")
	. S VDATA=$$GET^EASEZC1(EASDFN_";"_+X,"2^2.3216^.03")
	. I (VDATA=-1)!(VDATA="") S VDATA="UNKNOWN"
	. S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	. S KEY=+$$KEY711^EASEZU1("SERVICE NUMBER")
	. S VDATA=$$GET^EASEZC1(EASDFN_";"_+X,"2^2.3216^.05")
	. I (VDATA=-1)!(VDATA="") S VDATA="UNKNOWN"
	. S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	. S KEY=+$$KEY711^EASEZU1("LAST DISCHARGE TYPE")
	. S VDATA=$$GET^EASEZC1(EASDFN_";"_+X,"2^2.3216^.06")
	. I (VDATA=-1)!(VDATA="") S VDATA="UNKNOWN"
	. S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	;
	;GET ENROLLMENT DATA
	D I2711^EASEZI(EASDFN,.ENROLL)
	I $D(ENROLL)>1 D
	. S VDATA="" D ENR^EASEZC1(ENROLL(1),.VDATA)
	. Q:VDATA=-1  Q:VDATA=""
	. S ^TMP("EZDATA",$J,C2711,1,2)=VDATA
	;
	;GET DATA FROM FILES 408.12, 408.13, 408.21, AND 408.22
	D V408^EASEZPV2(EASDFN,EASMTIEN)
	;
	;GET RACE DATA
	D I202^EASEZI(EASDFN,.RACE)
	I $D(RACE)>1 D
	. N SBIEN
	. S X=0 F  S X=$O(RACE(X)) Q:'X  D
	. . S SBIEN=$P(RACE(X),";",2)
	. . S VDATA=$$GET1^DIQ(2.02,SBIEN_","_EASDFN,.01)
	. . Q:VDATA=-1  Q:VDATA=""
	. . S KEY=+$$KEY711^EASEZU1("APPLICANT RACE - "_VDATA)
	. . S ^TMP("EZDATA",$J,KEY,1,2)="YES"
	;
	;GET ETHNICITY DATA
	D I206^EASEZI(EASDFN,.ETHNC)
	I $D(ETHNC)>1 D
	. N SBIEN
	. S X=0 F  S X=$O(ETHNC(X)) Q:'X  D
	. . S SBIEN=$P(ETHNC(X),";",2)
	. . S VDATA=$$GET1^DIQ(2.06,SBIEN_","_EASDFN,.01)
	. . Q:VDATA=-1  Q:VDATA=""
	. . Q:$E(VDATA,1,8)="DECLINED"
	. . I VDATA="HISPANIC OR LATINO" S VDATA="YES"
	. . I $E(VDATA,1,3)="NOT" S VDATA="NO"
	. . I $E(VDATA,1,3)="UNK" S VDATA="UNKNOWN"
	. . S KEY=+$$KEY711^EASEZU1("APPLICANT SPANISH, HISPANIC, OR LATIN")
	. . S ^TMP("EZDATA",$J,KEY,1,2)=VDATA
	;
	;GET INSURANCE DATA
	D INSUR^EASEZPVI(EASDFN)
	Q
