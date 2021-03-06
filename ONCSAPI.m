ONCSAPI	;Hines OIFO/SG - ONCOLOGY WEB-SERVICE  ; 12/7/06 10:37am
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;
	; ONCSAPI ------------- API DESCRIPTOR
	;
	; ONCSAPI(
	;
	;   "DEBUG")            Debug mode
	;                         0  Disabled
	;                         1  Enabled
	;
	;   "MSG",              ""
	;     IEN,
	;       0)              Error Descriptor
	;                         ^01: Error Code   (see MSGLIST^ONCSAPIE)
	;                         ^02: Error Message
	;                         ^03: Label+Offset (optional)
	;                         ^04: Routine      (optional)
	;       1,i)            Error details (text)
	;     "E",
	;       Error Code,
	;         IEN)    ""
	;
	; ^XTMP("ONCSAPI") ---- LOCAL CACHE FOR WEB-SERVICE DATA
	;
	; ^XTMP("ONCSAPI",
	;
	;   0)                  Node descriptor
	;                         ^01: Purge date  (FileMan)
	;                         ^02: Create date (FileMan)
	;                         ^03: Description
	;
	;   "EDITS",            Metafile Version
	;     IEN,
	;       0)              Edit Descriptor
	;                         ^01: Index in the edit set
	;                         ^02: Name
	;       "D",i)          Description
	;       "H",i)          Help
	;     "ES",
	;       EditSetName,
	;         EditIndex)    IEN
	;
	;   "SCHEMAS",
	;     Schema#,
	;       0)              Schema name
	;
	;     "N",
	;       Name)           Schema#
	;
	;     "SH",
	;       Site,Hist)      Schema#
	;
	;   "TABLES",           DLL Version
	;
	;     IEN,
	;       0)              Table descriptor
	;                         ^01: Number of rows
	;                         ^02: Schema number
	;                         ^03: Table number
	;                         ^04: Table pattern
	;                         ^05: Table title
	;                         ^06: Table subtitle
	;       Row#,
	;         1)            Codes
	;                         ^01: Row code
	;                         ^02: Additional code #1
	;                         ^03: Additional code #2
	;                         ^04: ...
	;         3,i)          Description (text)
	;
	;       "C",
	;         RowCode)      Descriptor
	;                         ^01: Row#
	;                         ^02: Upper boundary (for intervals)
	;
	;       "FN",
	;         Note#,i)      Footnote (text)
	;       "TN",
	;         Note#,i)      Note (text)
	;
	;     "ST",
	;       Schema#,
	;         Table#)       IEN
	;
	; CS TABLE NUMBER ----- TABLE DESCRIPTION
	;
	;               1       CS Tumor Size
	;               2       CS Extension
	;               3       CS Size/Ext Eval
	;               4       CS Lymph Nodes
	;               5       CS Reg Nodes Eval
	;               6       Regional Nodes Positive
	;               7       Regional Nodes Examined
	;               8       CS Mets at DX
	;               9       CS Mets Eval
	;              10       CS Site-Specific Factor 1
	;              11       CS Site-Specific Factor 2
	;              12       CS Site-Specific Factor 3
	;              13       CS Site-Specific Factor 4
	;              14       CS Site-Specific Factor 5
	;              15       CS Site-Specific Factor 6 
	;              16       CS Site-Specific Factor 7 
	;              17       CS Site-Specific Factor 8
	;              18       CS Site-Specific Factor 9
	;              19       CS Site-Specific Factor 10
	;              20       CS Site-Specific Factor 11
	;              21       CS Site-Specific Factor 12
	;              22       CS Site-Specific Factor 13
	;              23       CS Site-Specific Factor 14
	;              24       CS Site-Specific Factor 15
	;              25       CS Site-Specific Factor 16
	;              26       CS Site-Specific Factor 17
	;              27       CS Site-Specific Factor 18
	;              28       CS Site-Specific Factor 19
	;              29       CS Site-Specific Factor 20
	;              30       CS Site-Specific Factor 21
	;              31       CS Site-Specific Factor 22
	;              32       CS Site-Specific Factor 23
	;              33       CS Site-Specific Factor 24
	;              34       CS Site-Specific Factor 25
	;              35       Histologies
	;
	; CS ENTRY POINT ------ DESCRIPTION
	;
	;       HELP^ONCSAPI1   Displays the field's valid codes
	;      INPUT^ONCSAPI1   Checks if the code is valid
	;
	;     $$CALC^ONCSAPI3   Calculates the staging values
	;
	;   $$SCHEMA^ONCSAPIS   Returns schema number
	;
	; $$CODEDESC^ONCSAPIT   Loads the CS code description
	; $$GETCSTBL^ONCSAPIT   Returns table IEN (loads table if necessary)
	;
	; EDITS ENTRY POINT --- DESCRIPTION
	;
	;  $$RBQEXEC^ONCSED01   Executes the 'Run Batch' EDITS request
	;  $$RBQPREP^ONCSED01   Starts preparation of the 'Run Batch' request
	;
	;   $$REPORT^ONCSED01   Prints EDITS report generated by the
	;                       $$RBQEXEC^ONCSED01
	;
	; $$GETEDESC^ONCSED04   Returns the edit description node
	; $$GETEDHLP^ONCSED04   Returns the edit help text node
	;
	; UTILITY ------------- DESCRIPTION
	;
	;       DEMO^ONCSAPI    Demonstration entry point
	;
	;      CLEAR^ONCSAPIE   Initializes the error stack
	;      $$DBS^ONCSAPIE   Cehcks for FileMan DBS errors
	;    $$ERROR^ONCSAPIE   Generates an error message
	;      $$MSG^ONCSAPIE   Returns the text and type of the message
	;    PRTERRS^ONCSAPIE   Displays the error messages
	;      STORE^ONCSAPIE   Stores the message into the error stack
	;
	;   $$CHKERR^ONCSAPIR   Checks for parsing and web-service errors
	;     HEADER^ONCSAPIR   Generates the request header
	;   $$PARAMS^ONCSAPIR   Converts input parameters into XML format
	;        PUT^ONCSAPIR   Adds element/text to the destination buffer
	;  $$REQUEST^ONCSAPIR   Sends the request and gets the response
	;    TRAILER^ONCSAPIR   Generates the request trailer
	;
	; $$GETCSURL^ONCSAPIU   Returns the Oncology web-service URL
	;     $$PAGE^ONCSAPIU   Pauses the output at page end
	; $$UPDCSURL^ONCSAPIU   Updates the Oncology web-service URL
	;         WW^ONCSAPIU   Wraps the string and prints it
	;         ZW^ONCSAPIU   Emulates and extends the ZWRITE command
	;
	;   $$CHKVER^ONCSAPIV   Checks version of the local cache
	;  $$VERSION^ONCSAPIV   Returns versions of web-service components
	;
	;      BEGIN^ONCSNACR   Starts the NAACCR record output
	;        END^ONCSNACR   Finishes the NAACCR record output
	;      WRITE^ONCSNACR   Outputs the piece of the NAACCR record
	;
	; INITIALS ------------ DEVELOPER
	;
	; SG                    Sergey Gavrilov
	;
	Q
	;
	;***** DEMO ENTRY POINT
DEMO	;
	N DA,DIR,DIRUT,DTOUT,DUOUT,ONCSAPI,X,Y
	;
	;--- Debug mode?
	K DIR  S DIR(0)="Y"
	S DIR("A")="Run in debug mode"
	S DIR("B")="NO"
	D ^DIR  Q:$D(DIRUT)
	S:Y ONCSAPI("DEBUG")=1
	;
	;--- Select and run a demo
DEMOSEL	K DIR  S DIR(0)="SO^C:Collaborative Staging;E:EDITS"
	S DIR("A")="Select a demo"
	D ^DIR  Q:$D(DIRUT)
	D  G DEMOSEL
	. I Y="C"  D DEMO^ONCSAPID(.ONCSAPI)  Q  ; Collaborative Staging
	. I Y="E"  D DEMO^ONCSEDEM(.ONCSAPI)  Q  ; EDITS
