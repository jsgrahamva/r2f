EDPRPTBV	;SLC/MKB - BVAC Report ;3:06 PM  8 Sep 2015
	;;2.0;EMERGENCY DEPARTMENT;**6,2,WVEHR,LOCAL**;Feb 24, 2012;Build 1
	;
	; Copyright 2015 WorldVistA.
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
	;
EN(BEG,END,CSV)	; Get Activity Report for EDPSITE by date range
	N LOG,X,X0,X1,X3,DX,IN,OUT,ROW,ICD,I
	N ELAPSE,TRIAGE,ADMDEC,ADMDEL,CNT,ADM,MIN,AVG
	D INIT ;set counters, sums to 0
	D:'$G(CSV) XML^EDPX("<logEntries>") I $G(CSV) D  ;headers
	. N TAB S TAB=$C(9)
	. ;Begin EDP*2.0*2 changes
	. S X="Patient"_TAB_"Time In"_TAB_"Time Out"_TAB_"Complaint"_TAB_"MD"_TAB_"Acuity"_TAB_"Elapsed"_TAB_"Triage"_TAB_"Dispo"_TAB_"Admit Dec"_TAB_"Admit Delay"_TAB_"Diagnosis"_TAB_"ICD"_TAB_"ICD Type"
	. ;End EDP*2.0*2 Changes
	. ;***pij 4/19/2013 removed Unemploy
	. ;S X=X_TAB_"Viet Vet"_TAB_"Agent Orange"_TAB_"OEF/OIF"_TAB_"Pers Gulf"_TAB_"VA Pension"_TAB_"POW"_TAB_"Serv Conn %"_TAB_"Purp Hrt"_TAB_"Unemploy"_TAB_"Combat End"
	. S X=X_TAB_"Viet Vet"_TAB_"Agent Orange"_TAB_"OEF/OIF"_TAB_"Pers Gulf"_TAB_"VA Pension"_TAB_"POW"_TAB_"Serv Conn %"_TAB_"Purp Hrt"_TAB_"Combat End"
	. ;***
	. D ADD^EDPCSV(X)
	S IN=BEG-.000001
	F  S IN=$O(^EDP(230,"ATI",EDPSITE,IN)) Q:'IN  Q:IN>END  S LOG=0 F  S LOG=+$O(^EDP(230,"ATI",EDPSITE,IN,LOG)) Q:LOG<1  D
	. S X0=^EDP(230,LOG,0),X1=$G(^(1)),X3=$G(^(3))
	. S DX=$$BVAC(+$P(X0,U,3),LOG) Q:DX=""  ;no codes in range
	. S CNT=CNT+1,OUT=$P(X0,U,9) ;S:OUT="" OUT=NOW
	. S ELAPSE=$S(OUT:($$FMDIFF^XLFDT(OUT,IN,2)\60),1:0)
	. S MIN("elapsed")=MIN("elapsed")+ELAPSE
	. S X=$$ACUITY^EDPRPT(LOG),TRIAGE=0 ;S:X<1 X=OUT
	. S:X TRIAGE=($$FMDIFF^XLFDT(X,IN,2)\60)
	. S MIN("triage")=MIN("triage")+TRIAGE
	. S (ADMDEC,ADMDEL)=""
	. S X=$$ADMIT^EDPRPT(LOG) I X S ADM=ADM+1 D   ;decision to admit
	.. S ADMDEC=($$FMDIFF^XLFDT(X,IN,2)\60)
	.. S ADMDEL=$S(OUT:($$FMDIFF^XLFDT(OUT,X,2)\60),1:0)
	.. S MIN("admDec")=MIN("admDec")+ADMDEC
	.. S MIN("admDel")=MIN("admDel")+ADMDEL
	. ;
BV1	. ; add row to report
	. ;S ICD=$P($G(^ICD9(+$P(X4,U,2),0)),U) Q:ICD<290  Q:ICD>316
	. K ROW S ROW("patient")=$P(X0,U,4)
	. S ROW("inTS")=$S($G(CSV):$$EDATE^EDPRPT(IN),1:IN)
	. S ROW("outTS")=$S($G(CSV):$$EDATE^EDPRPT(OUT),1:OUT)
	. S ROW("complaint")=$P(X1,U)
	. S ROW("md")=$$EPERS^EDPRPT($P(X3,U,5))
	. S ROW("acuity")=$$ECODE^EDPRPT($P(X3,U,3))
	. S ROW("elapsed")=ELAPSE_$S(ELAPSE>359:" *",1:"")
	. S ROW("triage")=TRIAGE
	. S ROW("disposition")=$$ECODE^EDPRPT($P(X1,U,2))
	. S ROW("admDec")=ADMDEC,ROW("admDel")=ADMDEL
	.; S ROW("icd")=$P(DX,U),ROW("dx")=$P(DX,U,2) replaced this line with one below
	. S ROW("icd")=$P(DX,U),ROW("dx")=$P(DX,U,2),ROW("icdType")=$P(DX,"^",3)
	. ; get other patient attributes from VADPT
	. N DFN,VAEL,VASV,VAMB,VAERR
	. S DFN=$P(X0,U,6) I DFN D 8^VADPT D
	.. S ROW("vietnam")=$S(VASV(1):"Y",1:"N")
	.. S ROW("agentOrange")=$S(VASV(2):"Y",1:"N")
	.. S ROW("iraq")=$S(VASV(11)!VASV(12)!VASV(13):"Y",1:"N")
	.. S ROW("persGulf")=$P($G(^DPT(DFN,.322)),U,10)
	.. S ROW("vaPension")=$S(VAMB(4):"Y",1:"N")
	.. S ROW("pow")=$S(VASV(4):"Y",1:"N")
	.. S ROW("servConnPct")=+$P(VAEL(3),U,2)
	.. S ROW("purpleHeart")=$S(VASV(9):"Y",1:"N")
	.. ; ROW("unemployable")=$P($G(^DGEN(27.11,DFN,"E")),U,17) ;or VAPD(7)=3^NOT EMPLOYED ??
	.. ;***pij 4/19/2013 VASV(10,1)=3011216^DEC 16,2001
	.. S ROW("combatEndDT")=$P($G(VASV(10,1)),U)
	.. I CSV,ROW("combatEndDT") S ROW("combatEndDT")=$$FMTE^XLFDT(ROW("combatEndDT"),"2D")
	.. ;S ROW("combatEndDT")=$P($G(VASV(10,1)),U,2)
	.. ;***
BV2	. ;
	. I '$G(CSV) S X=$$XMLA^EDPX("log",.ROW) D XML^EDPX(X) Q
	. S X=ROW("patient")
	. F I="inTS","outTS","complaint","md","acuity","elapsed","triage","disposition","admDec","admDel","dx","icd","icdType" S X=X_$C(9)_$G(ROW(I))
	. ;End EDP*2.0*2 Changes
	. ;***pij 4/19/2013 deleted unemployable
	. ;F I="vietnam","agentOrange","iraq","persGulf","vaPension","pow","servConn%","purpleHeart","unemployable","combatEndDT" S X=X_$C(9)_$G(ROW(I))
	. F I="vietnam","agentOrange","iraq","persGulf","vaPension","pow","servConn%","purpleHeart","combatEndDT" S X=X_$C(9)_$G(ROW(I))
	. ;***
	. D ADD^EDPCSV(X)
	D:'$G(CSV) XML^EDPX("</logEntries>")
	;
BV3	; calculate & include averages
	Q:CNT<1  ;no visits found
	S ELAPSE=$$ETIME^EDPRPT(MIN("elapsed")\CNT),AVG("elapsed")=ELAPSE
	S TRIAGE=$$ETIME^EDPRPT(MIN("triage")\CNT),AVG("triage")=TRIAGE
	S ADMDEC=$S(ADM:$$ETIME^EDPRPT(MIN("admDec")\ADM),1:"00:00")
	S ADMDEL=$S(ADM:$$ETIME^EDPRPT(MIN("admDel")\ADM),1:"00:00")
	S AVG("admDec")=ADMDEC,AVG("admDel")=ADMDEL,AVG("total")=CNT
	;
	I $G(CSV) D  Q  ;CSV format
	. N TAB,D S TAB=$C(9)
	. D BLANK^EDPCSV
	. ;***pij 4/19/2013 added extra/needed TAB
	. ;S X=TAB_"Total Patients"_TAB_CNT_TAB_"Averages Per Patient"_TAB_TAB_TAB_ELAPSE_TAB_TRIAGE_TAB_ADMDEC_TAB_ADMDEL
	. S X=TAB_"Total Patients"_TAB_CNT_TAB_"Averages Per Patient"_TAB_TAB_TAB_ELAPSE_TAB_TRIAGE_TAB_TAB_ADMDEC_TAB_ADMDEL
	. ;***
	. D ADD^EDPCSV(X),BLANK^EDPCSV
	D XML^EDPX("<averages>")
	S X=$$XMLA^EDPX("average",.AVG) D XML^EDPX(X)
	D XML^EDPX("</averages>")
	Q
	;
INIT	; Initialize counters and sums
	N I,X S (CNT,ADM)=0
	F I="elapsed","triage","admDec","admDel" S MIN(I)=0
	Q
	;
ECODE(IEN)	; Return external value for a Code
	Q:IEN $P($G(^EDPB(233.1,IEN,0)),U,2) ;name
	Q ""
	;
BVAC(AREA,LOG)	; -- Return ICD^text of diagnosis in range, else null
	N X,Y,I,EDPDX S Y=""
	D DXALL^EDPQPCE(AREA,LOG,.EDPDX)
	; drp Begin EDP*2.0*2 Changes
	S I=0 F  S I=$O(EDPDX(I)) Q:I<1  D
	. S X=$G(EDPDX(I))
	. ;Begin WorldVistA change
	. ;WAS;I 290<=+X,+X<=316 S Y=X
	. I 290'>+X,+X'>316 S Y=X
	. ;End WorldVistA change
	. I $E(X,1)["F",10<=+($E(X,2,8)),+($E(X,2,8))<=99 S Y=X
	.Q
	; End EDP*2.0*2 Changes
	Q Y
