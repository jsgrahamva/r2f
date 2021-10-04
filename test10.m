test10	;
        S IBX=$P($T(@(SET_"DR")+1),";;",2),EXTFILE=+$P(IBX,U,1),DRBUF=$P(IBX,U,2),DREXT=$P(IBX,U,3)
        ;
        D GETS^DIQ(355.33,IBBUFDA,DRBUF,"E","BUFARR")
        D GETS^DIQ(EXTFILE,IBEXTDA,DREXT,"E","EXTARR")
        ;
        I +$G(TYPE) S IBBUFFLD=0 F  S IBBUFFLD=$O(BUFARR(355.33,IBBUFDA,IBBUFFLD)) Q:'IBBUFFLD  D
        . ;If not called by ACCEPAPI^IBCNICB API, don't update from these
        . ;fields:
        . ;   Insurance Company Name - #20.01, Reimburse? - 20.05
        . ;   Is this a Group Policy - #40.01
        . I $G(IBSUPRES)'>0,"^20.01^20.05^40.01^"[("^"_IBBUFFLD_"^") Q
        . ;
        . S IBCHNG(EXTFILE,IBEXTDA,IBEXTFLD)=IBBUFVAL
        . ;For ACCEPAPI^IBCNICB do not delete the .01 field. This prevents a
        . ;Data Dictionary Deletion Write message
        . Q:IBEXTFLD=".01"
        . S IBCHNGN(EXTFILE,IBEXTDA,IBEXTFLD)=""
        ;
        I $D(IBCHNGN)>9 D FILE^DIE("E","IBCHNGN","IBERR")
        ;Removed delete errors and move FM errors to RESULT
        D:$D(IBERR)>0 REMOVDEL(.IBERR),EHANDLE(SET,.IBERR,.RESULT)
        K IBERR
        I $D(IBCHNG)>9 D FILE^DIE("E","IBCHNG","IBERR")
        ;Move FM errors to RESULT
        D:$D(IBERR)>0 EHANDLE(SET,.IBERR,.RESULT)
        Q

