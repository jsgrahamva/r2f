DGROHLU	;DJH/AMA,TDM - ROM HL7 BUILD ORF SEGMENT ; 10/20/10 3:00pm
	;;5.3;Registration;**533,572,754,797**;Aug 13, 1993;Build 24
	;
	Q
	;
DIQ(DGROFDA,FILE,DFN,DGQRY)	  ;GATHER THE PATIENT DATA USING GETS^DIQ
	;Called from BLDORF^DGROHLQ
	;  INPUT:
	;    DGROFDA = ROOT FILE NAME OF TEMP GLOBAL ARRAY, ^TMP("DGROFDA",$J)
	;    FILE    = FILE FROM WHICH TO GATHER THE DATA
	;    DFN     = POINTER TO PATIENT (#2) FILE
	;    DGQRY   = ARRAY OF PARSED "QRY" DATA   ;DG*5.3*572
	;
	;  OUTPUT:
	;    GLOBAL ARRAY OF REQUESTED DATA ELEMENTS, IN DGROFDA
	;
	;THIS ROUTINE ALSO CHECKS THE DG REGISTER ONCE FIELD DEFINITION
	;(#391.23) FILE TO ENSURE EACH DATA ELEMENT IS REQUESTED.
	;
	N U,FLAG,FIELD,TMPFLD,F,IEN,CNT,F1,F2,F3,F4,EIEN,STATEIEN,CNTYIEN,CNTY
	N CAGET,CANOD,CAACT,CABDT,CAEDT
	;
	;BUILD THE INITIAL DATA ELEMENT GLOBAL ARRAY
	;* County name is sent instead of number (avoid duplicate on number)
	;*  Direct global reads of STATE file, COUNTY multiple supported with
	;*  IA #10056
	;
	S U="^",FLAG="EN" ;*Get External value (DG*5.3*572)
	S (STATEIEN,CNTYIEN)=""
	S FILE=0
	;
	;Determine if Confidential Address info should be retreived.
	S CAGET=0,CANOD=$G(^DPT(DFN,.141))
	S CAACT=$P(CANOD,"^",9),CABDT=$P(CANOD,"^",7),CAEDT=$P(CANOD,"^",8)
	I CAACT="Y",+CABDT>0,((CAEDT="")!((CAEDT+1)>DT)) S CAGET=1
	;
	F  S FILE=$O(^DGRO(391.23,"C",FILE)) Q:'FILE  D
	. I (FILE=2.01)!(FILE=2.02)!(FILE=2.06)!(FILE=2.141)!(FILE=2.11)!(FILE=2.3216) Q
	. S FIELD=0
	. F  S FIELD=$O(^DGRO(391.23,"C",FILE,FIELD)) Q:'FIELD  D
	. . Q:$$DIS^DGROHLR1(FILE,FIELD)
	. . I 'CAGET,FILE=2,((FIELD=.1315)!(FIELD=.14105)!((FIELD>.1410)&(FIELD<.1419))!((FIELD>.14110)&(FIELD<.14117))) Q
	. . S (CNTY,CNTYIEN,STATEIEN)=0
	. . I FILE=2 DO
	. . . I (FIELD=.117),($D(^DPT(DFN,.11))) DO
	. . . . S STATEIEN=$P(^DPT(DFN,.11),"^",5)
	. . . . S CNTYIEN=$P(^DPT(DFN,.11),"^",7)
	. . . . S:((+STATEIEN>0)&(+CNTYIEN>0)) @DGROFDA@(FILE,DFN,FIELD,"E")=$P(^DIC(5,STATEIEN,1,CNTYIEN,0),"^",1)
	. . . . S CNTY=1
	. . . I (FIELD=.12111),($D(^DPT(DFN,.121))) DO
	. . . . S STATEIEN=$P(^DPT(DFN,.121),"^",5)
	. . . . S CNTYIEN=$P(^DPT(DFN,.121),"^",11)
	. . . . S:((+STATEIEN>0)&(+CNTYIEN>0)) @DGROFDA@(FILE,DFN,FIELD,"E")=$P(^DIC(5,STATEIEN,1,CNTYIEN,0),"^",1)
	. . . . S CNTY=1
	. . . I (FIELD=.14111),($D(^DPT(DFN,.141))) DO
	. . . . S STATEIEN=$P(^DPT(DFN,.141),"^",5)
	. . . . S CNTYIEN=$P(^DPT(DFN,.141),"^",11)
	. . . . S:((+STATEIEN>0)&(+CNTYIEN>0)) @DGROFDA@(FILE,DFN,FIELD,"E")=$P(^DIC(5,STATEIEN,1,CNTYIEN,0),"^",1)
	. . . . S CNTY=1
	. . ; Figure out how to skip the following line if CA is skipped
	. . D:(CNTY=0) GETS^DIQ(FILE,DFN,FIELD,FLAG,DGROFDA)
	;
	;IF THERE'S NO DATE OF DEATH, KILL ALL OTHER DoD FIELDS
	I '$D(@DGROFDA@(2,DFN_",",.351)) F FIELD=.351:.001:.355 K @DGROFDA@(2,DFN_",",FIELD)
	;
	;GET INTERNAL AND EXTERNAL VALUES - ALIAS, RACE, AND ETHNICITY SUB-FILES
	F FILE=2.01,2.02,2.06,2.141,2.11,2.3216 D
	. N SBFL,SBDA,SBFLD
	. S FLAG="IEN" ;*Get Internal and External; no Null values (DG*5.3*572)
	. S SBFL=FILE-2 I FILE=2.141 S SBFL=.14
	. I FILE=2.11 S SBFL=.37
	. S SBDA=0 F  S SBDA=$O(^DPT(DFN,SBFL,SBDA)) Q:'SBDA  D
	. . S SBFLD=0 F  S SBFLD=$O(^DGRO(391.23,"C",FILE,SBFLD)) Q:'SBFLD  D
	. . . Q:$$DIS^DGROHLR1(FILE,SBFLD)
	. . . D GETS^DIQ(FILE,SBDA_","_DFN,SBFLD,FLAG,DGROFDA)
	;ENSURE THE RACE DATA IS ACTIVE
	S IEN="" F  S IEN=$O(@DGROFDA@(2.02,IEN)) Q:IEN=""  D
	. N RIEN,MIEN
	. S RIEN=$G(@DGROFDA@(2.02,IEN,.01,"I"))
	. I $$GET1^DIQ(10,RIEN,200,"I") K @DGROFDA@(2.02,IEN) Q
	. K @DGROFDA@(2.02,IEN,.01,"I")
	. K @DGROFDA@(2.02,IEN,.02,"I")
	;ENSURE THE ETHNICITY DATA IS ACTIVE
	S IEN="" F  S IEN=$O(@DGROFDA@(2.06,IEN)) Q:IEN=""  D
	. N EIEN,MIEN
	. S EIEN=$G(@DGROFDA@(2.06,IEN,.01,"I"))
	. I $$GET1^DIQ(10.2,EIEN,200,"I") K @DGROFDA@(2.06,IEN) Q
	. K @DGROFDA@(2.06,IEN,.01,"I")
	. K @DGROFDA@(2.06,IEN,.02,"I")
	;
	;CHECK FOR SENSITIVE PATIENT; IF SO, THEN PUT THE QUERY SITE (QS)
	;USER IN THE NEW PERSON (#200) FILE, RECORD THE ACCESS IN THE
	;SECURITY LOG, AND SEND A MAIL BULLETIN TO THE ISO.    ;DG*5.3*572
	I $D(@DGROFDA@(38.1)) D
	. N DGREMS,DGREMN,DGUSER
	. S DGREMS=$$IEN^XUAF4(DGQRY("SNDFAC"))   ;QS Institution File (#4) IEN
	. S DGREMN=$P($$NS^XUAF4(DGREMS),U)       ;Get QS Station Name
	. S DGUSER=$TR(DGQRY("USER"),"~",U)       ;Get QS user data
	. ;
	. ;Build input for New Person File
	. ;(format: SSN^Name^Station Name^Station #^Remote DUZ^Phone)
	. S DGUSER=$P(DGUSER,U,1,2)_U_DGREMN_U_DGQRY("SNDFAC")_U_$P(DGUSER,U,3,4)
	. I '$$PUT^XUESSO1(DGUSER) K @DGROFDA Q
	. ;
	. S DUZ=$$FIND1^DIC(200,"","",$P(DGUSER,U),"SSN","")
	. S EVENT="DGRO ROM QRY/R02 EVENT"
	. D SETLOG1^DGSEC(DFN,DUZ,0,U_EVENT)   ;Create Security Log entry
	. D BULTIN1^DGSEC(DFN,DUZ,U_EVENT)     ;Send ISO mail bulletin
	Q
	;
FDA(DGWRK,DGCURLIN,DGFS,DGCS,DGRS,DGDATA)	  ;Download patient data from Last Site Treated
	;Called from PARSORF^DGROHLQ3
	;  Input:
	;    DGWRK - Root global with all of the patient data segments, ^TMP("DGROHL7",$J)
	;    DGCNT - Counter for the root global subscript
	;     DGFS - HL7 field separator
	;     DGCS - HL7 component separator
	;     DGRS - HL7 repetition separator
	;
	;  Output:
	;    DGDATA - Root global for the patient data to upload, ^TMP("DGROFDA",$J)
	;
	N DGSUBS,DGVAL,DGFILE,DGIEN,DGFIELD,DGINT,DGRODA
	;
	S DGCURLIN=DGCURLIN-1
	F  S DGCURLIN=$O(@DGWRK@(DGCURLIN)) Q:'DGCURLIN  D
	. N DGSEG
	. S DGSEG=$P(@DGWRK@(DGCURLIN,0),DGFS,2)
	. S DGSUBS=$P(DGSEG,DGRS),DGVAL=$P(DGSEG,DGRS,2)
	. S DGFILE=$P(DGSUBS,DGCS),DGIEN=$P(DGSUBS,DGCS,2)
	. S DGFIELD=$P(DGSUBS,DGCS,3),DGINT=$P(DGVAL,DGCS)
	. ;
	. I '$D(^DGRO(391.23,"C",DGFILE,DGFIELD)) Q
	. N SUB S SUB=$O(^DGRO(391.23,"C",DGFILE,DGFIELD,0)) Q:'SUB
	. I $P($G(^DGRO(391.23,SUB,0)),"^",5)=1 Q
	. ;
	. ;BUILD/STORE EXTERNAL VALUES INTO ;*DG*5.3*572
	. ;  ^TMP("DGROFDA",$J,FILE,IEN,FIELD,"E")=VALUE
	. S @DGDATA@(DGFILE,DGIEN,DGFIELD,"E")=DGINT
	Q
