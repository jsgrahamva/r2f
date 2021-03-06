BIUTL4 ;IHS/CMI/MWR - UTIL: SCREENMAN CODE;2015-08-31  1:24 PM
 ;;8.5;IMMUNIZATION;**10**;MAY 30,2015;Build 9
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY: SCREENMAN CODE: VAC SELECT ACTIONS, SERIES VALID,
 ;;           LOC BRANCHING LOGIC, VISIT LOC DEF, SKIN TEST READ MM.
 ;;  PATCH 2: Comment out code that would disable VFC Elig field for
 ;            patients >19yrs.  OLDDATE+15
 ;;  PATCH 5: Add NDC to reset fields when vaccine is changed.  VACCHG+14
 ;;  PATCH 5: Add leading zero to default volume if less than 1.  VISVOL+21
 ;;  PATCH 9: Make VIS Presented Date default to Visit Date (when changed).  OLDATE+9
 ;;  PATCH 10: Only stuff VIS Presented Date if this is a V Imm.  OLDDATE+18
 ;
 ;----------
VACSCR ;EP
 ;ZEXCEPT:DIR
 ;---> Set Screen for vaccine selection in Screen field of
 ;---> "Form Only Field Parameters" of the Form BI FORM-IMM VISIT ADD/EDIT
 ;---> when selecting vaccine.
 ;---> Screen: If this vaccine is Active OR if this is an Historical Event
 ;--->         AND this is NOT a Skin Test.
 ;
 S DIR("S")="I ('$P(^AUTTIMM(Y,0),U,7)!($G(BI(""I""))=""E""))"
 S DIR("S")=DIR("S")_"&('$P(^AUTTIMM(Y,0),U,8))"
 Q
 ;
 ;
 ;----------
VACSEL(BIVAC) ;EP
 ;ZEXCEPT:BI
 ;---> For IMMUNIZATIONS:
 ;---> Actions to take in Screenman when Vaccine is selected.
 ;---> Called by the POST ACTION of Field 2, Vaccine
 ;---> of the Form BI FORM-IMM VISIT ADD/EDIT.
 ;---> Parameters:
 ;     1 - BIVAC (req) IEN of Vaccine in IMM File (9999999.14).
 ;
 ;---> Display Vaccine Short Name below Vaccine Name.
 Q:('$G(BIVAC))
 S BI("B")=BIVAC
 D PUT^DDSVALF(2.5,,,"("_$$VNAME^BIUTL2(BIVAC)_")")
 Q
 ;
 ;
 ;----------
VACSELC(BIVAC) ;EP
 ;ZEXCEPT:BI
 ;---> For CONTRAINDICATIONS:
 ;---> Actions to take in Screenman when Vaccine is selected.
 ;---> Called by the POST ACTION of Field 2, Vaccine
 ;---> of the Form BI FORM-CONTRAINDICATION ADD.
 ;---> Parameters:
 ;     1 - BIVAC (req) IEN of Vaccine in IMM File (9999999.14).
 ;
 ;---> If a vaccine has not been chosen, then disable the Reason field.
 I '$G(BIVAC) D  Q
 .D HLP^DDSUTL("You must first choose a vaccine."),HLP^DDSUTL("$$EOP")
 .;---> Make Reason uneditable.
 .D UNED^DDSUTL(4,,,1)
 ;
 ;---> Make Reason editable.
 D UNED^DDSUTL(4,,,0)
 ;---> Display Vaccine Short Name below Vaccine Name.
 S BI("B")=BIVAC
 D PUT^DDSVALF(2.5,,,"("_$$VNAME^BIUTL2(BIVAC)_")")
 Q
 ;
 ;
 ;----------
VACCHG(BIVAC) ;EP
 ;ZEXCEPT:BI
 ;---> Actions to take in Screenman when the Vaccine is selected
 ;---> or changed.
 ;---> Called by the POST ACTION ON CHANGE of Field 2, Vaccine"
 ;---> of the Form BI FORM-IMM VISIT ADD/EDIT.
 ;---> Parameters:
 ;     1 - BIVAC  (req) IEN of Vaccine IMMUNIZATION File (9999999.14).
 ;
 Q:'$G(BIVAC)
 ;
 ;---> If this is NOT a new visit, inform user that Dose#, Lot#,
 ;---> Reaction, and VIS will be deleted and replaced.
 D:$G(BI("K"))
 .N BIMSG
 .;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 .;---> Add NDC to reset fields when vaccine is changed.
 .S BIMSG="* NOTE: Because you have changed the vaccine, Dose Override,"
 .;S BIMSG=BIMSG_"Lot#, and any Reaction and VIS will be removed or replaced"
 .S BIMSG=BIMSG_"Lot#, NDC, and any Reaction and VIS will be removed or replaced"
 .S BIMSG=BIMSG_" with defaults for the new vaccine."
 .D HLP^DDSUTL(BIMSG),HLP^DDSUTL("$$EOP")
 ;
 ;---> Clear data relating to previous Vaccine (if any).
 D PUT^DDSVALF(3) S BI("D")=""    ;Lot# IEN
 D PUT^DDSVALF(13) S BI("O")=""   ;Reaction
 D PUT^DDSVALF(10) S BI("Q")=""   ;VIS
 D PUT^DDSVALF(14) S BI("S")=""   ;Dose Override
 D PUT^DDSVALF(5) S BI("W")=""    ;Volume
 I $$RPMS^BIUTL9() D
 . D PUT^DDSVALF(3.8) S BI("H")=""  ;NDC
 ;**********
 ;
 ;---> If Category is Historical Event, do not stuff Lot# and VIS defaults.
 Q:$G(BI("I"))="E"
 ;
 ;---> If this Vaccine has a Default ("Current") Lot#, then stuff it.
 N BIX
 I '$G(BI("D")) D
 .S BIX=$$LOTDEF^BIUTL2(BIVAC)
 .I BIX D PUT^DDSVALF(3,,,BIX,"I") S BI("D")=BIX
 ;
 D VISVOL(BIVAC)
 Q
 ;
 ;
 ;----------
VISVOL(BIVAC) ;EP
 ;ZEXCEPT:BI
 ;---> Stuff VIS and Volume defaults for a Lot Number on
 ;---> the Form BI FORM-IMM VISIT ADD/EDIT.
 ;---> Parameters:
 ;     1 - BIVAC (req) IEN of Vaccine in IMM File (9999999.14).
 ;
 Q:'$G(BIVAC)
 N BIX
 ;---> If this Vaccine has a Default VIS, stuff it.
 D:'$G(BI("Q"))
 .S BIX=$$VISDEF^BIUTL2(BIVAC)
 .I BIX D PUT^DDSVALF(10,,,BIX,"I") S BI("Q")=BIX
 ;
 ;---> If this is a new visit, stuff Volume Default.
 D:'$G(BI("K"))
 .N X S X=$$CODE^BIUTL2(BIVAC,5)
 .Q:'X
 .;---> For Influenza CVX 15, if patient is <36 mths change default=.25 ml.
 .D:BIVAC=148
 ..Q:'$G(BIDFN)  S:$$AGE^BIUTL1(BIDFN)<36 X=".25"
 .;
 .;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 .;---> Add leading zero to default volume if less than 1.
 .S:(X<1) X="0"_X
 .;**********
 .S BI("W")=X D PUT^DDSVALF(5,,,BI("W"),"I")
 ;
 Q
 ;
 ;
 ;----------
LOTDUP(BILIEN) ;EP
 ;---> Return 1 if the Lot# has a duplicate in the IMMUNIZATION LOT
 ;---> File; 0 if it is unique.
 ;---> Parameters:
 ;     1 - BILIEN  (req) IEN of Lot# in IMMUNIZATION LOT File.
 ;
 Q:'$G(BILIEN) 0
 Q:'$D(^AUTTIML(BILIEN,0)) 0
 ;
 ;---> If Lot# is duplicated in the IMM LOT File, return 1.
 N Y,Z S Y=$P(^AUTTIML(BILIEN,0),U) S Z=$O(^AUTTIML("B",Y,0))
 Q:$O(^AUTTIML("B",Y,Z)) 1
 ;---> Lot# is unique, return 0.
 Q 0
 ;
 ;
 ;----------
LOTHELP(BILIEN) ;EP
 ;ZEXCEPT:BI,DDSBR
 ;---> If chosen Lot# is a duplicate, provide help message.
 ;---> Parameters:
 ;     1 - BILIEN  (req) IEN of Lot# in IMMUNIZATION LOT File.
 N BIPOP,X
 Q:'$$LOTDUP(BILIEN)
 ;
 D TITLE^BIUTL5("DUPLICATE LOT NUMBERS")
 S X="--> Lot# "_$$LOTTX^BIUTL6(BILIEN)_" <--" D CENTERT^BIUTL5(.X)
 W X,!
 D
 .I $$MAYMANAG^BIUTL11 D  Q
 ..D TEXT2^BIUTL6,DIRZ^BIUTL3(.BIPOP)
 ..Q:$G(BIPOP)
 ..D TITLE^BIUTL5("DUPLICATE LOT NUMBERS"),TEXT3^BIUTL6
 .D TEXT1^BIUTL6
 D:'$G(BIPOP) DIRZ^BIUTL3()
 D REFRESH^DDSUTL
 S BI("D")="",DDSBR=3 D PUT^DDSVALF(3)
 Q
 ;
 ;
 ;----------
LOTSCR ;EP
 ;ZEXCEPT:BI,DIR,Y
 ;---> Set Screen for Lot Number selection in Screen field of
 ;---> "Form Only Field Parameters" of the Form BI FORM-IMM VISIT ADD/EDIT
 ;---> when selecting Lot Number.
 ;---> Screen: If this Lot Number is Active, AND if no Vaccine has been selected OR
 ;--->         this Lot Number is assigned to the selected Vaccine,
 ;--->         AND if EITHER [it has no specific Location] OR
 ;--->         [its Location matches the user's Location (DUZ(2))].
 ;
 N BILOC S BILOC=$P($G(^AUTTIML(+Y,0)),U,14)
 ;
 ;---> Next line: Concat to avoid suspected naked ref.
 S DIR("S")="I $P(^"_"(0),U,3)=0,($G(BI(""B""))=""""!$D(^AUTTIML(""C"",+$G(BI(""B"")),Y)))"
 S DIR("S")=DIR("S")_",(('$P($G(^AUTTIML(Y,0)),U,14))!($P($G(^AUTTIML(Y,0)),U,14)=$G(DUZ(2))))"
 Q
 ;
 ;
 ;----------
LOTSEL(BIX) ;EP
 ;ZEXCEPT:BI
 ;---> Action to take after Lot Number has been selected.
 ;---> Parameters:
 ;     1 - BIX (req) X=Internal Value of Lot Number selected.
 ;
 ;---> Executed from the "POST ACTION ON CHANGE" field of the
 ;---> "Form ONly Field Properties" of the Form BI FORM-IMM VISIT ADD/EDIT.
 ;
 ;---> Action: If a Vaccine was not chosen, but instead a Lot Number was entered first,
 ;---> then populate the Vaccine field on the form (which triggers VACCHG above).
 ;
 Q:'BIX
 ;
 D
 .;---> Don't change the Vaccine if it has already been selected.
 .Q:(+$G(BI("B")))
 .;---> Stuff Vaccine IEN for this Lot Number.
 .N BIVAC S BIVAC=$$LOTTX^BIUTL6(BIX,1)
 .D PUT^DDSVALF(2,,,BIVAC,"I")
 .D VACSEL(BIVAC)
 .D LOTWARN^BIUTL7($G(BI("D")),$G(BI("E")),$G(BI("F")))
 .D VISVOL(BIVAC)
 ;
 D
 .;---> Stuff default NDC IEN for this Lot Number.
 .Q:(+$G(BI("H")))
 .N BINDC S BINDC=$$LOTTX^BIUTL6(BIX,3)
 .I BINDC D PUT^DDSVALF(3.8,,,BINDC,"I")
 ;
 Q
 ;
 ;
 ;----------
NDCSCR ;EP
 ;ZEXCEPT:BI,DIR
 ;---> Set Screen for NDC Code selection in Screen field of
 ;---> "Form Only Field Parameters" of the Form BI FORM-IMM VISIT ADD/EDIT
 ;---> when selecting NDC Code.
 ;---> Screen: If this NDC is Active, AND this NDC is assigned to the selected
 ;---> vaccine in BI("B").
 ;
 ;W !!,"This screen in NDCSCR^BIUTL4",! X ^O
 S DIR("S")="I $P(^BINDC(Y,0),U,6)'=1,$D(^BINDC(""C"",+$G(BI(""B"")),Y))"
 Q
 ;
 ;
 ;----------
CREASCR() ;EP
 ;ZEXCEPT:BI,Y
 ;---> Set Screen for Contraindication Reason selection in Reason field
 ;---> VEN/SMH - All of this is changed now. We now will point to 920.4 for
 ;--->           both VISTA and RPMS.
 ;--->           Rather than setting DIC("S") here, we will become DIC("S"),
 ;--->           such that the form will S DIR("S")="I $$CREASCR^BIUTL4()"
 ;---> "Form Only Field Parameters" of the Form BI FORM-CONTRAINDICATION ADD.
 ;---> Screen: If this Reason is Active AND if this Reason is Skin Test
 ;--->         related AND this Vaccine is a Skin Test.
 ;
 ; OLD RPMS CODE
 ;---> If no vaccine chosen, then screen says all reasons are invalid.
 ; I '$G(BI("B")) S DIR("S")="I 0" Q
 ;
 ; S DIR("S")="I ($P(^BICONT(Y,0),U,3))&(+$P(^BICONT(Y,0),U,4)"
 ; S DIR("S")=DIR("S")_"=+$P(^AUTTIMM(BI(""B""),0),U,8))"
 ;
 ;---> If no vaccine chosen, then screen says all reasons are invalid.
 I '$G(BI("B")) Q 0
 ;
 ;---> if not active, quit
 I $$GET1^DIQ(920.4,Y,"INACTIVE") Q 0
 ;
 ;---> Vaccine must be associated with this contraindication
 I '$DATA(^PXV(920.4,"D",BI("B"),Y)) QUIT 0
 ;
 QUIT 1
 ;
 Q
 ;
 ;
 ;----------
HISTORY(X) ;EP
 ;ZEXCEPT:BI
 ;---> Add/Edit Screenman actions to take ON POST-CHANGE of Category Field.
 ;---> Parameters:
 ;     1 - X (opt) X=Internal Value of Category Field ("E"=Historical Event).
 ;
 ;---> If this is an Historical Event, then set Lot#="" and not required.
 I X="E" D
 .S BI("D")=""
 .D PUT^DDSVALF(3,"","",""),REQ^DDSUTL(3,"","",0)
 .D PUT^DDSVALF(9,,,) S BI("R")=""
 Q
 ;
 ;
 ;----------
OLDDATE(X) ;EP
 ;ZEXCEPT:BI
 ;---> Add/Edit Screenman actions to take ON POST-CHANGE of Date Field.
 ;---> If date entered is earlier than today, Category default changes to
 ;---> Historical.  If the date is more than 5 days earlier than today,
 ;---> user as default Provider is removed.
 ;---> Parameters:
 ;     1 - X (opt) X=Internal Value of Date of Visit entered.
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Make VIS Presented Date default to Visit Date (when changed).
 N BIDATEE S BIDATEE=X
 ;
 I '$G(BI("K"))&($P(X,".")'=DT) D
 .D PUT^DDSVALF(11,,,"E","I") S BI("I")="E"
 .I ($G(DT)-X)>5 D NOPROV^BIUTL7("E")
 ;
 ;
 ;********** PATCH 10, v8.5, MAY 30,2015, IHS/CMI/MWR
 ;---> Only stuff VIS Presented Date if this is a V Imm.
 ;D PUT^DDSVALF(10.2,,,BIDATEE,"E") S BI("QQ")=BIDATEE
 I $G(BIVTYPE)="I" D PUT^DDSVALF(10.2,,,BIDATEE,"E") S BI("QQ")=BIDATEE
 QUIT
 ;**********
 ;
 ;
 ;----------
SKINCHG(BISKIEN) ;EP
 ;ZEXCEPT:BI
 ;---> Actions to take in Screenman when the Skin Test is selected
 ;---> or changed.
 ;---> Called by the POST ACTION ON CHANGE of Field 2, Skin Test"
 ;---> of the Form BI FORM-SKIN VISIT ADD/EDIT.
 ;---> Parameters:
 ;     1 - BISKIEN  (opt) IEN of Vaccine IMMUNIZATION File (9999999.14).
 ;                        (Not used for now.)
 Q:'$G(BISKIEN)
 ;
 ;---> If this is NOT a new visit, inform user that Dose#, Lot#,
 ;---> Reaction, and VIS will be deleted and replaced.
 D:$G(BI("K"))
 .N BIMSG
 .S BIMSG="* NOTE: Because you have changed the Skin Test, the Result,"
 .S BIMSG=BIMSG_" Reading, Date of Reading, and Reader will be removed."
 .D HLP^DDSUTL(BIMSG),HLP^DDSUTL("$$EOP")
 ;
 ;---> Clear data relating to previous Skin Test (if any).
 D PUT^DDSVALF(3) S BI("L")=""   ;Result
 D PUT^DDSVALF(4) S BI("M")=""   ;Reading
 D PUT^DDSVALF(5) S BI("N")=""   ;Date of Reading
 D PUT^DDSVALF(10) S BI("X")=""  ;Reader
 Q
 ;
 ;
 ;----------
SERVAL(BIDOSE,BIVAC) ;EP
 ; ZEXCEPT: DDSERROR
 ;---> Validate Dose# for this Immunization Visit.
 ;---> Parameters:
 ;     1 - BIDOSE (req) Dose# entered by the user.
 ;     2 - BIVAC  (req) IEN of Vaccine IMMUNIZATION File (9999999.14).
 ;
 Q:'BIDOSE  Q:'BIVAC
 N BIMAX S BIMAX=$$VMAX^BIUTL2(BIVAC)
 ;
 ;---> If Dose# entered is greater than Max Dose# for this Vaccine,
 ;---> reject value and display help text.
 I BIDOSE>BIMAX S DDSERROR=1 D
 .N Z
 .S Z="The Maximum Dose# for "_$$VNAME^BIUTL2(BIVAC)_" is "_BIMAX
 .S Z=Z_".  Please enter a number between 1 and "_BIMAX_"."
 .D HLP^DDSUTL(Z)
 Q
 ;
 ;
 ;----------
INACTV(X) ;EP
 ;ZEXCEPT:BI
 ;---> Called by the POST ACTION of Field 4, "Inactive Date"
 ;---> of the Form BI FORM-CASE DATA EDIT.
 ;---> Actions to take in Screenman when Patient is made Inactive
 ;---> by adding a date to Field 4, Inactive Date, of the Form.
 ;---> Parameters:
 ;     1 - X (req) Internal value of the date entered.
 ;
 ;---> If no Inactive Date entered, set Reason="" and "Moved to"=""
 ;---> and disable navigation to and editing of the fields.
 I '$G(X) D  Q
 .D PUT^DDSVALF(5),PUT^DDSVALF(5.5)
 .D UNED^DDSUTL(5,,,1),UNED^DDSUTL(5.5,,,1)
 .S (BI("F"),BI("I"))="@"
 ;---> A date has been entered, so enable edit and navigation.
 D UNED^DDSUTL(5,,,0),UNED^DDSUTL(5.5,,,0)
 Q
 ;
 ;
 ;----------
LOCBR ;EP
 ;ZEXCEPT:BI,X,DDSOLD
 ;---> Location Type branching logic for Add/Edit Imm Visit Form:
 ;---> "Location" field.
 ;
 ;---> If Location Type is "Other":
 I (X="O")&($G(DDSOLD)'="O") D
 .;
 .;---> Disable IHS Loc (7) and put a null value in IHS Loc (7).
 .D UNED^DDSUTL(7,,,1),PUT^DDSVALF(7)
 .;
 .;---> Set IHS Location IEN in BI array =null (ADD+18^BIVISIT).
 .S BI("F")=""
 .;
 .;---> Enable Other Loc (8).
 .D UNED^DDSUTL(8,,,0)
 .;
 .;---> Make Other Loc required, and IHS Loc not required.
 .D REQ^DDSUTL(8,,,1),REQ^DDSUTL(7,,,0)
 ;
 ;
 ;---> If Location Type is "IHS":
 I (X="I")&($G(DDSOLD)'="I") D
 .;
 .;---> Disable Other Loc (8) and put a null value in Other Loc (8).
 .D UNED^DDSUTL(8,,,1),PUT^DDSVALF(8)
 .;
 .;---> Set Outside Location text in BI array =null (ADD+19^BIVISIT).
 .S BI("G")=""
 .;
 .;---> Enable IHS Loc (7).
 .D UNED^DDSUTL(7,,,0)
 .;
 .;---> Make IHS Loc required, and Other Loc not required.
 .D REQ^DDSUTL(7,,,1),REQ^DDSUTL(8,,,0),DEFSITE
 Q
 ;
 ;
 ;----------
VISDATE ;EP
 ;ZEXCEPT:BI,X
 ;---> Enable/disable and if necessary clear VIS Date, based on
 ;---> YES/NO answer of VIS Given question.
 ;
 ;---> If VIS Given=YES (1), then enable editing of VIS Date.
 I X=1 D  Q
 .D UNED^DDSUTL(13,,,0)
 .;---> If no VIS Date present, get default from IMMUNIZATION File.
 .Q:$$GET^DDSVALF(13)
 .N BIY S BIY=$$GET^DDSVALF(2)
 .D PUT^DDSVALF(13,,,$$VISDEF^BIUTL2(BIY))
 ;
 ;---> Otherwise, stuff null in VIS Date and make it uneditable.
 D PUT^DDSVALF(13) S BI("Q")=""
 D UNED^DDSUTL(13,,,1)
 Q
 ;
 ;
 ;----------
DEFSITE ;EP
 ;---> Code to stuff default Location of Visit in Add/Edit Imm Visit
 ;---> form.  If Location Type is IHS and current value is null,
 ;---> stuff user's DUZ(2) as default.
 ;
 Q:$$GET^DDSVALF(6)'="I"
 Q:$$GET^DDSVALF(7)]""
 D PUT^DDSVALF(7,"","",DUZ(2),"I")
 Q
 ;
 ;
 ;----------
BADREAD ;EP
 ;ZEXCEPT:DDSERROR
 ;---> Code to check Skin Test results: If the result is Negative,
 ;---> the Reading must be <15mm; in that case,
 ;---> display help message and reject value.
 ;
 N X
 S X="If the result is NEGATIVE, the Reading must be less than 15 millimeters."
 D HLP^DDSUTL(X)
 S DDSERROR=""
 Q
 ;
 ;
 ;----------
BADRDAT ;EP
 ;ZEXCEPT:DDSERROR,Y
 ;---> If the Read Date is earlier than the initial visit date or later
 ;---> than today, advise and return to Read Date field.
 ;
 I Y<$$GET^DDSVALF(1) S DDSERROR="" D  Q
 .D HLP^DDSUTL(" * Date of Reading may not be prior to date of initial visit.")
 I Y>DT S DDSERROR="" D  Q
 .D HLP^DDSUTL(" * Date of Reading may not be later than today.")
 Q
 ;
 ; VEN/SMH - HAND EDIT IMMUN CONTRAINDICATIONS (920.4) file
 ; NB: This is just one time use code. No need to run again.
 ; This is written to port the VISTA CI data from VISTA to RPMS.
 ; Kept here for reference.
KILLALL ; [Private] Delete all entries
 N I F I=0:0 S I=$O(^PXV(920.4,I)) Q:'I  D
 . N J F J=0:0 S J=$O(^PXV(920.4,I,3,J)) Q:'J  D
 .. N DA,DIK S DA(1)=I,DA=J,DIK=$$OREF^DILF($NA(^PXV(920.4,I,3))) D ^DIK
 QUIT
 ;
EDIT2 ; [Private] Get entries from VISTA and file them.
 ; ZEXCEPT: AUTTIMM,PXV
 N FDA,DIERR
 N CNT S CNT=0
 N VISTA S VISTA="/var/local/foia201502/mumps.gld"
 N VGLOCI S VGLOCI=$NA(^|VISTA|PXV(920.4)) ; exteneded ref to VISTA
 N VGLOIMM S VGLOIMM=$NA(^|VISTA|AUTTIMM)  ; ditto
 N BII F BII=0:0 S BII=$O(^PXV(920.4,BII)) Q:'BII  D
 . W $P(^PXV(920.4,BII,0),U),!
 . N BIJ F BIJ=0:0 S BIJ=$O(@VGLOCI@(BII,3,BIJ)) Q:'BIJ  D
 .. S CNT=CNT+1
 .. N IMM S IMM=$P(@VGLOCI@(BII,3,BIJ,0),U)
 .. N VIMM S VIMM=$P(@VGLOIMM@(IMM,0),U)
 .. N CVX S CVX=$P(@VGLOIMM@(IMM,0),U,3)
 .. ; W ?3,VIMM,?40,CVX,!
 .. N RPMSIEN S RPMSIEN=$$FIND1^DIC(9999999.14,,"QX",+CVX,"C")
 .. W ?3,CVX," ",$$GET1^DIQ(9999999.14,RPMSIEN,.01),!
 .. N C S C=","
 .. N P S P="+"
 .. S FDA(920.43,P_CNT_C_BII_C,.01)=RPMSIEN
 .. ; N DIE,DR,DA S DIE=$$OREF^DILF($NA(^PXV(920.4))),DR="3//CVX",DA=BII D ^DIE
 ;
 D UPDATE^DIE(,$NA(FDA))
 ;i $d(DIERR) break
 QUIT
