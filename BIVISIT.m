BIVISIT ;IHS/CMI/MWR - ADD/EDIT IMM/SKIN VISITS.;2015-08-31  1:35 PM
 ;;8.5;IMMUNIZATION;**10**;MAY 30,2015;Build 9
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CODE TO ADD V IMMUNIZATION AND V SKIN TEST VISITS.  CALLED BY BIRPC3.
 ;;  PATCH 5: Added BINOM parameter to ADDEDIT P.E.P. for Visit Selection Menu. ADDV+0
 ;;           Added Admin Note, piece 27.  PARSE+36,+66, ADDV+16, VFILE+13,+184
 ;;  PATCH 9: Added save of Admin Date and VIS Presented Date.  VFILE+200
 ;;           If >19yrs on date of immunization and Elig="", set Elig-V01.  VFILE+188
 ;
 ;
 ;----------
PARSE(Y,Z) ;EP
 ;---> Parse out passed Visit and V File data into local variables.
 ;---> Parameters:
 ;     1 - Y (req) String of data for the Visit to be added.
 ;     2 - Z (opt) If Z=1 do NOT set BIVSIT (call from VFILE below must
 ;                 preserve new Visit IEN sent to it).
 ;
 ;---> Pieces of Y delimited by "|":
 ;     -----------------------------
 ;     1 - BIVTYPE (req) "I"=Immunization Visit, "S"=Skin Text Visit.
 ;     2 - BIDFN   (req) DFN of patient.
 ;     3 - BIPTR   (req) Vaccine or Skin Test .01 pointer.
 ;     4 - BIDOSE  (opt) Dose# number for this Immunization.
 ;     5 - BILOT   (opt) Lot Number IEN for this Immunization.
 ;     6 - BIDATE  (req) Date.Time of Visit.
 ;     7 - BILOC   (req) Location of encounter IEN.
 ;     8 - BIOLOC  (opt) Other Location of encounter.
 ;     9 - BICAT   (req) Category: A (Ambul), I (Inpat), E (Event/Hist)
 ;    10 - BIVSIT  (opt) Visit IEN.
 ;    11 - BIOIEN  (opt) Old V File IEN (for edits).
 ;    12 - BIRES   (req) Skin Test Result: P,N,D,O.
 ;    13 - BIREA   (req) Skin Test Reading: 0-40.
 ;    14 - BIDTR   (req) Skin Test Date Read.
 ;    15 - BIREC   (opt) Vaccine Reaction.
 ;    16 - BIVFC   (opt) VFC Eligibility.  vvv83
 ;    17 - BIVISD  (opt) Release/Revision Date of VIS (YYYMMDD).
 ;    18 - BIPROV  (opt) IEN of Provider of Immunization/Skin Test.
 ;    19 - BIOVRD  (opt) Dose Override.
 ;    20 - BIINJS  (opt) ROUTE (#920.2) - SITE (#920.3)
 ;    21 - BIVOL   (opt) Volume.
 ;    22 - BIREDR  (opt) IEN of Reader of Skin Test.
 ;    23 - BISITE  (opt) Passed DUZ(2) for Site Parameters.
 ;    24 - BICCPT  (opt) If created from CPT ^DD BICCPT=1 or IEN; otherwise=""
 ;                       (called from BIRPC6
 ;    25 - BIMPRT  (opt) If =1 it was imported.
 ;    26 - BINDC   (opt) NDC Code IEN pointer to file #9002084.95.
 ;    27 - BIANOT  (opt) Administrative Note (<161 chars).
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Add Admin Date and VIS Presented Date to data being saved.
 ;    28 - BIADMIN (opt) Admin Date (Date shot admin'd to patient.
 ;    29 - BIVPRES (opt) Date VIS Presented to Patient.
 ;
 ;********** PATCH 10, v8.5, MAY 30,2015, IHS/CMI/MWR
 ;    30 - BILOTSK (opt) Skin Test Lot Number.
 ;
 N V S V="|"
 ;
 S BIVTYPE=$P(Y,V,1)
 S BIDFN=$P(Y,V,2)
 S BIPTR=$P(Y,V,3)
 S BIDOSE=$P(Y,V,4)
 S BILOT=$P(Y,V,5)
 S BIDATE=$P(Y,V,6) S:$P(BIDATE,".",2)="" BIDATE=BIDATE_".12"
 S BILOC=$P(Y,V,7)
 S BIOLOC=$P(Y,V,8)
 S BICAT=$P(Y,V,9)
 S:'$G(Z) BIVSIT=$P(Y,V,10)
 S BIOIEN=$P(Y,V,11)
 S BIRES=$P(Y,V,12)
 S BIREA=$P(Y,V,13)
 S BIDTR=$P(Y,V,14) S:BIDTR<1 BIDTR=""
 S BIREC=$P(Y,V,15)
 S BIVFC=$P(Y,V,16)
 S BIVISD=$P(Y,V,17)
 S BIPROV=$P(Y,V,18)
 S BIOVRD=$P(Y,V,19)
 S BIINJS=$P(Y,V,20)
 S BIVOL=$P(Y,V,21)
 S BIREDR=$P(Y,V,22)
 S BISITE=$P(Y,V,23)
 S BICCPT=$P(Y,V,24)
 S BIMPRT=$P(Y,V,25)
 S BINDC=$P(Y,V,26)
 S BIANOT=$P(Y,V,27)
 S BIADMIN=$P(Y,V,28)
 S BIVPRES=$P(Y,V,29)
 S BILOTSK=$P(Y,V,30)
 ;**********
 Q
 ;
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Added BINOM parameter to control Visit Menu display.
 ;----------
ADDV(BIERR,BIDATA,BIOIEN,BINOM) ;EP
 ;---> Add a Visit (if necessary) and V FILE entry for this patient.
 ;---> Called exclusively by ^BIRPC3.
 ;---> Parameters:
 ;     1 - BIERR  (ret) 1^Text of Error Code if any, otherwise null.
 ;     2 - BIDATA (req) String of data for the Visit to be added.
 ;                      See BIDATA definition at linelabel PARSE (above).
 ;     3 - BIOIEN (opt) IEN of V IMM or V SKIN being edited (if
 ;                      not new).
 ;     4 - BINOM  (opt) 0=Allow display of Visit Selection Menu if site
 ;                       parameter is set. 1=No display (for export).
 ;
 I BIDATA="" D ERRCD^BIUTL2(437,.BIERR) S BIERR="1^"_BIERR Q
 ;
 N BIVTYPE,BIDFN,BIPTR,BIDOSE,BILOT,BIDATE,BILOC,BIOLOC,BICAT,BIVSIT
 N BIOIEN,BIRES,BIREA,BIDTR,BIREC,BIVISD,BIPROV,BIOVRD,BIINJS,BIVOL
 N BIREDR,BISITE,BICCPT,BIMPRT,BIANOT,BILOTSK
 ;
 ;---> See BIDATA definition at linelabel PARSE.
 D PARSE(BIDATA)
 ;
 N APCDALVR,APCDANE,AUPNTALK,BITEST,DLAYGO,X
 S BIERR=0
 ;
 ;---> Set BITEST=1 To display VISIT and V IMM pointers after sets.
 ;---> NOTE: This will write directly to IO.  Should be turned OFF
 ;---> (BITEST=0) when not testing in M Programmer mode.
 S BITEST=0
 ;
 ;---> If this is an edit, check or set BIVSIT=IEN of Parent Visit.
 D:$G(BIOIEN)
 .I (BIVTYPE'="I"&(BIVTYPE'="S")) D  Q
 ..D ERRCD^BIUTL2(410,.BIERR) S BIERR="1^"_BIERR
 .;
 .;---> Quit if valid Visit IEN passed.
 .Q:$G(^AUPNVSIT(+$G(BIVSIT),0))
 .;
 .;---> Get Visit IEN from V File entry (and set in BIDATA).
 .N BIGBL S BIGBL=$S(BIVTYPE="I":"^AUPNVIMM(",1:"^AUPNVSK(")
 .S BIGBL=BIGBL_BIOIEN_",0)"
 .;---> Get IEN of VISIT.
 .S BIVSIT=$P($G(@BIGBL),U,3)
 Q:BIERR
 ;
 ;---> Create or edit Visit if necessary.
 ;---> NOTE: BIVSIT, even if sent, might come backed changed (due to
 ;---> change in Date, Category, etc.)
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Added BINOM parameter to control Visit Menu display.
 S:($G(BINOM)="") BINOM=0
 D VISIT^BIVISIT1(BIDFN,BIDATE,BICAT,BILOC,BIOLOC,BISITE,.BIVSIT,.BIERR,BINOM)
 ;**********
 Q:BIERR
 ;
 ;---> Create V FILE entry.
 D VFILE($G(BIVSIT),BIDATA,.BIERR)
 Q:BIERR
 ;
 ;---> If this was a mod to an existing Visit, update VISIT Field .13.
 I $$RPMS^BIUTL9() D:($G(BIOIEN)&($G(BIVSIT)))
 .N AUPNVSIT,DA,DIE,DLAYGO
 .S AUPNVSIT=BIVSIT,DLAYGO=9000010
 .D MOD^AUPNVSIT
 ;
 I $T(^KBANTEST)]"" D  ; Only for Sam to see what happened.
 . N BIVISITDISPLAY,BIVISITDISPLAYE
 . N PXCEVIEN S PXCEVIEN=BIVSIT  ; Some naughty person wants this in the ST.
 . D BUILD^PXCEAE1(BIVSIT,"D",$NA(BIVISITDISPLAY),$NA(BIVISITDISPLAYE))
 . N I F I=0:0 S I=$O(BIVISITDISPLAY(I)) Q:'I  W BIVISITDISPLAY(I,0),!
 . D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
VFILE(BIVSIT,BIDATA,BIERR) ;EP
 ;---> Add (create) V IMMUNIZATION or V SKIN TEST entry for this Visit.
 ;---> Parameters:
 ;     1 - BIVSIT (req) IEN of Parent Visit.
 ;     2 - BIDATA (req) String of data for the Visit to be added.
 ;                      See BIDATA definition at linelabel PARSE.
 ;     3 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;
 ;---> if we are on VISTA, do the VISTA V File update.
 I '$$RPMS^BIUTL9() D VFILE^PXVVISIT(BIVSIT,BIDATA,.BIERR) QUIT
 ;
 I BIDATA="" D ERRCD^BIUTL2(437,.BIERR) S BIERR="1^"_BIERR Q
 ;
 N BIVTYPE,BIDFN,BIPTR,BIDOSE,BILOT,BIDATE,BILOC,BIOLOC,BICAT
 N BIOIEN,BIRES,BIREA,BIDTR,BIREC,BIVISD,BIPROV,BIOVRD,BIINJS,BIVOL
 N BIREDR,BISITE,BICCPT,BIMPRT,BIANOT,BILOTSK
 ;
 ;---> See BIDATA definition at linelabel PARSE (above).
 D PARSE(BIDATA,1)
 ;
 ;---> Fields in V IMMUNIZATION File are as follows:
 ;
 ;       .01 APCDTIMM  Pointer to IMMUNIZATION File (Vaccine)
 ;       .02 APCDPAT   Patient
 ;       .03 APCDVSIT  IEN of Visit
 ;       .04 APCDTSER  Dose# (Series#)
 ;       .05 APCDTLOT  Lot# IEN, Pointer to IMMUNIZATION LOT File
 ;       .06 APCDTREC  Reaction
 ;
 ;       This will no longer be used:
 ;       .07 APCDTCON  Contraindication (Stored in ^BIP.)
 ;
 ;       .12 APCDTVSD  VIS Date (Lori will put in a future template.)
 ;      1204 APCDTEPR  Immunization Provider
 ;
 ;---> Fields in V SKIN TEST File are as follows:
 ;
 ;       .01 APCDTSK   Pointer to IMMUNIZATION File
 ;       .02 APCDPAT   Patient
 ;       .03 APCDVSIT  IEN of Visit
 ;       .04 APCDTRES  Result
 ;       .05 APCDTREA  Reading
 ;       .06 APCDTDR   Date read
 ;      1204 APCDTEPR  Skin Test Provider
 ;
 ;---> Check that a Parent VISIT exists.
 I '$D(^AUPNVSIT(+$G(BIVSIT),0)) D  Q
 .D ERRCD^BIUTL2(432,.BIERR) S BIERR="1^"_BIERR
 ;
 N APCDALVR
 ;
 ;---> Set Visit pointer.
 S APCDALVR("APCDVSIT")=BIVSIT
 ;
 ;---> Set Patient.
 S APCDALVR("APCDPAT")=BIDFN
 ;
 ;
 ;
 ;---> * * * If this is an IMMUNIZATION, set APCD array for Immunizations. * * *
 ;
 I BIVTYPE="I" D
 .;
 .;---> Set permission override for this file.
 .S DLAYGO=9000010.11
 .;
 .;---> Immunization/vaccine name.
 .S APCDALVR("APCDTIMM")="`"_BIPTR
 .;
 .;---> Dose# for this immunization.
 .;S:'$G(BIDOSE) BIDOSE=""
 .;S APCDALVR("APCDTSER")=BIDOSE
 .;
 .;---> Lot Number IEN for this immunization.
 .S:'$G(BILOT) BILOT=""
 .;---> Lot Number passed to PCC more reliably if prepend "`".
 .;---> Imm v8.5: Handle Lot Number below
 .;S:BILOT BILOT="`"_BILOT
 .;S APCDALVR("APCDTLOT")=BILOT
 .;
 .;---> Reaction to this vaccine on this Visit.
 .S:'$G(BIREC) BIREC=""
 .S APCDALVR("APCDTREC")=BIREC
 .;
 .;---> Immunization Provider ("Shot giver").
 .S:$G(BIPROV) APCDALVR("APCDTEPR")="`"_BIPROV
 .;
 .;---> User who last edited this Immunization.
 .S:$G(DUZ) APCDALVR("APCDTULU")="`"_DUZ
 .;
 .;---> Template to add encounter to V IMMUNIZATION File.
 .S APCDALVR("APCDATMP")="[APCDALVR 9000010.11 (ADD)]"
 ;
 ;
 ;
 ;---> * * * If this is a SKIN TEST, set APCD array for Skin Tests.  * * *
 ;
 I BIVTYPE="S" D
 .;
 .;---> Set permission override for this file.
 .S DLAYGO=9000010.12
 .;
 .;---> Skin Test name.
 .S APCDALVR("APCDTSK")="`"_BIPTR
 .;
 .;---> Skin Test Result.
 .S APCDALVR("APCDTRES")=BIRES
 .;
 .;---> Skin Test Reading (mm).
 .S APCDALVR("APCDTREA")=BIREA
 .;
 .;---> Skin Test Date Read.
 .S APCDALVR("APCDTDR")=BIDTR
 .;
 .;---> Skin Test Provider (Person who administered the test).
 .S:$G(BIPROV) APCDALVR("APCDTEPR")="`"_BIPROV
 .;
 .;---> Template to add encounter to V SKIN TEST File.
 .S APCDALVR("APCDATMP")="[APCDALVR 9000010.12 (ADD)]"
 ;
 ;
 ;---> * * *  CALL TO APCDALVR.  * * *
 D EN^APCDALVR
 D:$G(BITEST) DISPLAY2^BIPCC
 ;
 ;---> Quit if a V File entry was not created.
 I '$G(APCDALVR("APCDADFN"))!($D(APCDALVR("APCDAFLG"))) D  Q
 .I BIVTYPE="I" D ERRCD^BIUTL2(402,.BIERR) S BIERR="1^"_BIERR Q
 .I BIVTYPE="S" D ERRCD^BIUTL2(413,.BIERR) S BIERR="1^"_BIERR
 ;
 ;Returns:  APCDADFN - IEN of V IMMUNIZATION File entry.
 ;          APCDAFLG - =2 If FAILED to create a V FILE entry.
 ;
 ;
 ;---> Save IEN of V IMMUNIZATION just created.
 N BIADFN S BIADFN=APCDALVR("APCDADFN")
 ;
 ;
 ;---> ADD OTHER V SKIN TEST FIELDS:
 ;---> If this is a Skin Test, add Skin Test Reader and Quit.
 I BIVTYPE="S" D  Q
 .;---> Store Additional data.
 .N BIFLD
 .S BIFLD(.08)=BIREDR,BIFLD(.09)=BIINJS,BIFLD(.11)=BIVOL
 .;
 .;********** PATCH 10, v8.5, MAY 30,2015, IHS/CMI
 .;---> BILOTSK (opt) Skin Test Lot Number.
 .S BIFLD(.14)=BILOTSK
 .;
 .;---> Set DATE/TIME LAST MODIFIED, per Lori Butcher, 5/26/12
 .S:$G(BIOIEN) BIFLD(1218)=$$NOW^XLFDT
 .;
 .D FDIE^BIFMAN(9000010.12,BIADFN,.BIFLD,.BIERR)
 .I BIERR=1 D ERRCD^BIUTL2(421,.BIERR) S BIERR="1^"_BIERR
 .;
 .;---> If Skin Test is a PPD and result is Positive, add Contraindication
 .;---> to further TST-PPD tests.
 .I $$SKNAME^BIUTL6($G(BIPTR))="PPD",$E($G(BIRES))="P" D
 ..;---> Set date equal to either Date Read, or Date of Visit, or Today.
 ..N BIDTC S BIDTC=$S($G(BIDTR):BIDTR,$G(BIDATE):$P(BIDATE,"."),1:$G(DT))
 ..S BIDATA=BIDFN_"|"_203_"|"_17_"|"_BIDTC
 ..D ADDCONT^BIRPC4(,BIDATA)
 ;
 ;
 ;---> ADD OTHER V IMMUNIZATION FIELDS:
 ;---> Quit if this is not an Immunization.
 Q:BIVTYPE'="I"
 ;
 ;---> Add VIS, Dose Override, Injection Site and Volume data.
 ;---> Build DR string.
 ;
 S:(BIVISD<1) BIVISD="@" S:BIOVRD="" BIOVRD="@"
 ;
 S:BIINJS="" BIINJS="@" S:BIVOL="" BIVOL="@"
 S:BILOT="" BIILOT="@" S:BINDC="" BINDC="@"
 ;
 ;---> Store Additional data.
 N BIFLD
 S BIFLD(.05)=BILOT
 S BIFLD(.08)=BIOVRD,BIFLD(.09)=BIINJS
 S BIFLD(.11)=BIVOL,BIFLD(.12)=BIVISD,BIFLD(.13)=BICCPT
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> If patient is 19yrs or older at the time of the immunization,
 ;---> and Eligibility is null, set Eligibility=V01.
 D
 .Q:(BIVFC]"")
 .N BIAGDT S BIAGDT=$S($G(BIADMIN):BIADMIN,1:BIDATE)
 .I $$AGE^BIUTL1(BIDFN,1,BIAGDT)>18 S BIVFC=$O(^BIELIG("B","V01",0))
 ;**********
 ;
 S BIFLD(.14)=BIVFC
 S BIFLD(.15)=$S(BIMPRT>0:2,1:"")
 S BIFLD(.16)=BINDC
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Added Admin Note, piece 27.
 S:($G(BIANOT)]"") BIFLD(1)=BIANOT
 ;**********
 ;
 ;********** PATCH 3, v8.5, SEP 10,2012, IHS/CMI/MWR
 ;---> Set DATE/TIME LAST MODIFIED, per Lori Butcher, 5/26/12
 S:$G(BIOIEN) BIFLD(1218)=$$NOW^XLFDT
 ;**********
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Add Admin Date and VIS Presented Date to data being saved.
 ;    28 - BIADMIN  Admin Date (Date shot admin'd to patient.
 ;    29 - BIVPRES  Date VIS Presented to Patient.
 ;
 S BIFLD(1201)=BIADMIN
 S BIFLD(.17)=BIVPRES
 ;**********
 ;
 D FDIE^BIFMAN(9000010.11,BIADFN,.BIFLD,.BIERR)
 I BIERR=1 D  Q
 .D ERRCD^BIUTL2(421,.BIERR) S BIERR="1^"_BIERR
 ;
 ;
 ;---> If there was an anaphylactic reaction to this vaccine,
 ;---> add it as a contraindication for this patient.
 D:BIREC=9
 .Q:'$G(BIDFN)  Q:'$G(BIPTR)  Q:'$G(BIDATE)
 .N BIREAS S BIREAS=$O(^BICONT("B","Anaphylaxis",0))
 .Q:'BIREAS
 .;
 .N BIADD,N,V S N=0,BIADD=1,V="|"
 .;---> Loop through patient's existing contraindications.
 .F  S N=$O(^BIPC("B",BIDFN,N)) Q:'N  Q:'BIADD  D
 ..N X S X=$G(^BIPC(N,0))
 ..Q:'X
 ..;---> Quit (BIADD=0) if this contra/reason/date already exists.
 ..I $P(X,U,2)=BIPTR&($P(X,U,3)=BIREAS)&($P(X,U,4)=BIDATE) S BIADD=0
 .Q:'BIADD
 .;
 .D ADDCONT^BIRPC4(.BIERR,BIDFN_V_BIPTR_V_BIREAS_V_BIDATE)
 .I $G(BIERR)]"" S BIERR="1^"_BIERR
 ;
 ;---> Now trigger New Immunization Trigger Event.
 D TRIGADD
 Q
 ;
 ;
 ;----------
TRIGADD ;EP
 ;---> Immunization Added Trigger Event call to Protocol File.
 D TRIGADD^BIVISIT2
 Q
 ;
 ;
 ;----------
VFILE1 ;EP
 ;---> Add (create) V IMMUNIZATION from ^DD of V CPT.
 ;---> Called from EN^XBNEW, from CPTIMM^BIRPC6
 ;---> Local Variables:
 ;     1 - BIVSIT (req) IEN of Parent Visit.
 ;     2 - BIDATA (req) String of data for the Visit to be added.
 ;                      See BIDATA definition at linelabel PARSE.
 ;
 Q:'$G(BIVSIT)  Q:'$D(BIDATA)
 D VFILE(BIVSIT,BIDATA)
 Q
 ;
 ;
 ;----------
IMPORT(APCDALVR) ;PEP - Code to flag V Imm as "Imported."
 ;---> Code for Tom Love to flag entry as Imported From Outside Registry.
 ;---> Parameters:
 ;     1 - APCDALVR (req) Array returned from call to EN^APCDALVR.
 ;                   APCDALVR("APCDADFN") - IEN of V IMMUNIZATION File entry.
 ;                   APCDALVR("APCDAFLG") - =2 If FAILED to create a V FILE entry.
 ;
 Q:($G(APCDALVR("APCDAFLG")))
 Q:('$G(APCDALVR("APCDADFN")))
 N BIADFN S BIADFN=APCDALVR("APCDADFN")
 ;
 ;---> Add Import From Outside.
 N BIFLD S BIFLD(.15)=1
 D FDIE^BIFMAN(9000010.11,BIADFN,.BIFLD,.BIERR)
 Q
