XQSET	;MJM/SEA - Rebuild display/user XUTL("XQO") ;05/09/2011
	;;8.0;KERNEL;**28,82,155,569**;Jul 10, 1995;Build 1
SET	;Rebuild the +XQDIC and "U"_DUZ nodes
	;
	;** P569 START CJM
	I XQDIC["U",$P(XQDIC,"U",2)'=DUZ D  Q
	.D
	..N DUZ
	..S DUZ=$P(XQDIC,"U",2)
	..D NEWSET
	.D
	..N XQDIC
	..S XQDIC="U"_DUZ
	..D NEWSET
	D NEWSET
	Q
	;
NEWSET	;
	;
	; ** P569 END CJM
	;
	K ^XUTL("XQO",XQDIC)
	I XQDIC=+XQDIC,'$D(^DIC(19,XQDIC,0)) Q
	F XQSI=0:0 S XQSI=$S(+XQDIC:$O(^DIC(19,XQDIC,10,XQSI)),1:$O(^VA(200,DUZ,203,XQSI))) Q:XQSI'>0  I $D(^(XQSI,0)) S XQSY=^(0) D SET1
	S XQSK=250,XQSD="",XQSM=1,XQSY=0,XQNO=0
	F XQSI=0:0 S XQSY=$O(XQST(XQSY)) Q:XQSY=""!($E(XQSY,1,4)="ZZZZ")  D
	.S XQS0=+XQST(XQSY)
	.D DIS
	.S:(XQSK<$L(XQS0)) ^XUTL("XQO",XQDIC,0,XQSM)=XQSD,XQSD="",XQSK=250,XQSM=XQSM+1
	.I XQNO S XQNO=0 Q
	.S XQSD=XQSD_XQS0,XQSK=XQSK-$L(XQS0)
	.Q
	I XQDIC=+XQDIC,$D(^DIC(19,XQDIC,0))#2 S:'$D(^DIC(19,XQDIC,99)) ^DIC(19,XQDIC,99)=$H S %H=^DIC(19,XQDIC,99)
	I XQDIC'=+XQDIC S:'$D(^VA(200,DUZ,203.1)) ^VA(200,DUZ,203.1)=$H S %H=^VA(200,DUZ,203.1)
	S ^XUTL("XQO",XQDIC,0,XQSM)=XQSD,^XUTL("XQO",XQDIC,0)=XQSM_U_%H
	S XQSY=0 F XQSI=0:0 S XQSY=$O(XQST(XQSY)) Q:XQSY=""  S %=XQST(XQSY),XQSK=$E(XQSY,5,99) D:$E(XQSK,1)=" " XBLK S:$L(XQSK) ^XUTL("XQO",XQDIC,XQSK)=%
	K %,%H,X,XQNO,XQSA,XQSB,XQSD,XQSDO,XQSI,XQSL,XQSK,XQS0,XQSOO,XQSPR,XQSN,XQST,XQSM,XQSX,XQSZ,XQSY
	Q
	;
SET1	Q:'$D(^DIC(19,+XQSY,0))  S XQS0=^(0),X=$S($D(^("U")):^("U"),1:"") I X="" S X=$E($P(XQS0,U,2),1,30) D UP S ^("U")=X
	S XQSOO=$P(XQS0,U,3),XQS0=$P(XQS0,U,1,2)_U_($S($P(XQS0,U,3)]"":1,1:""))_U_$P(XQS0,U,4,99)
	S (XQSX,XQSZ)="",%=$P(XQS0,U,9) I %]"",$L(%)>2 S XQSX=%_"MO-FR",XQSZ="MO-FR "_%
	I $D(^DIC(19,+XQSY,3.91)) F XQSL=0:0 S XQSL=$O(^DIC(19,+XQSY,3.91,XQSL)) Q:XQSL'>0  I ^(XQSL,0)]"" S XQSX=$S(XQSX'="":XQSX_";",1:"")_$P(^(0),U,1)_$P(^(0),U,2),XQSZ=$S(XQSZ'="":XQSZ_"; ",1:"")_$P(^(0),U,2)_" "_$P(^(0),U,1)
	I XQSX]"" S $P(XQS0,U,9)=XQSX
	S XQSX="" I $P(XQS0,U,16),$D(^DIC(19,+XQSY,3)) S XQSX=$P(^(3),U) I XQSX'="" S $P(XQS0,U,16)=XQSX
	S XQSN=$P(XQSY,U,2),XQSDO=$P(XQSY,U,3),^XUTL("XQO",XQDIC,"^",+XQSY)=XQSN_U_$P(XQS0,U,1,4)_"^^"_$P(XQS0,U,6,99)
	I $L(X) S:X?.N X=" "_X S X=$S($L(XQSN):"ZZZZ",$L(XQSDO):$E(0,1,($L(XQSDO*100)=3))_(XQSDO*100),1:"BBBB")_X D:$D(XQST(X)) SET3 S XQST(X)=+XQSY_"^1"
	I $L(XQSN) S X=XQSN D UP Q:'$L(X)  S:X?.N X=$E("    ",1,5-$L(X))_X S X=$S($L(XQSDO):$E(0,1,($L(XQSDO*100)=3))_(XQSDO*100),1:"AAAA")_X D:$D(XQST(X)) SET3 S XQST(X)=+XQSY_"^0"
	S:XQSOO]"" XQST(X,"OO")=XQSOO
	S:XQSZ]"" XQST(X,"TM")=XQSZ
	Q
SET3	S XQSD=X F I=0:0 S XQSM=$O(XQST(XQSD)) Q:($P(XQSM,U,1)'=X)  S XQSD=XQSM
	S I=+$P(XQSD,U,2) S X=X_U_(I+1) Q
CK	;
	S %=$P(^DIC(19,D0,0),U,6),%Y=$P(^DIC(19,D0,0),U,1) I $S($L(%):$D(^XUSEC(%,DUZ)),1:1)
	Q:'$T
	I DUZ(0)="@"!$D(^XUSEC("XUMGR",DUZ))!$D(^VA(200,DUZ,19.5,Y,0))
	Q:'$T
CK1	S %=$P(^DIC(19,D0,0),U,4),%Y=$P(^DIC(19,Y,0),U,4) I $S((%'="O"&(%'="Q"))&(%Y'="Q"):1,(%="O"&(%Y="O")):1,(%="Q"&((%Y="O")!(%Y="Q"))):1,1:0)
	Q
DEV	;See if device is legit for this option
	S (%,XQSJ)=0 Q:'$D(^DIC(19,+XQSW,3.96,0))
	F XQSL=1:1 S %=$O(^DIC(19,+XQSW,3.96,%)) Q:%=""!(%'=+%)  S:XQSIO=^(%,0) XQSJ=1
	Q
UP	S X=$$UP^XLFSTR(X) ;F XQSA=1:1 Q:X?.NUP  S %=$A(X,XQSA) I %<123,%>96 S X=$E(X,1,XQSA-1)_$C(%-32)_$E(X,XQSA+1,255)
	Q
XBLK	F XASB=0:0 S XQSW=$E(XQSK,1) Q:XQSW'=" "  S XQSK=$E(XQSK,2,99)
	Q
DIS	;Create display nodes
	S %=$S($D(^XUTL("XQO",XQDIC,"^",XQS0)):^(XQS0),1:"") S:$L(%) XQS0=% I '$L(%) S %=$O(^DIC(19,XQDIC,10,"B",XQS0,%)),%=$P(^DIC(19,XQDIC,10,%,0),U,2),XQS0=%_U_^DIC(19,XQS0,0)
	I "MO"[$P(XQS0,U,5) S $P(XQS0,U,3)=$P(XQS0,U,3)_" ..."
	I "SB"[$P(XQS0,U,5) S XQNO=1 ;Don't Display servers or broker-type options
	S XQS0=$P(XQS0,U,1,3)_U_$S($D(XQST(XQSY,"OO")):XQST(XQSY,"OO"),1:"")_U_$P(XQS0,U,7)_U_$S($D(XQST(XQSY,"TM")):XQST(XQSY,"TM"),1:"")_U_$P(XQS0,U,11)_U_$P(XQS0,U,17)_U
	Q
