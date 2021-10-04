ISINU006 ;ISI/NST - Utilities for RPC calls ; 09 Jan 2014 4:16 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
VALIDFLD(FILE,FIELD,VALUE,MESSAGE) ; call to validate value for field in a FM file.
 ; Function is boolean.  Returns:
 ;        0   -  Invalid 
 ;        1   -  Valid 
 ; FILE  : File Number
 ; FIELD  : Field Number
 ; VALUE  : (sent by reference) data value of field
 ; MESSAGE (sent by reference) Result message
 ; 
 N ISIR,ISIMSG,ISISP,ISIRESA,ISIPT
 ; Get the Field number
 I +FIELD'=FIELD S FIELD=$$GETFLDID^ISINU001(FILE,FIELD)
 ;if a BAD field number
 I '$$VFIELD^DILFD(FILE,FIELD) D  Q 0
 . S MESSAGE="The field number: "_FIELD_", in File: "_FILE_", is invalid."
 D FIELD^DID(FILE,FIELD,"","SPECIFIER","ISISP")
 ; If it is a pointer field 
 ; If an  integer - We assume it is a pointer and validate that and Quit.
 ; If not integer - We assume it is external value, proceed to let CHK do validate
 I (ISISP("SPECIFIER")["P"),(+VALUE=VALUE) D  Q ISIPT
 . I $$EXTERNAL^DILFD(FILE,FIELD,"",VALUE)'="" S ISIPT=1 Q
 . S ISIPT=0,MESSAGE="The value: "_VALUE_" for field: "_FIELD_" in File: "_FILE_" is an invalid Pointer."
 . Q
 ;
 D CHK^DIE(FILE,FIELD,"",VALUE,.ISIR,"ISIMSG")
 ; If success, Quit. We changed External to Internal. Internal is in ISIR
 I ISIR'="^" Q 1
 ;  If not success Get the error text and Quit 0
 D MSG^DIALOG("A",.ISIRESA,245,5,"ISIMSG")
 S MESSAGE=ISIRESA(1)
 Q 0
