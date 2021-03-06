BISITE2 ;IHS/CMI/MWR - EDIT SITE PARAMETERS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**8**;MAR 15,2014;Build 9
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT SITE PARAMETERS.
 ;;  PATCH 1: Update text to relect DTap change in Option 1,
 ;;           and allow for Option 11.  RULES+9 and TEXT-4.
 ;;  PATCH 2: Update prompts and help text for HPV.  RULES+41, TEXT9+15
 ;;  PATCH 5: Update help text for HPV.  TEXT8+8
 ;;  PATCH 8: Changes to accommodate new TCH Forecaster   MINAGE+12, RULES+6
 ;
 ;
 ;----------
CMGR ;EP
 ;---> Select Default Case Manager.
 ;---> Called by Protocol BI SITE CASE MANAGER.
 ;#
 ; ZEXCEPT:BISITE
 Q:$$BISITE
 D FULL^VALM1,TITLE^BIUTL5("DEFAULT CASE MANAGER"),TEXT1
 D DIE^BIFMAN(9002084.02,".02",BISITE)
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;The Default Case Manager is the Case Manager who will be
 ;;presented automatically at all Case Manager prompts, such as
 ;;when you are adding a new patient.
 ;;
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
OTHER ;EP
 ;---> Select Other Location.
 ;---> Called by Protocol BI SITE OTHER LOCATION.
 ; ZEXCEPT:BISITE
 ;
 Q:$$BISITE
 D FULL^VALM1,TITLE^BIUTL5("OTHER LOCATION")
 I $$RPMS^BIUTL9() D TEXT2RPM,DIE^BIFMAN(9002084.02,".03",BISITE)
 E  D TEXT2VIS,DIE^BIFMAN(9002084.02,"920000.01",BISITE)
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT2RPM ;EP
 ;;The Other Location is an entry in the IHS LOCATION file
 ;;that will serve as the Location for a PCC Visit when the
 ;;actual location is not in the LOCATION File.
 ;;
 ;;
 D PRINTX("TEXT2RPM")
 Q
 ;
 ;
 ;----------
TEXT2VIS ;EP
 ;;The Other Location is a free text field that will be used
 ;;as the default other location when entering an external
 ;;immunization
 ;;
 ;;
 D PRINTX("TEXT2VIS")
 Q
 ;----------
DUELET ;EP
 ;---> Select Immunizations Due Letter.
 ;---> Called by Protocol BI SITE DUE LETTER.
 ; ZEXCEPT:BISITE
 ;
 Q:$$BISITE
 D FULL^VALM1,TITLE^BIUTL5("IMMUNIZATIONS DUE LETTER"),TEXT3
 D DIE^BIFMAN(9002084.02,".04",BISITE)
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;The Immunizations Due Letter is the form letter that is sent to
 ;;patients or their parents, listing their Immunization History and
 ;;informing them of which immunizations are due next.  It may also
 ;;contain information about where and when to receive the next
 ;;immunizations.
 ;;
 ;;The letter selected here will be presented as the default letter
 ;;to use when printing Due Letters.
 ;;
 ;;In order to select the letter for this Site Parameter, it must
 ;;already have been created.  To create the Standard Due Letter,
 ;;select LET under the Manager Menu (MGR-->LET).  Create a new letter
 ;;named "Standard Due Letter," and then return to this site parameter
 ;;to choose it.
 ;;
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
REPHDR ;EP
 ;---> Edit Report Header.
 ;---> Called by Protocol BI SITE REPORT HEADER
 ; ZEXCEPT:BISITE
 ;
 Q:$$BISITE
 D FULL^VALM1,TITLE^BIUTL5("REPORT & SCREEN HEADER"),TEXT4
 N BIDFLT,DIR,DIRUT,Y
 S DIR(0)="FOA",DIR("A")="     Enter the Report/Screen Header: "
 S DIR("B")=$$REPHDR^BIUTL6(BISITE)
 S DIR("?")="     Enter the site name as you would like it to appear"
 D ^DIR
 S:Y="" Y="@"
 ;
 ;---> CodeChange for v7.1 - IHS/CMI/MWR 12/01/2000:
 ;---> Next line missing negation.
 ;D:$D(DUOUT) DIE^BIFMAN(9002084.02,".06///"_Y,BISITE)
 D:'$D(DUOUT) DIE^BIFMAN(9002084.02,".06///"_Y,BISITE)
 ;
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT4 ;EP
 ;;The Report/Screen Header is the name of your site or institution
 ;;as you would like it to appear at the top of various reports and
 ;;screens throughout this software.
 ;;
 ;;(This may be the same as the Site Name that appears on some
 ;;of screens, however, that name is often an abbreviated
 ;;form of the actual site name.)
 ;;
 ;;Please enter the name of your facility as you would like it
 ;;to appear at the top of reports and screens in this software.
 ;;
 D PRINTX("TEXT4")
 Q
 ;
 ;
 ;----------
HFSPATH ;EP
 ;---> Edit Host File Server path.
 ;---> Called by Protocol BI SITE HFS PATH
 ; ZEXCEPT:BISITE
 ;
 Q:$$BISITE  N BIPOP S BIPOP=0
 F  D  Q:$G(BIPOP)
 .D FULL^VALM1,TITLE^BIUTL5("HOST FILE SERVER PATH"),TEXT5
 .N BIFLD,BIERR,BIDFLT,BIZ,DIR,DIRUT,X,Y S BIZ=0
 .;
 .S DIR(0)="FOA^1:30",DIR("A")="     Please enter the Host File Path: "
 .S DIR("B")=$$HFSPATH^BIUTL8(BISITE)
 .S DIR("?")="     Enter the full path name of the Host File directory"
 .D ^DIR
 .I $D(DIRUT) S BIPOP=1 Q
 .D:Y'="@" CHKSLASH(.Y,.BIZ,.BIPOP)
 .Q:(BIZ=1!($G(BIPOP)))
 .;D DIE^BIFMAN(9002084.02,".14////"_Y,BISITE) S BIPOP=1
 .S BIFLD(.14)=Y D FDIE^BIFMAN(9002084.02,+BISITE,.BIFLD,.BIERR) S BIPOP=1
 ;
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
CHKSLASH(Y,Z,BIPOP) ;EP
 ;---> Make sure there is a final slash in the path name.
 ;---> Parameters:
 ;     1 - Y  (req) File Path submitted for verification.
 ;     2 - Z  (ret) Z=1 if path contains both "/" and "\" or other error.
 ;     3 - BIPOP (ret) =1 if user ^-out.
 ;
 I Y["/"&(Y["\") D  S Z=1 Q
 .W !!?5,"Path may not contain both ""/"" and ""\""."
 .D DIRZ^BIUTL3()
 ;---> Get rid of any quotes.
 S Y=$TR(Y,"""","")
 ;
 D
 .N X S X=$$VERSION^%ZOSV(1)
 .;
 .;---> Ensure Windows path contains drive & root path.
 .I (X["Windows")&(Y'[":\") D  S Z=1  Q
 ..W !!?5,"Path must contain a drive specification (e.g., C:\path...)."
 ..D DIRZ^BIUTL3(.BIPOP)
 .;
 .;---> Ensure path terminates with appropriate slash.
 .I (X["Windows")!(Y["\") D  Q
 ..I $E(Y,$L(Y))'="\" S Y=Y_"\" Q
 .;
 .I (X["Linux")!(X["UNIX")!(Y["/") D  Q
 ..I $E(Y,$L(Y))'="/" S Y=Y_"/" Q
 Q
 ;
 ;
 ;----------
TEXT5 ;EP
 ;;The Host File Server Path is the directory on the Host File Server
 ;;where files to be imported and exported are stored.
 ;;
 ;;Include ALL necessary slashes in the path name (everything except
 ;;the filename itself).
 ;;
 ;;Examples would be: C:\TEMP\ (on a Windows PC)
 ;;               or  /usr/local/ (in unix/AIX)
 ;;
 ;;
 D PRINTX("TEXT5")
 Q
 ;
 ;
 ;----------
MINDAYS ;EP
 ;---> Edit the default Minimum Number of days since last letter sent.
 ;---> Called by Protocol BI SITE MIN DAYS LAST LET.
 ; ZEXCEPT:BISITE
 ;
 Q:$$BISITE
 D FULL^VALM1,TITLE^BIUTL5("EDIT MINIMUM DAYS LAST LETTER"),TEXT6
 N BIDFLT,DIR,DIRUT,Y
 S DIR(0)="NOA^0:9999:0"
 S DIR("A")="     Number of days: "
 S DIR("B")=$$MINDAYS^BIUTL2(BISITE)
 D ^DIR
 D:'$D(DUOUT) DIE^BIFMAN(9002084.02,".05///"_+Y,BISITE)
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT6 ;EP
 ;;The Minimum Days Last Letter is the least number of days that must
 ;;pass--after a letter is sent to a patient--before the software
 ;;will automatically send another letter to that same patient.
 ;;(This pertains only to the printing of letters.)
 ;;
 ;;For example, if a patient received a letter 2 weeks ago and
 ;;the Minimum Days Last Letter is 60, then the software will not
 ;;generate a letter for that patient today, even if the patient
 ;;is due for immunizations.
 ;;
 ;;This Site Parameter sets only the DEFAULT Minimum Days Last Letter--
 ;;the Case Manager always has the option to change it when printing
 ;;Due Letters.
 ;;
 ;;Please enter the default Minimum number Days since Last Letter.
 ;;
 D PRINTX("TEXT6")
 Q
 ;
 ;
 ;----------
MINAGE ;EP
 ;---> Edit the parameter directing the ImmServe Forecast to return
 ;---> Immunization Due dates for either the Minimum Acceptable Age
 ;---> or the Recommended Age.
 ;---> Called by Protocol BI SITE FORC MIN VS RECOMM
 ; ZEXCEPT:BISITE
 ;
 Q:$$BISITE
 D FULL^VALM1,TITLE^BIUTL5("SELECT MINIMUM VS RECOMMENDED AGE"),TEXT7
 N BIDFLT,DIR,DIRUT,Y
 S DIR(0)="SOA^M:Minimum;R:Recommended"
 S DIR("A")="     Please select either MINIMUM or RECOMMENDED: "
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Change parameter prompt to default recommended.
 S DIR("B")=$S($$MINAGE^BIUTL2(BISITE)=1:"Minimum",1:"Recommended")
 ;**********
 D ^DIR
 S:Y="M" Y="A"
 D:'$D(DIRUT) DIE^BIFMAN(9002084.02,".07///"_Y,BISITE)
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT7 ;EP
 ;;
 ;;The Minimum vs Recommended Age parameter allows you to direct the
 ;;Forecasting program to forecast Immunizations due at either the
 ;;Minimum Acceptable Patient Age or at the Recommended Age.
 ;;
 D PRINTX("TEXT7")
 Q
 ;
 ;
 ;----------
RULES ;EP
 ;---> Edit the parameter directing which version of Forecasting
 ;---> Rules should be used by ImmServe.
 ;---> Called by Protocol BI SITE FORC RULES
 ; ZEXCEPT:BISITE
 ;
 Q:$$BISITE
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Change parameter prompt to just Grace Period.
 ;D FULL^VALM1,TITLE^BIUTL5("SELECT FORECASTING OPTIONS",1),TEXT8
 N BIDFLT,BIPOP,DIR,DIRUT,X,Y
 ;
 ;---> For a new set of Immserve Rules, change here below and $$VALIDRUL^BIUTL2.
 ;S DIR(0)="NOA^1,2,3,4,5,6,7,11"
 ;S DIR("?")="     Enter a number from the left column to choose one of the Options."
 ;S DIR("A")="     Select Forecasting Option: "
 ;S Y=$P($G(^BISITE(BISITE,0)),U,8)
 ;S:'Y Y=1 S DIR("B")=+Y
 ;D ^DIR
 ;---> For a new set of Immserve Rules, change here below and $$VALIDRUL^BIUTL2.
 ;I (Y>7)&(Y<11) D  G RULES
 ;.W !!?8,Y," is not a valid Option.  Please choose again."
 ;.D DIRZ^BIUTL3(.BIPOP)
 ;
 ;D:'$D(DIRUT) DIE^BIFMAN(9002084.02,".08///"_+Y,BISITE,.BIPOP)
 ;I $G(DIRUT) D RESET^BISITE Q
 ;
 ;---> Grace Period question.
 ;D TITLE^BIUTL5("SELECT FORECASTING RULES"),TEXT9
 D FULL^VALM1,TITLE^BIUTL5("4-DAY GRACE PERIOD OPTION",1),TEXT9
 N BIDFLT,BIHELP,BIHELP1,BIPRMPT,X,Y
 S BIPRMPT="     Do you wish to implement a 4-Day Grace Period"
 S BIHELP1="        Enter Yes to allow a 4-day grace period."
 S BIHELP="        Enter No to disallow any grace period."
 S BIDFLT=$P($G(^BISITE(BISITE,0)),U,21)
 S BIDFLT=$S(BIDFLT:"YES",1:"NO")
 W !
 D DIR^BIFMAN("YO",.Y,,BIPRMPT,BIDFLT,BIHELP,BIHELP1)
 I $G(Y)="^" D RESET^BISITE Q
 D DIE^BIFMAN(9002084.02,".21///"_Y,BISITE)
 ;
 ;---> HPV Age question.
 ;D TITLE^BIUTL5("SELECT FORECASTING RULES"),TEXT10
 ;N BIDFLT,BIHELP,BIPRMPT,X,Y
 ;
 ;********** PATCH 2, v8.5, MAY 15,2012, IHS/CMI/MWR
 ;---> Update prompts and help text for HPV.
 ;S BIPRMPT="     Select 1 (18 yrs) or 2 for (26f/21m yrs): "
 ;S BIHELP="        Enter 1 to stop HPV at 18 yrs old; or 2 to stop"
 ;S BIHELP=BIHELP_" at 26f/21m yrs."
 ;**********
 ;
 ;S BIDFLT=+$P($G(^BISITE(BISITE,0)),U,24)  S:'BIDFLT BIDFLT=1
 ;D DIR^BIFMAN("SAB^1:18;2:26",.Y,,BIPRMPT,BIDFLT,BIHELP)
 ;I $G(Y)="^" D RESET^BISITE Q
 ;D DIE^BIFMAN(9002084.02,".24///"_Y,BISITE)
 ;**********
 ;
 D RESET^BISITE
 Q
 ;
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Update HPV text below.
 ;**********
 ;----------
TEXT8 ;EP
 ;;Versions 1, 3, 5, 6, 7 and 11 forecast the first vaccines series at 6 wks;
 ;;the others beginning at 2 mths.  All versions forecast Rotavirus at
 ;;2 (6 wks), 4, and 6 mths, and Influenza between Aug 15 and March 14
 ;;for infants 6 months-18 years (or all ages).  Options 3,4 & 6 forecast
 ;;Hep A starting at 12 months, while options 1,2,5 and 11 forecast Hep A
 ;;at 15 months.  Option 11 does not forecast Hep A or Hep B in persons
 ;;over 18 years, regardless of prior doses. All options forecast Tdap, MCV4,
 ;;and HPV for adolescents per ACIP recommendations.
 ;;
 ;;   Option       6 Mths         12 Mths                     15 Mths
 ;;   ------       ------  -----------------------------      ----------
 ;;    1) ......   IPV     Hib, MMR, Pn, Var ...........      DTaP, HepA
 ;;    2) ......   ....    Hib, IPV, MMR, Pn, Var ......      DTaP, HepA
 ;;    3) ......   IPV     DTaP, Hib, MMR, Pn, Var, HepA
 ;;    4) ......   ....    DTaP, Hib, IPV, MMR, Pn, Var, HepA
 ;;    5) ......   IPV     Hib, MMR, Var ...............      DTaP, Pn, HepA
 ;;    6) ......   IPV     Hib, MMR, Var, HepA..........      DTaP, Pn
 ;;    7) Comvax   IPV     DTaP, HepB, Hib, MMR, Pn, Var      Hep A
 ;;   11) ......   IPV     Hib, MMR, Pn, Var ...........      DTaP, HepA
 ;;
 D PRINTX("TEXT8",3)
 Q
 ;
 ;
 ;----------
TEXT9 ;EP
 ;;The ACIP recommends that vaccine doses administered 4 days or less
 ;;before the minimum interval or age be counted as valid.  (Not all
 ;;states accept this "4-Day Grace Period.")
 ;;
 ;;Below, choose "Yes" if you would like to screen using the 4-Day Grace
 ;;Period.  Choose "No" to adhere strictly to the recommended intervals.
 ;;
 ;;Note: The 4-Day Grace Period will not affect vaccine forecasting, only
 ;;screening for the validity of the dose administered.
 ;;
 D PRINTX("TEXT9")
 Q
 ;
 ;
 ;********** PATCH 2, v8.5, MAY 15,2012, IHS/CMI/MWR
 ;---> Update prompts and help text for HPV.
 ;
 ;----------
TEXT10 ;EP
 ;;The ACIP recommends HPV for females 11-12 years with catch up for
 ;;13-26 years for females and 13-21 years for males.  But HPV is provided
 ;;by the Vaccine for Children's Program only for 9-18 year olds.
 ;;
 ;;Please select whether HPV should forecast for all patients from age 11
 ;;through 18 years, or only through age 26 for females and age 21 for males.
 ;;
 ;**********
 D PRINTX("TEXT10")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
BISITE() ;EP
 ; ZEXCEPT:BISITE
 ;---> Check for local variable BISITE.
 ;---> Variables:
 ;     1 - BISITE (req) Site IEN in BI SITE PARAMETER File.
 ;
 I '$G(BISITE) D ERRCD^BIUTL2(111,,1),RESET^BISITE Q 1
 I '$D(^BISITE(BISITE,0)) D ERRCD^BIUTL2(110,,1),RESET^BISITE Q 1
 Q 0
