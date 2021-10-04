LRJSML3	;ALB/GTS - Lab Vista Hospital Location Utilities - 2;02/17/2010 09:42:19
	;;5.2;LAB SERVICE;**425**;Sep 27, 1994;Build 30
	;
	;
SETNPARM(LRVALST,LRPARAM)	;Set New Params
	S LRPARAM("LRRM")=$P(LRVALST,"^",2)
	S LRPARAM("LROBED")=$P(LRVALST,"^",3)
	S LRPARAM("LRHD")=$P(LRVALST,"^",4)
	S LRPARAM("LRFSTLNE")=$P(LRVALST,"^",5)
	S LRPARAM("LRINIT")=$P(LRVALST,"^",6)
	QUIT
	;
SETEPARM(LRVALST,LRPARAM)	;Set Edited Params
	S LRPARAM("LRCRM")=$P(LRVALST,"^",2)
	S LRPARAM("LRCBED")=$P(LRVALST,"^",3)
	S LRPARAM("LRPRM")=$P(LRVALST,"^",5)
	S LRPARAM("LRPBED")=$P(LRVALST,"^",6)
	S LRPARAM("LRFSTLNE")=$P(LRVALST,"^",7)
	S LRPARAM("LRINIT")=$P(LRVALST,"^",8)
	QUIT
	;
MMDISPN(VALMCNT,LRPARAM,LROUTPT,LRMMARY)	;Break into 79/80 char chunks for Cur Val display
	; VALMCNT - Cur output array line number
	; LRPARAM - Array with parameters passed
	; LROUTPT - "DISPLAY" : Listman; "MAIL" : Mail Message
	; LRMMARY - Mail message output array (Optional)
	; 
	;Array params sent & received (LRPARAM)
	; XN      - NEW HL extract data
	;  LEGEND: 
	;   NEW^LOCATION^IEN^Hosp Loc Name^Type^Inst^Div^Inactivation Date
	;                                            ^Reactivation Date^Accessed by^Chng Date/Time
	;                                          
	;   NEW^ROOM^Hosp Loc Name^Type^Inst^Div^Room
	;   NEW^BED^Hosp Loc Name^Type^Inst^Div^Room^Bed
	; LRLOC   - Cur Hosp Loc header Info
	; LRRM    - Cur Hosp Loc Room Info
	; LROBED  - Cur Hosp Loc Bed Info
	; LRHD    - Header (Location or Room) to display
	; LRFSTLNE- Value 1 = 1st line printed, 0 = 1st line hasn't printed
	; LRINIT  - Init extract or Change extract (1: Initialization; 0: Change)
	;
	N LRIEN,LRDTTYP,LRVALST,LRINIT
	N LRXN,LRLOC,LRRM,LROBED,LRHD,LRFSTLNE
	N LRLOCVAR,LRSUB,LPCNT,LRROOT
	;
	S:$G(LRMMARY)="" LRMMARY=""
	S:$G(LROUTPT)="" LROUTPT="DISPLAY"
	;
	;Put Array params in local vars
	S LRXN=LRPARAM("XN")
	;
	S LRLOCVAR="LRLOC^LRRM^LROBED^LRHD^LRFSTLNE^LRINIT"
	S LRROOT="LRPARAM"
	F LPCNT=1:1 S LRSUB=$P(LRLOCVAR,"^",LPCNT) Q:LRSUB=""  S @LRSUB=@LRROOT@(LRSUB)
	;
	S LRDTTYP=$P(LRXN,"^",2) ;Type of data node (LOCATION, ROOM or BED)
	I LRDTTYP="LOCATION" DO
	.I LRLOC'="" DO
	..D LRNEWOUT(.VALMCNT,.LRPARAM,LROUTPT,LRMMARY)
	..;
	..;Set Array params
	..S LRRM=LRPARAM("LRRM")
	..S LROBED=LRPARAM("LROBED")
	..S LRHD=LRPARAM("LRHD")
	..S LRPARAM("LRFSTLNE")=LRFSTLNE
	.S:'LRINIT LRHD="CHANGE DETAIL (NEW)"
	.S:LRINIT LRHD="CURRENT DEFINITION"
	.S LRLOC="^^"_$P(LRXN,"^",3,11)
	;
	I LRDTTYP="ROOM" DO
	.I LRRM'="" DO
	..;
	..;Reset Array params
	..S LRPARAM("LRFSTLNE")=LRFSTLNE
	..D LRNEWOUT(.VALMCNT,.LRPARAM,LROUTPT,LRMMARY)
	..;
	..;Set Array params
	..S LRRM=LRPARAM("LRRM")
	..S LROBED=LRPARAM("LROBED")
	..S LRHD=LRPARAM("LRHD")
	..S LRFSTLNE=LRPARAM("LRFSTLNE")
	.S:'LRINIT LRHD="CHANGE DETAIL (NEW)"
	.S:LRINIT LRHD="CURRENT DEFINITION"
	.S LRRM=$P(LRXN,"^",8)
	;
	I LRDTTYP="BED"  S:LROBED'="" LROBED=LROBED_" ; "_$P(LRXN,"^",9) S:LROBED="" LROBED=$P(LRXN,"^",9)
	;
	;Reset Array params
	S LRPARAM("LRLOC")=LRLOC
	S LRVALST="^"_LRRM_"^"_LROBED_"^"_LRHD_"^"_LRFSTLNE_"^"_LRINIT
	D SETNPARM(LRVALST,.LRPARAM)
	Q
	;
LRNEWOUT(VALMCNT,LRPARAM,LROUTPT,LRMMARY)	;Output New location
	;INPUT PARAMS:
	; VALMCNT - Cur Line number of output array
	; LRPARAM - Array with params passed
	; LROUTPT  - "DISPLAY" : Listman; "MAIL" : Mail message
	; LRMMARY - Mail message output array (Optional)
	; 
	;Array params sent & received (LRPARAM)
	; LRLOC   - Cur Hosp Loc Info
	; LRRM    - Cur Hosp Loc Room Info
	; LROBED  - Cur Hosp Loc Bed Info
	; LRHD    - Header Info
	; LRFSTLNE- Value 1 = 1st line printed, 0 = 1st line hasn't printed
	; LRINIT  - Init extract or Change extract (1: Initialization; 0: Change)
	;
	N LRLOCVAR,LRROOT,LPCNT,LRSUB
	N LAX,LRIEN,LRNNAME,LRTYPE,LRINST,LRDIV,LRINACT,LRREACT,LRUSR,LRDTCG
	N LRLOC,LRRM,LROBED,LRHD,LRFSTLNE,LRVALST,LRINIT
	;
	;Put Array params in local vars
	S LRLOCVAR="LRLOC^LRRM^LROBED^LRHD^LRFSTLNE^LRINIT"
	S LRROOT="LRPARAM"
	F LPCNT=1:1 S LRSUB=$P(LRLOCVAR,"^",LPCNT) Q:LRSUB=""  S @LRSUB=@LRROOT@(LRSUB)
	;
	;Set variables passed in LRPARAM("LRLOC")
	S LRIEN=$P(LRLOC,"^",3)
	S LRNNAME=$P(LRLOC,"^",4)
	S LRTYPE=$P(LRLOC,"^",5)
	S LRINST=$P(LRLOC,"^",6)
	S LRDIV=$P(LRLOC,"^",7)
	S LRINACT=$P(LRLOC,"^",8)
	S LRREACT=$P(LRLOC,"^",9)
	S LRUSR=$P(LRLOC,"^",10)
	S LRDTCG=$P(LRLOC,"^",11)
	;
	D:+LRFSTLNE>0 LRADDNOD(.VALMCNT," ","",LROUTPT,LRMMARY)
	D:LROUTPT="MAIL" LRADDNOD(.VALMCNT," ","",LROUTPT,LRMMARY)
	D LRADDNOD(.VALMCNT,"       "_LRHD,"",LROUTPT,LRMMARY)
	IF LROUTPT="DISPLAY" DO
	.DO CNTRL^VALM10(VALMCNT,8,$LENGTH(LRHD),IOUON,IOUOFF_IOINORM)
	;
	;Output Location info
	S LAX="  IEN: "_LRIEN
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,3,4,IOINHI,IOINORM)
	S LAX=" NAME: "_LRNNAME
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,5,IOINHI,IOINORM)
	S LAX=" TYPE: "_LRTYPE
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,5,IOINHI,IOINORM)
	S LAX=" INST: "_LRINST
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,5,IOINHI,IOINORM)
	S LAX="  DIV: "_LRDIV
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,3,4,IOINHI,IOINORM)
	S LAX="INACT: "_$$FMTE^XLFDT(LRINACT)
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,1,6,IOINHI,IOINORM)
	S LAX="  ACT: "_$$FMTE^XLFDT(LRREACT)
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,3,4,IOINHI,IOINORM)
	;
	;Output edit info
	S:LRINIT LAX=" "
	S:'LRINIT LAX="          CHANGED BY: "_LRUSR
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	IF LROUTPT="DISPLAY",'LRINIT D CNTRL^VALM10(VALMCNT,10,11,IOINHI,IOINORM)
	IF 'LRINIT DO
	.S LAX=" DATE/TIME OF CHANGE: "_$$FMTE^XLFDT(LRDTCG)
	.D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	.D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,20,IOINHI,IOINORM)
	;
	;Output Room/Bed info
	D LRADDNOD(.VALMCNT," ","",LROUTPT,LRMMARY)
	S LAX=" ROOM: "_LRRM
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,5,IOINHI,IOINORM)
	S LAX=" BEDS: "_LROBED
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,5,IOINHI,IOINORM)
	D:LROUTPT="MAIL" LRADDNOD(.VALMCNT," ","",LROUTPT,LRMMARY)
	;
	IF LRINIT DO LRADDNOD(.VALMCNT," ","",LROUTPT,LRMMARY)
	;
	S (LRRM,LROBED,LRHD)=""
	S LRFSTLNE=1
	;
	;Reset Param array
	S LRVALST="^"_LRRM_"^"_LROBED_"^"_LRHD_"^"_LRFSTLNE_"^"_LRINIT
	D SETNPARM(LRVALST,.LRPARAM)
	S LRPARAM("LRLOC")=LRLOC
	Q
	;
MMDISPC(VALMCNT,LRPARAM,LROUTPT,LRMMARY)	;Break into 79/80 char chunks for Cur Val display
	;
	;Input params
	; VALMCNT - Cur Line number of output array
	; LRPARAM - Array with parameters passed
	; LROUTPT - "DISPLAY" : Listman; "MAIL" : Mail Message
	; LRMMARY - Mail message output array (Optional)
	; 
	;Array params sent & received (LRPARAM)
	; XN      - CURRENT HL extract data
	;  LEGEND: 
	;   CURRENT^LOCATION^IEN^Hosp Loc Name^Type^Inst^Div^Inactivation Date
	;                                            ^Reactivation Date^Accessed by^Chng Date/Time
	;                                          
	;   CURRENT^ROOM^Hosp Loc Name^Type^Inst^Div^Room
	;   CURRENT^BED^Hosp Loc Name^Type^Inst^Div^Room^Bed
	;
	; XP      - PREVIOUS HL extract data
	;  LEGEND: 
	;   PREVIOUS^LOCATION^IEN^Hosp Loc Name^Type^Inst^Div^Inactivation Date
	;                                            ^Reactivation Date^Accessed by^Chng Date/Time
	;                                          
	;   PREVIOUS^ROOM^Hosp Loc Name^Type^Inst^Div^Room
	;   PREVIOUS^BED^Hosp Loc Name^Type^Inst^Div^Room^Bed
	;
	; LRCLOC  - Cur Hosp Loc info
	; LRCRM   - Cur Hosp Loc Room info
	; LRCBED  - Cur Hosp Loc Bed info
	; LRPLOC  - Prev Hosp Loc info
	; LRPRM   - Prev Hosp Loc Room info
	; LRPBED  - Prev Hosp Loc Bed info
	; LRFSTLNE- Value 1 = 1st line printed, 0 = 1st line hasn't printed
	; LRNEWLOC- Value 1 = the location not printed
	; LRINIT  - Init extract or Change extract (1: Initialization; 0: Change)
	;
	;
	N LRDTTYP,LRVALST,LRNEWLOC,LRINIT
	N LRXC,LRXP,LRCLOC,LRCRM,LRCBED,LRPLOC,LRPRM,LRPBED,LRFSTLNE,LRCHGARY
	N LRLOCVAR,LRSUB,LPCNT,LRROOT
	;
	S:$G(LRMMARY)="" LRMMARY=""
	S:$G(LROUTPT)="" LROUTPT="DISPLAY"
	;
	;Put Array params in local vars
	S LRXC=LRPARAM("XN")
	S LRXP=LRPARAM("XP")
	;
	S LRLOCVAR="LRCLOC^LRCRM^LRCBED^LRPLOC^LRPRM^LRPBED^LRFSTLNE^LRNEWLOC^LRINIT"
	S LRROOT="LRPARAM"
	F LPCNT=1:1 S LRSUB=$P(LRLOCVAR,"^",LPCNT) Q:LRSUB=""  S @LRSUB=@LRROOT@(LRSUB)
	;
	S LRDTTYP=$P(LRXC,"^",2) ;Data node type (LOCATION, ROOM or BED)
	;
	I LRDTTYP="LOCATION" DO
	.I LRCLOC'="" DO
	..;
	..;Set array & Print
	..S LRVALST="^"_LRCRM_"^"_LRCBED_"^^"_LRPRM_"^"_LRPBED_"^"_LRFSTLNE_"^"_LRINIT
	..D SETEPARM(LRVALST,.LRCHGARY)
	..S LRCHGARY("LRNEWLOC")=LRNEWLOC
	..S LRCHGARY("LRCLOC")=LRCLOC
	..S LRCHGARY("LRPLOC")=LRPLOC
	..;
	..D LRLOUT(.VALMCNT,.LRCHGARY,LROUTPT,.LRPARAM,.LRVALST,LRMMARY)
	..;
	..;Put Array params (LRCHGARY) in local vars
	..S LRLOCVAR="LRCLOC^LRCRM^LRCBED^LRPLOC^LRPRM^LRPBED^LRFSTLNE"
	..S LRROOT="LRCHGARY"
	..F LPCNT=1:1 S LRSUB=$P(LRLOCVAR,"^",LPCNT) Q:LRSUB=""  S @LRSUB=@LRROOT@(LRSUB)
	.;
	.S LRNEWLOC=1
	.S (LRCRM,LRCBED,LRPRM,LRPBED)=""
	;
	;If Room node exists, next node is Bed
	I LRDTTYP="ROOM" DO
	.I LRCBED="" DO
	..S LRCRM=$P(LRXC,"^",8)
	..S LRPRM=$P(LRXP,"^",8)
	;
	;ROOM/BED info output on BED node
	I LRDTTYP="BED" DO
	.S LRCRM=$P(LRXC,"^",8)
	.S LRPRM=$P(LRXP,"^",8)
	.S LRCBED=$P(LRXC,"^",9)
	.S LRPBED=$P(LRXP,"^",9)
	.;
	.;Set array & Print
	.S LRVALST="^"_LRCRM_"^"_LRCBED_"^^"_LRPRM_"^"_LRPBED_"^"_LRFSTLNE_"^"_LRINIT
	.D SETEPARM(LRVALST,.LRCHGARY)
	.S LRCHGARY("LRNEWLOC")=LRNEWLOC
	.S LRCHGARY("LRCLOC")=LRCLOC
	.S LRCHGARY("LRPLOC")=LRPLOC
	.;
	.D LRRBOUT(.VALMCNT,.LRCHGARY,LROUTPT,.LRPARAM,.LRVALST,LRMMARY)
	.;
	.;Put Array params (LRCHGARY) in local vars
	.S LRLOCVAR="LRCLOC^LRCRM^LRCBED^LRPLOC^LRPRM^LRPBED^LRFSTLNE"
	.S LRROOT="LRCHGARY"
	.F LPCNT=1:1 S LRSUB=$P(LRLOCVAR,"^",LPCNT) Q:LRSUB=""  S @LRSUB=@LRROOT@(LRSUB)
	;
	;Reset Array param
	S LRVALST="^"_LRCRM_"^"_LRCBED_"^^"_LRPRM_"^"_LRPBED_"^"_LRFSTLNE_"^"_LRINIT
	D SETEPARM(LRVALST,.LRPARAM)
	S LRPARAM("LRCLOC")=LRCLOC
	S LRPARAM("LRPLOC")=LRPLOC
	S LRPARAM("LRNEWLOC")=LRNEWLOC
	Q
	;
LRLOUT(VALMCNT,LRCHGARY,LROUTPT,LRPARAM,LRVALST,LRMMARY)	; Output Loc
	;INPUT:
	; VALMCNT - Cur Line number of output array
	; LRCHGARY- Array of param passed by ref
	; LROUTPT - "DISPLAY" : Listman; "MAIL" : Mail message
	; LRPARAM - Array with parameters passed
	; LRVALST - Carat delimited list of location data
	; LRMMARY - Mail message output array (Optional)
	;
	;Array Parameters sent and received (LRCHGARY)
	; LRCLOC  - CURRENT HL extract data
	; LRPLOC  - PREVIOUS Hosp Loc Data
	;  LEGEND (LRCLOC & LRPLOC): 
	;   ^^IEN^Hosp Loc Name^Type^Inst^Div^Inactivation Date
	;                                     ^Reactivation Date^Accessed by^Chng Date/Time
	;
	; LRCRM   - Cur Hosp Loc Room Info
	; LRCBED  - Cur Hosp Loc Bed Info                                        
	; LRPRM   - Prev Hosp Loc Room Info
	; LRPBED  - Prev Hosp Loc Bed Info
	; LRFSTLNE- Value 1 - 1st line printed, 0 - 1st line hasn't printed
	; LRNEWLOC- Value 1 = the location has not been printed
	; LRINIT  - Init extract ; Change extract (1: Init; 0: Change)
	;
	N LAX,C,LRIEN,LRNNAME,LRTYPE,LRINST,LRDIV,LRINACT
	N LRONAME,LROTYPE,LROINST,LRODIV,LROINACT,LROREACT,LRODTOUT,LRNEWLOC
	N LRCLOC,LRCRM,LRCBED,LRPLOC,LRPRM,LRPBED,LRFSTLNE,LRDTCG,LRUSR,LRINIT,LRREACT
	N LRLOCVAR,LRSUB,LPCNT,LRROOT
	;
	;Put Array params (LRCHGARY) in local vars
	S LRLOCVAR="LRCLOC^LRCRM^LRCBED^LRPLOC^LRPRM^LRPBED^LRFSTLNE^LRNEWLOC^LRINIT"
	S LRROOT="LRCHGARY"
	F LPCNT=1:1 S LRSUB=$P(LRLOCVAR,"^",LPCNT) Q:LRSUB=""  S @LRSUB=@LRROOT@(LRSUB)
	;
	S C="" ;-- Continue char
	D:+LRFSTLNE>0 LRADDNOD(.VALMCNT," ","",LROUTPT,LRMMARY)
	D:LROUTPT="MAIL" LRADDNOD(.VALMCNT," ","",LROUTPT,LRMMARY)
	D LRADDNOD(.VALMCNT,"       CHANGE DETAIL (CURRENT)               CHANGE DETAIL (PREVIOUS)","",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,8,$LENGTH("CHANGE DETAIL (CURRENT)"),IOUON,IOUOFF_IOINORM)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,46,$LENGTH("CHANGE DETAIL (PREVIOUS)"),IOUON,IOUOFF_IOINORM)
	;
	;Set new Current values passed in LRCHGARY("LRCLOC")
	S LRIEN=$P(LRCLOC,"^",3)
	S LRNNAME=$P(LRCLOC,"^",4)
	S LRTYPE=$P(LRCLOC,"^",5)
	S LRINST=$P(LRCLOC,"^",6)
	S LRDIV=$P(LRCLOC,"^",7)
	S LRINACT=$P(LRCLOC,"^",8)
	S LRREACT=$P(LRCLOC,"^",9)
	S LRUSR=$P(LRCLOC,"^",10)
	S LRDTCG=$P(LRCLOC,"^",11)
	;
	;Set Previous values passed in LRCHGARY("LRPLOC")
	S LRONAME=$P(LRPLOC,"^",4)
	S LROTYPE=$P(LRPLOC,"^",5)
	S LROINST=$P(LRPLOC,"^",6)
	S LRODIV=$P(LRPLOC,"^",7)
	S LROINACT=$P(LRPLOC,"^",8)
	S LROREACT=$P(LRPLOC,"^",9)
	;
	S LAX="  IEN: "_LRIEN
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,3,4,IOINHI,IOINORM)
	;
	S LAX=" NAME: "_LRNNAME
	D LRADDNOD(.VALMCNT,LAX,LRONAME,LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,5,IOINHI,IOINORM)
	;
	S LAX=" TYPE: "_LRTYPE
	D LRADDNOD(.VALMCNT,LAX,LROTYPE,LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,5,IOINHI,IOINORM)
	;
	S LAX=" INST: "_LRINST
	D LRADDNOD(.VALMCNT,LAX,LROINST,LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,5,IOINHI,IOINORM)
	;
	S LAX="  DIV: "_LRDIV
	D LRADDNOD(.VALMCNT,LAX,LRODIV,LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,3,5,IOINHI,IOINORM)
	;
	S LAX="INACT: "_$$FMTE^XLFDT(LRINACT)
	S LRODTOUT=$$FMTE^XLFDT(LROINACT)
	D LRADDNOD(.VALMCNT,LAX,LRODTOUT,LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,1,6,IOINHI,IOINORM)
	;
	S LAX="  ACT: "_$$FMTE^XLFDT(LRREACT)
	S LRODTOUT=$$FMTE^XLFDT(LROREACT)
	D LRADDNOD(.VALMCNT,LAX,LRODTOUT,LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,1,6,IOINHI,IOINORM)
	;
	;Output edit info
	S:LRINIT LAX=" "
	S:'LRINIT LAX="          CHANGED BY: "_LRUSR
	D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,10,11,IOINHI,IOINORM)
	;
	IF 'LRINIT DO
	.S LAX=" DATE/TIME OF CHANGE: "_$$FMTE^XLFDT(LRDTCG)
	.D LRADDNOD(.VALMCNT,LAX,"",LROUTPT,LRMMARY)
	.D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,20,IOINHI,IOINORM)
	;
	D LRADDNOD(.VALMCNT,"","",LROUTPT,LRMMARY)
	S LRNEWLOC=0
	;
	;Reset Parameter Array
	S LRVALST="^"_LRCRM_"^"_LRCBED_"^^"_LRPRM_"^"_LRPBED_"^"_LRFSTLNE_"^"_LRINIT
	D SETEPARM(LRVALST,.LRPARAM)
	S LRPARAM("LRCLOC")=LRCLOC
	S LRPARAM("LRPLOC")=LRPLOC
	Q
	;
LRRBOUT(VALMCNT,LRCHGARY,LROUTPT,LRPARAM,LRVALST,LRMMARY)	;Output Room/Bed
	;INPUT:
	; VALMCNT - Cur Line number of output array
	; LRCHGARY- Array of parameters passed by reference
	; LROUTPT - "DISPLAY" : Listman; "MAIL" : Mail Message
	; LRPARAM - Array with parameters passed
	; LRVALST - Carat delimited list of location data
	; LRMMARY - Mail message output array (Optional)
	;
	;Array Params (LRCHGARY) sent and received
	; LRCLOC  - CURRENT HL extract data
	; LRPLOC  - PREVIOUS Hosp Loc data
	;  LEGEND (LRCLOC & LRPLOC): 
	;   ^^IEN^Hosp Loc Name^Type^Inst^Div^Inactivation Date
	;                                     ^Reactivation Date^Accessed by^Chng Date/Time
	;
	; LRCRM   - Cur Hosp Loc Room Info
	; LRCBED  - Cur Hosp Loc Bed Info
	; LRPRM   - Prev Hosp Loc Room Info
	; LRPBED  - Prev Hosp Loc Bed Info
	; LRFSTLNE- Value 1 = 1st line printed, 0 = 1st line hasn't printed
	; LRNEWLOC- Value 1 = the location has not been printed
	; LRINIT  - Init extract or Change extract (1: Initialization; 0: Change)
	;
	N LAX,C,LRNEWLOC,LRINIT
	N LRCLOC,LRCRM,LRCBED,LRPLOC,LRPRM,LRPBED,LRFSTLNE
	N LRLOCVAR,LRSUB,LPCNT,LRROOT
	;
	;Put Array params (LRCHGARY) in local vars
	S LRLOCVAR="LRCLOC^LRCRM^LRCBED^LRPLOC^LRPRM^LRPBED^LRFSTLNE^LRNEWLOC^LRINIT"
	S LRROOT="LRCHGARY"
	F LPCNT=1:1 S LRSUB=$P(LRLOCVAR,"^",LPCNT) Q:LRSUB=""  S @LRSUB=@LRROOT@(LRSUB)
	;
	S C="" ;-- Continue char
	;Output Room/Bed changes
	S LAX=" ROOM: "_LRCRM
	D LRADDNOD(.VALMCNT,LAX,LRPRM,LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,5,IOINHI,IOINORM)
	;
	S LAX=" BEDS: "_LRCBED
	D LRADDNOD(.VALMCNT,LAX,LRPBED,LROUTPT,LRMMARY)
	D:LROUTPT="DISPLAY" CNTRL^VALM10(VALMCNT,2,5,IOINHI,IOINORM)
	D:LROUTPT="MAIL" LRADDNOD(.VALMCNT," ","",LROUTPT,LRMMARY)
	;
	I LRINIT D LRADDNOD(.VALMCNT," ","",LROUTPT,LRMMARY)
	;
	;Reset Parameter Array
	S (LRCBED,LRPBED)=""
	S LRFSTLNE=1
	;
	S LRVALST="^"_LRCRM_"^"_LRCBED_"^^"_LRPRM_"^"_LRPBED_"^"_LRFSTLNE_"^"_LRINIT
	D SETEPARM(LRVALST,.LRPARAM)
	S LRPARAM("LRCLOC")=LRCLOC
	S LRPARAM("LRPLOC")=LRPLOC
	Q
	;
LRADDNOD(LRNODECT,LRCUR,LRPREV,LROUTPT,LRMMARY)	;Include Prev value in string, add to mail array
	; INPUT:
	;   LRNODECT - Node number
	;   LRCUR    - Cur entry display
	;   LRPREV   - Prev entry display
	;   LROUTPT  - Type of array to populate (Display or Mail)
	;   LRMMARY  - Array of output for Mail messages
	;   
	; OUTPUT:
	;   Display array
	; 
	N LRLGTH
	S:$G(LRPREV)="" LRPREV=""
	S:$G(LROUTPT)="" LROUTPT="DISPLAY"
	S:$G(LRMMARY)="" LRMMARY=""
	S LRLGTH=$L(LRCUR)
	S LRCUR=LRCUR_$J(LRPREV,3+$L(LRPREV)+(42-LRLGTH))
	D:LROUTPT="DISPLAY" ADD^LRJSMLU(.LRNODECT,LRCUR)
	D:LROUTPT="MAIL" LRADDLNE(.LRNODECT,LRCUR,LRMMARY)
	Q
	;
LRADDLNE(LRNODECT,MSG,LRMMARY)	; -- add line to build display
	;INPUT:
	;  LRNODECT - Node number
	;  MSG      - Text to mail
	;  LRMMARY  - Array for MailMan call
	;
	;OUTPUT:
	;  Array for Mail message
	;  
	S LRNODECT=LRNODECT+1
	S @LRMMARY@(LRNODECT)=MSG
	Q
