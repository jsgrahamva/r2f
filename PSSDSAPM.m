PSSDSAPM	;BIR/RTR-Dose Check utilities routine ;09/13/10
	;;1.0;PHARMACY DATA MANAGEMENT;**117,168,160,173**;9/30/97;Build 9
	;
	;
	;DRG - returns best Dispense Drug to use for Order Checks when only the Orderable Item is available
	;Input:
	;   PSSNBOI - Pharmacy orderable Item from #50.7
	;   PSSNBPK - package Use,  I for Inpatient, O for Outpatient, X for Non-VA Meds
	;   PSSNBOR - defined only if being called from CPRS, 1 for Enhanced Order Checks, 2 for Dosing
	;Output:
	;   nnn;nnn;nnnn - First piece is File 50 Internal Number, Second piece is VA Generic Internal number, Third piece
	;   will be the GCNSEQNO number. Piece 1 ';' is 0 if no drug found.                              
	;   Piece 2 will be null if drug not matched to National Drug File
	;   Piece 3 will be the GCNSEQNO number, if the NDF match has a GCNSEQNO number
	;   Piece 4 is returned as 1 if the call is from CPRS for enhanced order checks, and it indicates no drug was returned
	;   or a drug was returned, but there is an active supply tied to the Orderable Item, indicating CPRS should also do
	;   the duplicate supply check
	;   Piece 5 is returned as 1 if CPRS is getting a drug for the Enhanced Order Checks call, and they should
	;   display the error message for all order checks and not do the Dosing call
	;
	;
	;hierarchy: (Drug must be active)
	;1 - Exact Package Match, matched to NDF with GCNSEQNO
	;2 - No package match, but second choice package exists, matched to NDF with GCNSEQNO
	;3 - No package match, but third choice package exists, matched to NDF with GCNSEQNO
	;4 - No package match, but fourth choice package exists, matched to NDF with GCNSEQNO
	;5 - No package match, matched to NDF with GCNSEQNO
	;6 - Exact Package Match, matched to NDF with no GCNSEQNO
	;7 - No package match, but second choice package exists, matched to NDF with no GCNSEQNO
	;8 - No package match, but third choice package exists, matched to NDF with no GCNSEQNO
	;9 - No package match, but fourth choice package exists, matched to NDF with no GCNSEQNO
	;10 - No package match, matched to NDF with no GCNSEQNO
	;11 - Exact Package Match, not matched to NDF
	;12 - No package match, but second choice package exists, not matched to NDF
	;13 - No package match, but third choice package exists, not matched to NDF
	;14 - No package match, but fourth choice package exists, not matched to NDF
	;15 - No package match, package is null or some other package that is not one of the 4 primary packages (O, I U, X), matched to NDF
	;16 - No package match, not matched to NDF, package is null or some other package that is not one of the 4 primary packages (O, I U, X)
	;
	;** CPRS and Inpatient always passes in "I" for PSSNBPK variable, so drugs with "I" and "U" application packages are 
	;         evaluated as either or in the APP subroutine.  In the hierarchy above 1 or 2,  6 or 7 and 11 or 12 are 
	;         considered to be exact matches.  Outpatient evaluates "I" and "U" separately.  
	;
	;Second/Third Choice packages:
	;Outpatient - U for Unit dose, I for IV, then X for Non-VA med
	;Inpatient - O for outpatient then X
	;Non-VA Meds - O, U then I
	;
	;PSNBLOW holds current number in array, only reset array entry if lower number is found
	;PSSNBSTP stops the loop because you found the best possible drug, no need to set PSSNBLOW in this case
	;
	;
DRG(PSSNBOI,PSSNBPK,PSSNBOR)	;
	I '$G(PSSNBOI) Q "0;;"_$S($G(PSSNBOR)=1&($G(PSSNBPK)="I"!($G(PSSNBPK)="U")):";1;1",$G(PSSNBOR)=1:";1",1:"")
	I $G(PSSNBPK)'="O",$G(PSSNBPK)'="I",$G(PSSNBPK)'="U",$G(PSSNBPK)'="X" Q "0;;"_$S($G(PSSNBOR)=1:";1;1",1:"")
	N PSSNB1,PSSNBRS,PSSNBSTP,PSSNBIN,PSSNBAPP,PSSNBLOW,PSSNBARR,PSSNBAP1,PSSNBARX,PSSNONE,PSSNS1,PSSNS2,PSSNS3,PSSNS4,PSSNBOF,PSSNBOD,PSSNBOL,PSSNBOA,PSSNBO3
	S PSSNBSTP=0,PSSNBLOW=16
	S PSSNBRS="0;;"
	;package preference sequence defined
	I PSSNBPK["O" S PSSNS1="O",PSSNS2="U",PSSNS3="I",PSSNS4="X"
	I PSSNBPK["I" S PSSNS1="I",PSSNS2="U",PSSNS3="O",PSSNS4="X"
	I PSSNBPK["U" S PSSNS1="U",PSSNS2="I",PSSNS3="O",PSSNS4="X"
	I PSSNBPK["X" S PSSNS1="X",PSSNS2="O",PSSNS3="U",PSSNS4="I"
	F PSSNB1=0:0 S PSSNB1=$O(^PSDRUG("ASP",PSSNBOI,PSSNB1)) Q:'PSSNB1!(PSSNBSTP)  D:'$$DREX
	.S PSSNBIN=$P($G(^PSDRUG(PSSNB1,"I")),"^") I PSSNBIN,PSSNBIN'>DT Q
	.S PSSNBAPP=$P($G(^PSDRUG(PSSNB1,2)),"^",3)
	.S PSSNBAP1=$$GCN
	.D APP
	S PSSNBARX=$O(PSSNBARR(0))
	I PSSNBARX S PSSNBRS=$G(PSSNBARR(PSSNBARX))
	I $G(PSSNBOR)=1 D
	.I '$P(PSSNBRS,";") S $P(PSSNBRS,";",4)=1 Q
	.S PSSNBOF=0 F PSSNBOL=0:0 S PSSNBOL=$O(^PSDRUG("ASP",PSSNBOI,PSSNBOL)) Q:'PSSNBOL!(PSSNBOF)  D
	..I '$$SUP^PSSDSAPI(PSSNBOL) Q
	..S PSSNBO3=$P($G(^PSDRUG(PSSNBOL,2)),"^",3),PSSNBOA=$S(PSSNBPK["I"!(PSSNBPK["U"):1,1:0)
	..I PSSNBOA,PSSNBO3'["I",PSSNBO3'["O" Q
	..I 'PSSNBOA,PSSNBO3'["O",PSSNBO3'["X" Q
	..S PSSNBOD=$P($G(^PSDRUG(PSSNBOL,"I")),"^") I PSSNBOD,PSSNBOD'>DT Q
	..S $P(PSSNBRS,";",4)=1,PSSNBOF=1 Q
	I $G(PSSNBOR)=1,'$P(PSSNBRS,";") I $$EMSY^PSSDSAPI S $P(PSSNBRS,";",5)=$$EMS I '$P(PSSNBRS,";",5) S $P(PSSNBRS,";",5)=$$EMSX
	Q PSSNBRS
	;
DREX()	;Quit if drug is exempt from order check
	I $G(PSSINCFO)!($G(PSSNBOR)=2) Q $$EXMT^PSSDSAPI(PSSNB1)
	Q $$SUP^PSSDSAPI(PSSNB1)
	;
EMS()	;Sets piece 5 of output to 1 if CPRS needs to show error message and not do Dose check
	I PSSNBPK'="U",PSSNBPK'="I" Q 0
	I $$PRE^PSSDSAPK(PSSNBOI,"U")=1 Q 1
	Q 0
	;
EMSX()	;Sets piece 5 of output to 1 if no active drugs are tied to the orderable Item
	N PSSKRC1,PSSKRC2,PSSKRC3,PSSKRC4,PSSKRC9
	S (PSSKRC3,PSSKRC9,PSSKRC4)=0
	F PSSKRC1=0:0 S PSSKRC1=$O(^PSDRUG("ASP",PSSNBOI,PSSKRC1)) Q:'PSSKRC1!(PSSKRC9)  D
	.S PSSKRC2=$P($G(^PSDRUG(PSSKRC1,"I")),"^") I PSSKRC2,PSSKRC2'>DT D:'PSSKRC4  Q
	..I '$$SUP^PSSDSAPI(PSSKRC1) S PSSKRC4=1
	.S PSSKRC3=1
	.I '$$SUP^PSSDSAPI(PSSKRC1) S PSSKRC9=1
	I 'PSSKRC3,PSSKRC4 S PSSKRC9=1
	Q PSSKRC9
	;
APP	;
	I PSSNBAPP[PSSNS1,$P(PSSNBAP1,";",3) S PSSNBARR(1)=PSSNBAP1,PSSNBSTP=1 Q
	Q:PSSNBLOW<2
	I PSSNBAPP[PSSNS2,$P(PSSNBAP1,";",3) S PSSNBARR(2)=PSSNBAP1,PSSNBLOW=2 Q
	I PSSNBAPP[PSSNS1!(PSSNBAPP[PSSNS2),$P(PSSNBAP1,";",3) S PSSNBARR(1)=PSSNBAP1,PSSNBSTP=1 Q
	Q:PSSNBLOW<3
	I PSSNBAPP[PSSNS3,$P(PSSNBAP1,";",3) S PSSNBARR(3)=PSSNBAP1,PSSNBLOW=3 Q
	Q:PSSNBLOW<4
	I PSSNBAPP[PSSNS4,$P(PSSNBAP1,";",3) S PSSNBARR(4)=PSSNBAP1,PSSNBLOW=4 Q
	Q:PSSNBLOW<5
	I $P(PSSNBAP1,";",3) S PSSNBARR(5)=PSSNBAP1,PSSNBLOW=5 Q
	Q:PSSNBLOW<6
	I PSSNBAPP[PSSNS1,PSSNBAP1 S PSSNBARR(6)=PSSNBAP1,PSSNBLOW=6 Q
	Q:PSSNBLOW<7
	I PSSNBAPP[PSSNS2,PSSNBAP1 S PSSNBARR(7)=PSSNBAP1,PSSNBLOW=7 Q
	I PSSNBAPP[PSSNS1!(PSSNBAPP[PSSNS2),PSSNBAP1 S PSSNBARR(6)=PSSNBAP1,PSSNBLOW=6,PSSNBSTP=1 Q
	Q:PSSNBLOW<8
	I PSSNBAPP[PSSNS3,PSSNBAP1 S PSSNBARR(8)=PSSNBAP1,PSSNBLOW=8 Q
	Q:PSSNBLOW<9
	I PSSNBAPP[PSSNS4,PSSNBAP1 S PSSNBARR(9)=PSSNBAP1,PSSNBLOW=9 Q
	Q:PSSNBLOW<10
	I $P(PSSNBAP1,";",2) S PSSNBARR(10)=PSSNBAP1,PSSNBLOW=10 Q
	Q:PSSNBLOW<11
	I PSSNBAPP[PSSNS1 S PSSNBARR(11)=PSSNB1_";;",PSSNBLOW=11 Q
	Q:PSSNBLOW<12
	I PSSNBAPP[PSSNS2 S PSSNBARR(12)=PSSNB1_";;",PSSNBLOW=12 Q
	I PSSNBAPP[PSSNS1!(PSSNBAPP[PSSNS2) S PSSNBARR(11)=PSSNB1_";;",PSSNBLOW=11,PSSNBSTP=1 Q
	Q:PSSNBLOW<13
	I PSSNBAPP[PSSNS3 S PSSNBARR(13)=PSSNB1_";;",PSSNBLOW=13 Q
	Q:PSSNBLOW<14
	I PSSNBAPP[PSSNS4 S PSSNBARR(14)=PSSNB1_";;",PSSNBLOW=14 Q
	Q:PSSNBLOW<15
	I PSSNBAP1 S PSSNBARR(15)=PSSNBAP1,PSSNBLOW=15 Q
	Q:PSSNBLOW<16
	S PSSNBARR(16)=PSSNB1_";;",PSSNBLOW=16
	Q
	;
GCN()	;Returns drug matching information
	N PSSNBGC1,PSSNBGC3,PSSNBGRS
	S PSSNBGC1=$P($G(^PSDRUG(PSSNB1,"ND")),"^"),PSSNBGC3=$P($G(^PSDRUG(PSSNB1,"ND")),"^",3)
	I 'PSSNBGC1!('PSSNBGC3) Q 0
	S PSSNBGRS=$$PROD0^PSNAPIS(PSSNBGC1,PSSNBGC3)
	I $P(PSSNBGRS,"^",7) Q PSSNB1_";"_PSSNBGC1_";"_$P(PSSNBGRS,"^",7)
	Q PSSNB1_";"_PSSNBGC1
	;
	;
MLT	;Multi Ingredient check called from PSSDSAPD
	D ITEM^PSSDSAPK D:'PSSDBFAL NUM^PSSDSAPL
	I '$G(PSSDBIFG) Q
	N PSSMLT1,PSSMLT2,PSSMLT3,DA
	S PSSMLT1=$P($G(^PSDRUG(PSSDBIFG,"ND")),"^"),PSSMLT3=$P($G(^PSDRUG(PSSDBIFG,"ND")),"^",3)
	I 'PSSMLT1!('PSSMLT3) D MLTS Q
	S PSSMLT2=$$TLS^PSSDSAPA(PSSMLT1,PSSMLT3) I PSSMLT2 D MLTS Q
	I $$MLTSU D MLTS
	Q
	;
	;
MLTS	;
	K PSSDBAR("AMN"),PSSDBAR("UNIT")
	S PSSDBCAZ(PSSDBFDB(PSSDBLP,"RX_NUM"),"MUING")=""
	Q
	;
	;
MLTSU()	;
	N X,Y,PSSMKT2,PSSMKT5,PSSMKT6,PSSMKT7
	S PSSMKT2=$$DFSU^PSNAPIS(PSSMLT1,PSSMLT3)
	S PSSMKT5=$P(PSSMKT2,"^",6) I PSSMKT5="" Q 1
	S PSSMKT6=$$UNITM(PSSMKT5) I PSSMKT6'="" Q 1
	S PSSMKT7=$$UNIT^PSSDSAPI(PSSMKT5) I PSSMKT7="" Q 1
	Q 0
	;
	;
UNITM(PSSXUTUN)	;Find First DataBank Unit, can't do DIC Lookup because of exact match check
	;Returns Null or First DataBank Unit for text passed in
	N PSSXUTX,PSSXUTZ,PSSXUTAA,PSSXUTFL
	S PSSXUTFL=0 I $G(PSSXUTUN)="" S PSSXUTZ="" G UNITDX
	S PSSXUTAA=$$UP^XLFSTR(PSSXUTUN)
UNITDP	;
	K PSSXUTZ S PSSXUTX=$O(^PS(51.24,"B",PSSXUTAA,0)) I PSSXUTX,'$$SCREEN^XTID(51.24,.01,PSSXUTX_",") S PSSXUTZ=$P($G(^PS(51.24,PSSXUTX,0)),"^") I PSSXUTZ'="",$P($G(^PS(51.24,PSSXUTX,0)),"^",3) G UNITDX
	K PSSXUTZ S PSSXUTX=$O(^PS(51.24,"C",PSSXUTAA,0)) I PSSXUTX,'$$SCREEN^XTID(51.24,.01,PSSXUTX_",") S PSSXUTZ=$P($G(^PS(51.24,PSSXUTX,0)),"^") I PSSXUTZ'="",$P($G(^PS(51.24,PSSXUTX,0)),"^",3) G UNITDX
	K PSSXUTZ S PSSXUTX=$O(^PS(51.24,"D",PSSXUTAA,0)) I PSSXUTX,'$$SCREEN^XTID(51.24,.01,PSSXUTX_",") S PSSXUTZ=$P($G(^PS(51.24,PSSXUTX,0)),"^") I PSSXUTZ'="",$P($G(^PS(51.24,PSSXUTX,0)),"^",3) G UNITDX
	K PSSXUTZ I 'PSSXUTFL,$G(PSSXUTUN)["/" S PSSXUTFL=1,PSSXUTAA=$P(PSSXUTUN,"/"),PSSXUTAA=$$UP^XLFSTR(PSSXUTAA) G:PSSXUTAA'="" UNITDP
UNITDX	;
	Q $G(PSSXUTZ)
	;
	;
MLTNO	;
	I $D(PSSDBCAZ(PSSDBKLP,"MUING")) S $P(PSSDBCAR(PSSDBKLP),"^",7)=1
	Q
	;
	;
MLTNP	;
	I $D(PSSDBCAZ(PSSDBRLS,"MUING")) S $P(PSSDBCAR(PSSDBRLS),"^",7)=1
	Q
	;
	;
FDRUG	; Find drug, called from PSSDSAPD
	N PSSINCFO S PSSINCFO=1
	S PSSDBIFL=1,PSSDBIFG=$$DRG^PSSDSAPK(PSSDBFDB("OI"),$G(PSSDBFDB("PACKAGE")),$G(PSSDBDS(PSSDBLP,"MR_IEN")),$G(PSSDBFDB("OI_USAGE")))
	I 'PSSDBIFG S PSSDBIFG=$$DRG(PSSDBFDB("OI"),$G(PSSDBFDB("PACKAGE"))) S PSSDBCAZ(PSSDBFDB(PSSDBLP,"RX_NUM"),"NO_DRUG")="" S PSSDBIFG=$P(PSSDBIFG,";")
	Q
	;
	;
INERR	;Set OI error
	N PSSNOOIX
	S PSSNOOIX=$G(PSSDBFDB(PSSDBLP,"OI_ERROR",PSSDBFDB(PSSDBLP,"DRUG_NM")))
	I PSSNOOIX'="" S ^TMP($J,PSSDBASE,"IN","EXCEPTIONS","OI",PSSDBFDB(PSSDBLP,"DRUG_NM"))=$P(PSSNOOIX,"^")_"^"_$P(PSSNOOIX,"^",2),PSSENO=1 D STDB
	Q
	;
	;
FRQE	;Set Frequency error called from PSSDSAPD
	D INFERR^PSSDSAPK,FRDR^PSSDSAPK I $D(PSSDBFDB(PSSDBLP,"FRQ_ERROR")) S PSSDBCAZ(PSSDBFDB(PSSDBLP,"RX_NUM"),"FRQ_ERROR")=""
	Q
	;
	;
INFUE	;Set Infusion rate error from PSSDSAPD
	I $D(PSSDBFDB(PSSDBLP,"INF_ERROR")) S PSSDBCAZ(PSSDBFDB(PSSDBLP,"RX_NUM"),"INF_ERROR")=""
	Q
	;
	;
ERST	;Set Dosing Sequences into error summary list
	N PSSWSB1,PSSWSB2
	F PSSDBEQ3=0:0 S PSSDBEQ3=$O(PSSDBEQ2(PSSDBEQ3)) Q:'PSSDBEQ3  S PSSDBCAX(PSSDBRLS,PSSDBEQ3)="" I $O(PSSDBXAX(PSSDBEQ3,""))'="",$E(PSSDBASE,1,3)'="PSJ" D
	.S PSSWSB1="",PSSWSB2=0 F  S PSSWSB1=$O(PSSDBXAX(PSSDBEQ3,PSSWSB1)) Q:PSSWSB1=""!($G(PSSDBCAX(PSSDBRLS,PSSDBEQ3))["All")  S PSSWSB2=PSSWSB2+1 D
	..I PSSDBEQ3=5!(PSSDBEQ3=6)!(PSSDBEQ3=8) S PSSDBCAX(PSSDBRLS,PSSDBEQ3)=" (All" Q
	..I PSSWSB2=1 S PSSDBCAX(PSSDBRLS,PSSDBEQ3)=" (DOSE SEQ "_$P(PSSWSB1,";",4) Q
	..S PSSDBCAX(PSSDBRLS,PSSDBEQ3)=PSSDBCAX(PSSDBRLS,PSSDBEQ3)_", "_$P(PSSWSB1,";",4)
	.S PSSDBCAX(PSSDBRLS,PSSDBEQ3)=PSSDBCAX(PSSDBRLS,PSSDBEQ3)_")"
	Q
	;
	;
PAT	;
	N DFN,VADM,VAPTYP,VAHOW,VAROOT,VAERR,VA,X1,X2,X,%Y,PSSDBWT,PSSDBWTX,PSSDBHT,PSSDBHTX,GMRVSTR,PSSDBBSA,PSSDBATX
	S DFN=PSSDBDFN,PSSDBATX=0
	D DEM^VADPT
	K X S X2=$P(VADM(3),"^"),X1=DT I X1,X2 D ^%DTC S PSSDBATX=X
	S ^TMP($J,PSSDBASE,"IN","DOSE","AGE")=PSSDBATX
	S DFN=PSSDBDFN
	S (PSSDBWTX,PSSDBHTX,PSSDBBSA)=0
	S GMRVSTR="WT" K X D EN6^GMRVUTL
	S PSSDBWT=$P(X,"^",8) I PSSDBWT S PSSDBWTX=PSSDBWT/2.2
	S ^TMP($J,PSSDBASE,"IN","DOSE","WT")=$G(PSSDBWTX)
	S DFN=PSSDBDFN
	S GMRVSTR="HT" K X D EN6^GMRVUTL
	S PSSDBHT=$P(X,"^",8) I PSSDBHT S PSSDBHTX=.0254*PSSDBHT
	;Using DuBios formula for BSA calculation, and sending in 2 decimal places
	I $G(PSSDBWTX),$G(PSSDBHTX) S PSSDBBSA=.20247*(PSSDBHTX**.725)*(PSSDBWTX**.425)
	;I $G(PSSDBWTX),$G(PSSDBHTX) S PSSDBBSA=$J((((PSSDBWTX*PSSDBHTX)/3600)**.5),0,2)    Mosteller BSA Formula
	S ^TMP($J,PSSDBASE,"IN","DOSE","BSA")=$G(PSSDBBSA)
	Q
	;
	;
ADDCT	;Add counter to output globals so data appears in correct order for more than 9 Dosing Sequences
	;I PSSDBASA D ADDCTA  ;Remove comment when CPRS is ready to convert to new output, to show messages in Sequence order
	I PSSDBASB D ADDCTB
	Q
	;
	;
ADDCTA	;Add counter to CPRS global
	I '$D(^TMP($J,PSSDBASF)) Q 
	N PSSJW1,PSSJW2,PSSJW3,PSSJW4,PSSJW5,PSSJW6
	K ^TMP($J,"PSSJWTM1") M ^TMP($J,"PSSJWTM1")=^TMP($J,PSSDBASF) K ^TMP($J,PSSDBASF)
	;
	S PSSJW1="" F  S PSSJW1=$O(^TMP($J,"PSSJWTM1","OUT","DOSE","ERROR",PSSJW1)) Q:PSSJW1=""  D
	.S PSSJW2="" F  S PSSJW2=$O(^TMP($J,"PSSJWTM1","OUT","DOSE","ERROR",PSSJW1,PSSJW2)) Q:PSSJW2=""  D
	..S PSSJW3=$P(PSSJW1,";",4)
	..S PSSJW4=$G(^TMP($J,"PSSJWTM1","OUT","DOSE","ERROR",PSSJW1,PSSJW2,"MSG"))
	..S PSSJW5=$G(^TMP($J,"PSSJWTM1","OUT","DOSE","ERROR",PSSJW1,PSSJW2,"TEXT"))
	..I $D(^TMP($J,"PSSJWTM1","OUT","DOSE","ERROR",PSSJW1,PSSJW2,"MSG")) S ^TMP($J,PSSDBASF,"OUT","DOSE","ERROR",PSSJW3,PSSJW1,PSSJW2,"MSG")=PSSJW4
	..I $D(^TMP($J,"PSSJWTM1","OUT","DOSE","ERROR",PSSJW1,PSSJW2,"TEXT")) S ^TMP($J,PSSDBASF,"OUT","DOSE","ERROR",PSSJW3,PSSJW1,PSSJW2,"TEXT")=PSSJW5
	;
	S PSSJW1="" F  S PSSJW1=$O(^TMP($J,"PSSJWTM1","OUT","EXCEPTIONS","DOSE",PSSJW1)) Q:PSSJW1=""  D
	.S PSSJW2="" F  S PSSJW2=$O(^TMP($J,"PSSJWTM1","OUT","EXCEPTIONS","DOSE",PSSJW1,PSSJW2)) Q:PSSJW2=""  D
	..S PSSJW3=$P(PSSJW1,";",4)
	..S PSSJW4=$G(^TMP($J,"PSSJWTM1","OUT","EXCEPTIONS","DOSE",PSSJW1,PSSJW2))
	..S ^TMP($J,PSSDBASF,"OUT","EXCEPTIONS","DOSE",PSSJW3,PSSJW1,PSSJW2)=PSSJW4
	;
	S PSSJW1="" F  S PSSJW1=$O(^TMP($J,"PSSJWTM1","OUT","DOSE",PSSJW1)) Q:PSSJW1=""  I PSSJW1'="ERROR" D
	.S PSSJW2="" F  S PSSJW2=$O(^TMP($J,"PSSJWTM1","OUT","DOSE",PSSJW1,PSSJW2)) Q:PSSJW2=""  D
	..S PSSJW3="" F  S PSSJW3=$O(^TMP($J,"PSSJWTM1","OUT","DOSE",PSSJW1,PSSJW2,PSSJW3)) Q:PSSJW3=""  D
	...S PSSJW4="" F  S PSSJW4=$O(^TMP($J,"PSSJWTM1","OUT","DOSE",PSSJW1,PSSJW2,PSSJW3,"MESSAGE",PSSJW4)) Q:PSSJW4=""  D
	....S PSSJW5=$P(PSSJW1,";",4)
	....S PSSJW6=$G(^TMP($J,"PSSJWTM1","OUT","DOSE",PSSJW1,PSSJW2,PSSJW3,"MESSAGE",PSSJW4))
	....S ^TMP($J,PSSDBASF,"OUT","DOSE",PSSJW5,PSSJW1,PSSJW2,PSSJW3,"MESSAGE",PSSJW4)=PSSJW6
	;
	K ^TMP($J,"PSSJWTM1")
	Q
	;
	;
ADDCTB	;Add counter to Pharmacy global
	I '$D(^TMP($J,PSSDBASG)) Q 
	N PSSJW7,PSSJW8,PSSJW9,PSSJWNUM,PSSJWVAL,PSSJW56,PSSJW57
	K ^TMP($J,"PSSJWTM2") M ^TMP($J,"PSSJWTM2")=^TMP($J,PSSDBASG) K ^TMP($J,PSSDBASG)
	;
	S PSSJW7="" F  S PSSJW7=$O(^TMP($J,"PSSJWTM2","OUT",PSSJW7)) Q:PSSJW7=""  D
	.S PSSJWNUM=$P(PSSJW7,";",4)
	.S PSSJW8="" F  S PSSJW8=$O(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"ERROR",PSSJW8)) Q:PSSJW8=""  D
	..I $D(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"ERROR",PSSJW8,"MSG")) S ^TMP($J,PSSDBASG,"OUT",PSSJWNUM,PSSJW7,"ERROR",PSSJW8,"MSG")=$G(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"ERROR",PSSJW8,"MSG"))
	..I $D(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"ERROR",PSSJW8,"TEXT")) S ^TMP($J,PSSDBASG,"OUT",PSSJWNUM,PSSJW7,"ERROR",PSSJW8,"TEXT")=$G(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"ERROR",PSSJW8,"TEXT"))
	..I $G(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"ERROR",PSSJW8,"WARN"))="Warning" S ^TMP($J,PSSDBASG,"OUT",PSSJWNUM,PSSJW7,"ERROR",PSSJW8,"WARN")="Warning"
	.;
	.S PSSJW8="" F  S PSSJW8=$O(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"EXCEPTIONS",PSSJW8)) Q:PSSJW8=""  D
	..S PSSJW9=$G(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"EXCEPTIONS",PSSJW8))
	..S ^TMP($J,PSSDBASG,"OUT",PSSJWNUM,PSSJW7,"EXCEPTIONS",PSSJW8)=PSSJW9
	.;
	.S PSSJW8="" F  S PSSJW8=$O(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"MESSAGE",PSSJW8)) Q:PSSJW8=""  D
	..S PSSJW9="" F  S PSSJW9=$O(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"MESSAGE",PSSJW8,PSSJW9)) Q:PSSJW9=""  D
	...I +PSSJW8=3 D  Q
	....S PSSJW56="" F  S PSSJW56=$O(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"MESSAGE",PSSJW8,PSSJW9,PSSJW56)) Q:PSSJW56=""  D
	.....S PSSJW57=$G(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"MESSAGE",PSSJW8,PSSJW9,PSSJW56))
	.....S ^TMP($J,PSSDBASG,"OUT",PSSJWNUM,PSSJW7,"MESSAGE",PSSJW8,PSSJW9,PSSJW56)=PSSJW57
	...S PSSJWVAL=$G(^TMP($J,"PSSJWTM2","OUT",PSSJW7,"MESSAGE",PSSJW8,PSSJW9))
	...S ^TMP($J,PSSDBASG,"OUT",PSSJWNUM,PSSJW7,"MESSAGE",PSSJW8,PSSJW9)=PSSJWVAL
	; 
	K ^TMP($J,"PSSJWTM2")
	Q
	;
	;
DSP(PSSDBDS,PSSDBFDB)	;Return Dose and Dose Unit to Inpatient for complex order display
	;Return value set into parameter 1 as "DRG_DISP" 
	N PSSDBAR,PSSINDSP,PSSIND1,PSSIND2,PSSIND3,PSSDSLCL,PSSDBNOD,PSSDBXP,PSSDBLPD,PSSDSXTD,PSSDBNT,PSSDBFAL,PSSDBLP,PSSDBIFL
	S PSSDBLP="" F  S PSSDBLP=$O(PSSDBDS(PSSDBLP)) Q:PSSDBLP=""  D
	.S PSSINDSP="",(PSSDBLPD,PSSDBFAL,PSSDBIFL)=0 K PSSDBAR
	.I $D(PSSDBFDB(PSSDBLP,"DOSE_AMT")),$D(PSSDBFDB(PSSDBLP,"DOSE_UNIT")) S PSSINDSP=PSSDBFDB(PSSDBLP,"DOSE_AMT")_"^"_PSSDBFDB(PSSDBLP,"DOSE_UNIT") D DSPL Q
	.I $G(PSSDBDS(PSSDBLP,"DRG_AMT")),$G(PSSDBDS(PSSDBLP,"DRG_UNIT"))'="" D
	..S PSSIND1=$S(PSSDBDS(PSSDBLP,"DRG_UNIT")["/":$P(PSSDBDS(PSSDBLP,"DRG_UNIT"),"/"),1:PSSDBDS(PSSDBLP,"DRG_UNIT"))
	..S PSSIND1=$$UP^XLFSTR(PSSIND1)
	..S PSSIND2=$$UNIT^PSSDSAPI(PSSIND1)
	..I PSSIND2'="" S PSSINDSP=PSSDBDS(PSSDBLP,"DRG_AMT")_"^"_PSSIND2 D DSPL S PSSDBFAL=1
	.I PSSDBFAL Q
	.I '$G(PSSDBFDB(PSSDBLP,"DRUG_IEN")) S PSSDBDS(PSSDBLP,"DRG_DISP")="" Q
	.;"DOSE" Node should only come from CPRS, for selected Local Possible Dosage
	.S PSSDSLCL=$S($G(PSSDBDS(PSSDBLP,"DOSE"))'="":$P($G(PSSDBDS(PSSDBLP,"DOSE")),"&",5),1:$G(PSSDBDS(PSSDBLP,"DO")))
	.I PSSDSLCL'="" S PSSIND3=0 D
	..F PSSDBXP=0:0 S PSSDBXP=$O(^PSDRUG(PSSDBFDB(PSSDBLP,"DRUG_IEN"),"DOS2",PSSDBXP)) Q:'PSSDBXP!(PSSIND3)  D
	...S PSSDBNOD=$G(^PSDRUG(PSSDBFDB(PSSDBLP,"DRUG_IEN"),"DOS2",PSSDBXP,0))
	...I $$MTCH^PSSDSAPK S PSSDBLPD=1 I $P(PSSDBNOD,"^",5),$P(PSSDBNOD,"^",6)'="" D
	....S PSSDSXTD=+$P(PSSDBNOD,"^",5) I PSSDSXTD,$$SCREEN^XTID(51.24,.01,PSSDSXTD_",") Q
	....S PSSDBNT=$P($G(^PS(51.24,+$P(PSSDBNOD,"^",5),0)),"^",2)
	....I PSSDBNT'="" S PSSINDSP=$P(PSSDBNOD,"^",6)_"^"_PSSDBNT,(PSSIND3,PSSDBFAL)=1
	.I PSSDBFAL D DSPL Q
	.I PSSDBLPD D DPOP^PSSDSAPK I PSSDBFAL S PSSINDSP=PSSDBAR("AMN")_"^"_PSSDBAR("UNIT") D DSPL Q
	.D ITEM^PSSDSAPK I PSSDBFAL S PSSINDSP=PSSDBAR("AMN")_"^"_PSSDBAR("UNIT") D DSPL Q
	.D NUM^PSSDSAPL I $G(PSSDBAR("AMN"))'="",$G(PSSDBAR("UNIT"))'="" S PSSINDSP=PSSDBAR("AMN")_"^"_PSSDBAR("UNIT") D DSPL Q
	.S PSSDBDS(PSSDBLP,"DRG_DISP")=""
	Q
	;
	;
DSPL	;Add leading zero
	I $E(PSSINDSP)="." S PSSINDSP="0"_PSSINDSP
	S PSSDBDS(PSSDBLP,"DRG_DISP")=PSSINDSP
	Q
	;
	;
NXDRUG	;No Drug found
	I $G(PSSDBFDB("PACKAGE"))="X",$$DLTM^PSSDSAPI(PSSDBFDB("OI")) K ^TMP($J,PSSDBASE,"IN","EXCEPTIONS","OI",PSSDBFDB(PSSDBLP,"DRUG_NM")),PSSDBCAZ(PSSDBFDB(PSSDBLP,"RX_NUM"),"NO_DRUG") Q
	I $D(^TMP($J,PSSDBASE,"IN","EXCEPTIONS","OI",PSSDBFDB(PSSDBLP,"DRUG_NM"))) D DPL^PSSDSAPK Q
	I PSSDSIVF S ^TMP($J,PSSDBASE,"IN","EXCEPTIONS","OI",PSSDBFDB(PSSDBLP,"DRUG_NM"))="4^"_PSSDBFDB(PSSDBLP,"RX_NUM") D STDB Q
	S ^TMP($J,PSSDBASE,"IN","EXCEPTIONS","DOSE",PSSDBFDB(PSSDBLP,"RX_NUM"))="1^"_PSSDBFDB(PSSDBLP,"DRUG_NM") D STDB
	Q
	;
	;
STDB	;Set PSSDBCAR array for Input Exceptions
	S PSSDBCAR(PSSDBFDB(PSSDBLP,"RX_NUM"))="B^"_PSSDBFDB(PSSDBLP,"DRUG_NM")
	S $P(PSSDBCAR(PSSDBFDB(PSSDBLP,"RX_NUM")),"^",18)=1,$P(PSSDBCAR(PSSDBFDB(PSSDBLP,"RX_NUM")),"^",13)=1
	;S PSSENHKZ(PSSDBFDB(PSSDBLP,"RX_NUM"))=1
	D DPL^PSSDSAPK
	Q
