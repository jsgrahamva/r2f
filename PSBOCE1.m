PSBOCE1	;BIRMINGHAM/TEJ-Expired/DC'd/EXPIRING ORDERS REPORT (1) ;Mar 2004
	;;3.0;BAR CODE MED ADMIN;**32,50**;Mar 2004;Build 78
	;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified.
	;
FMTDT(Y)	;
	; Format date/time as displayed by GUI  ie. 02/25/2005@2323
	N X S X=$E(Y,4,5) X ^DD("DD") S Y=$TR(Y," ,:","//") S $P(Y,"/")=X
	Q Y
BUILDLN	; Constr recs
	K J S J(0)="" F PSBFLD=1:1:8 S J=1 D FORMDAT(PSBFLD) S J($O(PSBRPLN(""),-1))=""
	; Write administration info...
	Q:'PSBXFLG
	S J=($O(J(""),-1)+1),PSBRPLN(J)=PSBBLANK,J(J)="",J=J+1
	S (N,Y)=""
	M PSBLGD("INITIALS")=PSBLGD(PSBX2X,"X","INITIALS")
	F  S Y=$O(PSBADM(PSBX2X,Y)) Q:Y']""  D
	.F  S N=$O(PSBADM(PSBX2X,Y,N)) Q:N']""  D
	..I $D(PSBBID(PSBX2X,$P(N,U,2))) S PSBDATA(2,0)="BAG ID: "_PSBBID(PSBX2X,$P(N,U,2))
	..S $E(PSBDATA(2,0),25)="ACTION BY: "_$P(PSBADM(PSBX2X,Y,N),U,7)_" "_$$FMTDT^PSBOCE1($E($P(PSBADM(PSBX2X,Y,N),U,6),1,12))
	..S X=$P(PSBADM(PSBX2X,Y,N),U,5) S $E(PSBDATA(2,0),56)="ACTION: "_$S(X="G":"GIVEN",X="R":"REFUSED",X="RM":"REMOVED",X="H":"HELD",X="S":"STOPPED",X="I":"INFUSING",X="C":"COMPLETED",X="M":"MISSING DOSE",X=" ":"*UNKNOWN*",1:" ")
	..I $D(PSBPRNR(PSBX2X)) S $E(PSBDATA(2,0),72)="PRN REASON: "_PSBPRNR(PSBX2X,$P(N,U,2))
	..I $G(PSBDATA(2,0))]" " D WRAPPER(1,132-1,PSBDATA(2,0)) K PSBDATA(2) S J=J+1
	..N PSBEIECMT S PSBEIECMT="" I $D(PSBPRNEF(PSBX2X,$P(N,U,2))),$P($G(PSBRPT(.2)),U,8)=0 S PSBEIECMT=$$PRNEFF^PSBO(PSBEIECMT,$P(N,U,2))
	..I $D(PSBPRNEF(PSBX2X,$P(N,U,2))) S PSBDATA(2,0)="PRN EFFECTIVENESS: "_PSBPRNEF(PSBX2X,$P(N,U,2))_PSBEIECMT
	..I $G(PSBDATA(2,0))]" " D WRAPPER(30,132-30,PSBDATA(2,0)) K PSBDATA(2) S J=J+1
	..I ('PSBCFLG)!('$D(PSBCMT(PSBX2X,$P(N,U,2)))) S PSBRPLN(J)=PSBBLANK,J(J)="",J=J+1 Q
	..M PSBLGD("INITIALS")=PSBLGD(PSBX2X,"C","INITIALS")
	..S X="" F   S X=$O(PSBCMT(PSBX2X,$P(N,U,2),X)) Q:X']""  D
	...N PSBDAT S PSBDAT="" F  S PSBDAT=$O(PSBCMT(PSBX2X,$P(N,U,2),X,PSBDAT)) Q:PSBDAT']""  D
	....S PSBDATA(2,0)="COMMENT BY: "_$S($P(PSBCMT(PSBX2X,$P(N,U,2),X,PSBDAT),U,5)]"":$P(PSBCMT(PSBX2X,$P(N,U,2),X,PSBDAT),U,5)_" "_$$FMTDT^PSBOCE1($E($P(PSBCMT(PSBX2X,$P(N,U,2),X,PSBDAT),U,6),1,12)),1:" n/a ")
	....S PSBDATA(2,0)=PSBDATA(2,0)_"  COMMENT: "_$S($P(PSBCMT(PSBX2X,$P(N,U,2),X,PSBDAT),U,2)]"":$P(PSBCMT(PSBX2X,$P(N,U,2),X,PSBDAT),U,2),1:" ")
	....I $G(PSBDATA(2,0))]" " D WRAPPER(30,132-30,PSBDATA(2,0)) K PSBDATA(2) S J=J+1
	..S PSBRPLN(J)=PSBBLANK,J(J)="",J=J+1
	Q
FORMDAT(FLD)	;
	K PSBVAL
	Q:'$D(PSBDATA(1,FLD))
	S PSBVAL=PSBDATA(1,FLD)
	D WRAPPER(@("PSBTAB"_(FLD-1))+1,((@("PSBTAB"_(FLD))-(@("PSBTAB"_(FLD-1))+1))),PSBVAL)
	I FLD=4 S J=$O(J(""),-1)+1,PSBVAL=PSBDATA(1,4,0) D WRAPPER(@("PSBTAB"_(FLD-1))+1,((@("PSBTAB"_(FLD))-(@("PSBTAB"_(FLD-1))+1))),PSBVAL)
	Q
WRAPPER(X,Y,Z)	;  Text WRAP
	N PSB
	I ($L(Z)>0),$F(Z,"""")>1 F  Q:$F(Z,"""")'>1  S Z=$TR(Z,"""","^")
	F  Q:'$L(Z)  D
	.I $L(Z)<Y S $E(PSBRPLN(J),X)=Z S Z="" Q
	.F PSB=Y:-1:0 Q:$E(Z,PSB)=" "
	.S:PSB<1 PSB=Y
	.S $E(PSBRPLN(J),X)=$E(Z,1,PSB)
	.I $L(PSBRPLN(J),"^")>1 F X=1:1:$L(PSBRPLN(J),"^")-1 S $P(PSBRPLN(J),"^",X)=$P(PSBRPLN(J),"^",X)_""""
	.S PSBRPLN(J)=$TR(PSBRPLN(J),"^","""")
	.S Z=$E(Z,PSB+1,250),J=J+1,J(J)=""
	Q ""
PGC	;
	S PSBPGNUM=PSBPGNUM+1,PSBLNTOT=PSBTOPHD S PSBMORE=$S(PSBMORE>(IOSL-(PSBTOPHD)):(IOSL-(PSBTOPHD)),1:PSBMORE)
	S NOTE(PSBPGNUM)="( "_PSBX1X_" - Continued )"
	Q
