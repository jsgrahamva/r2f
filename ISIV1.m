ISIV1 ;ISI/GEK,SAF - API BP functions.
 ;;1.0;ISI IMAGING;;Jan 03, 2008;Build 2
 ;
 Q
BACKUP(MAGRY,MAGGDA) ;
 N PLACE,JBPTR,X,ISIBKUP
 S MAGRY=$G(MAGRY)
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 I 'PLACE Q
 S ISIBKUP=$P($G(^MAG(2006.1,PLACE,"ISI")),"^",1)
 I ISIBKUP'=1 Q
 ; 1 means the Client does the Copy to JB
 ;  i.e.  copy to CURRENT PLATTER
 S JBPTR="",X=""
 ;;;;;
 D GETJBP(.X,MAGGDA,.JBPTR) ; ISI
 S MAGRY=MAGRY_"|"_X ; ISI
 I JBPTR]"" S $P(^MAG(2005,MAGGDA,0),"^",5)=JBPTR ; 
 Q
GETJBP(ISIY,IEN,JBPTR) ;[RPC GET JB PATH]
 ;
 N NL,FN,FPATH
 S NL=$$JBCWL()
 I 'NL S ISIY="0^Error Getting Current Write Location" Q
 S FN=$P(^MAG(2005,IEN,0),"^",2)
 S FPATH=$$JBPATH(FN,NL)
 I '$L(FPATH) S ISIY="0^Error Getting JB Path" Q
 S JBPTR=NL
 S ISIY="1^"_FPATH
 Q
JBCWL() ;
 ; This is the CURRENT PLATTER FIELD IN 2006.1
 ; RETURN THE CURRENT WRITE LOCATION FOR A JUKEBOX.
 N PLACE
 S PLACE=$$PLACE^MAGBAPI(DUZ(2)) Q:'PLACE 0
 Q +$P($G(^MAG(2006.1,PLACE,"JBX")),"^",3)
 ; 
JBPATH(FN,JBNL) ;Returns the full path to the JukeBox for a Filename.
 ; AND A NETWORK LOCATION (JUKEBOX)
 Q $P($G(^MAG(2005.2,JBNL,0)),U,2)_$$DIRHASH^MAGFILEB(FN,JBNL)_FN
