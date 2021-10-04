PRCFFM2M	;WOIFO/SJG/AS-ROUTINE TO PROCESS OBLIGATIONS ;3/8/05
V	;;5.1;IFCAP;**81,120**;Oct 20, 2000;Build 27
	;Per VHA Directive 2004-038, this routine should not be modified.
	;
SUPP	; Entry point for FMS Documents for Supply Fund Special Control Point
	; Amendments
	; Called from PRCHMA
	S DIC("S")="I +^(0)=PRC(""SITE"")",DIC=442,DIC(0)="NZ",X=PRCHPO
	D ^DIC K DIC G:+Y<0 EXIT
	S (XRBLD,FLG)=0,PO(0)=Y(0),PO=Y,PRCFA("PODA")=+Y,PCP=+$P(PO(0),"^",3),$P(PCP,"^",2)=$S($D(^PRC(420,PRC("SITE"),1,+PCP,0)):$P(^(0),"^",12),1:"")
	S MTOP=$P(^PRC(442,PRCFA("PODA"),0),"^",2)
	I $P($G(^PRC(443.6,PRCHPO,6,PRCHAM,1)),U,2)="" W !!,"PURCHASE ORDER HAS NOT BEEN PROPERLY SIGNED BY THE PURCHASING AGENT" Q
	D DT442^PRCFFUD1(PRCHPO,PO(0),443.6,PRCHAM)
	;S PRCFA("OBLDATE")=$$EN^PRCFFUD1() D ENSFM^PRCFFMO2
	S PRCFA("OBLDATE")=$$DTOBL^PRCFFUD1(PRC("RBDT"),PRC("PODT"))
	S PRCFA("BBFY")=$$BBFY^PRCFFU5(+PO) ;D BBFYCHK^PRCFFU19(+PO)
	D GENDIQ^PRCFFU7(442,+PO,".1;.07;.03;17","IEN","")
	S IDFLAG="I",PRCFA("AMEND#")=PRCHAM
	N PARAM S PARAM=+PCP_"^"_PRC("FY")_"^"_PRCFA("BBFY")
	S PRCFMO=$$ACC^PRC0C(PRC("SITE"),PARAM)
	S PRCFA("MOD")="M^1^Modification Entry"
	S PRCFA("DLVDATE")=+$P(^PRC(442,PRCFA("PODA"),0),"^",10)
	S PRCFA("IDES")="Purchase Order Amendment Obligation"
	S PRCFA("REF")=$P(PO(0),U),PRCFA("SYS")="FMS"
	S PRCFA("SFC")=$P(PO(0),U,19),PRCFA("MP")=$P(PO(0),U,2)
	S PRCFA("TT")=$S(PRCFA("MP")=2:"SO",PRCFA("MP")=1:"MO",PRCFA("MP")=8:"MO",1:"MO")
TRANS	; Transfer amendment entry from work file to Purchase Order file
	W !!,"...copying amendment information back to Purchase Order file...",! D WAIT^DICD
	D DT442^PRCFFUD1(PRCFA("PODA"),PO(0),442,"")
	S PRCOAMT=+^PRC(442,PRCFA("PODA"),0),$P(PRCOAMT,"^",2)=+$P(^(0),"^",3),$P(PRCOAMT,"^",3)=PRC("FYQDT"),$P(PRCOAMT,"^",5)=-$P(^(0),"^",$P(PRCFMO,"^",12)="N"+15)
	S ERFLAG=""
	D CHECK^PRCHAMYA(PRCFA("PODA"),PRCFA("AMEND#"),.ERFLAG)
	I ERFLAG W !!,"...ERROR IN COPYING AMENDMENT INFORMATION BACK TO PURCHASE ORDER FILE..." D MSG G EXIT
	D DT442^PRCFFUD1(PRCFA("PODA"),PO(0),442,PRCFA("AMEND#"))
	;  transmit amendment from IFCAP to DynaMed   **81**
	D:$$GET^XPAR("SYS","PRCV COTS INVENTORY",1)=1 ENT^PRCVPOU(PRCFA("PODA"),PRCFA("AMEND#"))
	S PRCFA("OLDPODA")=PRCFA("PODA"),PRCFA("OLDREF")=PRCFA("REF")
	N PARAM S PARAM="^"_PRC("SITE")_"^"_+PCP_"^"_PRC("FY")_"^"_PRCFA("BBFY")
	D DOCREQ^PRC0C(PARAM,"SPE","PRCFMO")
	S (PRCFA("G/N"),PRCFMO("G/N"))=$P(PRCFMO,U,12)
	D LIST^PRCFFU7(PRCFA("PODA"),PRCFA("AMEND#"))
	;PRC*5.1*120 => AUTOOBLG (set in PRCHSWCH) controls auto obligation of FCP UNOBL $$
	I MTOP'=25,($P($G(^PRC(442,PRCFA("PODA"),0)),U,19)=2!($G(AUTOOBLG)=1)),$G(PRCFA("AUTHE"))=1 D AMEND^PRCFFUD,FCP^PRCFFU11 G EXIT
	I MTOP'=25,'PRCFA("MOMREQ") D MSG^PRCFFU8 G EXIT
	D AMEND^PRCFFUD
	I MTOP'=25 D STACK^PRCFFM1M
	D EXIT QUIT
MSG	W ! S X="No further processing is being taken on this obligation.*" D MSG^PRCFQ
	Q
EXIT	K %,AMT,C1,C,D0,DA,DI,DIC,DEL,E,I,J,N1,N2,POP,PO,PODA,PRCFA,PRCFQ,MTOP,AUTOOBLG
	K PTYPE,T,T1,TIME,TRDA,Y,Z,Z5,ZX
	K PODATE,P,MO,GECSFMS
	Q
