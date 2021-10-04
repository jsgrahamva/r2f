FBPAID3A	;DSS/SCR - Utilities to support FEE BASIS PAID TO IB Process ;3/28/1012
	;;3.5;FEE BASIS;**135**;JAN 30, 1995;Build 3
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
	;; DBIA SUPPORTED REF CHKDGT^XUSNPI
	Q
	;
	;
PRCFBREC(FBIEN,FBRECARY,FBARRY,FBCHECK)	;Processes one Fee Basis record
	;                                       
	; INPUT : FBIEN - the IEN of the FEE BASIS TO IB file line being processed
	;         FBRECARY - AN array populated with information about the FEE BASIS INVOICE
	;         FBARRY - An array used to update the FEE BASIS PAID TO IB file
	;         FBCHECK - An array passed by reference which holds processed NPIs
	;  
	; OUTPUT: FBARRY populated with line item provider information
	;         FBCHECK populated with information about each NPI which has been processed
	;         'FBQUIT - 1 if no problems stopped processing, 0 if they did
	;
	N FBDUZ,FBPRVTYP,FBVDRIEN,FBATDNAM,FBATDNPI,FBATDTXY,FBOPRNAM,FBOPRNPI,FBOPRTXY
	N FBRNDNAM,FBRNDNPI,FBRNDTXY,FBSRVNAM,FBSRVNPI,FBSRVTXY,FBREFNAM,FBREFNPI,FBREFTXY
	N FBLIRNAM,FBLIRNPI,FBLIRTXY
	N FBINFO,FBIBIEN,FBNPIFLG,FBTXYFLG,FBOK,FBQUIT,FBNIEN,FBBADNPI
	;
	S FBQUIT=0
	;
	S FBDUZ=$$GETFBDUZ(FBRECARY("BATCH NUMBER"))
	;FIRST add the PRIMARY provider info
	S FBPRVTYP="1"   ;FIRST WE LOOK FOR/ADD A FACILITY PROVIDER IN THE IB FILE
	S FBVDRIEN=FBRECARY("VENDOR INTERNAL")
	I FBVDRIEN<0 S FBQUIT=1  ;if we don't have a valid VENDOR we won't be sending a bill out
	I 'FBQUIT D
	.S FBATDNAM=FBRECARY("ATTENDING NAME")
	.S FBOPRNAM=FBRECARY("OPERATING NAME")
	.S FBRNDNAM=FBRECARY("RENDERING NAME")
	.S FBSRVNAM=FBRECARY("SERVICING NAME")
	.S FBREFNAM=FBRECARY("REFERRING NAME")
	.S FBPRVNAM=""
	.S FBPRVNPI=""
	.S FBPRVTXY=""
	.S FBINFO=$$FBTOIB(FBVDRIEN,FBPRVNAM,FBPRVTYP,FBPRVNPI,FBPRVTXY,FBDUZ,.FBCHECK)
	.S FBIBIEN=$P(FBINFO,U,1)
	.S FBNPIFLG=$P(FBINFO,U,2)
	.S FBTXYFLG=$P(FBINFO,U,3)
	.S FBOK=$$UPDTONE(FBIEN,"V",FBIBIEN,FBNPIFLG,FBTXYFLG,.FBARRY)  ;UPDATES FEE BASIS PAID WITH RESULTS FOR THIS PROVIDER
	.Q:FBNPIFLG=0
	.;ADD SERVICING PROVIDER INFORMATION AS A TYPE 1 PROVIDER
	.I FBSRVNAM'="" D
	..N FBSRVINF,FBNIEN
	..S FBSRVNPI=$G(FBRECARY("SERVICING NPI"))
	..S FBSRVTXY=$G(FBRECARY("SERVICING TXY"))
	..S FBSRVTXY=""
	..S FBSRVINF("ADDRESS")=FBRECARY("SERVICING ADDRESS")
	..S FBSRVINF("CITY")=FBRECARY("SERVICING CITY")
	..S FBSRVINF("STATE")=FBRECARY("SERVICING STATE INT")
	..S FBSRVINF("ZIP")=FBRECARY("SERVICING ZIP")
	..S FBINFO=$$FBTOIB("",FBSRVNAM,FBPRVTYP,FBSRVNPI,FBSRVTXY,FBDUZ,.FBCHECK,.FBSRVINF)
	..S FBIBIEN=$P(FBINFO,U,1)  ;THIS IS "" IF NO UPDATES WERE MADE, the IB record if it was found/updated
	..S FBNPIFLG=$P(FBINFO,U,2)
	..S FBTXYFLG=$P(FBINFO,U,3)
	..S FBNIEN=$$ADD5010(FBARRY("PROGRAM INTERNAL"),FBARRY("FBICN"),FBARRY("PATIENT INTERNAL"),FBARRY("PROCESS DATE INTERNAL"),FBARRY("LI NUMBER"))
	..Q:'+FBNIEN
	..S FBOK=$$UPDTONE(FBNIEN,"S",FBIBIEN,FBNPIFLG,FBTXYFLG,.FBARRY)  ;UPDATES FEE BASIS PAID WITH RESULTS FOR THIS PROVIDER
	.;MAKE A TYPE "2" PROVIDER ENTRY FOR EACH 5010 PROVIDER EXCEPT SERVICING
	.S FBPRVTYP="2"  ;AN INDIVIDUAL TYPE PROVIDER IN THE IB NON/OTHER VA BILLING PROVIDER FILE
	.I FBATDNAM'="" D
	..S FBATDNPI=FBRECARY("ATTENDING NPI")
	..S FBATDTXY=FBRECARY("ATTENDING TXY")
	..S FBOK=$$TYPETWO("A",FBATDNAM,FBATDNPI,FBATDTXY,FBDUZ,.FBARRAY,.FBCHECK)
	.I FBOPRNAM'="" D
	..S FBOPRNPI=FBRECARY("OPERATING NPI")
	..S FBOPRTXY=""
	..S FBOK=$$TYPETWO("O",FBOPRNAM,FBOPRNPI,FBOPRTXY,FBDUZ,.FBARRAY,.FBCHECK)
	.I FBRNDNAM'="" D
	..S FBRNDNPI=FBRECARY("RENDERING NPI")
	..S FBRNDTXY=FBRECARY("RENDERING TXY")
	..S FBOK=$$TYPETWO("R",FBRNDNAM,FBRNDNPI,FBRNDTXY,FBDUZ,.FBARRAY,.FBCHECK)
	.I FBREFNAM'="" D
	..S FBREFNPI=FBRECARY("REFERRING NPI")
	..S FBREFTXY=""
	..S FBOK=$$TYPETWO("F",FBREFNAM,FBREFNPI,FBREFTXY,FBDUZ,.FBARRAY,.FBCHECK)
	.I FBARRY("PROGRAM INTERNAL")=3  D
	..;ADD LINE ITEM RENDERING PROVIDER FOR OUPATIENT
	..S FBLIRNAM=FBRECARY("LI RENDERING NAME")
	..S FBLIRNPI=FBRECARY("LI RENDERING NPI")
	..S FBLIRTXY=FBRECARY("LI RENDERING TXY")
	..I FBLIRNAM'="" S FBOK=$$TYPETWO("L",FBLIRNAM,FBLIRNPI,FBLIRTXY,FBDUZ,.FBARRAY,.FBCHECK)
	.I FBARRY("PROGRAM INTERNAL")=9 D
	..;ADD A LINE FOR EACH INPATIENT LINE ITEM RENDERING INFO
	..S FBLINUM=0
	..F  S FBLINUM=$O(FBRECARY("LIRENDER NAME",FBLINUM)) Q:FBLINUM=""  D
	...S FBLIRNAM=$G(FBRECARY("LIRENDER NAME",FBLINUM))
	...S FBLIRNPI=$G(FBRECARY("LIRENDER NPI",FBLINUM))
	...S FBLIRTXY=$G(FBRECARY("LIRENDER TXY",FBLINUM))
	...S FBARRY("LI NUMBER")=$G(FBRECARY("LINE ITEM NUMBER",FBLINUM))
	...S FBOK=$$TYPETWO("L",FBLIRNAM,FBLIRNPI,FBLIRTXY,FBDUZ,.FBARRAY,.FBCHECK)
	Q 'FBQUIT
	;
UPDTONE(FBIEN,FBTYP,FBIBICN,FBNPIFLG,FBTXYFLG,FBARRY)	 ;UPDATES a record in 161.9
	;
	; INPUT FBIEN : IEN OF FEE BASIS PAID TO IB file being updated
	;       FBTYP: INTERNAL value of set of codes identifying provider type
	;       FBIBICN  : IEN OF IB NON/VA OTHER BILLING PROVIDER file that was added or looked up
	;
	;       FBNPIFLG : '0' FOR NO NPI DATA PROVIDED;
	;                  '1' FOR NPI DATA INVALID;
	;                  '2' FOR NPI MATCHED ACTIVE, NO UPDATES;
	;                  '3' FOR NPI MATCHED ACTIVE, IB UPDATED;
	;                  '4' FOR NPI MATCHED INACTIVE, NO UPDATES;
	;                  '5' FOR NPI NEW, IB RECORD CREATED;
	;
	;       FBTXYFLG : '0' FOR NO TXY UPDATES ATTEMPTED;
	;                  '1' FOR TXY CODE NOT FOUND IN 8932.1;
	;                  '2' FOR MATCHED PRIMARY,NO UPDATES;
	;                  '3' FOR MATCHED NON-PRIMARY, IB TXY UPDATES;
	;                  '4' FOR NEW, IB TXY ENTRY CREATED;
	;
	;       FBARRY : ARRAY populated with initial values from lookup
	;
	N FBOK,FBERR
	;
	S FBARRY("PROVIDER TYPE")=FBTYP ; INTERNAL CODE FOR PRIMARY
	S FBARRY("IBICN")=$G(FBIBICN)   ;CAN BE NULL
	S FBARRY("NPI ADDED")=FBNPIFLG ;
	S FBARRY("TXY ADDED")=FBTXYFLG ;
	S FBOK=$$SETFB2IB^FBPAID3(FBIEN,.FBARRY)
	Q FBOK
	;
FBTOIB(FBVDRIEN,FBPRVNAM,FBPRVTYP,FBPRVNPI,FBPRVTXY,FBDUZ,FBCHECK,FBSRVINF)	  ;
	; PROCESSES information about one FB PROVIDER
	;
	; INPUTS  :  FBVDRIEN  : AN IEN to FEE BASIS VENDOR FILE
	;            FBPRVNAM  : A STRING OF TEXT FROM FB FILES REPRESENTING THE PROVIDER NAME
	;            FBPRVTYP  : "1" FOR FACILITY TYPE PROVIDER ;  "2" FOR INDIVIDUAL
	;            FBPRVNPI  : A STRING OF TEXT FROM FB FILES REPRESENTING THE PROVIDER NPI
	;            FBPRVTXY  : A STRING OF TEXT FROM FB FILES REPRESENTING A SUPPORTING PROVIDER TAXONOMY CODE
	;            FBDUZ     ; FB USER DUZ WHO LAST UPDATED THE FB FILE INFO IS COMING FROM
	;            FBSRVINF  : AN ARRAY OF INFORMATION FOR A SERVICING PROVIDER (TYPE 1) 
	;                            WILL BE NULL UNLESS THIS IS BEING CALLED TO ADD A SERVICING PROVIDER
	;
	;            FBCHECK   ; AN ARRAY OF NPIs that have been previously examined for this date
	;
	; OUTPUT :    A three piece string with information about how attempted updates went
	;        :    FBCHECK will contain information about NPIs that are 'new' for this date
	;
	N FBQUIT,FBRTRN,FBIBIEN,FBIENS,FBFLDS,FBFLGS,FBINDX,FBSCRN,FBIDNT,FBINFO,FBBADNPI,FBNEW,FBRETRN
	;
	S FBINFO("FBPRVTYP")=FBPRVTYP   ;"1" OR "2" for IB FACILITY or IB INDIVIDUAL
	S FBQUIT=0
	S FBIBIEN=-1
	I FBPRVNAM="" D
	.I '+FBVDRIEN S FBPRVTYP=-1
	I FBPRVNAM'="" D
	.I ($L($G(FBPRVNAM))>30) S FBPRVNAM=$E(FBPRVNAM,1,30)
	.I ($L($G(FBPRVNAM))<3) S FBPRVTYP=-1  ;
	S FBINFO("FB SUP DUZ")=FBDUZ
	S FBINFO("NAME")=FBPRVNAM
	I (FBPRVTYP="1") D
	.I FBVDRIEN'="" D
	..;LOOK UP THE PROVIDER IN THE FEE BASIS VENDOR FILE
	..;(#.01) NAME [1F] ^ (#1) ID NUMBER [2F] ^ (#2) STREET ADDRESS[3F] ^(#2.5) STREET ADDRESS 2 [14F]
	..;^ (#3) CITY [4F] ^ (#4) STATE [5P:5] ^ (#5) ZIP CODE [6F]^(#14) PHONE NUMBER [1F] ;(#41.01) NPI (#42) TAXONOMY CODE [3F]
	..I '+FBVDRIEN S FBPRVTYP=-1 Q
	..S FBFLDS=".01;1;2;2.5;3;4;5;14;41.01;42"
	..D GETS^DIQ(161.2,FBVDRIEN_",",FBFLDS,"IE","FBRTRN","FBERR")  ;161.2  ;FEE BASIS VENDOR
	..I $G(FBERR("DIERR"))'="" S FBPRVTYP=-1 Q
	..S FBINFO("NAME")=$G(FBRTRN(161.2,FBVDRIEN_",",".01","I"))
	..I $L(FBINFO("NAME"))>30 S FBINFO("NAME")=$E(FBINFO("NAME"),1,30)
	..S FBPRVNAM=FBINFO("NAME")
	..S FBINFO("FBFACID")=$G(FBRTRN(161.2,FBVDRIEN_",","1","I"))
	..S FBINFO("FBADD1")=$G(FBRTRN(161.2,FBVDRIEN_",","2","I"))
	..S FBINFO("FBADD2")=$G(FBRTRN(161.2,FBVDRIEN_",","2.5","I"))
	..S FBINFO("FBCITY")=$G(FBRTRN(161.2,FBVDRIEN_",","3","I"))
	..S FBINFO("FBSTATE")=$G(FBRTRN(161.2,FBVDRIEN_",","4","E"))
	..S FBINFO("FBSTATE INT")=$G(FBRTRN(161.2,FBVDRIEN_",","4","I"))  ;this is pointer to state file
	..S FBINFO("FBZIP")=$G(FBRTRN(161.2,FBVDRIEN_",","5","I"))
	..S FBINFO("FBPHONE")=$G(FBRTRN(161.2,FBVDRIEN_",","14","I"))
	..S FBINFO("FBNPI")=$G(FBRTRN(161.2,FBVDRIEN_",","41.01","I"))
	..S FBINFO("FBTXY")=$G(FBRTRN(161.2,FBVDRIEN_",","42","I"))
	..S FBINFO("IB TYPE")=1
	.I FBVDRIEN="" D 
	..;ADDING A SERVICING PROVIDER with address info from the FEE BASIS INVOICE or PAYMENT file
	..S FBINFO("FBADD1")=$G(FBSRVINF("ADDRESS"))
	..S FBINFO("FBADD2")=""
	..S FBINFO("FBCITY")=$G(FBSRVINF("CITY"))
	..S FBINFO("FBSTATE INT")=$G(FBSRVINF("STATE"))  ;this is pointer to state file
	..S FBINFO("FBZIP")=$G(FBSRVINF("ZIP"))
	..S FBINFO("FBNPI")=$G(FBPRVNPI)
	..S FBINFO("FBTXY")=$G(FBPRVTXY)
	..S FBINFO("IB TYPE")=1
	.S FBPRVNPI=FBINFO("FBNPI")
	.S FBPRVTXY=FBINFO("FBTXY")
	.;Check to see if NPI has been processed for this process date
	.I $G(FBPRVNPI)="" S FBPRVNPI=0
	.I $G(FBCHECK(FBPRVNPI))'="" D
	..S:$P(FBCHECK(FBPRVNPI),U,2)'=1 FBNEW=$P(FBCHECK(FBPRVNPI),U,1)_"^0^0" ;IBRECORD^NO UPDATES ATTEMPTED ^ NO TXY UPDATES ATTEMPTED
	..S:$P(FBCHECK(FBPRVNPI),U,2)'=1 FBNEW=FBCHECK(FBPRVNPI)  ; "^1^0" ;NPI INVALID, no IB record
	.Q:$G(FBNEW)'=""
	.S FBBADNPI=0
	.S:$G(FBPRVNPI)="" FBPRVNPI=0
	.Q:$G(FBPRVNPI)=""
	.I $L(FBPRVNPI)>10!($L(FBPRVNPI)<10)!('$$CHKDGT^XUSNPI(FBPRVNPI)) S FBBADNPI=1
	.I 'FBBADNPI D 
	..D EPFBAPI^IBCEP8C(.FBINFO,.FBRETRN)  ;compares/updates 355.93 -- IB NON/OTHER VA BILLING PROVIDER FILE
	..S FBNEW=FBRETRN(1)_"^"_FBRETRN(2)_"^"_FBRETRN(3)
	.I FBBADNPI S FBNEW="^1^0"
	.S FBCHECK(FBPRVNPI)=FBNEW
	I FBPRVTYP="2" D
	.;NO LOOK UP TO FB FILES OCCURS- THIS IS NOT A BILLING PROVIDER AND WON'T BE IN THE FEE BASIS VENDOR FILE
	.S FBINFO("NAME")=FBPRVNAM
	.S FBINFO("FBNPI")=FBPRVNPI
	.S FBINFO("FBTXY")=FBPRVTXY
	.S FBINFO("IB TYPE")=2
	.I $G(FBPRVNPI)="" S FBPRVNPI=0
	.I $G(FBCHECK(FBPRVNPI))'="" S FBNEW=$G(FBCHECK(FBPRVNPI))
	.I $G(FBNEW)="" D
	..S FBBADNPI=0
	..I $L(FBPRVNPI)>10!($L(FBPRVNPI)<10)!('$$CHKDGT^XUSNPI(FBPRVNPI)) S FBBADNPI=1
	..I 'FBBADNPI D
	...D EPFBAPI^IBCEP8C(.FBINFO,.FBRETRN)  ;compares/updates 355.93 -- IB NON/OTHER VA BILLING PROVIDER FILE
	...S:FBRETRN(1)'="" FBNEW=FBRETRN(1)_"^"_FBRETRN(2)_"^"_FBRETRN(3)
	...S:FBRETRN(1)="" FBNEW="^0^0"   ;problems adding or finding provider, so no other updates attempted
	..I FBBADNPI S FBNEW="^1^0"
	.Q:FBBADNPI
	S:FBPRVTYP=-1 FBNEW="^0^0"  ;
	Q FBNEW   ;A THREE PIECE STRING OF INFORMATION ABOUT HOW UPDATES WENT
	;
ADD5010(FBPROG,FBICN,FBPAT,FBDATE,FBLINUM)	;EP FROM FBPAID AND FBPAID3A
	; INPUT  : 
	;          FBPROG : "3" FOR OUTPATIENT, "9" FOR INPATIENT
	;          FBICN  : A FOUR PIECE ';' DELIMITED STRING
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
	.S FBARRY("FBICN")=FBICN
	.S FBARRY("LI NUMBER")=FBLINUM
	I $G(FBPROG)=9 D
	.S FBARRY("FBICN")=FBICN
	S FBARRY("PROCESS DATE")=FBDATE   ;INTERNAL Date message started getting processed
	S FBOK=$$SETFB2IB^FBPAID3("",.FBARRY)  ;returns the ien of a new line, or -1
	Q FBOK
	;
TYPETWO(FB5010TYP,FBPRVNAM,FBPRVNPI,FBPRVTXY,FBDUZ,FBARRAY,FBCHECK)	  ;process IB INDIVIDUAL providers
	; Validates NPI information for IB INDIVIDUAL (type 2) providers, and calls the IBAPI if the NPI is
	;    valid and has not already been processed for the current processing date.
	;
	; Updates the FEE BASIS PAID TO IB file with the results of validation/update
	;
	; INPUT  :   FB5010TYP ('A','O','R','S','F','L')
	;            FBPRVNAM   - The name of a type 2 provider
	;            FBPRVNPI  - The NPI of a type 2 provider
	;            FBPRVTXY  - Taxonomy code of a type 2 provider (can be null)
	;            FBDUZ      - IEN of supervisor who validated batch the fee basis record is in
	;            FBARRAY  - an array of information about the fee basis record being processed
	;            FBCHECK - an array of information about NPIs which have already been dealt with
	;
	;  OUTPUT : FBCHECK is updated with information about any NPI which is not already represented
	;           FBOK - IEN of record added or -1 if problems occurred
	;
	N FBBADNPI,FBIBIEN2,FBNPIFLG,FBTXYFLG,FBNIEN,FBOK
	;
	S FBIBIEN2=""
	S FBBADNPI=0
	S FBOK=0
	S:$G(FBPRVNPI)="" FBPRVNPI=0
	I $G(FBCHECK(FBPRVNPI))'="" D
	.S FBIBIEN2=$P($G(FBCHECK(FBPRVNPI)),U,1)  ;a record we found or added tonight or NULL
	.S:$P($G(FBCHECK(FBPRVNPI)),U,2)'=1 FBNPIFLG=0   ;NO NPI UPDATES ATTEMPTED
	.S:$P($G(FBCHECK(FBPRVNPI)),U,2)=1 FBNPIFLG=1  ;NPI INVALID
	.S FBTXYFLG=0   ; NO TXY UPDATES ATTEMPTED
	I $G(FBCHECK(FBPRVNPI))="" D
	.I $L(FBPRVNPI)>10!($L(FBPRVNPI)<10)!('$$CHKDGT^XUSNPI(FBPRVNPI)) S FBBADNPI=1
	.I FBBADNPI S FBCHECK(FBPRVNPI)="^1^0"   ;INVALID NPI
	.I 'FBBADNPI S FBCHECK(FBPRVNPI)=$$FBTOIB("",FBPRVNAM,2,FBPRVNPI,FBPRVTXY,FBDUZ,.FBCHECK)
	.S FBIBIEN2=$P($G(FBCHECK(FBPRVNPI)),U,1)
	.S FBNPIFLG=$P($G(FBCHECK(FBPRVNPI)),U,2)
	.S FBTXYFLG=$P($G(FBCHECK(FBPRVNPI)),U,3)
	S FBNIEN=$$ADD5010(FBARRY("PROGRAM INTERNAL"),FBARRY("FBICN"),FBARRY("PATIENT INTERNAL"),FBARRY("PROCESS DATE INTERNAL"),FBARRY("LI NUMBER"))
	S:'+FBNIEN FBOK=-1
	S:FBOK'=-1 FBOK=$$UPDTONE(FBNIEN,FB5010TYP,FBIBIEN2,FBNPIFLG,FBTXYFLG,.FBARRY)  ;UPDATES FEE BASIS PAID WITH RESULTS FOR THIS PROVIDER
	Q FBOK
	;
GETFBDUZ(FBBTCH)	;returns an IEN from NEW PERSON file
	;INPUT FBBTCH : the internal number of the FEE BASIS BATCH that the invoice is part of
	;
	; OUTPUT : the IEN of the NEW PERSON file for SUPERVISOR WHO CERTIFIED this batch
	;
	N FBDUZ
	;
	S FBIENS=FBBTCH_","
	S FBDUZ=$$GET1^DIQ(161.7,FBBTCH_",",6,"I","","")   ;FEE BASIS BATCH FILE (#6) SUPERVISOR WHO CERTIFIED [7P:200]
	Q FBDUZ