FBAAUTL2	;AISC/GRR-FEE UTILITY ROUTINE ; 11/8/12 2:31pm
	;;3.5;FEE BASIS;**8,143**;JAN 30, 1995;Build 20
	;;Per VA Directive 6402, this routine should not be modified.
CONDAT	;called from input transform in 161.21,.02-.03
	S (FBOUT,Z)=0
	F  S Z=$O(^FBAA(161.21,"C",+$G(FBVIEN),Z)) Q:'Z  I $P($G(^FBAA(161.21,Z,0)),U,2) S Z(0)=^(0),FBVCON($P(Z(0),U,2))=$P(Z(0),U,3)
	K FBVCON(+$P(^FBAA(161.21,DA,0),U,2))
	S Z=0 F  S Z=$O(FBVCON(Z)) Q:Z'>0!(FBOUT)  I X'<Z&(X'>FBVCON(Z)) S FBOUT=1 W !,*7,"Date entered overlaps existing contract dates!",! K X,Z,FBVCON Q
	K Z,FBVCON
	Q
DATES	;ASK FROM AND TO DATES AND ENSURE THEY DO NOT OVERLAP PRIOR AUTHORIZATIONS
	;variables FBO and FB1 are set in FBNHEDAT as default dates
	S FBFLAG=1 K FBAUT
FDAT	S (FBBEGDT,FBENDDT)="",%DT("A")="Select FROM DATE: ",%DT="AEX" S:$S($G(FBO):1,1:0) %DT("B")=$$FMTE^XLFDT(FBO,1) D ^%DT G:Y'>0 END S FBBEGDT=Y
	G:FBFLAG=2 EN1
EDAT	S FBOUT=0,%DT("A")="Select TO DATE: ",%DT="AEX",%DT(0)=FBBEGDT S:$S($G(FB1):1,1:0) %DT("B")=$$FMTE^XLFDT(FB1,1) D ^%DT K %DT(0) G:Y'>0 END S FBENDDT=Y
EN1	;CHECK WHETHER AUTHORIZATION FROM DATE OVERLAPS PREVIOUS ENTRIES
	S (FBOUT,FBLG)=0 F Z=0:0 S Z=$O(^FBAAA(DFN,1,Z)) Q:Z'>0  I $D(^(Z,0)) S Z(0)=^(0) I $P(Z(0),"^",3)=FBPROG S FBAUT($P(Z(0),"^"))=$P(Z(0),"^",2)
	I $G(FBO),($G(FB1)),($G(FBAUT(FBO))=FB1) K FBAUT(FBO)
	F Z=0:0 S Z=$O(FBAUT(Z)) Q:Z'>0!(FBOUT)  D CHKDT:FBFLAG=1,CHKBO:FBFLAG=2,ERRD:FBLG>0
	I FBOUT S FBOUT=0 G:FBLG>0&(FBFLAG=1) FDAT
	Q
END	S (FBBEGDT,FBENDDT)="" K Z,FBAUT,FBOUT,FBLG Q
CHKDT	I FBBEGDT<Z&(FBENDDT<Z) S FBLG=0,FBOUT=1 Q
	I FBBEGDT<Z&(FBENDDT'<Z) S FBLG=2,FBOUT=1 Q
	I FBPROG=7,FBAUT(Z)>DT S FBLG=0,FBOUT=1,FBBEGDT="" K FBAUT W !!?5,"There already is an active CNH authorization on file.",!?5,"Use the 'Edit CNH Authorization' option.",! Q
	I FBPROG=7,FBBEGDT=FBAUT(Z) Q
CHKBO	I FBBEGDT'<Z&(FBBEGDT'>FBAUT(Z)) S FBLG=1,FBOUT=1 Q
	Q
ERRD	W !,*7,$S(FBLG=1:"FROM ",1:"TO "),"DATE entered overlaps a previous Authorization!",!
	Q
	;
UPDT	;UPDATE BATCH STATUS
	S DA=J,(DIC,DIE)="^FBAA(161.7,",DR="11////^S X=FBSTAT;12////^S X=DT" D ^DIE Q
	Q
	;
PAT	S FBSSN=$P(Y(0),"^",9) S:$L(FBSSN)=9 FBSSN=FBSSN_" " S FBSEX=$P(Y(0),"^",2),FBSEX=$S(FBSEX="F":FBSEX,1:"M")
	S FBDOB=$P(Y(0),"^",3),FBDOB=$S(FBDOB="":"        ",1:$E(FBDOB,4,7)_($E(FBDOB,1,3)+1700))
	S FBNAME=$P(Y(0),"^",1),FBLNAM=$E($P(FBNAME,",",1),1,5),FBFLNAM=$E($P(FBNAME,",",1),1,21),FBFLNAM=FBFLNAM_$E(PAD,$L(FBFLNAM)+1,21)
	S:$L(FBLNAM)<5 FBLNAM=FBLNAM_$E("     ",$L(FBLNAM)+1,5)
	S FBFI=$E($P(FBNAME,",",2),1),FBMI=$P(FBNAME,",",2),A=$F(FBMI," "),FBMI=$S(A<1:" ",1:$E(FBMI,A)),FBMI=$S(FBMI="":" ",1:FBMI)
	Q
	;
ASKVOK	S DIR(0)="Y",DIR("A")="Is this the correct vendor",DIR("B")="YES" D ^DIR K DIR G:$D(DIRUT) VENOUT S:'Y FBVENO=1
	Q
VENOUT	S FBVENOT=1 K DIRUT Q
	;
FBPH	W ! S DIR("A")="Want to review fee pharmacy payment history",DIR("B")="No",DIR(0)="Y" D ^DIR K DIR
	I Y,$D(DFN),$D(^DPT(+DFN,0)) S N=$P(^(0),"^"),FBHDFN=DFN N FBAAOUT D LIST^FBAAPPH S DFN=FBHDFN K FBHDFN
	Q
PRPRDT	D NOW^%DTC S Y=% X ^DD("DD") W ?60,Y
	Q
IFCAP	S PRCF("X")="S" D ^PRCFSITE S PRC("SITE")=$S($D(PRC("SITE")):PRC("SITE"),1:"") I PRC("SITE")="" S FBERR(1)=1 Q
	S FB("SITE")=PRC("SITE")
	Q
POV	;GET POV/TREATMENT TYPE FROM 161 FOR TRANSMISSION OF PAYMENTS
	S (FBTT,POV)="" Q:'$D(^FBAAC(K,1,L,1,M,0))  S POV(0)=$P(^(0),"^",4) Q:POV(0)=""
	Q:'$D(^FBAAA(K,1,POV(0),0))  S POV=$P(^(0),"^",7),FBTT=$P(^(0),"^",13)
	Q
XREF	;SET X-REF FOR PRINT AUTHORIZATION FIELD (161.01,1)
	Q:'$D(^FBAAA(DA(1),1,DA,0))  N FBZZ S FBZZ(0)=^(0),FBZZ(1)=$P(FBZZ(0),"^",3)
	S FBZZ(2)=$S(FBZZ(1)=2:"",FBZZ(1)=3:"",FBZZ(1)=11:"",1:1) I FBZZ(2) S ZZZ="" Q
	S ZZZ=$P(FBZZ(0),"^",13),ZZZ=$S(ZZZ=1:$P(FBZZ(0),"^"),ZZZ=2:$P(FBZZ(0),"^"),ZZZ=3:$S($D(^FBAAA(DA(1),4)):$P(^(4),"^",2),1:""),1:"")
	Q
ADD	S ZZZ="" D XREF Q:ZZZ=""  S ^FBAAA("AF",$P(^FBAAA(DA(1),1,DA,0),"^",3),ZZZ,DA(1),DA)=""
	Q
KILL	S ZZZ="" D XREF Q:ZZZ=""  K ^FBAAA("AF",$P(^FBAAA(DA(1),1,DA,0),"^",3),ZZZ,DA(1),DA)
	Q
OPPS	;FB*3.5*143 Adds support for OPPS payment model to input transform of
	; Amount Paid field of the Fee Basis Payment (#162).
	I $D(^XUSEC("FBAASUPERVISOR",DUZ)) Q
	I $P(^FBAAC(DA(3),1,DA(2),1,DA(1),1,DA,0),"^",2)<X D EN^DDIOL("Amount Paid cannot be greater than Amount Claimed!","","$C(7),!") K X
	Q
	;
VER(X)	;determine version of a file based on DD node
	;X= file number
	Q $S('X:0,1:+$P($G(^DD(X,0,"VR")),U))
