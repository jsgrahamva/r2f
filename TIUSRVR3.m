TIUSRVR3	; SLC/JER - Load Signatures for record-wise GET ;4/12/01 [10/18/04 8:32am]
	;;1.0;TEXT INTEGRATION UTILITIES;**100,176,157,241**;Jun 20, 1997;Build 7
	; Created 4/12/01 by splitting TIUSRVR2
LOADSIG(DA,TIUL)	; Get signature and co-signature blocks
	N DIC,DIQ,DR,TIUSIG,TIUESIG1,TIUESIG2,TIUSIG1,TIUSIG2,TIUS1,TIUS2
	N TIUSNM,TIUSTTL,TIUS1DT,TIUS2DT,TIUSDT
	;VMP/ELR CHANGED NEXT LINE FROM QUIT IF NOT DEFINED TO GO TO XTRA
	I '$D(^TIU(8925,DA,15)) G XTRA
	S DIC=8925,DIQ="TIUSIG(",DIQ(0)="IE",DR="1204;1208;1501:1505;1507:1513;1601:1605"
	D EN^DIQ1 I '$D(TIUSIG) Q
	S TIUS1=$S(TIUSIG(8925,DA,1505,"I")="E":"/es/ ",TIUSIG(8925,DA,1505,"I")="C":"/s/ ",1:"")_$G(TIUSIG(8925,DA,1503,"E"))
	S TIUS2=$S(TIUSIG(8925,DA,1511,"I")="E":"/es/ ",TIUSIG(8925,DA,1511,"I")="C":"/s/ ",1:"")_$G(TIUSIG(8925,DA,1509,"E"))
	S TIUESIG1=$G(TIUSIG(8925,DA,1204,"I"))
	S TIUSIG1=$G(TIUSIG(8925,DA,1502,"I"))
	S TIUS1DT=$S(+$G(TIUSIG(8925,DA,1501,"I")):"Signed: "_$$DATE^TIULS($G(TIUSIG(8925,DA,1501,"I")),"MM/DD/CCYY HR:MIN"),1:"")
	S TIUESIG2=$G(TIUSIG(8925,DA,1208,"I"))
	S TIUS2DT=$S(+$G(TIUSIG(8925,DA,1507,"I")):"Cosigned: "_$$DATE^TIULS($G(TIUSIG(8925,DA,1507,"I")),"MM/DD/CCYY HR:MIN"),1:"")
	S TIUSIG2=$G(TIUSIG(8925,DA,1508,"I"))
	S TIUL=TIUL+1,@TIUARR@(TIUL)=" "
	S TIUL=TIUL+1,@TIUARR@(TIUL)=TIUS1
	S TIUL=TIUL+1,@TIUARR@(TIUL)=$G(TIUSIG(8925,DA,1504,"E"))
	S TIUL=TIUL+1,@TIUARR@(TIUL)=TIUS1DT
	I $G(TIUSIG(8925,DA,1505,"I"))="C" D
	. S TIUL=+$G(TIUL)+1,@TIUARR@(TIUL)="Marked signed on chart by: "_$G(TIUSIG(8925,DA,1512,"E"))
	I TIUSIG1]"",(TIUSIG1'=TIUESIG1) D LOADFOR(TIUSIG1,TIUESIG1,.TIUL)
	I +$G(TIUSIG(8925,DA,1507,"I"))>0 D
	. S TIUL=TIUL+1,@TIUARR@(TIUL)=" "
	. S TIUL=TIUL+1,@TIUARR@(TIUL)=TIUS2
	. S TIUL=TIUL+1,@TIUARR@(TIUL)=$G(TIUSIG(8925,DA,1510,"E"))
	. S TIUL=TIUL+1,@TIUARR@(TIUL)=TIUS2DT
	. I $G(TIUSIG(8925,DA,1511,"I"))="C" D
	. . S TIUL=+$G(TIUL)+1,@TIUARR@(TIUL)="Marked cosigned on chart by: "_$G(TIUSIG(8925,DA,1513,"E"))
	I TIUSIG2]"",(TIUSIG2'=TIUESIG2) D LOADFOR(TIUSIG2,TIUESIG2,.TIUL)
XTRA	I +$O(^TIU(8925.7,"B",DA,0)) D XTRASIG(DA,.TIUL)
	I +$G(TIUSIG(8925,DA,1601,"I")) D
	. N TIUMODE,TIUY
	. S TIUL=TIUL+1,@TIUARR@(TIUL)=""
	. S TIUY=$$DATE^TIULS(TIUSIG(8925,DA,1601,"I"),"MM/DD/CCYY HR:MIN")
	. S TIUY=TIUY_"  AMENDMENT FILED:"
	. S TIUL=TIUL+1,@TIUARR@(TIUL)=TIUY
	. S TIUL=TIUL+1,@TIUARR@(TIUL)=""
	. S TIUMODE=$S(+$G(TIUSIG(8925,DA,1603,"I")):"/es/ ",1:" /s/ ")
	. S TIUY=$S($G(TIUSIG(8925,DA,1604,"E"))]"":$G(TIUSIG(8925,DA,1604,"E")),1:$G(TIUSIG(8925,DA,1602,"E")))
	. S TIUL=TIUL+1,@TIUARR@(TIUL)=TIUMODE_TIUY
	. I $L($G(TIUSIG(8925,DA,1605,"E"))) D
	. . S TIUL=TIUL+1,@TIUARR@(TIUL)=$G(TIUSIG(8925,DA,1605,"E"))
	. S TIUL=TIUL+1,@TIUARR@(TIUL)=$P($G(TIUPRM1),U,5)
	Q
XTRASIG(TIUDA,TIUL)	; Load additional signature blocks
	N TIUI S TIUI=0
	S TIUL=TIUL+1,@TIUARR@(TIUL)=""
	S TIUL=TIUL+1,@TIUARR@(TIUL)="Receipt Acknowledged By:"
	F  S TIUI=$O(^TIU(8925.7,"B",TIUDA,TIUI)) Q:+TIUI'>0  D
	. N DA,DIC,DR,DIQ,TIUX,TIUXTRA,TIUSGNR,TIUSDT
	. S DIC="^TIU(8925.7,",DIQ="TIUXTRA",DA=TIUI,DR=".03:.08",DIQ(0)="IE"
	. D EN^DIQ1 Q:+$D(TIUXTRA)'>9
	. S TIUSGNR=$S($L($G(TIUXTRA(8925.7,DA,.06,"E"))):"/es/ "_$G(TIUXTRA(8925.7,DA,.06,"E")),1:"     "_$G(TIUXTRA(8925.7,DA,.03,"E")))
	. S TIUSDT=$S(+$G(TIUXTRA(8925.7,DA,.04,"I")):$$DATE^TIULS(TIUXTRA(8925.7,DA,.04,"I"),"MM/DD/CCYY HR:MIN"),1:"* AWAITING SIGNATURE *")
	. S TIUX=""
	. S TIUX=$$SETSTR^VALM1(TIUSDT,TIUX,1,38)
	. S TIUX=$$SETSTR^VALM1(TIUSGNR,$G(TIUX),25,55)
	. S TIUL=TIUL+1,@TIUARR@(TIUL)=TIUX,TIUX=""
	. S TIUX=$$SETSTR^VALM1($G(TIUXTRA(8925.7,DA,.07,"E")),$G(TIUX),30,50)
	. S TIUL=TIUL+1,@TIUARR@(TIUL)=TIUX
	. I $G(TIUXTRA(8925.7,DA,.05,"I")),$G(TIUXTRA(8925.7,DA,.05,"I"))'=$G(TIUXTRA(8925.7,DA,.03,"I")) D
	. . N TIUFOR
	. . S TIUX=""
	. . S TIUFOR="for "_$P($G(TIUXTRA(8925.7,DA,.03,"E")),",",2)_" "_$P($G(TIUXTRA(8925.7,DA,.03,"E")),",")
	. . S TIUX=$$SETSTR^VALM1(TIUFOR,$G(TIUX),26,55)
	. . S TIUL=TIUL+1,@TIUARR@(TIUL)=TIUX
	Q
LOADFOR(TIUS1,TIUES1,TIUL)	; Apply "for" block(s)
	N TIUESN1,TIUEST1,TIUFORN,TIUFORT
	S TIUESN1="for "_$$SIGNAME^TIULS(TIUES1),TIUEST1=$$SIGTITL^TIULS(TIUES1)
	I +$G(TIUS1),($G(TIUS1)'=$G(TIUES1)) S TIUFORN=$$SETSTR^VALM1(TIUESN1,$G(TIUFORN),1,50),TIUFORT=$$SETSTR^VALM1(TIUEST1,$G(TIUFORT),1,50)
	S TIUL=TIUL+1,@TIUARR@(TIUL)=TIUFORN
	S TIUL=TIUL+1,@TIUARR@(TIUL)=TIUFORT
	Q
