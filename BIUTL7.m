BIUTL7 ;IHS/CMI/MWR - UTIL: SCREENMAN CODE;2015-08-31  1:32 PM
 ;;8.5;IMMUNIZATION;**10**;MAY 30,2015;Build 9
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  SCREENMAN RELATED CODE TO LOAD & SAVE: VISIT, CASE DATA, CONTRAS.
 ;;  PATCH 9: Added Preload of Admin Date and VIS Presented Date. LOADVIS+70
 ;;           Added save of Admin Date and VIS Presented Date. SAVISIT+41
 ;;  PATCH 10: Added Preload of Skin Test Lot Number. LOADVIS+92
 ;;            Added save of Skin Test Lot Number.  SAVISIT+46
 ;
 ;
 ;----------
LOADVIS(BIVTYPE) ;EP
 ;---> Code to load Visit data for ScreenMan Edit form.
 ;---> Called by Pre Action of Block BI BLK-IMM VISIT ADD/EDIT or
 ;---> BI BLK-SKIN VISIT ADD/EDIT of Forms BI FORM-IMM VISIT ADD/EDIT
 ;---> or BI FORM-SKIN VISIT ADD/EDIT, respectively.
 ;---> Parameters:
 ;     1 - BIVTYPE (req) "I"=Immunization Visit, "S"=Skin Text Visit.
 ;
 ;---> If BIVTYPE does not="I" (Imm Visit) and it does
 ;---> not="S" (Skin Test Visit), then set Error Code and quit.
 I ($G(BIVTYPE)'="I")&($G(BIVTYPE)'="S") D ERRCD^BIUTL2(410,,1) Q
 ;
 ;
 ;---> If this is an old Visit, load data for Screenman.
 D:$G(BI("K"))
 .;
 .;---> IMMUNIZATIONS *
 .D:BIVTYPE="I"
 ..;
 ..;---> Load the Vaccine.
 ..D:$G(BI("B"))
 ...;---> Load Vaccine Name and display Short Name below (if different).
 ...D PUT^DDSVALF(2,,,BI("B"),"I")
 ...D VSHORT(BI("B"))
 ..;
 ..;---> Load Lot Number IEN, and display Lot data (Amount and Exp Date).
 ..I $G(BI("D")) D
 ...D PUT^DDSVALF(3,,,BI("D"),"I")
 ...D LOTDAT(BI("D"))
 ..;
 ..;---> Make Dose Override editable (Screenman Field "Disable Editing"
 ..;---> is set to "YES" by default when the form is loaded.)
 ..D UNED^DDSUTL(14,,,0)
 ..;---> Load Dose Override if there is one.
 ..I $G(BI("S")) D PUT^DDSVALF(14,,,BI("S"),"I")
 ..;
 ..;
 ..;---> Make Reaction editable (Screenman Field "Disable Editing"
 ..;---> is set to "YES" by default when the form is loaded.)
 ..D UNED^DDSUTL(13,,,0)
 ..;---> Load Immunization Reaction.
 ..I $G(BI("O")) D PUT^DDSVALF(13,,,BI("O"),"I")
 ..;
 ..;---> Load the Injection Site.
 ..I $G(BI("T"))]"" D PUT^DDSVALF(4,,,BI("T"),"I")
 ..;
 ..;VISTA Fields
 ..I $G(BI("T1")) D PUT^DDSVALF(3.9,,,BI("T1"),"I") ; Route (#920.2)
 ..I $G(BI("T2")) D PUT^DDSVALF(4,,,BI("T2"),"I")   ; Site (#920.3)
 ..;
 ..;---> Release/Rev Date of VIS (DD-Mmm-YYYY).
 ..;I $G(BI("Q"))>1 D PUT^DDSVALF(10,,,BI("Q"),"E")
 ..; In VISTA, BI("Q") is a pointer to the VIS in file #920.
 ..; Therefore, we must put it in internal form.
 ..I BI("Q"),BI("Q")["-" D PUT^DDSVALF(10,,,BI("Q"),"E")
 ..I BI("Q"),BI("Q")=+BI("Q") D PUT^DDSVALF(10,,,BI("Q"),"I")
 ..;
 ..;---> Load the Volume, add leading zero to Volume if necessary.
 ..I $G(BI("W")) D PUT^DDSVALF(5,,,$$LEADZ^BIUTL5(BI("W")),"E")
 ..;
 ..;---> Load Imported from Outside Source, if=1 (display "edited" if=2).
 ..I $G(BI("Y")) D PUT^DDSVALF(15,,,"*Imported"_$S(BI("Y")=2:" (edited)*",1:"*"))
 ..;
 ..;---> Load VFC Elig if Native and <19.
 ..D VFCSET^BIUTL8
 ..;
 ..;---> Load NDC Code.
 ..I $G(BI("H"))]"" D PUT^DDSVALF(3.8,,,BI("H"),"I")
 ..;
 ..;
 ..;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ..;---> Preload Admin Date and Date VIS Presented.
 ..I $G(BI("EE"))>1 D PUT^DDSVALF(1.5,,,BI("EE"),"E")
 ..I $G(BI("QQ"))>1 D PUT^DDSVALF(10.2,,,BI("QQ"),"E")
 ..;**********
 ..;
 .;
 .;---> SKIN TESTS *
 .D:BIVTYPE="S"
 ..;
 ..;---> Load the Skin Test.
 ..D:$G(BI("B")) PUT^DDSVALF(2,,,BI("B"),"I")
 ..;
 ..;---> Load Skin Test Result.
 ..I $G(BI("L"))]"" D PUT^DDSVALF(3,,,$E(BI("L")),"I")
 ..;
 ..;---> Load Skin Test Reading.
 ..I $G(BI("M"))'="" D PUT^DDSVALF(4,,,BI("M"),"I")
 ..;
 ..;---> Load Skin Test Date Read.
 ..I $D(BI("N")) D PUT^DDSVALF(5,,,BI("N"),"E")
 ..;
 ..;---> If Reader already stored previously, load it.
 ..I $G(BI("X")) D PUT^DDSVALF(10,,,BI("X"),"I")
 ..;
 ..;---> Load the Injection Site.
 ..I $G(BI("T"))]"" D PUT^DDSVALF(2.4,,,BI("T"),"I")
 ..;
 ..;---> Load the Volume.
 ..I $G(BI("W"))]"" D PUT^DDSVALF(2.8,,,BI("W"),"I")
 ..;
 ..;********** PATCH 10, v8.5, MAY 30,2015, IHS/CMI/MWR
 ..;---> Preload Skin Test Lot Number.
 ..I $G(BI("LL"))>1 D PUT^DDSVALF(2.9,,,BI("LL"),"I")
 ..;**********
 .;
 .;
 .;---> If there is text for Other Location:
 .D:$G(BI("G"))]""
 ..;---> Set Location Type to Other.
 ..D PUT^DDSVALF(6,,,"O","I")
 ..;---> Make IHS Loc uneditable and null (ADD+12^BIVISIT will handle).
 ..D UNED^DDSUTL(7,,,1),PUT^DDSVALF(7)
 ..;---> Load Other Loc text and make editable.
 ..D PUT^DDSVALF(8,,,BI("G")),UNED^DDSUTL(8,,,0)
 ..;---> Make Other Loc required, IHS Loc not required.
 ..D REQ^DDSUTL(8,,,1),REQ^DDSUTL(7,,,0)
 .;
 .;---> If Other Loc is null and IHS Loc is set, load it.
 .I $G(BI("G"))="" I $G(BI("F")) D
 ..D PUT^DDSVALF(7,,,BI("F"),"I")
 .;
 .;---> Load Category.
 .I $G(BI("I"))]"" D PUT^DDSVALF(11,,,BI("I"),"I")
 ;
 ;---> Load default date.
 D
 .N X S X=$G(BI("E"))
 .Q:X=""
 .S:X[" @12:00" X=$P(X," @")
 .D PUT^DDSVALF(1,,,X,"E")
 ;
 ;---> Load default site.
 D DEFSITE^BIUTL4
 S BI("F")=$$GET^DDSVALF(7),BI("I")=$$GET^DDSVALF(11)
 ;
 ;---> If this is an Immunization, load VFC Eligibility and Local Text.
 I BIVTYPE="I",$G(BI("P"))]"" D PUT^DDSVALF(10.5,,,BI("P"),"I"),ELIGLAB^BIUTL8(BI("P"))
 ;
 ;---> If Provider already stored previously, load it and quit.
 I $G(BI("R")) D PUT^DDSVALF(9,,,BI("R"),"I") Q
 ;
 ;---> If this is a new Skin Test, load default volume of .1 ml.
 I BIVTYPE="S",'$G(BI("K")) S BI("W")=.1 D PUT^DDSVALF(2.8,,,BI("W"),"I")
 ;
 ;---> If this is a new Visit, and if Site Parameter is yes, and
 ;---> if the User is a provider, then load User as default Provider.
 I '$G(BI("K")),$$DEFPROV^BIUTL6($G(DUZ(2))) D
 .I $D(^XUSEC("PROVIDER",DUZ)) D
 ..;
 ..;---> Same as NOPROV (see below).
 ..Q:('$G(BI("K"))&($G(BI("I"))="E"))
 ..;
 ..;---> To set default provider into local BI array, even if the
 ..;---> user doesn't <return> past the provider field on the screen.
 ..D PUT^DDSVALF(9,,,$G(DUZ),"I") S BI("R")=$G(DUZ)
 ;
 Q
 ;
 ;
 ;----------
NOPROV(X) ;EP
 ;---> Called by Post Action field of Field 11 on BI FORM-IMM VISIT ADD/EDIT
 ;---> and BI FORM-SKIN VISIT ADD/EDIT.
 ;---> If adding a new immunization and user changes Category to
 ;---> "E" (Hist Event), then remove default user/provider from Field 9.
 ;---> Parameters:
 ;     1 - X  Value of Field 11, Category (A, E or I).
 I X="E" I '$G(BI("K")) D PUT^DDSVALF(9,,,"") S BI("R")=""
 Q
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Next 4 calls moved to BIUTL9 for space (<15000k).
 ;
 ;----------
REASCHK ;EP
 ;---> See BIUTL9.
 D REASCHK^BIUTL9
 Q
 ;
 ;
 ;----------
READCHK ;EP
 ;---> See BIUTL9.
 D READCHK^BIUTL9
 Q
 ;
 ;
 ;----------
READCH6 ;EP
 ;---> See BIUTL9.
 D READCH6^BIUTL9
 Q
 ;
 ;
 ;----------
CREASCHK ;EP
 ;---> See BIUTL9.
 D CREASCHK^BIUTL9
 Q
 ;**********
 ;
 ;
 ;----------
LOTDAT(X) ;EP
 ;---> Called by Post Action field of Field 3 on BI FORM-IMM VISIT ADD/EDIT.
 ;---> Display Lot Exp Date and Remaining Balance (if tracked).
 ;---> Parameters:
 ;     1 - X (req) IEN of Lot Number in ^AUTTIML.
 ;
 Q:'$G(X)
 D PUT^DDSVALF(3.4,,," Exp Date: "_$$LOTEXP^BIRPC3(X,1))
 D PUT^DDSVALF(3.5,,,"Remaining: "_$$LOTRBAL^BIRPC3(X))
 Q
 ;
 ;
 ;----------
LOTWARN(BILIEN,BIVDATE,BILOC) ;EP
 ;---> Called by Branching Logic field of Field 3 on BI FORM-IMM VISIT ADD/EDIT.
 ;---> Display Lot Exp Date and Remaining Balance (if tracked).
 ;---> Parameters:
 ;     1 - BILIEN  (req) IEN of Lot Number in ^AUTTIML.
 ;     2 - BIVDATE (req) Date of Imm Visit.
 ;     3 - BILOC   (req) Location of Encounter.
 ;
 Q:'$G(BILIEN)  Q:'$D(^AUTTIML(BILIEN,0))
 N BIEXP,BILOW S (BIEXP,BILOW)=0
 ;
 D
 .N X S X=$$LOTRBAL^BIRPC3(BILIEN)
 .;---> Do not alert if this Lot is not tracked.   vvv83
 .Q:(X="Not tracked")
 .I X<$$LOTLOW^BIUTL2(BILIEN,BILOC) S BILOW=1
 ;
 D
 .N X S X=$$LOTEXP^BIRPC3(BILIEN,2)
 .;---> Do not warn if this Lot has no expiration date.
 .Q:('X)
 .I BIVDATE>X S BIEXP=1
 ;
 I (BILOW&BIEXP) S DDSSTACK="BI PAGE-EXPIRED AND LOW" Q
 I BILOW S DDSSTACK="BI PAGE-LOW SUPPLY ALERT"
 I BIEXP S DDSSTACK="BI PAGE-LOT EXPIRED"
 Q
 ;
 ;
 ;----------
VSHORT(X) ;EP
 ;---> Called by LOADVIS above and by Post Action field of Field 2
 ;---> on BI FORM-IMM VISIT ADD/EDIT.
 ;---> Display Short Name below Vaccine Name if different.
 ;---> Parameters:
 ;     1 - X (req) IEN of Vaccine in ^AUTTIMM.
 ;
 Q:'$G(X)  Q:($$VNAME^BIUTL2(X)=$$VNAME^BIUTL2(X,1))
 D PUT^DDSVALF(2.5,,,"("_$$VNAME^BIUTL2(X)_")")
 Q
 ;
 ;
 ;----------
SAVISIT(BIVTYPE,BI) ;EP
 ;---> Called by BIPATVW2 to save data after exiting Screenman Forms
 ;---> BI FORM-IMM VISIT ADD/EDIT and BI FORM-SKIN VISIT ADD/EDIT.
 ;---> Parameters:
 ;     1 - BIVTYPE (req) "I"=Immunization Visit, "S"=Skin Text Visit.
 ;     2 - BI      (req) Local array of data elements for this visit.
 ;
 N BI31 S BI31=$C(31)_$C(31)
 ;
 ;---> If BIVTYPE does not="I" (Immunization Visit) and it does
 ;---> not="S" (Skin Test Visit), then set Error Code and quit.
 I ($G(BIVTYPE)'="I")&($G(BIVTYPE)'="S") D ERRCD^BIUTL2(410,,1) Q
 ;
 N A,B,BIDATA,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T1,T2,V,W,X,Y,Z,EE,QQ,LL  S V="|"
 ;
 S A=$G(BI("A"))      ;Patient DFN.
 S B=$G(BI("B"))      ;Vaccine or Skin Test IEN.
 S C=$G(BI("C"))      ;Dose Override.
 S D=$G(BI("D"))      ;Lot Number IEN.
 S E=$G(BI("E"))      ;Date of Visit.
 S F=$G(BI("F"))      ;Location of Encounter IEN.
 S G=$G(BI("G"))      ;Other Location of Encounter Text.
 S H=$G(BI("H"))      ;NDC Code Pointer.
 S I=$G(BI("I"))      ;Catgegory of Visit (A,E,I).
 S J=$G(BI("J"))      ;Visit IEN
 S K=$G(BI("K"))      ;Old Visit IEN (for edits).
 S L=$G(BI("L"))      ;Skin Test Result.
 S M=$G(BI("M"))      ;Skin Test Reading (mm).
 S N=$G(BI("N"))      ;Skin Test Date Read.
 S O=$G(BI("O"))      ;Immunization Reaction
 S P=$G(BI("P"))      ;VFC Elilgibility
 S Q=$G(BI("Q"))      ;Release/Revision Date of VIS (DD-Mmm-YYYY).
 S R=$G(BI("R"))      ;IEN of Provider of Imm/Skin Test.
 S S=$G(BI("S"))      ;Dose Override.
 ;S T=$G(BI("T"))      ;Injection Site.
 S T1=$G(BI("T1"))    ;Route (#920.2) (New in VISTA Port)
 S T2=$G(BI("T2"))    ;Site  (#920.3) (New in VISTA Port)
 S W=$G(BI("W"))      ;Volume.
 S X=$G(BI("X"))      ;IEN of Reader (Provider) of Skin Test.
 S Z=$G(BI("Z"))      ;DUZ(2) for Site Parameters.
 S Y=$G(BI("Y"))      ;If Y=1, this was a previously imported Imm;
 ;                     now it needs to =2 ("Imported (edited)").
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Add Admin Date and VIS Presented Date to data being saved.
 S EE=$G(BI("EE"))     ;Admin Date (Date shot admin'd to patient.
 S QQ=$G(BI("QQ"))     ;Date VIS Presented to Patient.
 ;
 ;********** PATCH 10, v8.5, MAY 30,2015, IHS/CMI/MWR
 ;---> Add Skin Test Lot Number.
 S LL=$G(BI("LL"))
 ;
 ;---> Check Site IEN for parameters.
 S:'$G(Z) Z=$G(DUZ(2))
 I '$G(Z) D ERRCD^BIUTL2(105,,1) Q
 ;---> Piece:       2   3   4   5   6   7   8   9   10  11
 S BIDATA=BIVTYPE_V_A_V_B_V_C_V_D_V_E_V_F_V_G_V_I_V_J_V_K
 ;---> NOTE: Y will be pc 25 (not 24) because BIRPC6 feeds CPT Import to pc 24.
 ;---> Add pieces 27-29.
 ;---> Piece:     12  13  14  15  16  17  18  19       20     21  22  23 24 25  26 27  28   29   30
 S BIDATA=BIDATA_V_L_V_M_V_N_V_O_V_P_V_Q_V_R_V_S_V_T1_"-"_T2_V_W_V_X_V_Z_V_V_Y_V_H_V_V_EE_V_QQ_V_LL
 ;
 ;**********
 ;
 ;---> Call RPC to save visit to PCC Files.
 D ADDEDIT^BIRPC3(.BIERR,BIDATA)
 ;
 ;---> If an error is passed back, display it.
 S BIERR=$P(BIERR,BI31,2)
 D:BIERR]""
 .W !!," * ",BIERR,!?3,"NO Changes made! (Visit NOT added/edited.)"
 .D DIRZ^BIUTL3()
 ;
 Q
 ;
 ;
 ;----------
SAVCONTR(BI,BIERR) ;EP
 ;---> Called by BIPATCO2 to save data after exiting Screenman Form
 ;---> BI FORM-CONTRAINDICATION ADD/EDIT.
 ;---> Parameters:
 ;     1 - BI    (req) Local array of data elements for this contra.
 ;     1 - BIERR (ret) Text of Error Code if any, otherwise null.
 ;
 N BI31 S BI31=$C(31)_$C(31)
 N A,B,C,D,N,V S V="|"
 ;
 S A=$G(BI("A"))      ;Patient DFN.
 S B=$G(BI("B"))      ;Vaccine IEN (^AUTTIMM).
 S C=$G(BI("C"))      ;Contra Reason IEN (^BICONT).
 S D=$G(BI("D"))      ;Date Noted.
 S N=$G(BI("N"))      ;If this was an Edit, N=1 (otherwise null/0).
 ;
 D ADDCONT^BIRPC4(.BIERR,A_V_B_V_C_V_D_V_N)
 ;
 ;---> If an error is passed back, display it.
 S BIERR=$P(BIERR,BI31,2)
 D:BIERR]""
 .W !!," * ",BIERR,!?3,"Contraindication NOT added!" D DIRZ^BIUTL3()
 ;
 Q
 ;
 ;
 ;----------
LDCONTR ;EP
 ;---> Code to load Contraindication data for ScreenMan Edit form.
 ;---> Called by Pre Action of Block BI BLK-CONTRAINDICATION ADD
 ;---> of Form BI FORM-CONTRAIND ADD/EDIT
 ;
 ;
 Q:'$G(BIDFN)
 Q:'$G(BI("N"))
 ;
 ;---> Load Vaccine Name.
 I $G(BI("B"))]"" D PUT^DDSVALF(1,,,BI("B"),"I")
 ;
 ;---> Make Vaccine Name uneditable.
 D UNED^DDSUTL(1,,,1)
 ;
 ;---> Load Reaspm.
 I $G(BI("C"))]"" D PUT^DDSVALF(4,,,BI("C"),"E")
 ;
 ;---> Load Date.
 I $G(BI("D"))]"" D PUT^DDSVALF(5,,,BI("D"),"E")
 ;
 Q
 ;
 ;
 ;----------
LOADCAS ;EP
 ;---> Code to load Case Data for a patient for ScreenMan Edit form.
 ;---> Called by Pre Action of Block BI BLK-CASE DATE EDIT on
 ;---> Form BI FORM-CASE DATA EDIT.
 ;
 Q:'$G(BIDFN)
 ;
 ;---> Load Patient's Case Manager or default Case Manager.
 D
 .I $G(BI("B"))]"" D PUT^DDSVALF(1,,,BI("B"),"E") Q
 .Q:'$G(DUZ(2))
 .N BIX S BIX=$$CMGRDEF^BIUTL2(DUZ(2))
 .D:BIX PUT^DDSVALF(1,,,BIX,"I")
 ;
 ;---> Load Parent/Guardian.
 I $G(BI("C"))]"" D PUT^DDSVALF(2,,,BI("C"),"E")
 ;
 ;---> Load Mother's HBsAG Status.
 I $G(BI("D"))]"" D PUT^DDSVALF(7,,,BI("D"),"I")
 ;
 ;---> Load Date Patient became Inactive.
 I $G(BI("E"))]"" D PUT^DDSVALF(4,,,BI("E"),"E")
 ;
 ;---> Load Reason for Inactive.
 I $G(BI("F"))]"" D PUT^DDSVALF(5,,,BI("F"),"I")
 ;
 ;---> Load Other Info.
 I $G(BI("G"))]"" D PUT^DDSVALF(3,,,BI("G"),"E")
 ;
 ;---> Load Forecast Influ/Pneumo.
 I $G(BI("H"))]"" D PUT^DDSVALF(6,,,BI("H"),"I")
 ;
 ;---> Load Moved to/Tx Elsewhere.
 I $G(BI("I"))]"" D PUT^DDSVALF(5.5,,,BI("I"),"E")
 ;
 ;---> Load Consent State Registry.
 I $G(BI("K"))]"" D PUT^DDSVALF(8,,,BI("K"),"E")
 Q
 ;
 ;
 ;----------
SAVCAS ;EP
 ;---> Code to save Case Data exiting from Screenman.
 ;---> Called by Post Save Action of Form BI FORM-CASE DATA EDIT.
 ;
 N BI31 S BI31=$C(31)_$C(31)
 N A,B,C,D,DATA,E,F,G,H,I,J,K,U S U="^"
 ;
 S A=$G(BI("A"))      ;Patient DFN.
 S B=$G(BI("B"))      ;Case Manager's name, text.
 S C=$G(BI("C"))      ;Parent or Guardian, text.
 S D=$G(BI("D"))      ;Mother's HBsAG Status (P,N,A,U).
 S E=$G(BI("E"))      ;Date Pat became Inactive (ext format).
 S F=$G(BI("F"))      ;Reason for Inactive.
 S G=$G(BI("G"))      ;Other Info.
 S H=$G(BI("H"))      ;Forecast Influ/Pneumo.
 S I=$G(BI("I"))      ;Location Moved or Tx Elsewhere.
 S K=$G(BI("K"))      ;State Registry Consent.
 ;
 I E]"" S J=$G(DUZ)   ;IEN of User who Inactivated this patient.
 ;
 S DATA=A_U_B_U_C_U_D_U_E_U_F_U_G_U_H_U_I_U_$G(J)_U_K
 ;
 ;---> Store edits to database.
 D EDITCAS^BIRPC4(.BIERR,DATA)
 ;
 ;---> If an error is passed back, display it.
 S BIERR=$P(BIERR,BI31,2)
 D:BIERR]""
 .W !!," * ",BIERR,!?3,"Edits to Patient Case Data not saved!"
 .D DIRZ^BIUTL3()
 ;
 Q
