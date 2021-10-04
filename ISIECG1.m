ISIECG1 ;ISI/GEK,SAF - API  ECG Functions
 ;;1.0;ISI IMAGING;;Jan 27, 2010;Build 2
 ;      
 Q
 ; ******  CONS is the RPC Call from the ISI ECG Window 
 ;         that will result the Consult and create a new TIU Note.
 ;              
 ;              MAGRY is the return array in the usual format
 ;              (0)= 0^ error message 
 ;                        or
 ;              (0)= 1^ success message.
 ;              
 ;              INPUT :
 ;              
 ;              MAGDFN : Patient DFN
 ;              MAGIEN : Image IEN
 ;              MAGDATA  : This is an '^' delimited string of field code '|' field data
 ;                    i.e.  MAGTITLE|7^MAGADCL|1^MAGMODE|E^....
 ;                    Possible fields for now are
 ;                   MAGTITLE,MAGADCL,MAGMODE,  
 ;                   MAGES,MAGESBY,MAGLOC,MAGDATE,MAGCNSLT,
 ;                   and easily expandable to future data if needed.
 ;              
 ;              MAGARR : is the input array contains the Report Data to be filed 
 ;              in the New TIU Note.  it is in the form 
 ;              (0) = Line 1
 ;              (1..n) Line 2 .. n
 ;              =>   we will get the data for 
 ;                   the new TIU Note from successive nodes of the MAGARR
 ;                   array.  We put into the MAGTEXT Array to 
 ;                   send to the call to make new TIU Note.
 ;              
 ;   The MAGDATA String will be parsed to get the data.
 ;   The existing API is called : NEW^MAGGNTI1 
 ;   it will create the note and result the Consult.
 ;   
CONS(MAGRY,MAGDFN,MAGIEN,MAGDATA,MAGARR) ; RPC :  [ISI2 ECG CONSULT]
 ; 
 N $ETRAP,$ESTACK S $ETRAP="D ERRA^MAGGTERR"
 S MAGRY(0)="0^processing request..."
 ;These are the possible Input array nodes.  They coorespond to the Input Parameters 
 ;   that are needed to create a new note.
 N MAGTITLE,MAGADCL,MAGMODE,MAGES,MAGESBY,MAGLOC,MAGDATE,MAGCNSLT
 S (MAGTITLE,MAGADCL,MAGMODE,MAGES,MAGESBY,MAGLOC,MAGDATE,MAGCNSLT)=""
 N NUM,NDAT,LINE,ICT,MAGRYN,OK
 ;
 N MAGISC,DFT
 D DEBUG
 ;
 S MAGDFN=$G(MAGDFN) I '$$ISDFNOK(.RES,MAGDFN) S MAGRY(0)=RES Q
 S MAGIEN=$G(MAGIEN) I '$$ISIENOK(.RES,MAGIEN) S MAGRY(0)=RES Q
 ;
 S MAGDATA=$G(MAGDATA)
 ; 
 ; We'll get the global defaults 
 ; if data exists for these fields in the input array, 
 ;   then the Defaults Will be overwritten.  Thats as designed.
 S DFT=$G(^MAG(2006.1,"ISIECG")) ; example: "19^1^E^7^Note created from ISI ECG Window"
 S MAGTITLE=$P(DFT,"^",1) ; IEN of TIU Title
 S MAGADCL=$P(DFT,"^",2) ; Admin Close allowed 1 Yes  0 No
 S MAGMODE=$P(DFT,"^",3) ; "E" Means Electronically Filed.
 S MAGLOC=$P(DFT,"^",4) ; Hospital Location,  needed for New Note.
 ; default text for first line of TIU Note.
 I $L($P(DFT,"^",5))>0 S MAGTEXT(0)=$P(DFT,"^",5)
 ;
 S MAGES=""
 S MAGESBY=DUZ ;
 S MAGDATE=$$NOW^XLFDT ;
 ; END Setting Defaults;
 ; 
 ;  If MAGTEXT is empty, default text will be put in to the TIU Note from
 ;   the call to NEW^MAGGNTI, also, if text is in the Defaults, use it as 
 ;   first line.
 ;   
 ; MAGTEXT(0) is set to the default above;
 S ICT=2
 S I="" F  S I=$O(MAGARR(I)) Q:I=""  D
 . S LINE=$TR(MAGARR(I),"^","")
 . S MAGTEXT(ICT)=LINE
 . S ICT=ICT+1
 . Q
 ;
 ;Parse DATA ,  DATA can.. ( for now)  be Null.
 I ($L(MAGDATA,"^"))>0 D
 . S NUM=$L(MAGDATA,"^")
 . F I=1:1:NUM  S NDAT=$P(MAGDATA,"^",I) 
 . S IFLD=$P(NDAT,"|",1),IDATA=$P(NDAT,"|",2)
 . ;I IFLD]"" I IDATA]"" S @IFLD=IDATA ; Doesn't allow Null values.
 . I IFLD]"" S @IFLD=IDATA ; This allows the field value sent from Delph
 . ;                          to be null.
 . Q
 ;
 ;
 ; HERE the input data has been parsed.
 ; 
 ; If this title is a CONSULT, then Get the CONSULT DA from the GMRC Temp file.
 ; NOTE: it will usually be a consult.  But we'll allow Not a Consult, so we can
 ; test creating of the TIU Note.. and Linking IMAGE <-> TIU Note
 ; 
 D ISCNSLT^TIUCNSLT(.MAGISC,MAGTITLE)
 I MAGISC D GETCONS(.MAGCNSLT,MAGIEN) I 'MAGCNSLT D  Q
 . S MAGRY(0)=MAGCNSLT
 . Q
 ;
 ; Save all params in GEKTMP for debugging.
 D DEBUGZ ;
 ;
 ; The return from this call is a string, not an array
 D NEW^MAGGNTI1(.MAGRYN,MAGDFN,MAGTITLE,MAGADCL,MAGMODE,MAGES,MAGESBY,MAGLOC,MAGDATE,MAGCNSLT,.MAGTEXT) ;
 ; 
 S MAGRY(0)=MAGRYN
 ;Link Note to Image if Creating Note was successful
 I MAGRYN D  ;
 . D FILE^MAGGNTI(.RY,MAGIEN,+MAGRYN) ;This is RPC called from Capture [MAG3 TIU IMAGE]
 . ; Here it gets a little tricky.  Note was filed okay, but Link to Image Failed
 . I 'RY D  ;
 . . S MAGRY(0)="0^Note Created Okay. Failed to Link Image"
 . . S MAGRY(1)=MAGRYN
 . . S MAGRY(2)=RY
 . Q
 Q
 ; **** GETCONS
 ;   Return the Consult DA (GMRCDA) from the Temp GMRC Imaging File (^MAG(2006.5839)
GETCONS(GMRCDA,MAGIEN) ;
 N I
 S GMRCDA="0^Consult doesn't exist for Image: "_MAGIEN
 S I=0 F  S I=$O(^MAG(2006.5839,I)) Q:'I  D
 . I MAGIEN=$P(^MAG(2006.5839,I,0),"^",3) S GMRCDA=$P(^MAG(2006.5839,I,0),"^",2)
 . Q
 Q
ISDFNOK(OK,MAGDFN) ;
 I 'MAGDFN S OK="0^Error: Null Patient Identifier." Q 0
 I '$D(^DPT(MAGDFN)) S OK="0^Error: Invalid Patient: "_MAGDFN Q 0
 Q 1
 ;
ISIENOK(OK,MAGIEN) ;
 N PAR
 I 'MAGIEN S OK="0^Error: Null Image Identifier." Q 0
 I '$D(^MAG(2005,MAGIEN)) S OK="0^Error: Invalid Image: "_MAGIEN Q 0
 S PAR=$P($G(^MAG(2005,MAGIEN,2)),"^",6)
 I (PAR=8925) I $P($G(^MAG(2005,MAGIEN,2)),"^",7) S OK="0^Error: Image is already linked to Report." Q 0
 Q 1
 ;
TESTDFT ; this sets the global defaults for testing
 ; We can default :
 ;  $p(1)    The TIU Note TITLE  (of CONSULT Class)
 ;                   (it'll still work if it's not a Consult.)
 ;  $p(2)    If we allow Administrative Closure 1|0
 ;  $p(3)    The "Mode" of closure  if 1 above
 ;            "S" = Scanned Document 
 ;            "M" = Manual closure,
 ;            "E" = Electronically Filed
 ;  $p(4)    The Hospital Location
 ;  
 ;
 ;  $P(1)  ^TIU(8925.1,19,0)=FINAL DISCHARGE NOTE^FDN^Final Discharge Note 
 ;         ^TIU(8925.1,10,0)=GENERAL NOTE^GPN^General Note
 
 ;   Consult =>  
 ;       ^TIU(8925.1,1376,0)=CARE COORDINATION HOME TELEHEALTH SCREENING CONSULT
 ;       ^TIU(8925.1,1402,0)=NEW GEK CONSULT^
 ;       
 ;  $P(4)  ^SC(7,0)=RADIOLOGY^
 ;  
 ;  $p(5)  "Text to use as first line of TIU Note"
 ;  
 S ^MAG(2006.1,"ISIECG")="19^1^E^7^Note created from ISI ECG Window"
 Q
DEBUG ;
 ;;;;;;;;;;;; TESTING
 S GEKCT=$O(^GEKTMP("ISIECG1",""),-1)+1
 S ^GEKTMP("ISIECG1",GEKCT,"MAGDFN")=$G(MAGDFN)
 S ^GEKTMP("ISIECG1",GEKCT,"MAGIEN")=$G(MAGIEN)
 S ^GEKTMP("ISIECG1",GEKCT,"MAGDATA")=$G(MAGDATA)
 M ^GEKTMP("ISIECG1",GEKCT,"MAGARR")=MAGARR
 Q 
DEBUGZ ;
 I '$D(GEKCT) S GEKCT=$O(^GEKTMP("ISIECG1",""),-1)+1
 S ^GEKTMP("ISIECG1",GEKCT,"Z","MAGDFN")=$G(MAGDFN)
 S ^GEKTMP("ISIECG1",GEKCT,"Z","MAGTITLE")=$G(MAGTITLE)
 S ^GEKTMP("ISIECG1",GEKCT,"Z","MAGADCL")=$G(MAGADCL)
 S ^GEKTMP("ISIECG1",GEKCT,"Z","MAGMODE")=$G(MAGMODE)
 S ^GEKTMP("ISIECG1",GEKCT,"Z","MAGES")=$G(MAGES)
 S ^GEKTMP("ISIECG1",GEKCT,"Z","MAGESBY")=$G(MAGESBY)
 S ^GEKTMP("ISIECG1",GEKCT,"Z","MAGLOC")=$G(MAGLOC)
 S ^GEKTMP("ISIECG1",GEKCT,"Z","MAGDATE")=$G(MAGDATE)
 S ^GEKTMP("ISIECG1",GEKCT,"Z","MAGCNSLT")=$G(MAGCNSLT)
 M ^GEKTMP("ISIECG1",GEKCT,"Z","MAGTEXT")=MAGTEXT
 Q
 
