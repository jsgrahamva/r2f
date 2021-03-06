PSJCLOR5	;BIR/JCH - INPATIENT MEDICATIONS UTILITIES FOR CLINIC ORDERS ;25 SEP 97 / 7:43 AM
	;;5.0;INPATIENT MEDICATIONS;**275**;16 DEC 97;Build 157
	;
	; Reference to ^PS(55 is supported by DBIA# 2191
	;
DSPORD(PSGP,TMPORDER,PSJORDAR)	; Display order summary
	N NDP2,PSJOINM,TMPSTOP,ND0,ND2,NDP1,TMPSTARE,TMPSOL1,PSJBLANK S ND0=$S(TMPORDER["U":$G(^PS(55,PSGP,5,+TMPORDER,0)),TMPORDER["P":$G(^PS(53.1,+TMPORDER,0)),TMPORDER["V":$G(^PS(55,PSGP,"IV",+TMPORDER,0)),1:"")
	S ND2=$S(TMPORDER["U":$G(^PS(55,PSGP,5,+TMPORDER,2)),TMPORDER["P":$G(^PS(53.1,+TMPORDER,2)),TMPORDER["V":$G(^PS(55,PSGP,"IV",+TMPORDER,2)),1:""),TMPSTOP=$P(ND2,"^",4)
	S NDP2=$S(TMPORDER["U":$G(^PS(55,PSGP,5,+TMPORDER,.2)),TMPORDER["P":$G(^PS(53.1,+TMPORDER,.2)),TMPORDER["V":$G(^PS(55,PSGP,"IV",+TMPORDER,.2)),1:"")
	I TMPORDER["V" S TMPSOL1=$G(^PS(55,PSGP,"IV",+TMPORDER,"SOL",1,0)),TMPSTOP=$P(ND0,"^",3)
	S TMPSTARE=$S(TMPORDER["P"!(TMPORDER["U"):$$FMTE^XLFDT($P(ND2,"^",2),2),TMPORDER["V":$$FMTE^XLFDT($P(ND0,"^",2),2),1:"") I TMPSTARE D
	.S TMPSTARE=$P(TMPSTARE,"@"),TMPSTOP=$P($$FMTE^XLFDT(TMPSTOP,2),"@") F TMPDT="TMPSTARE","TMPSTOP" N PSJPCNT,PSJPCV S PSJPCNT=0 F PSJPCNT=1:1 S PSJPCV=$P(@(TMPDT),"/",PSJPCNT) Q:(PSJPCV="")  I PSJPCV,(PSJPCV<10) D
	..S $P(@(TMPDT),"/",PSJPCNT)=0_+PSJPCV
	.S TMPSTARE=TMPSTARE_"    "_TMPSTOP
	I '$G(PSJORDAR) D
	.I TMPORDER'["V" S PSJOINM=$P($G(^PS(50.7,+$P(NDP2,"^"),0)),"^") W !?5,$S(PSJOINM]"":PSJOINM,1:"DRUG NAME NOT FOUND") W ?50,TMPSTARE D
	..W !?8," Give: ",$P(NDP2,"^",2)," ",$P($G(^PS(51.2,+$P(ND0,"^",3),0)),"^",3)," ",$P(ND2,"^")
	.I TMPORDER["V" D
	..N PSIVACNT,PSJINDNT,AD,ADINT,ADEXT S AD=0 F PSIVACNT=1:1  S AD=$O(^PS(55,PSGP,"IV",+TMPORDER,"AD",AD)) Q:AD=""  S ADINT=$G(^(AD,0)),AD(0)=$G(AD(0))+1 I ADINT W !?5,$P($G(^PS(52.6,+ADINT,0)),"^") I (PSIVACNT=1) W ?50,TMPSTARE
	..S PSJINDNT=$S($G(ADINT):8,1:4)
	..W !?PSJINDNT W " in ",$P($G(^PS(52.7,+$G(TMPSOL1),0)),"^")," ",$P(TMPSOL1,"^",2)," ",$P(ND0,"^",8),?50,$S('$G(ADINT):TMPSTARE,1:"")
	I $G(PSJORDAR) S $P(PSJBLANK," ",75)=" " D
	.I TMPORDER'["V" S PSJORDAR(1)="     "_$P($G(^PS(50.7,+$P(NDP2,"^"),0)),"^") D
	..S PSJORDAR(1)=PSJORDAR(1)_$E(PSJBLANK,1,49-$L(PSJORDAR(1)))_TMPSTARE
	..S PSJORDAR(2)=$E(PSJBLANK,1,8)_"Give: "_$P(NDP2,"^",2)_" "_$P($G(^PS(51.2,+$P(ND0,"^",3),0)),"^",3)_" "_$P(ND2,"^")
	.I TMPORDER["V" N AD,ADINT,ADEXT,PSJINDNT,PAD1,PAD2 S $P(PAD1," ",75)=" " D
	..N II S II=1,AD=0 F  S AD=$O(^PS(55,PSGP,"IV",+TMPORDER,"AD",AD)) Q:AD=""  D
	...S ADINT=$G(^(AD,0)) I ADINT S ADEXT=$P($G(^PS(52.6,+ADINT,0)),"^") S AD(0)=$G(AD(0))+1,PSJORDAR(AD(0))="     "_ADEXT S PSJORDAR(AD(0))=PSJORDAR(AD(0))_$E(PSJBLANK,1,49-$L(PSJORDAR(AD(0))))_$S(II=1:TMPSTARE,1:""),II=II+1
	..S PSJINDNT=$S($G(ADINT):8,1:4)
	..S AD(0)=$G(AD(0))+1 S PSJORDAR(AD(0))=$E(PSJBLANK,1,PSJINDNT)_" in "_$P($G(^PS(52.7,+$G(TMPSOL1),0)),"^")_" "_$P(TMPSOL1,"^",2)_" "_$P(ND0,"^",8) D
	...S PSJORDAR(AD(0))=$E(PSJORDAR(AD(0)),1,49) S PAD2=49-$L(PSJORDAR(AD(0))),PAD2=$E(PAD1,1,PAD2) S PSJORDAR(AD(0))=PSJORDAR(AD(0))_$S('$G(ADINT):PAD2_TMPSTARE,1:"")
	Q
ORDCHK	; Check for conflicts among selected orders
	N PSJHOLD,PSJSELOR,PSJREVDN,PSJOROR,PSJOROR2,PSJCOMFL,TMPSELX,TMPSELX2,TMPSELCO,TMPSELCO1,TMPSELCO2,PSJONCAL
	S PSJSELOR=$S($G(TMPSELOR):TMPSELOR,1:$P($G(Y(1)),"=",2)) Q:'PSJSELOR  I $E(PSJSELOR,$L(PSJSELOR))'="," S PSJSELOR=PSJSELOR_","
	D NOW^%DTC S PSGDT=+$E(%,1,12),PSJCOMFL="",PSJONCAL=""
	S TMPCNT=0,TMPSEL=0,PSJTMPON="" F TMPCNT=1:1:($L(PSJSELOR,",")) Q:'TMPCNT  D
	.S TMPSEL=$P(PSJSELOR,",",TMPCNT) Q:'TMPSEL  S PSJTMPON=$G(^TMP("PSJON",$J,TMPSEL)) Q:'PSJTMPON
	.N STAT S STAT=$S(PSJTMPON["U":$P($G(^PS(55,PSGP,5,+PSJTMPON,0)),"^",9),PSJTMPON["V":$P($G(^PS(55,PSGP,"IV",+PSJTMPON,0)),"^",17),1:"")
	.I STAT="H" S PSJHOLD(PSJTMPON)=TMPSEL
	S TMPSELCO=PSJSELOR
	I $D(PSJHOLD)>1 D FULL^VALM1 D
	.N PSJDASH1 S $P(PSJDASH1,"-",75)="-"
	.W !!,"  ON HOLD orders cannot be edited - no changes will be applied",!,"  to any of the following ON HOLD orders:"
	.W !,"ON HOLD orders:",?45,"Current Start / Stop Dates",!,PSJDASH1
	.N PSJOHCT S PSJOROR2="" F PSJOHCT=1:1 S PSJOROR2=$O(PSJHOLD(PSJOROR2)) Q:'PSJOROR2  D
	..I '(PSJOHCT#8) N DIR W ! D CONT^PSJOE0,CLEAR^VALM1,FULL^VALM1 W !!,"ON HOLD orders (CONTINUED):",?45,"Current Start / Stop Dates",!,PSJDASH1
	..D DSPORD^PSJCLOR2(PSGP,PSJOROR2)
	..I PSJHOLD(PSJOROR2)=$P(TMPSELCO,",") S TMPSELCO=$P(TMPSELCO,PSJHOLD(PSJOROR2)_",",2) Q
	..S TMPSELCO1=$P(TMPSELCO,","_PSJHOLD(PSJOROR2)_","),TMPSELCO2=$P(TMPSELCO,","_PSJHOLD(PSJOROR2)_",",2) S TMPSELCO=TMPSELCO1_$S(TMPSELCO2]"":","_TMPSELCO2,1:"")
	.N DIR W ! D CONT^PSJOE0 W !
	S (PSJSELOR,TMPSELOR)=TMPSELCO
	S TMPCNT=0,TMPSEL=0,PSJTMPON="" F TMPCNT=1:1:($L(PSJSELOR,",")) Q:'TMPCNT  D
	.S TMPSEL=$P(PSJSELOR,",",TMPCNT) Q:'TMPSEL  S PSJTMPON=$G(^TMP("PSJON",$J,TMPSEL)) Q:'PSJTMPON
	.N STAT S STAT=$S(PSJTMPON["U":$P($G(^PS(55,PSGP,5,+PSJTMPON,0)),"^",9),PSJTMPON["V":$P($G(^PS(55,PSGP,"IV",+PSJTMPON,0)),"^",17),1:"")
	.I STAT="O" S PSJONCAL(PSJTMPON)=TMPSEL
	S TMPSELCO=PSJSELOR
	I $D(PSJONCAL)>1 D FULL^VALM1 D
	.N PSJOCCNT,PSJDASH1 S $P(PSJDASH1,"-",75)="-"
	.W !!,"  Orders with ON CALL Status cannot be edited - no changes will be applied",!,"  to any of the following orders with ON CALL status:"
	.W !,"ON CALL Status orders:",?45,"Current Start / Stop Dates",!,PSJDASH1
	.S PSJOROR2="" F PSJOCCNT=1:1 S PSJOROR2=$O(PSJONCAL(PSJOROR2)) Q:'PSJOROR2  D
	..I '(PSJOCCNT#8) N DIR W ! D CONT^PSJOE0,CLEAR^VALM1,FULL^VALM1 W !!,"ON CALL Status orders (CONTINUED):",?45,"Current Start / Stop Dates",!,PSJDASH1
	..D DSPORD^PSJCLOR2(PSGP,PSJOROR2)
	..I PSJONCAL(PSJOROR2)=$P(TMPSELCO,",") S TMPSELCO=$P(TMPSELCO,PSJONCAL(PSJOROR2)_",",2) Q
	..S TMPSELCO1=$P(TMPSELCO,","_PSJONCAL(PSJOROR2)_","),TMPSELCO2=$P(TMPSELCO,","_PSJONCAL(PSJOROR2)_",",2) S TMPSELCO=TMPSELCO1_$S(TMPSELCO2]"":","_TMPSELCO2,1:"")
	.N DIR W ! D CONT^PSJOE0 W !
	S (PSJSELOR,TMPSELOR)=TMPSELCO
	S TMPCNT=0,TMPSEL=0,PSJTMPON="" F TMPCNT=1:1:($L(PSJSELOR,",")) Q:'TMPCNT  D
	.S TMPSEL=$P(PSJSELOR,",",TMPCNT) Q:'TMPSEL  S PSJTMPON=$G(^TMP("PSJON",$J,TMPSEL)) Q:'PSJTMPON
	.I (PSJTMPON=+PSJTMPON),$D(^PS(53.1,"ACX",PSJTMPON)) S PSJCOMFL="P",PSJOROR="" F  S PSJOROR=$O(^PS(53.1,"ACX",PSJTMPON,PSJOROR)) Q:'PSJOROR  S PSJCOMFL(PSJOROR_"P")=TMPSEL
	.I PSJCOMFL="" S PSJOROR=$S(PSJTMPON["U":$P($G(^PS(55,PSGP,5,+PSJTMPON,.2)),"^",8),PSJTMPON["V":$P($G(^PS(55,PSGP,"IV",+PSJTMPON,.2)),"^",8),1:"") Q:'PSJOROR  D
	..S PSJCOMFL(PSJTMPON)=TMPSEL
	S TMPSELCO=PSJSELOR
	I $D(PSJCOMFL)>1 D FULL^VALM1 D
	.N PSJDASH1 S $P(PSJDASH1,"-",75)="-"
	.W !!,"  Complex Orders cannot be edited - no changes will be applied",!,"   to any of the following Complex order components:"
	.W !,"Complex Component (Child) Orders:",?45,"Current Start / Stop Dates",!,PSJDASH1
	.N PSJCOMCT S PSJOROR2="" F PSJCOMCT=1:1 S PSJOROR2=$O(PSJCOMFL(PSJOROR2)) Q:'PSJOROR2  D
	..I '(PSJCOMCT#8) N DIR W ! D CONT^PSJOE0,CLEAR^VALM1,FULL^VALM1 W !!,"Complex orders (CONTINUED):",?45,"Current Start / Stop Dates",!,PSJDASH1
	..D DSPORD^PSJCLOR2(PSGP,PSJOROR2)
	..I PSJCOMFL(PSJOROR2)=$P(TMPSELCO,",") S TMPSELCO=$P(TMPSELCO,PSJCOMFL(PSJOROR2)_",",2) Q
	..S TMPSELCO1=$P(TMPSELCO,","_PSJCOMFL(PSJOROR2)_","),TMPSELCO2=$P(TMPSELCO,","_PSJCOMFL(PSJOROR2)_",",2) S TMPSELCO=TMPSELCO1_$S(TMPSELCO2]"":","_TMPSELCO2,1:"")
	.W ! N DIR D CONT^PSJOE0 W !
	S (PSJSELOR,TMPSELOR)=TMPSELCO
	N TMPNEWSD,TMPSEL,TMPCLN,TMPCLNAR,PSJSTPDT,PSJTMPON,TMPCNT S PSJSTPDT="" S PSJQMSG=0,PSJABORT=0
	I ('$G(PSGOEAV)&(+$G(PSJSYSU)=3))!(+$G(PSJSYSU)'=3) S TMPCNT=0,TMPSEL=0,PSJTMPON="" F TMPCNT=1:1:($L(PSJSELOR,",")) Q:'TMPCNT!$G(PSJREVFY)!$G(PSJREVDN)  D
	.S TMPSEL=$P(PSJSELOR,",",TMPCNT) Q:'TMPSEL  S PSJTMPON=$G(^TMP("PSJON",$J,TMPSEL)) Q:'PSJTMPON
	.I PSJTMPON["V"!(PSJTMPON["U") S PSJREVFY=$S(+PSJSYSU=3:$$PSJREVFY^PSJCLOR1(),1:$$SURE^PSJCLOR1()),PSJREVDN=1
	I $G(DUOUT)!($G(PSJREVFY)<0) S PSJABORT=2 Q
	;
	S TMPCNT=0,TMPSEL=0,PSJTMPON="" F TMPCNT=1:1:($L(PSJSELOR,",")) Q:'TMPCNT  S TMPSEL=$P(PSJSELOR,",",TMPCNT) Q:'TMPSEL  S PSJTMPON=$G(^TMP("PSJON",$J,TMPSEL)) Q:'PSJTMPON  D
	.N ND0,ND2,NDP1 S ND0=$S(PSJTMPON["U":$G(^PS(55,PSGP,5,+PSJTMPON,0)),PSJTMPON["P":$G(^PS(53.1,+PSJTMPON,0)),PSJTMPON["V":$G(^PS(55,PSGP,"IV",+PSJTMPON,0)),1:"")
	.S ND2=$S(PSJTMPON["U":$G(^PS(55,PSGP,5,+PSJTMPON,2)),PSJTMPON["P":$G(^PS(53.1,+PSJTMPON,2)),PSJTMPON["V":$G(^PS(55,PSGP,"IV",+PSJTMPON,2)),1:"")
	.S TMPSTR=$S(PSJTMPON["P"!(PSJTMPON["U"):$P(ND2,"^",2),PSJTMPON["V":$P(ND0,"^",2),1:"") S TMPSTR($P(TMPSTR,"."))=""
	.S TMPCLN=$S(PSJTMPON["P":+$G(^PS(53.1,+PSJTMPON,"DSS")),PSJTMPON["U":+$G(^PS(55,+$G(PSGP),5,+PSJTMPON,8)),PSJTMPON["V":+$G(^PS(55,$G(PSGP),"IV",+PSJTMPON,"DSS")),1:"")
	.Q:'TMPCLN  I $O(TMPCLNAR("")),$O(TMPCLNAR(""))'=TMPCLN S PSJABORT=1
	.S TMPCLNAR(+TMPCLN)=""
	S TMPSTR="" F  S TMPSTR=$O(TMPSTR(TMPSTR)) Q:'TMPSTR  S TMPSTR(0)=$G(TMPSTR(0))+1
	I $G(PSJABORT)!($G(TMPSTR(0))>1) D
	.K DIR S DIR("A",1)="     You have selected orders"_$S($G(PSJABORT):" from different clinics",1:" with different Start Date/Times")_"  "
	.I $G(PSJABORT)&($G(TMPSTR(0))>1) S DIR("A",2)="          and with different Start Date/Times."
	.S DIR("A",3)="",DIR("A",4)=""
	.W ! N X,Y S DIR("A")="Do you want to continue",DIR(0)="Y" D ^DIR S PSJABORT=$S(Y>0:1,1:2)
	Q
	; 
NEWCLN	; Clean up Order variables
	K PSGNEDFD,PSGOEE,PSGOEEWF,PSGOORD,PSGPD,PSGPDN,PSGPDRGN,PSGRDTX,PSGS0Y,PSJCOM,PSJL,PSJNOO,PSJQMSG
	K PSJTMPON,VALMBCK,VALMCNT,VALMQUIT
	Q
