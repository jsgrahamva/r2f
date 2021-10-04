TMGXMLE2	;TMG/kst/XML Exporter -- Core functionality ;03/25/06, 3/2/11, 7/10/12
	        ;;1.0;TMG-LIB;**1**;07/12/05;Build 8
	;
	;"TMG XML EXPORT FUNCTIONS (CORE FUNCTIONALITY)
	;"Kevin Toppenberg MD
	;"GNU General Public License (GPL) applies
	;"7-12-2005
	;"=======================================================================
	;" API -- Public Functions.
	;"=======================================================================
	;"WTXMLOUT(PARRAY,FLAGS,INDENTS)
	;"WRIT1FIL(FILE,RECS,FLAGS,INDENTS,SAVFIELDINFO)
	;"=======================================================================
	;"PRIVATE API FUNCTIONS
	;"=======================================================================
	;
	;"=======================================================================
	;"DEPENDENCIES
	;" TMGDBAP3, TMGDEBU2, TMGMISC2, TMGSTUT2, TMGUSRIF, TMGXMLT, MXMLUTL
	;"=======================================================================
	;"=======================================================================
	;
	;"NOTES: The basic format is to be as follows:
	;
	;"Array(FILE,Record,FIELD,subRec,SubFIELD...)=""   <--- means export this entry to XML
	;"Array(FILE,"TEMPLATE",FIELD)
	;"Array(FILE,"TEMPLATE","ORDER",OrderNUM)=FIELD
	;"Array(FILE,"TEMPLATE","TAG NAME",FIELDNumber)="Custom field name to put in XML file"
	;"Array("FLAGS","b")=""  b -- show tags for ALL fields, even if field has no data
	;"Array("FLAGS","i")=""  i -- indent tags for pretty, but technically useless, file formating.
	;"Array("FLAGS","I")=""  I -- output INTERNAL values
	;"Array("FLAGS","D")=""  D -- output the data dictionary
	;"Array("!DOCTYPE")=MyLABEL
	;"Array("EXPORT_SYSTEM_NAME")=LABELForExportingSystem   -- OPTIONAL
	;"
	;"-----------------------------------------------------------------------------------------------
	;"Note: FILE numbers can be replaces with full FILE NAMES, e.g.
	;"   Array("NEW PERSON",1234,.01)=""
	;"
	;"Example:  For ALL records, output ALL fields, and ALL subfields
	;"     Array(8925,"*")=""   <--- this is default if RECS is not specified/passed
	;"
	;"Example: to print from:
	;"   file 8925, records 1234,1235,1236,1237
	;"   file 200, ALL records
	;"   file 22705, records 3,5
	;"   file 2, ALL records
	;"
	;"   Array(8925,1234)=""
	;"   Array(8925,1235)=""
	;"   Array(8925,1236)=""
	;"   Array(8925,1237)=""
	;"   Array(200,"*")=""
	;"   Array(22705,3)=""
	;"   Array(22705,5)=""
	;"   Array(2,"*")=""
	;"
	;"Example:  Output extra info in record node
	;"   Array(8925,1232)="TAG=value^TAG2=value2" <-- optional extra info for record
	;"     e.g. -->  <Record id=1232 TAG="value" TAG2="value2">
	;"
	;"Example:  For record 1231, output fields .01 and .02
	;"              For record 1232, output field .01 only
	;"              For record 1234, output field "NAME" only
	;"              For record 1235, output ALL fields
	;"     Array(8925,1231,.01)=""
	;"     Array(8925,1231,.02)=""
	;"     Array(8925,1232,.01)=""
	;"     Array(8925,1234,"NAME")=""
	;"     Array(8925,1235,"*")=""
	;"
	;"Example:
	;"   Array(8925,"TEMPLATE",.01)=""   <-- define a template for file 8925, with fields .01,.02,.03
	;"   Array(8925,"TEMPLATE",.02)=""
	;"   Array(8925,"TEMPLATE",.03)=""
	;"   Array(8925,1234)   <-- print record 1234  (will use the template)
	;"   Array(8925,1235)   <-- print record 1235
	;"
	;"Example:
	;"   Array(8925,"TEMPLATE","*"))=""  <-- include all fields in template
	;"   Array(8925,"TEMPLATE","Field Exclude",.04)=""   <-- but exclude field .04
	;"   Array(8925,1235)   <-- print record 1235, all fields but .04
	;"
	;"Example:  For all records, output fields .01 and .02 and "NAME"
	;"    Array(8925,"*",.01)=""
	;"    Array(8925,"*",.02)=""
	;"    Array(8925,"*","NAME")=""
	;"
	;"Example:
	;"    Array(8925,1231,"*")=""    <--- indicates that ALL fields, ALL subrecs,and ALL subfields are wanted
	;"
	;"Example:  For all records, output field "ENTRY", which is a multiple.  In
	;"            subfile, output all records, fields  .01, and .02
	;"    Array(8925,"*","ENTRY","*",.01)=""
	;"    Array(8925,"*","ENTRY","*",.02)=""
	;"
	;"Example:  For ALL records, output ALL fields, and ALL subfields, with 2 exceptions
	;"    Array(8925,"Rec Exclude",1234)=""  <-- All records except 1234 & 1235 will be output
	;"    Array(8925,"Rec Exclude",1235)=""
	;"    Array(8925,"*")=""
	;"
	;"Example:
	;"    Array(8925,"TEMPLATE","Field Exclude",.04)=""  <-- don't show field .04
	;"    Array(8925,"TEMPLATE","Field Exclude","STATE")=""  <-- don't show field "STATE"
	;"    Array(8925,1231,"*")=""   <-- in record 1231, show all fields but .04 and "STATE"
	;"
	;"Example: Field .04 is multiple. ALL sub records and ALL subfields to be written
	;"    Array(8925,1231,.04,"*","*")=""
	;"    Array(8925,1231,.04,"*")=""  <--- "*" assumed for subfields
	;"    Array(8925,1231,.04)=""   <-- "*" assumed for subrecords and subfields.
	;"
	;"Example: Field .03 is multiple. All sub records to be written (except for #5) , and .01 and .02 fields to be written
	;"    Array(8925,1231,.03,"*",.01)=""  <-- In all sub recs, sub field .01 is to be written
	;"    Array(8925,1231,.03,"*",.02)=""  <-- In all sub recs, sub field .02 is to be written
	;"    Array(8925,1231,.03,"Rec Exclude",5)=""  <-- Exclude subrec 5
	;"
	;"Example: Field .03 is multiple. All sub records to be written, and .01 and .02 fields to be written
	;"    Array(8925,1231,"TEMPLATE",.03,"*","TEMPLATE",.01)=""  <-- In all sub recs, sub field .01 is to be written
	;"    Array(8925,1231,"TEMPLATE",.03,"*","TEMPLATE",.02)=""  <-- In all sub recs, sub field .02 is to be written
	;
	;"Example: Field .03 is multiple. Sub records 1,2,3 to be written, fields as below
	;"    Array(8925,1231,.03,1,.01)=""   <-- In sub rec 1, sub field .01 is to be written
	;"    Array(8925,1231,.03,1,.02)=""   <-- In sub rec 1, sub field .02 is to be written
	;"    Array(8925,1231,.03,2,.01)=""   <-- In sub rec 2, sub field .01 is to be written
	;"    Array(8925,1231,.03,3,"*")=""   <-- In sub rec 3, all sub fields are to be written
	;"    Array(8925,1231,.03,4)=""        <-- In sub rec 4, all sub fields are to be written (defalt)
	;"    Array(8925,1231,.03,5,"*")=""   <-- In sub rec 5, all sub fields are to be written, with one exception
	;"    Array(8925,1231,.03,5,"Field Exclude",.01)="" <-- In sub rec 5, sub fields .01 is not to be written.
	;"
	;"Example:   Shows optional substitution of a NEW TAG name for a given field
	;"   Array(8925,"TEMPLATE","TAG NAME",.01)="Patent Name"  <-- use "Patient Name" instead of field name for .01 field
	;"   Array(8925,"TEMPLATE","TAG NAME",.02)="City"  <-- use "City" instead of field name for .02 field
	;"
	;"Note: pattern continues for sub-sub-multiples etc.
	;"
	;"Example:
	;"   Array(8925,1231,.01)=""
	;"   Array(8925,1231,.02)=""
	;"   Array(8925,1231,"NAME")=""  <--- note that field name is allowed in place of number
	;"   Array(8925,1231,.03,1,.01)=""   <-- In sub rec 1, sub field .01 is to be written
	;"   Array(8925,1231,.03,1,.02)=""   <-- In sub rec 1, sub field .02 is to be written
	;"   Array(8925,1231,.03,2,.01)=""   <-- In sub rec 2, sub field .01 is to be written
	;"   Array(8925,1231,.03,3,"*")=""   <-- In sub rec 3, all sub fields are to be written
	;"   Array(8925,1231,.03,4)=""        <-- In sub rec 4, all sub fields are to be written (defalt)
	;"
	;"Example:  Field .03 is a multiple
	;"   Array(8925,1231,.03,"TEMPLATE",.01)=""
	;"   Array(8925,1231,.03,"TEMPLATE",.02)=""
	;"   Array(8925,1231,.03,1)=""   <-- In sub rec 1, export fields .01,.02 from template
	;"   Array(8925,1231,.03,2)=""   <-- In sub rec 2, export fields .01,.02 from template
	;"   Array(8925,1231,.03,4)=""   <-- In sub rec 4, export fields .01,.02 from template
	;"
	;"Example:
	;"  Array(8925,"TEMPLATE","ORDER",1)=.03            <-- 1st field to output
	;"  Array(8925,"TEMPLATE","ORDER",2)=.02            <-- 2nd field to output
	;"  Array(8925,"TEMPLATE","ORDER",3)="NAME"    <-- 3rd field to output
	;"  Array(8925,"TEMPLATE","ORDER",4)=.01            <-- 4th field to output
	;"  Note: Specifying an 'ORDER' is not compatible with specifying "*" fields
	;"          If "ORDER" is specified, only fields with a given order will be output
	;"          Both Field("ORDER",x)=FieldNum *AND* Field(FieldNUM)="" should be defined
	;"                  This will be primarily important for fields that are multiples, with sub recs.
	;"
	;"Example:
	;"  Array(8925,"TEMPLATE","TRANSFORM",.01)="write ""Custom .01 output transform M code here..."""
	;"  Array(8925,"TEMPLATE","TRANSFORM",.02)="write ""Custom .02 output transform M code here..."""
	;
	;
	;
WTXMLOUT(PARRAY,FLAGS,INDENTS,SHOWPROG)	 ;
	       ;"Scope: PUBLIC
	       ;"Purpose: to dump out a specified SET of files and records in XML Format
	       ;"Input: PARRAY -- pointer to (i.e. name of) array containting formatting/output info.
	       ;"              REQUIRED An array specifying which files and records to display
	       ;"              Format as follows:
	       ;"              ;"-----------------------------------------
	       ;"              Array(FILE,IEN,FieldINFO)   ; For FieldINFO, see WRIT1FIL, and WRIT1REC
	       ;"              Array(FILE,["TEMPLATE"],...)   ;For TEMPLATE info see function WRIT1FIL
	       ;"              Array("FLAGS","b")=""  b -- show tags for ALL fields, even if field has no data
	       ;"              Array("FLAGS","i")=""  i -- indent tags for pretty, but technically useless, file formating.
	       ;"              Array("FLAGS","I")=""  I -- output INTERNAL values
	       ;"              Array("FLAGS","D")=""  D -- output the data dictionary
	       ;"              Array("FLAGS","S")=""  S -- output export settings.
	       ;"              Array("!DOCTYPE")=MyLABEL
	       ;"              Array("EXPORT_SYSTEM_NAME")=LABELForExportingSystem   -- OPTIONAL
	       ;"              ;"-----------------------------------------
	       ;"
	       ;"      e.g.    Array(8925,1234)=""
	       ;"              Array(8925,1235)=""
	       ;"              Array(8925,1236)=""
	       ;"              Array(8925,1237)=""
	       ;"              Array(8925,1232)="TAG=value^TAG2=value2" <-- optional extra info for record
	       ;"                  e.g. -->  <Record id=1232 TAG="value" TAG2="value2">
	       ;"              Array(200,"*")=""
	       ;"              Array(22705,3)=""
	       ;"              Array(22705,5)=""
	       ;"              Array(2,"*")=""
	       ;"
	       ;"              This would print from:
	       ;"                      file 8925, records 1234,1235,1236,1237
	       ;"                      file 200, ALL records
	       ;"                      file 22705, records 3,5
	       ;"                      file 2, ALL records
	       ;"
	       ;"           Example:
	       ;"              Array(8925,"TEMPLATE",.01)=""   <-- define a template for file 8925
	       ;"              Array(8925,"TEMPLATE",.02)=""
	       ;"              Array(8925,"TEMPLATE",.02)=""
	       ;"              Array(8925,1234)   <-- print record 1234
	       ;"              Array(8925,1235)   <-- print record 1235
	       ;"
	       ;"           Example:
	       ;"              Array(8925,1234)   <-- print record 1234
	       ;"              Array(8925,1235)   <-- print record 1235
	       ;"
	       ;"           Example:
	       ;"              Array(8925,1234,.01)   <-- print record 1234, only field .01
	       ;"              Array(8925,1235,.04)   <-- print record 1235, only field .04
	       ;"
	       ;"              Note: FILE numbers can be replaces with full FILE NAMES, e.g.
	       ;"              Array("NEW PERSON","*")=""
	       ;"
	       ;"            Note: All FILE numbers and field numbers can be replaced with NAMES
	       ;"
	       ;"         FLAGS -- OPTIONAL  (Note FLAGS can also be specified with a "FLAGS" node)
	       ;"                      b -- show tags for ALL fields, even if field has no data
	       ;"                      i -- indent tags for pretty, but technically useless, file formating.
	       ;"                      I -- output INTERNAL values
	       ;"                      D -- output Data dictionary
	       ;"                      e.g. FLAGS="b"  or "bi"  or "ib"  or "iI" etc.
	       ;"         INDENTS -- OPTIONAL -- current string to write to indent line.
	       ;"                    INDENTS("INCINDENT")=INCINDENT
	       ;"        SHOWPROG -- OPTIONAL -- if =1, then a progress bar will be shown.
	       ;"Output: RESULTs are written to the current device.
	       ;"RESULT : none
	       ;
	       NEW FILE,TARRAY,SAVFIELDINFO
	       MERGE TARRAY=@PARRAY
	       SET FLAGS=$GET(FLAGS)
	       NEW INCINDENT SET INCINDENT=$GET(INDENTS("INCINDENT")," ")
	       ;
	       IF ($DATA(TARRAY("FLAGS","b"))>0)&(FLAGS'["b") SET FLAGS=FLAGS_"b"
	       IF ($DATA(TARRAY("FLAGS","i"))>0)&(FLAGS'["i") SET FLAGS=FLAGS_"i"
	       IF ($DATA(TARRAY("FLAGS","I"))>0)&(FLAGS'["I") SET FLAGS=FLAGS_"I"
	       IF ($DATA(TARRAY("FLAGS","D"))>0)&(FLAGS'["D") SET FLAGS=FLAGS_"D"
	       IF ($DATA(TARRAY("FLAGS","S"))>0)&(FLAGS'["S") SET FLAGS=FLAGS_"S"
	       ;
	       DO WRITEHDR
	       WRITE "<!DOCTYPE "_$GET(TARRAY("!DOCTYPE"),"UNDEFINED"),">",!
	       NEW SRCNAME SET SRCNAME=$GET(TARRAY("EXPORT_SYSTEM_NAME"),"?Unnamed?")
	       WRITE "<EXPORT source=""",$$SYMENC^MXMLUTL(SRCNAME),""">",!
	       SET INDENTS=$GET(INDENTS)_INCINDENT
	       IF FLAGS["S" DO WRTSTNGS^TMGXMLE3(.FLAGS,.INDENTS)  ;"output writing settings
	       ;
	       SET FILE=""
	       FOR  SET FILE=$ORDER(TARRAY(FILE)) QUIT:(+FILE'>0)  DO
	       . NEW IEN,TEMPLATE,RECS
	       . MERGE TEMPLATE=TARRAY(FILE,"TEMPLATE")
	       . KILL TARRAY(FILE,"TEMPLATE")
	       . MERGE RECS=TARRAY(FILE)
	       . SET IEN=$ORDER(TARRAY(FILE,""))
	       . IF IEN'="" DO
	       . . IF $DATA(TMGXDEBUG) DO
	       . . . USE $P WRITE "Writing file: ",FILE,! USE IO
	       . . IF IEN="*" DO
	       . . . DO WRIT1FIL^TMGXMLE3(FILE,.RECS,.FLAGS,.INDENTS,.TEMPLATE,.SHOWPROG,,,,,.SAVFIELDINFO)
	       . . ELSE  DO
	       . . . NEW RECS MERGE RECS=TARRAY(FILE)
	       . . . DO WRIT1FIL^TMGXMLE3(FILE,.RECS,.FLAGS,.INDENTS,,.SHOWPROG,,,,,.SAVFIELDINFO)
	       ;
	       WRITE "</EXPORT>",!
	       QUIT
	       ;
WRITEHDR	;
	       ;"Scope: PUBLIC
	       ;"Purpose: A shell to write out a proper XML header.  This should be done prior
	       ;"              to writing out XML formatted data to a device
	       ;"Output: Header is output to current device
	       ;"Results: none
	       NEW STR SET STR=$$XMLHDR^MXMLUTL
	       WRITE STR,!
	       QUIT
	       ;
