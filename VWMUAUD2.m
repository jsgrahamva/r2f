VWMUAUD2	;KST;RPC Audit REPORT; 10/8/12
	;;0.1;VW WORLD VISTA;**1**;10/8/12;Build 8
	;
	;
	;"Kevin Toppenberg MD
	;"(C) 10/8/2012
	;"Released under: GNU General Public License (GPL)
	;
	;"=======================================================================
	;"PUBLIC FUNCTIONS
	;"=======================================================================
	;"AUDITRPT -- Menu structure for easy audit browsing.
	;
	;"=======================================================================
	;"PRIVATE FUNCTIONS
	;"=======================================================================
	;"GETDTS(SDATE,EDATE) -- Get date range.    
	;"GETALL(PARRAY,SDATE,EDATE) -- Gather list of ALL entries, in date range
	;"LIMIT(PARRAY,FILE,FIELD) -- Limit IEN list in PARRAY to selected matching values in given field.
	;"LMITPTRS(PARRAY,FILE,FIELD,P2FILE) -- Limit list to selected (pointers)
	;"LMITOTHR(PARRAY,FILE,FIELD) -- Limit list to selected (non-pointers)
	;"DOALIM(PARRAY,FILE,FIELD,SELECTED,MODE) -- limit IEN records in @PARRAY
	;"GETFLDVL(PARRAY,FILE,FIELD,OUT,MODE) -- extract list fild values for IEN list of PARRAY
	;"GETFIELD(FILE) -- Get user chosen field name
	;"PICKFLD(FILE,MODE,OUT) -- prompt user to pick field(s) from FILE
	;"REPORT(PARRAY) -- generate a report selected IEN listoutput to current device
	;"FMREPORT(PARRAY) -- Allow use of selected group of records, but output with Fileman
	;
	;"=======================================================================
	;"Dependancies :  TMGUSRI2, TMGUSRI3, TMGTERM, TMGMISC2, TMGDEBU3
	;
	;"=======================================================================
	;
AUDITRPT	;
	       ;"Purpose: Menu structure for easy audit browsing.
	       NEW MENU,MENU2,USRPICK,%ZIS,RPTPICK,USRIEN,PTIEN
	       NEW SDATE,EDATE,SDTSTR,EDTSTR,ARRAY,ARRAYCT
	       NEW FILE SET FILE=8994.81
	       WRITE !,"DISPLAY RPC AUDIT RECORDS",!
	       WRITE "==========================",!
DTS	    DO GETDTS(.SDATE,.EDATE)
	       IF (SDATE'>0)!(EDATE'>0) WRITE !,"INVALID DATES!",!,! GOTO PODN
	       SET SDTSTR=$$DTFORMAT^TMGMISC2(SDATE,"mm/dd/yy")
	       SET EDTSTR=$$DTFORMAT^TMGMISC2(EDATE,"mm/dd/yy")
ALL	    DO GETALL("ARRAY",SDATE,EDATE)
POM	    KILL MENU
	       WRITE "Counting..."
	       SET ARRAYCT=$$LISTCT^TMGMISC2("ARRAY")
	       IF ARRAYCT=0 DO  GOTO DTS:(ARRAYCT=0),PODN
	       . WRITE !,"NOTE: No records currently selected!",!
	       . NEW % SET %=1
	       . WRITE "Start over" DO YN^DICN WRITE !
	       . IF %'=1 SET ARRAYCT=-1
	       WRITE #
	       SET MENU(0)="Pick option to limit RPC audit records to show."
	       SET MENU(0,1)=ARRAYCT_" RPC audit records selected ("_SDTSTR_" - "_EDTSTR_")."
	       SET MENU(0,2)="Enter ? for help."
	       SET MENU(1)="Limit records to those by a chosen USER"_$CHAR(9)_"LIMIT;1"
	       SET MENU(2)="Limit records to those for chosen PATIENT"_$CHAR(9)_"LIMIT;100"
	       SET MENU(3)="Limit records to those with a chosen RPC"_$CHAR(9)_"LIMIT;.01"
	       SET MENU(4)="Limit records based on another field entry"_$CHAR(9)_"LIMIT;?"
	       SET MENU(5)="Start over with ALL records in date range"_$CHAR(9)_"GETALL"
	       SET MENU(6)="Change date range"_$CHAR(9)_"DATES"
	       SET MENU(7)="Show "_ARRAYCT_" records"_$CHAR(9)_"REPORT"
	       ;"SET MENU(8)="Show "_ARRAYCT_" records via Fileman"_$CHAR(9)_"FMREPORT"
	       WRITE !
	       SET USRPICK=$$MENU^TMGUSRI2(.MENU)
	       IF USRPICK="^" SET USRPICK=""
	       IF USRPICK="" GOTO PODN
	       IF "??"[USRPICK DO  GOTO POM
	       . DO HELP("MAIN",USRPICK)
	       IF USRPICK="GETALL" GOTO ALL
	       SET (USRIEN,PTIEN)="*"
	       IF USRPICK["LIMIT" DO  GOTO POM
	       . NEW FIELD SET FIELD=$PIECE(USRPICK,";",2)
	       . IF FIELD="?" DO  QUIT:(+FIELD'>0)
	       . . NEW DONE SET DONE=0
	       . . FOR  QUIT:(+FIELD>0)!DONE  DO
	       . . . SET FIELD=$$GETFIELD(FILE)
	       . . . IF +FIELD>0 QUIT
	       . . . NEW % SET %=2
	       . . . WRITE "Field not chosen for limiting RPC records."
	       . . . WRITE "Try again" DO YN^DICN WRITE !
	       . . . SET DONE=(%'=1)
	       . DO LIMIT("ARRAY",FILE,FIELD)
	       IF USRPICK="FMREPORT" DO  GOTO POM
	       . DO FMREPORT("ARRAY")  ;"//<-- Dave Whitten may finish this later
	       IF USRPICK="REPORT" DO  GOTO POM
	       . DO REPORT("ARRAY")
	       IF USRPICK="DATES" GOTO DTS
	       GOTO POM
PODN	   QUIT
	       ;
GETDTS(SDATE,EDATE)	;"Get custom date range.    
	       NEW %DT,X,Y
	       SET (SDATE,EDATE)=0
	       SET %DT="AET"
	       SET %DT("A")="Date range START DATE: "
	       DO ^%DT
	       SET SDATE=Y QUIT:(Y'>0)
	       SET %DT("A")="Date range END DATE: "
	       DO ^%DT
	       SET EDATE=Y
	       QUIT
	       ;
GETALL(PARRAY,SDATE,EDATE)	;
	       ;"Purpose: Gather list of ALL entries, in date range
	       KILL @PARRAY
	       NEW DT SET DT=SDATE-0.0001
	       FOR  SET DT=$ORDER(^XUSEC(8994,DT)) QUIT:(DT>EDATE)!(+DT'>0)  DO
	       . SET @PARRAY@(DT)=""
	       QUIT
	       ;
LIMIT(PARRAY,FILE,FIELD)	;
	       ;"Purpose: Limit IEN list in PARRAY to selected matching values in given field.
	       ;"Input:  PARRAY -- Pre-existing IEN array.  @PARRAY@(IEN)=""
	       ;"        FILE
	       ;"        FIELD
	       ;"Note: uses ARRAYCT by global scope
	       ;"Result: none
	       IF +$GET(FILE)'>0 GOTO LMTDN
	       IF +$GET(FIELD)'>0 GOTO LMTDN
	       NEW FLDNAME SET FLDNAME=$PIECE($GET(^DD(FILE,FIELD,0)),"^",1)
	       NEW INFO,SPEC
	       NEW P2FILE SET P2FILE=0
	       DO GFLDINFO^TMGDBAP3(FILE,FIELD,"INFO")
	       SET SPEC=$GET(INFO("SPECIFIER"))
	       IF SPEC["P" SET P2FILE=+$PIECE(SPEC,"P",2)
	       NEW MENU2,PICK2,IEN
	       SET MENU2(0)="Pick option to limit list by "_FLDNAME_"(s)"
	       SET MENU2(0,1)=ARRAYCT_" RPC audit records currently selected."
	       SET MENU2(0,2)="Enter ? for help."
	       SET MENU2(1)="Enter 1 "_FLDNAME_" name"_$CHAR(9)_"JUSTONE"
	       SET MENU2(2)="Select "_FLDNAME_" names from list"_$CHAR(9)_"PICK"
	       WRITE !
LM1	    SET PICK2=$$MENU^TMGUSRI2(.MENU2)
	       IF PICK2="^" SET PICK2=""
	       IF PICK2="" QUIT
	       IF PICK2["?" DO  GOTO LM1
	       . DO HELP("LIMIT^"_FLDNAME,PICK2)
	       IF P2FILE>0 DO  GOTO LMTDN
	       . IF PICK2="PICK" DO  QUIT
	       . . DO LMITPTRS("ARRAY",FILE,FIELD,P2FILE) ;"Limit list to selected
	       . ELSE  IF PICK2="JUSTONE" DO
	       . . NEW DIC,X,Y SET DIC=P2FILE,DIC(0)="MEAQ"
	       . . DO ^DIC WRITE !
	       . . SET IEN=+Y IF (IEN'>0) QUIT
	       . . NEW TEMP SET TEMP(IEN)=""
	       . . DO DOALIM(PARRAY,FILE,FIELD,.TEMP)
	       ELSE  DO  GOTO LMTDN
	       . IF PICK2="PICK" DO  QUIT
	       . . DO LMITOTHR(PARRAY,FILE,FIELD) ;"Limit list to selected
	       . ELSE  IF PICK2="JUSTONE" DO
	       . . NEW INPUT
	       . . WRITE "Specifiy value to match (exact) against field value.",!
	       . . READ "Enter value: ",INPUT:$GET(DTIME,3600),!
	       . . IF "^"[INPUT QUIT
	       . . NEW TEMP SET TEMP(INPUT)=""
	       . . DO DOALIM(PARRAY,FILE,FIELD,.TEMP,"E")
	       GOTO LM1
LMTDN	  QUIT
	       ;
LMITPTRS(PARRAY,FILE,FIELD,P2FILE)	;"Limit list to selected
	       ;"Note: Only valid for fields that are pointers to another file.
	       NEW PICKLIST,SELECTED
	       DO GETFLDVL(PARRAY,FILE,FIELD,.PICKLIST)
	       IF $DATA(PICKLIST)=0 GOTO LPDN
	       DO IENSELCT^TMGUSRI3("PICKLIST","SELECTED",P2FILE,".01",,"Pick entries to limit records. Type <ESC><ESC> when done.",".01")
	       IF $DATA(SELECTED)=0 KILL @PARRAY GOTO LPDN
	       DO DOALIM(PARRAY,FILE,FIELD,.SELECTED)
LPDN	   QUIT
	       ;
LMITOTHR(PARRAY,FILE,FIELD)	;"Limit list to selected
	       NEW PICKLIST,SELECTED
	       DO GETFLDVL(PARRAY,FILE,FIELD,.PICKLIST,"E")
	       IF $DATA(PICKLIST)=0 GOTO LODN
	       DO SELECTOR^TMGUSRI3("PICKLIST","SELECTED","Pick entries to limit records. Type <ESC><ESC> when done.")
	       IF $DATA(SELECTED)=0 KILL @PARRAY GOTO LODN
	       DO DOALIM(PARRAY,FILE,FIELD,.SELECTED,"E")
LODN	   QUIT
	       ;
DOALIM(PARRAY,FILE,FIELD,SELECTED,MODE)	;
	       ;"Purpose: limit IEN records in @PARRAY
	       ;"Input: PARRAY -- PASS BY NAME.  Array of IEN entries in FILE
	       ;"       FILE -- Fileman file # that IEN entries are from 
	       ;"       FIELD -- Field # from FILE
	       ;"       SELECTED -- PASS BY REFERENCE.  Array of INTERAL form of
	       ;"                      field values (from FIELD field).  All IEN 
	       ;"                     entries in PARRAY that don't have matching
	       ;"                    field value as found in SELECTED will be removed
	       ;"                   from PARRAY list.
	       ;"       MODE --OPTIONAL.  "I" for internal (DEFAULT) "E" for external
	       ;"Result: NONE
	       NEW TEMP
	       SET MODE=$GET(MODE,"I")
	       NEW IEN SET IEN=0
	       FOR  SET IEN=$ORDER(@PARRAY@(IEN)) QUIT:(+IEN'>0)  DO
	       . NEW ANENTRY SET ANENTRY=$$GET1^DIQ(FILE,IEN_",",FIELD,MODE)
	       . IF ANENTRY="" QUIT
	       . IF $DATA(SELECTED(ANENTRY))'>0 QUIT
	       . SET TEMP(IEN)=""
	       KILL @PARRAY
	       MERGE @PARRAY=TEMP
	       QUIT
	       ;
GETFLDVL(PARRAY,FILE,FIELD,OUT,MODE)	;
	       ;"Purpose: extract list fild values for IEN list of PARRAY
	       ;"Input: PARRAY  -- input IEN list.  Format @PARRAY@(IEN)=""
	       ;"       FILE -- fileman #
	       ;"       FIELD -- field # to extract
	       ;"       OUT -- PASS BY REFERENCE.  Format: OUT(<field value>)=""
	       ;"       MODE --OPTIONAL.  "I" for internal (DEFAULT) "E" for external
	       ;"Result: none
	       KILL @PARRAY@("USER")
	       SET MODE=$GET(MODE,"I")
	       NEW IEN SET IEN=0
	       FOR  SET IEN=$ORDER(@PARRAY@(IEN)) QUIT:(+IEN'>0)  DO
	       . NEW AVALUE SET AVALUE=$$GET1^DIQ(FILE,IEN_",",FIELD,MODE)
	       . IF AVALUE'="" SET OUT(AVALUE)=""
	       QUIT
	       ;
GETFIELD(FILE)	;
	       WRITE !,"Next, pick one field to use in limiting RPC audit records.",!
	       WRITE "Remember, pick just ONE field to use.",!
	       WRITE "Type ? in selector for help with selection process.",!
	       DO PRESS2GO^TMGUSRI2
	       NEW OUT
	       NEW RESULT SET RESULT="?"
	       NEW CT SET CT=$$PICKFLD(FILE,"1",.OUT)
	       IF CT'=1 GOTO GFDN
	       NEW NAME SET NAME=""
	       SET NAME=$ORDER(OUT(""))
	       SET RESULT=$GET(OUT(NAME))
	       IF RESULT="" SET RESULT="?"
GFDN	   QUIT RESULT
	       ;
PICKFLD(FILE,MODE,OUT)	;
	       ;"Purpose: prompt user to pick field(s) from FILE
	       ;"Input: FILE -- FM file to work on
	       ;"       MODE -- "1" for picking just 1 entry, or "*" for multiple
	       ;"       OUT -- PASS BY REFERENCE.  An OUT PARAMETER.  Format:
	       ;"          OUT(FLDNUM)=""
	       ;"Result: # of picks if OK, 0 if problem, or none picked
	       NEW ALLFIELDS
	       NEW CT SET CT=0
	       NEW FLD SET FLD=0
	       FOR  SET FLD=$ORDER(^DD(FILE,FLD)) QUIT:(+FLD'>0)  DO
	       . NEW NAME SET NAME=$PIECE($GET(^DD(FILE,FLD,0)),"^",1)
	       . SET ALLFIELDS(NAME)=FLD
	       IF $DATA(ALLFIELDS)=0 GOTO PKFDN
	       NEW HEADER
	       IF MODE="*" SET HEADER="Pick Desired Field(s)."
	       ELSE  SET HEADER="Pick JUST ONE field."
	       SET HEADER=HEADER_" When done, press [ESC][ESC] to exit."
PF1	    DO SELECTOR^TMGUSRI3("ALLFIELDS","OUT",HEADER)
	       SET CT=$$LISTCT^TMGMISC2("OUT")
	       IF CT=0 GOTO PKFDN
	       IF (CT>1)&(MODE=1) DO  GOTO:(CT=-1) PF1  GOTO PKFDN
	       . WRITE !,!,"THERE IS A PROBLEM.",!
	       . WRITE "You picked "_CT_" fields, but only ONE(1) allowed.",!,!
	       . ;NEW % SET %=1
	       . ;WRITE "Try Again" DO YN^DICN WRITE !
	       . ;IF %=1 SET CT=-1 QUIT
	       . SET CT=0
PKFDN	  QUIT CT
	       ;
HELP(MODE,USERINPUT)	;
	       ;"Purpose: generate help for menu system
	       ;"Input: MODE -- either "MAIN" for main menu, or "LIMIT^<field name>" for limiting by field
	       ;"       USERINPUT -- the actual user input
	       ;"Result: none
	       WRITE !
	IF MODE="MAIN" DO
	       . IF USERINPUT["??" DO
	       . . WRITE !,"RPC audit log records can easily run into the thousands each day.",!
	       . . WRITE "Thus, it is necessary to limit the group of those entries to be shown.",!
	       . . WRITE "The menu header will show the number of currently selected records.",!
	       . . WRITE "Enter the menu option number to select how to limit the list.  Specific",!
	       . . WRITE "options were provided to limit the group to a chosen user, patient, or",!
	       . . WRITE "RPC name.  But one may also limit based on any other field in the audit",!
	       . . WRITE "file.  Additional help is available from that menu.",!
	       . ELSE  DO
	       . . WRITE !,"Choose method to limit the number of selected RPC audit records.",!
	       . . WRITE "When the number has been sufficiently narrowed, choose option to",!
	       . . WRITE "show them.  This may be sent to the screen or a printer.",!
	       . . WRITE "From the menu, enter ?? for additional help",!
	       ELSE  IF MODE["LIMIT^" DO
	       . NEW FLDNAME SET FLDNAME=$PIECE(MODE,"^",2)
	       . IF USERINPUT["??" DO
	       . . WRITE "Additional help in using the scrolling selector may be obtained",!
	       . . WRITE "after choosing to 'Select "_FLDNAME_"'.  Type ? for help there.",!
	       . ELSE  DO
	       . . WRITE "To limit RPC audit records by ",FLDNAME,", either choose to enter 1",!
	       . . WRITE "specific ",FLDNAME," value to limit by.  Only records that do have",!
	       . . WRITE "a matching value will remain in list of selected audit records.",!,!
	       . . WRITE "Or, choose to select "_FLDNAME_" entries from a list.  All names found",!
	       . . WRITE "in currently selected list will be collated and shown.  One may pick",!
	       . . WRITE "one or more values.  All audit records that do not contain a value",!
	       . . WRITE "matching the value(s) chosen will be removed from the selected list.",!
	       . . WRITE "From the menu, enter ?? for additional help",!
	       ELSE  WRITE !,"Please enter ? for help",!
	       DO PRESS2GO^TMGUSRI2
	       QUIT
	       ;
REPORT(PARRAY)	 ;        
	       ;"Purpose: generate a report selected IEN listoutput to current device
	       ;"Input: PARRAY -- PASS BY NAME.  Format @PARRAY@(<IEN_8994.81>)=""
	       NEW FIELDS
	       NEW % SET %=2
	       WRITE "Pick which fields to show" DO YN^DICN WRITE !
	       IF %=-1 GOTO RPTDN
	       IF %=1 DO
	       . NEW CT SET CT=$$PICKFLD(FILE,"*",.FIELDS) ;
	       . IF CT=0 KILL FIELDS
	       NEW %ZIS
	       SET %ZIS("A")="Enter Output Device: "
	       SET %ZIS("B")="HOME"
	       DO ^%ZIS  ;"standard device call
	       IF POP GOTO RPTDN
	       USE IO
	       NEW IEN SET IEN=""
	       FOR  SET IEN=$ORDER(@PARRAY@(IEN)) QUIT:(+IEN'>0)  DO
	       . WRITE "-------------------------------",!
	       . DO DUMPREC^TMGDEBU3(8994.81,IEN_",",0,.FIELDS)
	       . WRITE !
	       DO ^%ZISC  ;" Close the output device 
	       DO PRESS2GO^TMGUSRI2
RPTDN	  QUIT
	       ;
FMREPORT(PARRAY)	;
	       ;"Purpose: Allow use of selected group of records, but outptu with Fileman
	       ;"Input: PARRAY -- PASS BY NAME.  Format: @PARRAY@(<IEN_8994.835>)=""
	       ;"Result: NONE
	       ;
	       ;"Dave Whitten may consider finishing this at some point.
	       ;
	       QUIT
