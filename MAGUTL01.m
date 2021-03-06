MAGUTL01 ;WOIFO/SG - PARAMETERS AND VALIDATION UTILITIES ; 3/9/09 12:53pm
 ;;3.0;IMAGING;**93**;Dec 02, 2009;Build 2
 ;; Per VHA Directive 2004-038, this routine should not be modified.
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; |                                                               |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way. |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
 ;;
 Q
 ;
 ;##### DELETES THE PARAMETER FROM THE DEFINITION TREE
 ;
 ; .MAGMSPSDEFS  Reference to a local variable that stores the
 ;               parameter definition tree generated by the
 ;               $$LDMPDEFS^MAGUTL01.
 ;
 ; PNAME         Full name of the parameter: list of names separated
 ;               by the '/' that form the path to the parameter
 ;               descriptor in the definition tree.
 ;
DELMPAR(MAGMSPSDEFS,PNAME) ;
 N I,NAME,PNODE
 S NAME=$P(PNAME,"/")  Q:NAME=""
 S PNODE="MAGMSPSDEFS"
 F I=2:1  S TMP=$P(PNAME,"/",I)  Q:TMP=""  D
 . S PNODE=$NA(@PNODE@("N",NAME)),NAME=TMP
 . Q
 K @PNODE@("N",NAME),@PNODE@("Q",NAME)
 Q
 ;
 ;+++++ RETURNS THE LINE OF THE PARAMETER DEFINITIONS TABLE
 ;
 ; OFFSET        Offset of the line from the tag
 ;
 ; Input Variables
 ; ===============
 ;   MAGRTN, MAGTAG
 ;
 ; Notes
 ; =====
 ;
 ; This is an internal entry point. Do not call it from outside
 ; of this routine.
 ;
GETPDEF(OFFSET) ;
 Q $P($T(@(MAGTAG_"+"_OFFSET_"^"_MAGRTN)),";;",2)
 ;
 ;##### LOADS DEFINITIONS OF MISCELLANEOUS PARAMETERS
 ;
 ; .MAGMSPSDEFS( Reference to a local variable where descriptors
 ;               of the miscellaneous parameters are loaded to.
 ;   "N",
 ;     Name,     Parameter descriptor
 ;                 ^01: (Sub)file number
 ;                 ^02: Field number
 ;                 ^03: Parameter type
 ;                 ^04: Custom flags
 ;       "N",
 ;         Name) Parameter descriptor (record field)
 ;           ...
 ;       "Q",    List of required parameters (record fields)
 ;         Name) ""
 ;   "Q",        List of required parameters
 ;     Name)     ""
 ;
 ;               See the MSPTBL^MAGUTL01 for details.
 ;
 ; TAGRTN        Tag^Routine pair that references the table of
 ;               parameter definitions. See the MSPTBL^MAGUTL01
 ;               for a sample/template.
 ;
 ; [MAGLDFLAGS]  Custom flags (characters) defined by the programmer. 
 ;               If this parameter is defined and not empty, then
 ;               only those definitions that have at least one flag
 ;               included in the value of this parameter are loaded.
 ;
 ; Return Values
 ; =============
 ;           <0  Error descriptor (see $$ERROR^MAGUERR)
 ;            0  Success
 ;
LDMPDEFS(MAGMSPSDEFS,TAGRTN,MAGLDFLAGS) ;
 N MAGRTN,MAGSRCI,MAGTAG,RC
 S MAGTAG=$P(TAGRTN,"^"),MAGRTN=$P(TAGRTN,"^",2)
 S MAGLDFLAGS=$G(MAGLDFLAGS),MAGSRCI=3
 K MAGMSPSDEFS  S RC=$$LDMPDEFZ("MAGMSPSDEFS")
 Q $S(RC<0:RC,1:0)
 ;
 ;+++++ RECURSIVE PARSER OF PARAMETER DEFINITIONS
 ;
 ; DSTNODE       Node of the MAGMSPSDEFS where parameter definitions
 ;               are stored to.
 ;
 ; [RECNAME]     Name of the current record. It is used to detect
 ;               the record boundaries.
 ;
 ; Input Variables
 ; ===============
 ;   MAGRTN, MAGSRCI, MAGTAG
 ;
 ; Output Variables
 ; ================
 ;   MAGSRCI
 ;
 ; Return Values
 ; =============
 ;           <0  Error descriptor (see $$ERROR^MAGUERR)
 ;            0  Success
 ;            1  End of the table
 ;
 ; Notes
 ; =====
 ;
 ; This is an internal entry point. Do not call it from outside
 ; of this routine.
 ;
LDMPDEFZ(DSTNODE,RECNAME) ;
 N BUF,NAME,PNODE,RC,TMP,TYPE
 S RC=0
 F  S MAGSRCI=MAGSRCI+1,BUF=$$GETPDEF(MAGSRCI)  Q:BUF=""  D  Q:RC
 . S BUF=$TR(BUF,"| ",U),NAME=$P(BUF,U,2)  Q:NAME=""
 . ;=== Check custom flags
 . I MAGLDFLAGS'=""  Q:$TR(MAGLDFLAGS,$P(BUF,U,6))=MAGLDFLAGS
 . ;=== If the name is the same as that of the current
 . ;=== record, then this is the end of the record.
 . I NAME=$G(RECNAME)  S RC=2  Q
 . S PNODE=$NA(@DSTNODE@("N",NAME))
 . ;=== Determine the parameter type
 . S TYPE=$P(BUF,U,5)
 . I TYPE["X"  D  Q:RC<0  S $P(BUF,U,5)=TYPE
 . . N DDTYPE,FIELD,FILE,MAGMSG
 . . ;--- Get the field type from the DD
 . . S FILE=$P(BUF,U,3),FIELD=$P(BUF,U,4)
 . . I (FILE'>0)!(FIELD'>0)  S RC=$$ERROR^MAGUERR(-23,,"X")  Q
 . . S DDTYPE=$$GET1^DID(FILE,FIELD,,"TYPE",,"MAGMSG")
 . . I $G(DIERR)  S RC=$$DBS^MAGUERR("MAGMSG")  Q
 . . ;--- Update the parameter type
 . . S TYPE=$TR(TYPE,"DPSWX")
 . . I DDTYPE="DATE/TIME"        S TYPE=TYPE_"D"  Q
 . . I DDTYPE="POINTER"          S TYPE=TYPE_"P"  Q
 . . I DDTYPE="SET"              S TYPE=TYPE_"S"  Q
 . . I DDTYPE="WORD-PROCESSING"  S TYPE=TYPE_"W"  Q
 . . Q
 . ;=== Store the parameter descriptor
 . S @PNODE=$P(BUF,U,3,6)
 . S:TYPE["Q" @DSTNODE@("Q",NAME)=""
 . ;=== Process definitions of a record
 . I TYPE["R"  S RC=$$LDMPDEFZ(PNODE,NAME)  Q
 . Q
 ;===
 Q $S(RC>1:0,'RC:1,1:RC)
 ;
MSPTBL ;+++++ SAMPLE/TEMPLATE OF THE PARAMETER DEFINITONS TABLE
 ;;==================================================================
 ;;| Parameter  | File  |Field|Type |Flags|        Comment          |
 ;;|------------+-------+-----+-----+-----+-------------------------|
 ;;|DTIS        |2005   |   7 | DHQ |     | DATE/TIME IMAGE SAVED   |
 ;;|DESCR       |       |     | W   |     |                         |
 ;;|OBJGROUP    |       |     | RM  |     |                         |
 ;;|  GROUP     |2005.04| .01 | PQ  |     |                         |
 ;;|  IMGNUM    |2005.04|   2 |     |     |                         |
 ;;|OBJGROUP    |       |     |     |     |                         |
 ;;|ORIGIN      |2005   |  45 |  M  |     |                         |
 ;;==================================================================
 ;
 ; Parameter     Parameter name. It must be unique on the top level
 ;               or inside each record definition (e.g. OBJGROUP) and 
 ;               must not contain spaces.
 ;
 ; File          If the file and field numbers are defined, then
 ; Field         values of the parameter are validated according to
 ;               the field data dictionary (using the CHK^DIE).
 ;
 ;               NOTE: This simple validation will not work for those 
 ;                     fields that have input transform that depend
 ;                     on other fields and/or records.
 ;
 ; Type          Parameter type:
 ;                 D - Date/time,  P - Pointer,
 ;                 R - Record,     S - Set of codes
 ;                 W - Word processing
 ;                 X - Set the type according to the field type from
 ;                     the DD (the File and Field must be provided).
 ;                     The 'X' itself is removed from the descriptor.
 ;               and modifiers:
 ;                 H - Date/time in HL7 format (TS)
 ;                 M - Multi-value parameter
 ;                 Q - Required parameter
 ;
 ; Flags         Custom flags defined by the programmer. Use them to
 ;               control what definitions are loaded by the
 ;               $$LDMPDEFS^MAGUTL01 function (see the MAGLDFLAGS
 ;               parameter of the function for more details).
 ;
 Q
