UVARPTR(ZVAR,ZTYP)      ;EXTRINSIC WHICH RETURNS THE POINTER TO ZVAR IN THE
        ; CCR DICTIONARY. IT IS LAYGO, AS IT WILL ADD THE VARIABLE TO
        ; THE CCR DICTIONARY IF IT IS NOT THERE. ZTYP IS REQUIRED FOR LAYGO
        ;
        N ZCCRD,ZVARN,C0CFDA2
        S ZCCRD=170 ; FILE NUMBER FOR CCR DICTIONARY
        S ZVARN=$O(^C0CDIC(170,"B",ZVAR,"")) ;FIND IEN OF VARIABLE
        I ZVARN="" D  ; VARIABLE NOT IN CCR DICTIONARY - ADD IT
        . I '$D(ZTYP) D  Q  ; WON'T ADD A VARIABLE WITHOUT A TYPE
        . . W "CANNOT ADD VARIABLE WITHOUT A TYPE: ",ZVAR,!
        . S C0CFDA2(ZCCRD,"?+1,",.01)=ZVAR ; NAME OF NEW VARIABLE
        . S C0CFDA2(ZCCRD,"?+1,",12)=ZTYP ; TYPE EXTERNAL OF NEW VARIABLE
        . D CLEAN^DILF ;MAKE SURE ERRORS ARE CLEAN
        . D UPDATE^DIE("E","C0CFDA2","","ZERR") ;ADD VAR TO CCR DICTIONARY
        . I $D(ZERR) D  ; LAYGO ERROR
        . . W "ERROR ADDING "_ZC0CI_" TO CCR DICTIONARY",!
        . E  D  ;
        . . D CLEAN^DILF ; CLEAN UP
        . . S ZVARN=$O(^C0CDIC(170,"B",ZVAR,"")) ;FIND IEN OF VARIABLE
        . . W "ADDED ",ZVAR," TO CCR DICTIONARY, IEN:",ZVARN,!
        Q ZVARN
