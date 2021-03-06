FBPAID3	;DSS/SCR - Utilities to support FEE BASIS PAID TO IB Process ;3/28/1012
	;;3.5;FEE BASIS;**135**;JAN 30, 1995;Build 3
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
	;  DBIA SUPPORTED REF INSUR^IBBAPI
	;                     ELIG^VADPT
	;
	Q
	;
IBALLWD()	 ;EP FROM FBPAID
	; RETURNS 1 if lines should be added to the FEE BASIS PAID TO IB file for further processing
	;           by scheduled background job FB PAID TO IB
	;         0 if the site has not set the site parameter to allow updates OR db errors occur
	;
	N FBIEN,FBRETRN,FBERR
	;
	S FBRETRN=0  ;DON'T ALLOW new entries to FEE BASIS PAID TO IB file...
	S FBIEN=$O(^FBAA(161.4,0))
	S:+FBIEN FBRETRN=$$GET1^DIQ(161.4,FBIEN_",",40,"I","","FBERR")  ;if "" or 1 is returned updates ok
	I $G(FBERR("DIERR"))'="" S FBRETRN=0
	S:FBRETRN="" FBRETRN=0  ;Site must set parameter to make interface work initially
	Q FBRETRN
	;
	;
ADDONE(FBPROG,FBIEN,FBPAT,FBDATE)	;EP FROM FBPAID
	; INPUT  : FBPROG : "3" FOR OUTPATIENT, "9" FOR INPATIENT
	;          FBIEN  : AN ARRAY SET UP FROM THE PARSING ROUTINE IN FBPAID1
	;          FBPAT  : POINTER TO THE PATIENT FILE
	;          FBDATE : DATE OF MM MESSAGE FROM CENTRAL FEE PROCESSING
	;
	; OUPUT  : ien of new entry or -1 if problems occur
	;
	N FBARRY,FBOK,FBERR
	;
	S FBARRY("PATIENT")=FBPAT  ;INTERNAL
	S FBARRY("PROGRAM")=FBPROG
	I $G(FBPROG)=3 D
	.S FBARRY("FBICN")=$G(FBIEN(3))_";"_$G(FBIEN(2))_";"_$G(FBIEN(1))_";"_$G(FBIEN)
	.S FBARRY("LI NUMBER")=FBIEN
	I $G(FBPROG)=9 D
	.S FBARRY("FBICN")=FBIEN
	.;S FBARRY("LI NUMBER")=1   ;There can be up to 25 line items in the same record
	S FBARRY("PROCESS DATE")=FBDATE   ;INTERNAL Date message started getting processed
	S FBOK=$$SETFB2IB("",.FBARRY)  ;returns the ien of a new line, or -1
	Q FBOK
	;
EPFBTOIB(FBDATEIN)	;EP FROM FB PAID TO IB OPTION
	;  INPUT : FBDATEIN - OPTIONAL and not supplied by the OPTION if sent
	;                      this should be 'DATE OF LAST GOOD RUN' 
	;                   - all dates after this date will be re-processed in the
	;                       FEE BASIS PAID TO IB file
	;                       
	N FBIEN,FBTEST,FBQUIT,FBOK,FBIEN3,FBDATE,FBTODAY
	S FBTODAY=DT
	;
	D CLEANUP(FBTODAY)
	K ^TMP($J,"FBPAID3") ;temporary global to hold info for each date to be processed
	; 
	I $G(FBDATEIN)="" D
	.S FBQUIT=0
	.S FBDATE=""
	.S FBDATE=$O(^FB(161.9,"AC",FBDATE),-1)
	.;FIND LAST PROCCESSED DATE BY LOOKING AT NPI ADDED field which is always populated when processed
	.S:FBDATE="" FBQUIT=1
	.F  Q:FBQUIT  D
	..S FBIEN=0
	..S FBIEN=$O(^FB(161.9,"AC",FBDATE,FBIEN))
	..I $$GET1^DIQ(161.9,FBIEN_",",.08,"I","","")'="" S FBQUIT=1
	..Q:FBQUIT
	..S FBDATE=$O(^FB(161.9,"AC",FBDATE),-1)
	..I FBDATE="" S FBQUIT=1
	.S FBDATE=$O(^FB(161.9,"AC",FBDATE))   ;then I have found a date that has been processed, stepped back one and then quit...
	I $G(FBDATEIN)'="" S FBDATE=FBDATEIN
	Q:FBDATE=""  ;NO UNPROCESSED RECORDS
	F  Q:(FBDATE="")  D
	.S FBIEN3=0
	.F  S FBIEN3=$O(^FB(161.9,"AC",FBDATE,FBIEN3)) Q:'+FBIEN3  S ^TMP($J,"FBPAID3",FBDATE,FBIEN3)=""
	.D SCRUB2IB(FBDATE)
	.K ^TMP($J,"FBPAID3",FBDATE)
	.S FBDATE=$O(^FB(161.9,"AC",FBDATE))
	Q
	;
CLEANUP(FBDATE)	;delete entries from 161.9 older than 180 days from FBDATE
	; INPUT : FBDATE - Today's date
	;
	;
	N FBIEN,FBOLDATE
	;
	N X1,X2,X,%H,DA,DIK,DIE,DR
	;
	S X1=FBDATE
	S X2=-179
	D C^%DTC
	S FBOLDATE=X  ;THE FM DATE 179 DAYS BEFORE FBDATE
	;
	F  S FBOLDATE=$O(^FB(161.9,"AC",FBOLDATE),-1) Q:FBOLDATE=""  D
	.S FBIEN=0
	.F  S FBIEN=$O(^FB(161.9,"AC",FBOLDATE,FBIEN)) Q:FBIEN=""  D DELFB2IB(FBIEN)
	Q
	;
SCRUB2IB(FBDATE)	; process entries in 161.9 for this process date
	;
	; INPUT  : FBDATE - Process date in FEE BASIS PAID TO IB file
	;
	; OUTUPT : 1 indication processing is complete
	;
	N FBIEN2,FBCHECK,FBPATARY,FBARRY,FBPAT,FBXIEN,FBNXT,FBRECARY,FBINSRET,FBTRTDT,FBDATE2,FBLINUM
	;
	; FBCHECK,FBARRY and FBRECARY are all arrays that keep persistent information
	;   through subroutine calls and are always passed by reference
	; 
	S FBIEN2=0
	;
	S FBCHECK(0)="^0^0"  ;the three piece string of info to use if NPI is blank
	;
	F  S FBIEN2=$O(^TMP($J,"FBPAID3",FBDATE,FBIEN2)) Q:FBIEN2=""  D
	.S FBOK=$$GETFB2IB(FBIEN2,.FBARRY)
	.S FBPAT=$G(FBARRY("PATIENT INTERNAL"))
	.Q:'+FBPAT
	.S:$G(FBPATARY(FBPAT,0))="" FBPATARY(FBPAT,0)='$$FBSC(FBPAT)  ;(IF SC RETURNS 1, WE WANT 0)
	.S FBPATARY(FBPAT,FBIEN2)=""
	.Q:FBPATARY(FBPAT,0)=0
	.S FBPROG=$G(FBARRY("PROGRAM INTERNAL"))
	.S FBICN=$G(FBARRY("FBICN"))
	.S FBLINUM=$G(FBARRY("LI NUMBER"))
	.S FBOK=0   ;FLAGS IF DB CALLS RETURN WITH PROBLEMS
	.I FBPROG=9 D
	..S FBOK=$$GETFBINV(FBICN,.FBRECARY)
	..Q:'FBOK
	..S FBTRTDT=FBRECARY("TREATMENT FROM DATE")
	..S:$G(FBPATARY(FBPAT,"STRTDT",FBTRTDT))="" FBPATARY(FBPAT,"STRTDT",FBTRTDT)=$$INSUR^IBBAPI(FBPAT,FBTRTDT,"I",.FBINSRET)
	..S FBPATARY(FBPAT,FBIEN2)=FBPATARY(FBPAT,"STRTDT",FBTRTDT)
	.;
	.I FBPROG=3 D
	..S FBOK=$$GETFBPAY(FBICN,.FBRECARY)
	..Q:'FBOK
	..S FBTRTDT=FBRECARY("TREATMENT DATE")
	..S:$G(FBPATARY(FBPAT,"TRTDT",FBTRTDT))="" FBPATARY(FBPAT,"TRTDT",FBTRTDT)=$$INSUR^IBBAPI(FBPAT,FBTRTDT,"O",.FBINSRET)
	..S FBPATARY(FBPAT,FBIEN2)=FBPATARY(FBPAT,"TRTDT",FBTRTDT)
	.;
	.Q:'FBOK
	.I $G(FBRECARY("CONTRACT"))'="" S FBPATARY(FBPAT,FBIEN2)=-1  ;get rid of this record
	.Q:$G(FBRECARY("CONTRACT"))'=""
	.Q:FBPATARY(FBPAT,FBIEN2)=0  ;get rid of this record since no valid INPATIENT insurance on 'start date'
	.I FBPATARY(FBPAT,FBIEN2)=1 D PRCFBREC^FBPAID3A(FBIEN2,.FBRECARY,.FBARRY,.FBCHECK)
	;NOW REMOVE EACH RECORD EACH PATIENT THAT HAS SC STATUS from FEE BASIS PAID TO IB and from local array 
	S FBPAT=0
	F  S FBPAT=$O(FBPATARY(FBPAT)) Q:'+FBPAT  D
	.;IF THIS PERSON HAS SERVICE CONNECTED STATUS, KILL ALL HIS/HER ENTRIES
	.I $G(FBPATARY(FBPAT,0))=0 D
	..S FBXIEN=0
	..F  S FBXIEN=$O(FBPATARY(FBPAT,FBXIEN)) Q:'+FBXIEN  D DELFB2IB(FBXIEN)
	..K FBPATARY(FBPAT)
	.;IF THIS PERSON DOES NOT HAVE APPROPRIATE COVERAGE ON THE DATE OF SERVICE, KILL THIS LINE
	.I $G(FBPATARY(FBPAT,0))=1 D
	..S FBXIEN=0
	..F  S FBXIEN=$O(FBPATARY(FBPAT,FBXIEN)) Q:'+FBXIEN  D 
	...I $G(FBPATARY(FBPAT,FBXIEN))<=0 D 
	....D DELFB2IB(FBXIEN)
	....K FBPATARY(FBPAT,FBXIEN)
	.S FBXIEN=0
	.;NOW KILL ANY REMAINING ENTRIES FOR THIS PATIENT THAT ARE FOR CONTRACTED SERVICES
	.F  S FBXIEN=$O(FBPATARY(FBPAT,FBXIEN)) Q:'+FBXIEN  D
	..I $G(FBPATARY(FBPAT,FBXIEN))<=0 D 
	...D DELFB2IB(FBXIEN)
	...K FBPATARY(FBPAT,FBXIEN)
	Q
	;
SETFB2IB(FBIEN,FBARRY)	 ;ADD OR UPDATE A RECORD TO 161.9 FEE BASIS PAID TO IB FILE
	;SETS FIELD VALUES INTO 161.9 -- FEE BASIS PAID TO IB FILE
	;
	; INPUT : FBIEN : IF "" a new entry will be created ELSE an EXISTING entry will be updated
	;         FBARRY - AN ARRAY OF INFORMATION IN INTERNAL FORMAT THAT WILL BE SET INTO THE NEW RECORD W/O VALIDATION
	;
	;         FBERR  - Empty array passed by reference which is populated if DB errors occur
	;
	N FBFDA,FBOK,FBIENRET,FBERR
	;
	S FBOK=1
	I FBIEN="" D
	.S FBFDA(161.9,"+1,",.01)=$G(FBARRY("PATIENT"))
	.S FBFDA(161.9,"+1,",.02)=$G(FBARRY("PROGRAM"))
	.S FBFDA(161.9,"+1,",.03)=$G(FBARRY("FBICN"))
	.S FBFDA(161.9,"+1,",.04)=$G(FBARRY("PROCESS DATE"))
	.S FBFDA(161.9,"+1,",.05)=$G(FBARRY("LI NUMBER"))
	.D UPDATE^DIE("","FBFDA","FBIENRET","FBERR")
	I FBIEN'="" D
	.S FBFDA(161.9,FBIEN_",",.05)=$G(FBARRY("LI NUMBER"))
	.S FBFDA(161.9,FBIEN_",",.06)=$G(FBARRY("PROVIDER TYPE"))
	.S FBFDA(161.9,FBIEN_",",.07)=$G(FBARRY("IBICN"))
	.S FBFDA(161.9,FBIEN_",",.08)=$G(FBARRY("NPI ADDED"))
	.S FBFDA(161.9,FBIEN_",",.09)=$G(FBARRY("TXY ADDED"))
	.D FILE^DIE("","FBFDA","FBERR")
	;
	I $G(FBERR("DIERR"))="" D
	.S:$G(FBIENRET(1))'="" FBOK=FBIENRET(1)  ;THE IEN WHICH WAS JUST ADDED
	.S:$G(FBIENRET(1))="" FBOK=FBIEN
	I $G(FBERR("DIERR"))'="" S FBOK=-1
	Q FBOK  ;RETURNS IEN JUST ADDED OR UPDATED OR -1
	;
GETFB2IB(FBIEN,FBARRY)	 ;GETS FIELD VALUES FROM 161.9 FEE BASIS PAID TO IB FILE
	;
	; INPUT: FBIEN - THE IEN OF THE FEE BASIS PAID TO IB FILE INFORMAITON IS DESIRED FOR
	;        FBARRY - AN EMPTY ARRAY PASSED BY REFERENCE 
	;
	; OUTPUT FBARRY :  POPULATED WITH INFO ABOUT THIS IEN
	;
	N FBIENS,FBFLDS,FBRET,FBOK,FBERR
	;
	S FBOK=1
	;
	; FB INTERNAL CONTROL NUMBER [4F]
	;^ 
	;^  ^
	;
	D GETS^DIQ(161.9,FBIEN_",","*","EI","FBRET","FBERR")
	I $G(FBERR("DIERR"))'="" S FBOK=-1
	I $G(FBRET(161.9,FBIEN_",",".01","I"))="" S FBOK=0 ;NO SUCH RECORD IEN
	;
	I FBOK D
	.S FBARRY("PATIENT")=$G(FBRET(161.9,FBIEN_",",".01","E"))
	.S FBARRY("PATIENT INTERNAL")=$G(FBRET(161.9,FBIEN_",",".01","I")) ;(#.01) ENTRY ID [1N]
	.S FBARRY("PROGRAM")=$G(FBRET(161.9,FBIEN_",",".02","E")) ;
	.S FBARRY("PROGRAM INTERNAL")=$G(FBRET(161.9,FBIEN_",",".02","I")) ;(#.02) PATIENT [2P:2]
	.S FBARRY("FBICN")=$G(FBRET(161.9,FBIEN_",",".03","E")) ;(#.03)PROGRAM [3S]
	.S FBARRY("PROCESS DATE")=$G(FBRET(161.9,FBIEN_",",".04","E")) ;
	.S FBARRY("PROCESS DATE INTERNAL")=$G(FBRET(161.9,FBIEN_",",".04","I")) ;(#.04)FB INTERNAL CONTROL NUMBER [4F]
	.S FBARRY("LI NUMBER")=$G(FBRET(161.9,FBIEN_",",".05","E")) ;(#.05) PROCESS DATE [5D] 
	.S FBARRY("PROVIDER TYPE")=FBRET(161.9,FBIEN_",",".06","E") ;(#.06) PROVIDER TYPE [6S]
	.S FBARRY("IBICN")=$G(FBRET(161.9,FBIEN_",",".07","E")) ;(#.07) IB NON/OTHER PNTR[7P] 
	.S FBARRY("NPI ADDED")=$G(FBRET(161.9,FBIEN_",",".08","E"))
	.S FBARRY("NPI ADDED INTERNAL")=$G(FBRET(161.9,FBIEN_",",".08","I")) ;(#.08) NPI ADDED [8S]
	.S FBARRY("TXY ADDED")=$G(FBRET(161.9,FBIEN_",",".09","E")) ;
	.S FBARRY("TXY ADDED INTERNAL")=$G(FBRET(161.9,FBIEN_",",".09","I")) ;(#.09) TAXONOMY ADDED [9S] 
	;
	I 'FBOK K FBARRY
	;
	Q FBOK
	;
DELFB2IB(FBIEN)	 ;EP FROM FBPAID3A
	;DELETES A RECORD FROM 161.9 FEE BASIS PAID TO IB FILE
	;
	; INPUT: FBIEN - The IEN of the FEE BASIS PAID TO IB FILE to be deleted
	;
	N DIK,DA
	S DIK="^FB(161.9,"
	S DA=FBIEN
	D ^DIK
	Q
	;
FBSC(FBDFN)	; returns 1 if service connection indicated, 0 otherwise (based on VAEL(3))
	; INPUT : FBDFN - ien to the PATIENT file
	;
	; OUTPUT : 1 if service connected, 0 if NO service connected
	N FBX,VAEL,VAERR,DFN
	S FBX=0
	S DFN=FBDFN
	I +$G(DFN) D ELIG^VADPT S FBX=$P($G(VAEL(3)),U,1)
	Q FBX
	;
GETFBINV(FBINVIEN,FBINVARY)	 ;Get info about a record in FEE BASIS INVOICE file
	;
	; INPUT :FBINVIEN   the ien we wish to examine
	;        FBINVARY  an empty array passed by reference 
	;
	; OUTPUT : FBINVARY : populated with information about this record
	;
	N FBFLDS,FBQUIT,FBLIPRV,FBERR,FBFLDS2,FBRET,FBRET2
	;
	S FBQUIT=0
	;
	S FBFLDS=".01;2;5;6;20;60;64;65;66;67;68;69;70;71;72;73;74;75;80;81;82;83"
	;(#2)VENDOR [3P:161.2] ;THIS IS OUR PRIMARY PROVIDER
	;(#5) TREATMENT FROM DATE [6D] ^ (#6) TREATMENT TO DATE [7D] 
	;(#20) BATCH NUMBER ; (#60) CONTRACT [8P:161.43] 
	;(#64) ATTENDING PROV NAME [1F] ^ (#65) ATTENDING PROV NPI [2F](#66) ATTENDING PROV TAXONOMY CODE [3F] ^ 
	;(#67) OPERATING PROV NAME [4F] ^ (#68) OPERATING PROV NPI [5F]
	; (#69)RENDERING PROV NAME [6F] ^ (#70) RENDERING PROV NPI [7F] ^(#71) RENDERING PROV TAXONOMY CODE [8F] 
	;(#72) SERVICING PROVNAME [9F] ^ (#73) SERVICING PROV NPI [10F] 
	;(#74) REFERRING PROV NAME [11F] ^ (#75) REFERRING PROV NPI [12F];(#80) SERVICING FACILITY ADDRESS [1F]
	;(#81) SERVICING FACILITY CITY [2F] ^ (#82) SERVICING FACILITY STATE [3P:5] ^ (#83) SERVICING FACILITY ZIP [4F]
	D GETS^DIQ(162.5,FBINVIEN_",",FBFLDS,"I","FBRET","FBERR")
	I $G(FBERR("DIERR"))'="" S FBQUIT=1
	I 'FBQUIT D
	.S FBINVARY("VENDOR INTERNAL")=$G(FBRET(162.5,FBINVIEN_",","2","I"))
	.S FBINVARY("TREATMENT FROM DATE")=$G(FBRET(162.5,FBINVIEN_",","5","I"))
	.S FBINVARY("TREATMENT TO DATE")=$G(FBRET(162.5,FBINVIEN_",","6","I"))
	.S FBINVARY("BATCH NUMBER")=$G(FBRET(162.5,FBINVIEN_",","20","I"))
	.S FBINVARY("CONTRACT")=$G(FBRET(162.5,FBINVIEN_",","60","I"))
	.S FBINVARY("ATTENDING NAME")=$G(FBRET(162.5,FBINVIEN_",","64","I"))
	.S FBINVARY("ATTENDING NPI")=$G(FBRET(162.5,FBINVIEN_",","65","I"))
	.S FBINVARY("ATTENDING TXY")=$G(FBRET(162.5,FBINVIEN_",","66","I"))
	.S FBINVARY("OPERATING NAME")=$G(FBRET(162.5,FBINVIEN_",","67","I"))
	.S FBINVARY("OPERATING NPI")=$G(FBRET(162.5,FBINVIEN_",","68","I"))
	.S FBINVARY("RENDERING NAME")=$G(FBRET(162.5,FBINVIEN_",","69","I"))
	.S FBINVARY("RENDERING NPI")=$G(FBRET(162.5,FBINVIEN_",","70","I"))
	.S FBINVARY("RENDERING TXY")=$G(FBRET(162.5,FBINVIEN_",","71","I"))
	.S FBINVARY("SERVICING NAME")=$G(FBRET(162.5,FBINVIEN_",","72","I"))
	.S FBINVARY("SERVICING NPI")=$G(FBRET(162.5,FBINVIEN_",","73","I"))
	.S FBINVARY("REFERRING NAME")=$G(FBRET(162.5,FBINVIEN_",","74","I"))
	.S FBINVARY("REFERRING NPI")=$G(FBRET(162.5,FBINVIEN_",","75","I"))
	.S FBINVARY("SERVICING ADDRESS")=$G(FBRET(162.5,FBINVIEN_",","80","I"))
	.S FBINVARY("SERVICING CITY")=$G(FBRET(162.5,FBINVIEN_",","81","I"))
	.S FBINVARY("SERVICING STATE INT")=$G(FBRET(162.5,FBINVIEN_",","82","I"))
	.S FBINVARY("SERVICING ZIP")=$G(FBRET(162.5,FBINVIEN_",","83","I"))
	.;kill any existing LI info, because it may not get overwritten like the above
	.K FBINVARY("LIRENDER NAME")
	.K FBINVARY("LIRENDER NPI")
	.K FBINVARY("LIRENDER TXY")
	.;
	.;NOW GET LI RENDERING PROVIDER INFO
	.S FBLIPRV=0
	.F  S FBLIPRV=$O(^FBAAI(FBINVIEN,"RPROV",FBLIPRV)) Q:'+FBLIPRV  D
	..S FBFLDS2=".01;.02;.03;.04"
	..;(#.01) LINE ITEM NUMBER [1N];(#.02) RENDERING PROV NAME [2F];(#.03) RENDERING PROV NPI [3F]
	..; (#.04)RENDERING PROV TAXONOMY CODE [4F] ^
	..D GETS^DIQ(162.579,FBLIPRV_","_FBINVIEN_",",FBFLDS2,"I","FBRET2","FBERR")  ;162.579(#79) LINE ITEM RENDERING PROV
	..I $G(FBERR("DIERR"))'="" S FBQUIT=1
	..I 'FBQUIT D
	...S FBINVARY("LINE ITEM NUMBER",FBLIPRV)=$G(FBRET2(162.579,FBLIPRV_","_FBINVIEN_",",".01","I"))
	...S FBINVARY("LIRENDER NAME",FBLIPRV)=$G(FBRET2(162.579,FBLIPRV_","_FBINVIEN_",",".02","I"))
	...S FBINVARY("LIRENDER NPI",FBLIPRV)=$G(FBRET2(162.579,FBLIPRV_","_FBINVIEN_",",".03","I"))
	...S FBINVARY("LIRENDER TXY",FBLIPRV)=$G(FBRET2(162.579,FBLIPRV_","_FBINVIEN_",",".04","I"))
	Q 'FBQUIT
	;
GETFBPAY(FBPAYIEN,FBPAYARY)	 ;Get info about a record in FEE BASIS PAYMENT file
	;
	; INPUT :FBPAYIEN   a four piece string that will identify the SERVICE
	;        FBPAYARY  an empty array passed by reference
	;
	; OUTPUT : FBPAYARY :  populated with information about this sub-record
	;          0 if problems occurred, 1 otherwise
	N FBIENS,FBFLDS,FBQUIT,FBRET,FBERR1
	;
	S FBQUIT=0
	S FBIENS=$P(FBPAYIEN,";",2)_","_$P(FBPAYIEN,";",1)_","   ;THE PATIENT:VENDOR sub-record id
	D GETS^DIQ(162.01,FBIENS,".01","I","FBRET","FBERR1") ;162.01 FEE BASIS PAYMENT FILE:(#.01) VENDOR subrecord
	I $G(FBERR1("DIERR"))'="" S FBQUIT=1
	I 'FBQUIT D
	.S FBPAYARY("VENDOR INTERNAL")=$G(FBRET(162.01,FBIENS,".01","I"))
	.;
	.S FBIENS=$P(FBPAYIEN,";",3)_","_FBIENS
	.D GETS^DIQ(162.02,FBIENS,".01","I","FBRET","FBERR1") ;162.02 (#.01) INITIAL TREATMENT DATE [1D]
	.I $G(FBERR1("DIERR"))'="" S FBQUIT=1
	.S FBPAYARY("TREATMENT DATE")=$G(FBRET(162.02,FBIENS,".01","I"))
	.;
	.I 'FBQUIT D
	..S FBIENS=$P(FBPAYIEN,";",4)_","_FBIENS
	..S FBFLDS="7;54;58;59;60;61;62;63;64;65;66;67;68;69;73;74;75;76;77;78;79"
	..D GETS^DIQ(162.03,FBIENS,FBFLDS,"I","FBRET","FBERR1")  ;162.03  ; (#2) SERVICE PROVIDED
	..I $G(FBERR1("DIERR"))'="" S FBQUIT=1
	..Q:FBQUIT
	..S FBPAYARY("BATCH NUMBER")=$G(FBRET(162.03,FBIENS,"7","I"))
	..S FBPAYARY("LI NUMBER")=$P(FBPAYIEN,";",4)
	..S FBPAYARY("CONTRACT")=$G(FBRET(162.03,FBIENS,"54","I"))
	..S FBPAYARY("ATTENDING NAME")=$G(FBRET(162.03,FBIENS,"58","I"))
	..S FBPAYARY("ATTENDING NPI")=$G(FBRET(162.03,FBIENS,"59","I"))
	..S FBPAYARY("ATTENDING TXY")=$G(FBRET(162.03,FBIENS,"60","I"))
	..S FBPAYARY("OPERATING NAME")=$G(FBRET(162.03,FBIENS,"61","I"))
	..S FBPAYARY("OPERATING NPI")=$G(FBRET(162.03,FBIENS,"62","I"))
	..S FBPAYARY("RENDERING NAME")=$G(FBRET(162.03,FBIENS,"63","I"))
	..S FBPAYARY("RENDERING NPI")=$G(FBRET(162.03,FBIENS,"64","I"))
	..S FBPAYARY("RENDERING TXY")=$G(FBRET(162.03,FBIENS,"65","I"))
	..S FBPAYARY("SERVICING NAME")=$G(FBRET(162.03,FBIENS,"66","I"))
	..S FBPAYARY("SERVICING NPI")=$G(FBRET(162.03,FBIENS,"67","I"))
	..S FBPAYARY("REFERRING NAME")=$G(FBRET(162.03,FBIENS,"68","I"))
	..S FBPAYARY("REFERRING NPI")=$G(FBRET(162.03,FBIENS,"69","I"))
	..S FBPAYARY("LI RENDERING NAME")=$G(FBRET(162.03,FBIENS,"73","I"))
	..S FBPAYARY("LI RENDERING NPI")=$G(FBRET(162.03,FBIENS,"74","I"))
	..S FBPAYARY("LI RENDERING TXY")=$G(FBRET(162.03,FBIENS,"75","I"))
	..S FBPAYARY("SERVICING ADDRESS")=$G(FBRET(162.03,FBIENS,"76","I"))
	..S FBPAYARY("SERVICING CITY")=$G(FBRET(162.03,FBIENS,"77","I"))
	..S FBPAYARY("SERVICING STATE INT")=$G(FBRET(162.03,FBIENS,"78","I"))
	..S FBPAYARY("SERVICING ZIP")=$G(FBRET(162.03,FBIENS,"79","I"))
	Q 'FBQUIT
