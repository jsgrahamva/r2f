C0CRPMS	; CCDCCR/GPL - CCR/CCD PROCESSING FOR RPMS ;1/14/09  14:33
	;;1.2;CCD/CCR GENERATION UTILITIES;;Oct 30, 2012;Build 51
	;
	; This program is free software: you can redistribute it and/or modify
	; it under the terms of the GNU Affero General Public License as
	; published by the Free Software Foundation, either version 3 of the
	; License, or (at your option) any later version.
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	; GNU Affero General Public License for more details.
	;
	; You should have received a copy of the GNU Affero General Public License
	; along with this program.  If not, see <http://www.gnu.org/licenses/>.
	;
	W "NO ENTRY FROM TOP",!
	Q
	;
DISPLAY	; RUN THE PCC DISPLAY ROUTINE
	D ^APCDDISP
	Q
	;
VTYPES	;
	D GETN2^C0CRNF("G1",9999999.07)
	; ZWR G1
	Q
	;
VISITS(C0CDFN,C0CCNT)	;LIST VISIT DATES FOR PATIENT DFN
	; C0CCNT IS A LIMIT ON HOW MANY VISITS TO DISPLAY ; DEFAULTS TO ALL
	I '$D(C0CCNT) S C0CCNT=999999999
	N G,GN
	S G="" S GN=0
	F  S G=$O(^AUPNVSIT("AA",C0CDFN,G)) Q:(G="")!(GN>C0CCNT)  D  ;
	. S GN=GN+1
	. W $$FMDTOUTC^C0CUTIL(9999999-G),!
	Q
	;
VISITS2(C0CDFN,C0CCNT)	;SECOND VERSION USING NEXTV
	;
	N C0CG,GN
	S C0CG=""
	S GN=0
	I '$D(C0CCNT) S C0CCNT=99999999
	F  S C0CG=$$NEXTV(C0CDFN,C0CG) Q:(C0CG="")!(GN'<C0CCNT)  D  ;
	. S GN=GN+1
	. W $$FMDTOUTC^C0CUTIL(C0CG),!
	Q
	;
NEXTV(C0CDFN,C0CVDT)	;EXTRINSIC WHICH RETURNS THE NEXT VISIT DATE
	;FOR PATIENT C0CDFN IN REVERSE TIME ORDER; PASS "" TO GET THE MOST
	; RECENT VISIT
	N G
	S G=C0CVDT
	I G'="" S G=9999999-C0CVDT ;INVERT FOR INDEX
	S G=$O(^AUPNVSIT("AA",C0CDFN,G))
	I G="" Q ""
	E  Q 9999999-G
	;
GETV(C0CDFN,C0CVDT)	; GET VISIT USING DATE C0CVDT . IF C0CVDT IS NULL,
	; GET MOST RECENT VISIT
	N C0CG
	I '$D(C0CVDT) S C0CVDT=$$NEXTV(C0CDFN,"")
	S APCDVLDT=C0CVDT
	S APCDPAT=C0CDFN
	D ^APCDVLK
	D ^APCDVD
	;K APCDCLN,APCDCAT,APCDDATE,APCDLOC,APCDVSIT,APCDLOOK,APCDTYPE
	Q
	;
GETNV(C0CDFN)	;GET MANY VISITS
	;
	S APCDPAT=C0CDFN ;
	N C0CG S C0CG=""
	F  S C0CG=$$NEXTV(C0CDFN,C0CG) Q:C0CG=""  D  ; LOOP BACKWARD THROUGH VISITS
	. W C0CG,"    ",$$FMDTOUTC^C0CUTIL(C0CG),!
	. S APCDVLDT=C0CG
	. D ^APCDVLK
	. D ^APCDVD
	. K APCDCLN,APCDCAT,APCDDATE,APCDLOC,APCDVSIT,APCDLOOK,APCDTYPE
	Q
	;
GETTBL(C0CTBL)	; SCAN FOR AND DISPLAY PATIENTS IN A RIMTBL, PASSED BY VALUE
	;
	N ZG S ZG=$NA(^TMP("GPLRIM","RIMTBL","PATS",C0CTBL))
	N C0CG S C0CG=""
	N C0CQ S C0CQ=0
	F  S C0CG=$O(@ZG@(C0CG),-1) Q:(C0CG="")  D  ;
	. W "PAT: ",C0CG,!
	. D GETNV^C0CRPMS(C0CG)
	. K X R X:DTIME
	. I X="Q" S C0CQ=1 ; QUIT IF Q
	Q
	;
CMPDRG	; COMPARE THE DRUG FILE TO THE VA VUID MAPPING FILE FOR MATCHES
	;
	S C0CZI=0 ;
	F  S C0CZI=$O(^C0CDRUG("V",C0CZI)) Q:C0CZI=""  D  ;ALL DRUGS IN RPMS DRUG FILE
	. S C0CZJ="" ; FOR EVERY FIELD AND SUBFIELD IN THE DRUG FILE
	. ;W "C0CZI:",C0CZI
	. F  S C0CZJ=$O(^C0CDRUG("V",C0CZI,C0CZJ)) Q:C0CZJ=""  D  ;
	. . ;W " C0CZJ:",C0CZJ
	. . N C0CZN,C0CZV ;
	. . S C0CZN=^C0CDRUG("V",C0CZI,C0CZJ,1) ; EVERY FIELD VALUE
	. . ;W " C0CZN:",C0CZN,!
	. . D GETN1^C0CRNF("C0CZV",176.112,C0CZN,"C") ;LOOK IN C XREF
	. . I $D(C0CZV) D  ;FOUND A MATCH
	. . . S C0CVO="FOUND:^"_C0CZI_"^"_C0CZJ_"^"_C0CZN
	. . . S C0CVO=C0CVO_"^RXNORM:^"_$$ZVALUE^C0CRNF("MEDIATION CODE","C0CZV")
	. . . D PUSH^GPLXPATH("^C0CZRX",C0CVO)
	. . . W C0CVO,!
	Q
	;
CMPDRG2	; COMPARE THE DRUG FILE TO THE VA VUID MAPPING FILE FOR MATCHES
	;
	S C0CZI=0 ;
	F  S C0CZI=$O(^C0CDRUG("V",C0CZI)) Q:C0CZI=""  D  ;ALL DRUGS IN RPMS DRUG FILE
	. S C0CZJ="" ; FOR EVERY FIELD AND SUBFIELD IN THE DRUG FILE
	. W "C0CZI:",C0CZI
	. F  S C0CZJ=$O(^C0CDRUG("V",C0CZI,C0CZJ)) Q:C0CZJ=""  D  ;
	. . W " C0CZJ:",C0CZJ
	. . N C0CZN,C0CZV ;
	. . S C0CZN=^C0CDRUG("V",C0CZI,C0CZJ,1) ; EVERY FIELD VALUE
	. . W " C0CZN:",C0CZN,!
	. . D GETN1^C0CRNF("C0CZV",176.112,C0CZN,"C") ;LOOK IN C XREF
	. . I $D(C0CZV) D  ;FOUND A MATCH
	. . . W "FOUND: ",C0CZI," ",C0CZJ," ",C0CZN
	. . . W " VUID:",$$ZVALUE^C0CRNF("VUID","C0CZV"),!
	Q
	;
