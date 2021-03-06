VPRDJ05V	;SLC/MKB -- IV/Infusions ;8/2/11  15:29
	;;1.0;VIRTUAL PATIENT RECORD;**2**;Sep 01, 2011;Build 317
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
	; External References          DBIA#
	; -------------------          -----
	; ^OR(100                       5771
	; ^ORD(100.98                    873
	; ^ORD(101.43                   2843
	; ^PSB(53.79                    5909
	; ^SC                          10040
	; ^VA(200                      10060
	; DIQ                           2056
	; ORQ1,^TMP("ORR"               3154
	; ORX8                     2467,3071
	; PSODI                         4858
	; PSOORDER,^TMP("PSOR"          1878
	; PSOORRL,^TMP("PS"             2400
	; PSS50                         4483
	; PSS50P7                       4662
	; PSS51P1                       4546
	; PSS51P2                       4548
	; PSS52P6                       4549
	; PSS52P7                       4550
	; PSSDI                         4551
	; XLFDT                        10103
	; XLFSTR                       10104
	;
	; All tags expect DFN, ID, [VPRSTART, VPRSTOP, VPRMAX, VPRTEXT]
	;
ISIV()	; -- Return 1 or 0, if order is for IV/infusion
	I ORPK["V" Q 1
	I $P($G(ORTO),U,2)?1"IV".E Q 1
	I +$G(ORPCL)=130 Q 1
	I $G(^TMP("PS",$J,"B",0)) Q 1
	Q 0
	;
IV1	; -- IV fluid, Infusion order [continued from VPRDJ05]
	; [Also expects ORPK, OEL^PSOORRL data]
	N PS,PS0,X,X0,RTE,I,ADD,BASE
	S MED("vaType")="V",MED("medType")="urn:sct:105903003"
	S (ADD,BASE)=""
	I ORPK,$D(^TMP("PS",$J)) D  G IVQ
	. M PS=^TMP("PS",$J) S PS0=$G(PS(0)),MED("name")=$P(PS0,U)
	. S X=$G(PS("MDR",1,0)) S:$L(X) MED("dosages",1,"routeName")=X
	. S X=$P($G(PS("SCH",1,0)),U) I $L(X) D
	.. S MED("dosages",1,"scheduleName")=X
	.. N Y D SCH(X)
	.. M MED("dosages",1)=Y
	. S X=$G(PS("ADM",1,0)) S:$L(X) MED("dosages",1,"adminTimes")=X
	. S X=$P(PS0,U,2) I X["INFUSE OVER" S MED("dosages",1,"duration")=X
	. E  S MED("dosages",1,"ivRate")=X
	. S X=$G(PS("IVLIM",0)) S:$L(X) MED("dosages",1,"restriction")=$$IVLIM(X)
	. S X=+$P($G(PS("RXN",0)),U,5)
	. S:X MED("orders",1,"pharmacistUid")=$$SETUID^VPRUTILS("user",,X),MED("orders",1,"pharmacistName")=$P($G(^VA(200,X,0)),U)
	. D IVP
	; no med in PS (pending or cancelled), so use Order values
	S RTE=+$$VALUE^ORX8(ID,"ROUTE") I RTE D
	. D ALL^PSS51P2(RTE,,,,"VPRTE")
	. S MED("dosages",1,"routeName")=$G(^TMP($J,"VPRTE",RTE,1))
	S X=$$VALUE^ORX8(ID,"SCHEDULE") I $L(X) D
	. S MED("dosages",1,"scheduleName")=X
	. N Y D SCH(X)
	. M MED("dosages",1)=Y
	S X=$$VALUE^ORX8(ID,"ADMIN") S:$L(X) MED("dosages",1,"adminTimes")=X
	S X=$$VALUE^ORX8(ID,"RATE")
	I X["INFUSE OVER" S MED("dosages",1,"duration")=X
	E  S MED("dosages",1,"ivRate")=X
	S I=0 F  S I=$O(^OR(100,ID,.1,I)) Q:I<1  S X=+$G(^(I,0)) D
	. S X0=$G(^ORD(101.43,X,0)),MED("name")=$P(X0,U)
	. S MED("products",I,"ingredientName")=$P(X0,U)
	S X=$$VALUE^ORX8(ID,"DAYS") I $L(X) D  S MED("dosages",1,"restriction")=X
	. I X?1.A1.N S X=$$IVLIM(X) Q
	. ; CPRS format = "for a total of 3 doses" or "with total volume 100ml"
	. F I=1:1:$L(X) I $E(X,I)=+$E(X,I) S X=$E(X,I,$L(X)) Q
IVQ	; done
	K ^TMP("PS",$J),^TMP($J,"VPRTE")
	S MED("qualifiedName")=ADD_$S($L(ADD)&$L(BASE):" in ",1:"")_BASE
	D BCMA(.MED,DFN,ORPK)
	D ADD^VPRDJ("MED","med")
	Q
	;
IVP	; -- add IV products
	; [expects PS("A") & PS("B") data arrays from IV1]
	N VPI,N,NAME,IEN,DRUG,OI,X S N=0
	; IV Additives
	S VPI=0 F  S VPI=$O(PS("A",VPI)) Q:VPI<1  D
	. K ^TMP($J,"VPRPSIV") S NAME=$P($G(PS("A",VPI,0)),U)
	. D ZERO^PSS52P6("",NAME,"","VPRPSIV")
	. S IEN=$O(^TMP($J,"VPRPSIV",0)),DRUG=+$G(^(IEN,1)) Q:IEN<1
	. S OI=$G(^TMP($J,"VPRPSIV",IEN,15)) S:OI NAME=$$NAME(+OI)
	. S N=N+1 D:DRUG NDF(DRUG,N,"A",NAME)
	. S MED("products",N,"strength")=$P($G(PS("A",VPI,0)),U,2)
	; IV Base Solutions
	S VPI=0 F  S VPI=$O(PS("B",VPI)) Q:VPI<1  D
	. K ^TMP($J,"VPRPSIV") S NAME=$P($G(PS("B",VPI,0)),U)
	. D ZERO^PSS52P7("",NAME,"","VPRPSIV")
	. S IEN=$O(^TMP($J,"VPRPSIV",0)),DRUG=+$G(^(IEN,1)) Q:IEN<1
	. S OI=$G(^TMP($J,"VPRPSIV",IEN,9)) S:OI NAME=$$NAME(+OI)
	. S N=N+1 D:DRUG NDF(DRUG,N,"B",NAME)
	. S MED("products",N,"volume")=$P($G(PS("B",VPI,0)),U,2)
	K ^TMP($J,"VPRPSIV")
	Q 
	;
NAME(PSOI)	; -- return name_form of PS orderable item
	N Y,VPRX S PSOI=+$G(PSOI),Y=""
	D EN^PSSDI(50.7,,50.7,".01;.02",PSOI,"VPRX")
	S:$D(VPRX) Y=$G(VPRX(50.7,PSOI,.01))_" "_$G(VPRX(50.7,PSOI,.02))
	Q Y
	;
NDF(DRUG,VPI,ROLE,OI)	; -- Set NDF data for dispense DRUG ien
	; code ^ name ^ vuid ^ role ^ concentration
	N VPRX,VUID,X,I,CONC,NM
	S DRUG=+$G(DRUG) Q:'DRUG
	D NDF^PSS50(DRUG,,,,,"NDF")
	S CONC=$P($G(PS(ROLE,VPI,0)),U,2),NM=""
	;
	S MED("products",VPI,"ingredientRole")=$$ROLE(ROLE)
	S OI=$G(OI) S:$L(OI) MED("products",VPI,"ingredientName")=OI,NM=OI
	; NM=X
	;
	S X=$G(^TMP($J,"NDF",DRUG,20)) I X D  ;VA Generic
	. S MED("products",VPI,"ingredientCode")="urn:va:vuid:"_$$VUID^VPRD(+X,50.6)
	. S MED("products",VPI,"ingredientCodeName")=$P(X,U,2)
	;
	S X=$G(^TMP($J,"NDF",DRUG,22)) I X D  ;VA Product
	. S MED("products",VPI,"suppliedCode")="urn:va:vuid:"_$$VUID^VPRD(+X,50.68)
	. S MED("products",VPI,"suppliedName")=$P(X,U,2)_" "_CONC
	. S:NM="" NM=$P(X,U,2)
	;
	S X=$G(^TMP($J,"NDF",DRUG,25)) I X D  ;VA Drug Class
	. S MED("products",VPI,"drugClassCode")="urn:vadc:"_$P(X,U,2)
	. S MED("products",VPI,"drugClassName")=$P(X,U,3)
	. S:NM="" NM=$P(X,U,3)
	;
	I $L(NM),ROLE="A" S ADD=ADD_$S($L(ADD):", ",1:"")_NM
	I $L(NM),ROLE="B" S BASE=BASE_$S($L(BASE):", ",1:"")_NM
	K ^TMP($J,"NDF",DRUG)
	Q
	;
IVLIM(X)	; -- Return expanded version of IV Limit X
	I '$L($G(X)) Q ""
	N Y,VAL,UNT,I
	S Y="",X=$$UP^XLFSTR(X)
	I X?1"DOSES".E S X="A"_$P(X,"DOSES",2)
	S UNT=$E(X),VAL=0 F I=2:1:$L(X) I $E(X,I) S VAL=$E(X,I,$L(X)) Q
	I UNT="A" S Y=+VAL_$S(+VAL>1:" doses",1:" dose")
	I UNT="D" S Y=+VAL_$S(+VAL>1:" days",1:" day")
	I UNT="H" S Y=+VAL_$S(+VAL>1:" hours",1:" hour")
	I UNT="C" S Y=+VAL_" CC"
	I UNT="M" S Y=+VAL_" ml"
	I UNT="L" S Y=+VAL_" L"
	Q Y
	;
ROLE(X)	;
	N RESULT,TXT,Y
	S RESULT="",TXT="urn:sct:"
	S RESULT=$S(X="A":TXT_"418804003",X="B":TXT_"418297009",1:TXT_"410942007")
	Q RESULT
	;
MEDSTAT(X)	;
	N Y S Y="urn:sct:"
	S Y=Y_$S(X="active":"55561003",X="historical":"392521001","hold":"421139008",1:"73425007")
	Q Y
	;
TYPE(VA)	;
	N RESULT,TXT,Y
	S RESULT="",TXT="urn:sct:"
	S RESULT=$S(VA="N":TXT_"329505003",VA="O":TXT_"73639000",1:TXT_"105903003")
	Q RESULT
	;
SCH(NAME)	; -- Return other schedule info
	N I K ^TMP($J,"VPRS")
	I NAME?.E1" PRN" S NAME=$P(NAME," PRN") Q:NAME=""  ;strip off PRN for search
	D ZERO^PSS51P1("",NAME,"PSJ",,"VPRS")
	S I=+$O(^TMP($J,"VPRS","B",NAME,0)) Q:'I
	S Y("scheduleFreq")=+$G(^TMP($J,"VPRS",I,2))
	S Y("scheduleType")=$P($G(^TMP($J,"VPRS",I,5)),U,2)
	K ^TMP($J,"VPRS")
	Q
	;
BCMA(Y,DFN,ORPK)	; -- administration times
	Q:$G(DFN)<1  Q:$G(ORPK)<1
	N ADT,DA,CNT,STS S (ADT,CNT)=0
	F  S ADT=$O(^PSB(53.79,"AORDX",DFN,ORPK,ADT)) Q:ADT<1  D
	. S DA=0 F  S DA=+$O(^PSB(53.79,"AORDX",DFN,ORPK,ADT,DA)) Q:DA<1  D
	.. S STS=$$GET1^DIQ(53.79,DA_",",.09) Q:STS="REMOVED"
	.. S CNT=CNT+1,Y("administrations",CNT,"status")=STS
	.. S Y("administrations",CNT,"dateTime")=$$JSONDT^VPRUTILS(ADT)
	Q
