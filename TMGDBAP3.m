TMGDBAP3	;TMG/kst/SACC-compliant DB APT utilities ;10/12/12
	        ;;1.0;TMG-LIB;**1,17**;07/12/05;Build 8
	;
	;"TMG DB API UTILITIES
	;"SACC compliant versions of TMGDEBUG
	;"Kevin Toppenberg MD
	;"GNU General Public License (GPL) applies
	;"10/12/12
	;
	;"NOTE: This will contain SACC-compliant versions of code from TMGDBAPI
	;"      If routine is not found here, the please migrate and update the
	;"      code to be compliant.
	;"=======================================================================
	;" API -- Public Functions.
	;"=======================================================================
	;"ASKFIENS() --Ask user to pick a file number, then pick a record
	;"ASKIENS(FILENUM,IENS) -- ask user to select a record in File indicated by FILENUM.
	;"$$GETFNUM(FILENAME) -- Convert a file name into a file number
	;"$$GTNUMFLD(FILENUMBER,FIELDNAME) -- Given file and the name of a field, this will return the field NUMBER
	;"$$SETFFNUM(FILE,FIELD,FILENUMBER,FIELDNUMBER) -- ensure that FILE and FIELD numbers are in place
	;"READWP(FILE,IENS,FIELD,ARRAY) --a wrapper for reading a WP with error trap, error reporting
	;"GFLDINFO(FILENUMBER,FIELD,POUT,INFOS) -- GET FIELD INFO
	;
	;"=======================================================================
	;"Private API functions
	;"=======================================================================
	;"GETREFAR(FILENUM,ARRAY) -- Get ARRAY to use with ^DIC
	;"ASKSCRN -- Input transform for ASKFIENS
	;
	;"=======================================================================
	;"DEPENDENCIES: TMGDEBU2
	;"=======================================================================
	;
ASKFIENS()	 ;
	       ;"Purpose: Ask user to pick a file number, then pick a record
	       ;"         from that file.  This supports selection of subfiles.
	       ;"Input: none
	       ;"Results: format-- File^IENS, or ^ if abort
	       NEW RESULT SET RESULT="^"
	       NEW DIR,X,Y
	       SET DIR(0)="F"
	       SET DIR("A")="Select FILE (or SUBFILE)"
	       SET DIR("?")="Answer with FILE NUMBER or NAME, or SUBFILE NUMBER"
	       SET DIR("PRE")="D ASKSCRN^TMGDBAP3"
	       DO ^DIR
	       SET Y=+Y
	       IF Y>0 SET RESULT=Y_"^"_$$ASKIENS(Y)
	       ;
	       QUIT RESULT
	       ;
ASKIENS(FILENUM,IENS)	;
	       ;"Purpose: To ask user to select a record in File indicated by FILENUM.
	       ;"         If FILENUM is a subfile number, then the user will be asked
	       ;"         for records to drill down to desired record, and return values
	       ;"         as an IENS.
	       ;"Input: FILENUM: A file number or subfile number
	       ;"       IENS: OPTIONAL.  Allows for supplying a partial IENS supplying a
	       ;"                      partial path.  E.g. if a full IENS to FILENUM
	       ;"                    would be '2,3,4455,' and if the IENS supplied is
	       ;"                  '3,4455,' then only the missing IEN (in this case 2)
	       ;"                 would be asked.
	       ;"Results: Returns IENS.  format: IEN in file,IEN in parentfile,IEN in grandparentfile, ... ,
	       ;"            Note: IENS will contain '?' if there is a problem,
	       ;"                  or "" if FILENUM is invalid
	       NEW ARRAY
	       DO GETREFAR(FILENUM,.ARRAY)
	       NEW RESULTIENS SET RESULTIENS=""
	       SET IENS=$GET(IENS)
	       ;
	       NEW DANUM SET DANUM=1
	       NEW TMGDA,NUMIENS
	       SET NUMIENS=$LENGTH(IENS,",")
	       NEW IDX,ABORT SET IDX="",ABORT=0
	       FOR  SET IDX=$ORDER(ARRAY(IDX),-1) QUIT:(IDX="")!ABORT  DO
	       . NEW DIC,X,Y,DA
	       . NEW TEMPIEN SET TEMPIEN=+$PIECE(IENS,",",NUMIENS-DANUM)
	       . IF TEMPIEN'>0 DO
	       . . SET DIC=$GET(ARRAY(IDX,"GL")),DIC(0)="AEQM"
	       . . IF DIC'="" WRITE !,"Select entry in file# ",ARRAY(IDX,"FILE NUM")
	       . . DO ^DIC WRITE !
	       . ELSE  SET Y=TEMPIEN
	       . IF +Y'>0 SET RESULTIENS="?,"_RESULTIENS,ABORT=1 QUIT
	       . SET TMGDA(DANUM)=+Y,DANUM=DANUM+1
	       . SET RESULTIENS=+Y_","_RESULTIENS
	       ;
	       WRITE "#: ",RESULTIENS,!
	       QUIT RESULTIENS
	       ;
ASKSCRN	 ;
	      ;"Purpose: an Input transform for ASKFIENS
	      ;"Input: (global) X -- the user's response in ^DIR
	      ;"       (global) DTOUT -- this will be defined IF the read timed out.
	      ;"Output: If X is changed, it will be as IF user entered in NEW X
	      ;"        If X is killed, it will be as IF user entered an illegal value.
	      ;"Result: none
	      IF $DATA(DTOUT) QUIT
	      IF +X=X DO
	      . IF $DATA(^DD(X,0))=0  KILL X QUIT
	      . IF $DATA(^DIC(X,0)) WRITE " ",$PIECE(^DIC(X,0),"^",1)," " QUIT
	      . ;"Here we deal with subfiles
	      . NEW TEMP,IDX,FILENUM
	      . SET FILENUM=X
	      . SET X=""
	      . FOR IDX=100:-1:0 DO  QUIT:(FILENUM=0)
	      . . SET TEMP(IDX)=FILENUM
	      . . SET X=X_FILENUM_","
	      . . SET FILENUM=+$GET(^DD(FILENUM,0,"UP"))
	      . NEW INDENT SET INDENT=5
	      . NEW INDENTS SET $PIECE(INDENTS," ",75)=" "
	      . WRITE !
	      . SET IDX=""
	      . FOR  SET IDX=$ORDER(TEMP(IDX)) QUIT:(IDX="")  DO
	      . . SET FILENUM=+$GET(TEMP(IDX)) QUIT:(FILENUM=0)
	      . . WRITE $EXTRACT(INDENTS,1,INDENT)
	      . . IF $DATA(^DIC(FILENUM,0)) DO
	      . . . WRITE $PIECE(^DIC(FILENUM,0),"^",1)," (FILE #",FILENUM,")",!
	      . . ELSE  WRITE "+--SUBFILE# ",FILENUM,!
	      . . SET INDENT=INDENT+3
	      ELSE  DO  ;"check validity of FILE NAME
	      . IF X="" QUIT
	      . NEW FILENUM SET FILENUM=$ORDER(^DIC("B",X,""))
	      . IF +FILENUM>0 SET X=+FILENUM_"," QUIT
	      . SET FILENUM=$$GETFNUM(X)
	      . IF +FILENUM>0 SET X=+FILENUM_"," QUIT
	      . NEW DIC,Y
	      . SET DIC=1 SET DIC(0)="EQM"
	      . DO ^DIC w !
	      . IF +Y>0 SET X=+Y QUIT
	      . SET X=0
	      ;
	      IF $GET(X)="" SET X=0
	      QUIT
	      ;
GETFNUM(FILENAME)	;
	       ;"Purpose: Convert a file name into a file number
	       ;"Input: The name of a file
	       ;"Result: The filenumber, or 0 IF not found.
	       NEW RESULT SET RESULT=0
	       IF $GET(FILENAME)="" GOTO GFNUMDN
	       IF FILENAME=" " DO  GOTO GFNUMDN
	       . DO SHOWERR^TMGDEBU2(,"No file specifier (either name or number) given!")
	       . SET RESULT=0
	       SET DIC=1  ;"File 1=Global file reference (the file listing info for all files)
	       SET DIC(0)="M"
	       SET X=FILENAME   ;"i.e. "AGENCY"
	       DO ^DIC  ;"lookup filename  Result comes back in Y ... i.e. "4.11^AGENCY"
	       SET RESULT=$PIECE(Y,"^",1)
	       IF RESULT=-1 SET RESULT=0
GFNUMDN	QUIT RESULT
	       ;
GTNUMFLD(FILENUMBER,FIELDNAME)	;
	       ;"PUBLIC FUNCTION
	       ;"Purpose: Given file and the name of a field, this will return the field NUMBER
	       ;"Input: FILENUMBER.  Number of file, i.e. "4.11"
	       ;"       FIELDNAME: the name of a field, i.e. "NAME"  spelling must exactly match
	       ;"Output: Returns field number, i.e. ".01" or 0 if not found
	       QUIT $$FLDNUM^DILFD(FILENUMBER,FIELDNAME)
	       ;
SETFFNUM(FILE,FIELD,FILENUMBER,FIELDNUMBER)	;
	       ;"Purpose: To provide a generic shell to ensure that FILE and FIELD numbers are in place
	       ;"Input:     FILE -- FILE number or name
	       ;"           FIELD -- field number or name
	       ;"           FILENUMBER -- PASS BY REFERENCE -- an out parameter
	       ;"           FIELDNUMBER -- PASS BY REFERENCE -- an out parameter
	       ;"Results: 1 if ok, otherwise 0 if error
	       ;"Output -- FILENUMBER and FIELDNUMBER are filled in.
	       NEW RESULT SET RESULT=1
	       SET FILENUMBER=+$GET(FILE)
	       IF FILENUMBER=0 SET FILENUMBER=$$GETFNUM^TMGDBAP3(.FILE)
	       IF FILENUMBER=0 DO  GOTO SFFNDN
	       . SET RESULT=0
	       . DO SHOWERR^TMGDEBU2(,"Can't convert file '"_$GET(FILE)_", to a number.")
	       SET FIELDNUMBER=$GET(FIELD)
	       IF +FIELDNUMBER=0 SET FIELDNUMBER=$$GTNUMFLD(FILENUMBER,.FIELD)
	       IF FIELDNUMBER=0 DO  GOTO SFFNDN
	       . SET RESULT=0
	       . DO SHOWERR^TMGDEBU2(,"Can't convert field '"_$GET(FIELD)_", to a number.")
SFFNDN	 QUIT RESULT
	       ;
GETREFAR(FILENUM,ARRAY)	;
	       ;"Purpose: To return an ARRAY containing global references that can
	       ;"         be passed to ^DIC, for given file or subfile number
	       ;"Input: FILENUM: A file number or subfile number
	       ;"       ARRAY: PASS BY REFERENCE.  See format below
	       ;"Results: none, but ARRAY is filled with result.  Format (example):
	       ;"      ARRAY(1,"FILE NUM")=2.011  <--- sub sub file
	       ;"      ARRAY(1,"GL")="^DPT(TMGDA(1),""DE"",TMGDA(2),""1"","
	       ;"      ARRAY(2,"FILE NUM")=2.001  <---- sub file
	       ;"      ARRAY(2,"GL")="^DPT(TMGDA(1),""DE"","
	       ;"      ARRAY(3,"FILE NUM")=2  <---- parent file
	       ;"      ARRAY(3,"GL")="^DPT("
	       ;"Note: To use the references stored in "GL", then the IEN for
	       ;"      each step should be stored in TMGDA(x)
	       NEW IDX
	       FOR IDX=1:1 QUIT:(+$GET(FILENUM)=0)  DO
	       . SET ARRAY(IDX,"FILE NUM")=FILENUM
	       . IF $DATA(^DD(FILENUM,0,"UP")) DO
	       . . NEW PARENTFLNUM,FIELD
	       . . SET PARENTFLNUM=+$GET(^DD(FILENUM,0,"UP"))
	       . . IF PARENTFLNUM=0 QUIT  ;"really should be an abort
	       . . SET FIELD=$ORDER(^DD(PARENTFLNUM,"SB",FILENUM,""))
	       . . IF FIELD="" QUIT  ;"really should be an abort
	       . . NEW NODE SET NODE=$PIECE($PIECE($GET(^DD(PARENTFLNUM,FIELD,0)),"^",4),";",1)
	       . . SET ARRAY(IDX,"NODE IN PARENT")=NODE
	       . ELSE  DO
	       . . SET ARRAY(IDX,"GL")=$GET(^DIC(FILENUM,0,"GL"))
	       . SET FILENUM=+$GET(^DD(FILENUM,0,"UP"))
	       ;
	       SET IDX="" SET IDX=$ORDER(ARRAY(IDX),-1)
	       SET ARRAY(IDX,"REF")=$GET(ARRAY(IDX,"GL"))_"TMGDA(1),"
	       NEW DANUM SET DANUM=2
	       FOR  SET IDX=$ORDER(ARRAY(IDX),-1) QUIT:(IDX="")  DO
	       . NEW REF
	       . SET REF=$GET(ARRAY(IDX+1,"REF"))_""""_$GET(ARRAY(IDX,"NODE IN PARENT"))_""","
	       . KILL ARRAY(IDX+1,"REF"),ARRAY(IDX,"NODE IN PARENT")
	       . SET ARRAY(IDX,"GL")=REF
	       . SET ARRAY(IDX,"REF")=REF_"TMGDA("_DANUM_"),"
	       . SET DANUM=DANUM+1
	       KILL ARRAY(1,"REF")
	       QUIT
	       ;
READWP(FILE,IENS,FIELD,ARRAY)	;
	       ;"Purpose: To provide a shell for reading a WP with error trap, error reporting
	       ;"Input: FILE: a number or name
	       ;"         IENS: a standard IENS (i.e.  "IEN,parent-IEN,grandparent-IEN,ggparent-IEN," etc.
	       ;"              Note: can just pass a single IEN (without a terminal ",")
	       ;"         FIELD: a name or number
	       ;"         ARRAY: The array to receive WP data.  PASS BY REFERENCE
	       ;"                      returned In Fileman acceptible format.
	       ;"                      ARRAY will be deleted before refilling
	       ;"Results -- IF error occured
	       ;"        1  if no error
	       ;"        0  if error
	       NEW FILENUM,FLDNUM
	       NEW TMGWP,TEMP,TMGMSG
	       NEW RESULT SET RESULT=1
	       IF $GET(IENS)="" DO  GOTO RWPDN
	       . DO SHOWERR^TMGDEBU2(,"Valid IENS not supplied.")
	       IF $EXTRACT(IENS,$LENGTH(IENS))'="," SET IENS=IENS_","
	       IF $$SETFFNUM^TMGDBAP3(.FILE,.FIELD,.FILENUM,.FLDNUM)=0 GOTO RWPDN
	       SET TEMP=$$GET1^DIQ(FILENUM,IENS,FLDNUM,"","TMGWP","TMGMSG")
	       IF $DATA(TMSETGMSG),$DATA(TMGMSG("DIERR"))'=0 DO 
	       . DO SHOWDIER^TMGDEBU2(.TMGMSG)
	       . SET RESULT=0
	       IF RESULT=0 GOTO RWPDN
	       KILL ARRAY MERGE ARRAY=TMGWP
RWPDN	  QUIT RESULT
	       ;
GFLDINFO(FILENUMBER,FIELD,POUT,INFOS)	;"GET FIELD INFO
	       ;"PUBLIC FUNCTION
	       ;"Purpose: To get FIELD info,
	       ;"Input: FILENUMBER: File or subfile number
	       ;"         FIELD: FIELD name or number
	       ;"         POUT -- the NAME of the variable to put result into.
	       ;"         INFOS -- [OPTIONAL] -- additional attributes of field info to be looked up
	       ;"                              (as allowed by FIELD^DID).  Multiple items should be
	       ;"                              separated by a semicolon (';')
	       ;"                              e.g. "TITLE;LABEL;POINTER"
	       ;"Output: Data is put into POUT (any thing in POUT is erased first
	       ;"        i.e. @POUT@("MULTIPLE-VALUED")=X
	       ;"        i.e. @POUT@("SPECIFIER")=Y
	       ;"        i.e. @POUT@("TYPE")=Z
	       ;"        i.e. @POUT@("StoreLoc")="0;1"   <-- not from  fileman output (i.e. extra info)
	       ;"      (if additional attributes were specified, they will also be in array)
	       ;"Result: none
	       KILL @POUT  ;"erase any old information
	       IF +FIELD=0 SET FIELD=$$GTNUMFLD(FILENUMBER,FIELD)
	       SET @POUT@("StoreLoc")=$PIECE($GET(^DD(FILENUMBER,FIELD,0)),"^",4)
	       NEW TMGMSG,ATTRIBS SET ATTRIBS="MULTIPLE-VALUED;SPECIFIER;TYPE"
	       IF $DATA(INFOS) SET ATTRIBS=ATTRIBS_";"_INFOS
	       ;"Next, check if  field is a multiple and get field info.
	       DO FIELD^DID(FILENUMBER,FIELD,,ATTRIBS,POUT,"TMGMSG")
	       IF $DATA(TMGMSG),$DATA(TMGMSG("DIERR"))'=0 DO
	       . DO SHOWDIER^TMGDEBU2(.TMGMSG)
	       QUIT
	       ;
