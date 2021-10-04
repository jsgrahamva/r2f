VAFCPDT2	;BIR/CML/ALS-DISPLAY MPI/PD INFORMATION FOR SELECTED PATIENT ; 1/6/11 3:57pm
	;;5.3;Registration;**414,505,627,697,797,876**;Aug 13, 1993;Build 6
	;Reference to ^MPIF(984.9,"C" supported by IA #3298
	;
CMORHIS	;Find CMOR History
	I '$O(^DPT(DFN,"MPICMOR",0)) G CMORCHG
	I $Y+4>IOSL&($E(IOST,1,2)="C-") D  Q:QFLG
	.S LNQ=22 D SS^VAFCPDAT Q:QFLG
	.W @IOF,!,"MPI/PD data for: ",NAME,"  (DFN #",DFN,")",!,LN2
	D CHISHDR
	S HIS=0 F  S HIS=$O(^DPT(DFN,"MPICMOR",HIS)) Q:'HIS  D  Q:QFLG
	.S DIC=2,DR="993",DR(2.0993)=".01;3",DA=DFN,DA(2.0993)=HIS
	.S DIQ(0)="E",DIQ="CMORNODE"
	.D EN^DIQ1 K DIC,DR,DA,DIQ
	.S HISCMOR=$G(CMORNODE(2.0993,HIS,.01,"E"))
	.I +HISCMOR S HISCMOR=$$GET1^DIQ(4,HISCMOR,.01)
	.S CHGDT=$G(CMORNODE(2.0993,HIS,3,"E"))
	.I $Y+3>IOSL&($E(IOST,1,2)="C-") D  Q:QFLG
	..S LNQ=22 D SS^VAFCPDAT Q:QFLG
	..W @IOF,!,"MPI/PD data for: ",NAME,"  (DFN #",DFN,")",!,LN2 D CHISHDR
	.W !,$P(CHGDT,"@"),?12," - CMOR changed from ",HISCMOR
	;
CMORCHG	;Find CMOR change request
	I '$O(^MPIF(984.9,"C",DFN,0)) G EXT
	I $Y+4>IOSL&($E(IOST,1,2)="C-") D  Q:QFLG
	.S LNQ=22 D SS^VAFCPDAT Q:QFLG
	.W @IOF,!,"MPI/PD data for: ",NAME,"  (DFN #",DFN,")",!,LN2
	D CCHGHDR
	S CHG=0 F  S CHG=$O(^MPIF(984.9,"C",DFN,CHG)) Q:'CHG  D  Q:QFLG
	.S DIC=984.9,DA=CHG,DR=".01;.03;.06;.07;.08;1.03",DIQ="CHGNODE"
	.S DIQ(0)="EI" D EN^DIQ1 K DIC,DA,DR,DIQ
	.S CHGNUM=$G(CHGNODE(984.9,CHG,.01,"E"))
	.S CHGDT=$G(CHGNODE(984.9,CHG,.03,"E"))
	.S TMSG=$G(CHGNODE(984.9,CHG,.08,"E"))
	.S TREQ=$G(CHGNODE(984.9,CHG,1.03,"E"))
	.S SITE=$G(CHGNODE(984.9,CHG,.07,"E"))
	.S STATUS=$G(CHGNODE(984.9,CHG,.06,"E"))
	.I $Y+4>IOSL&($E(IOST,1,2)="C-") D  Q:QFLG
	..S LNQ=22 D SS^VAFCPDAT Q:QFLG
	..W @IOF,!,"MPI/PD data for: ",NAME,"  (DFN #",DFN,")",!,LN2 D CCHGHDR
	.W !,"REQUEST #",CHGNUM," - ",TMSG," ",CHGDT
	.W !?4,"Type of Request: ",TREQ," ",SITE
	.W !?4,"Status : ",STATUS,!
	;
EXT	;Extended patient demographic data
	I $E(IOST,1,2)="C-" D  Q:QFLG
	.S LNQ=22 D SS^VAFCPDAT Q:QFLG
	.W @IOF
	I QFLG=1 G QUIT^VAFCPDAT
	W !!,"Additional DPT Data for: ",NAME,"  (DFN #",DFN,")",!,LN2
	S DA=DFN,DIC=2,DIQ="XDATA",DIQ(0)="EI"
	S DR=".05;.08;.092;.093;.219;.2401;.2402;.2403;.211;.302;.323;.341;.331;.361;1901;.325;.328;.326;.327;.097;.525;391"  ;**876 - MVI_3432 (cml)
	N COB,SOB,FNM,MNM,MMNM,NOK,NOKN,DESIG,EMER,ELIG,VET,SRVBR,SRVNUM,SRVEDT,SRVSDT,SRVCPCT,POSRVC,FILEDT,MARS,RELP,POW,NODE,MSD,PATTYPE  ;**876 - MVI_3432 (cml)
	D EN^DIQ1 K DIC,DA,DR,DIQ
	S COB=$G(XDATA(2,DFN,.092,"E")),SOB=$G(XDATA(2,DFN,.093,"E"))
	S FILEDT=$G(XDATA(2,DFN,.097,"E")),FNM=$G(XDATA(2,DFN,.2401,"E"))
	S MNM=$G(XDATA(2,DFN,.2402,"E")),MMNM=$G(XDATA(2,DFN,.2403,"E"))
	S NOK=$G(XDATA(2,DFN,.211,"E")),DESIG=$G(XDATA(2,DFN,.341,"E"))
	S EMER=$G(XDATA(2,DFN,.331,"E"))
	S ELIG=$G(XDATA(2,DFN,.361,"E")),VET=$G(XDATA(2,DFN,1901,"E"))
	S SRVBR=$G(XDATA(2,DFN,.325,"E")),SRVNUM=$G(XDATA(2,DFN,.328,"E"))
	S SRVEDT=$G(XDATA(2,DFN,.326,"E")),SRVSDT=$G(XDATA(2,DFN,.327,"E"))
	S MARS=$G(XDATA(2,DFN,.05,"E")),RELP=$G(XDATA(2,DFN,.08,"E"))
	S POSRVC=$G(XDATA(2,DFN,.323,"E")),SRVCPCT=$G(XDATA(2,DFN,.302,"E"))
	S NOKN=$G(XDATA(2,DFN,.219,"E")),POW=$G(XDATA(2,DFN,.525,"E"))
	S PATTYPE=$G(XDATA(2,DFN,391,"E"))  ;**876 - MVI_3432 (cml)
	;
	W !,"PLACE OF BIRTH [CITY]",?31,": ",COB
	W !,"PLACE OF BIRTH [STATE]",?31,": ",SOB
	W !,"FATHER'S NAME",?31,": ",FNM
	W !,"MOTHER'S NAME",?31,": ",MNM
	W !,"MOTHER'S MAIDEN NAME",?31,": ",MMNM
	W !,"NAME OF PRIMARY NEXT OF KIN",?31,": ",NOK
	W !,"NEXT OF KIN PHONE NUMBER",?31,": ",NOKN
	W !,"NAME OF DESIGNEE",?31,": ",DESIG
	W !,"EMERGENCY NAME",?31,": ",EMER
	W !,"MARITAL STATUS",?31,": ",MARS
	W !,"RELIGIOUS PREFERENCE",?31,": ",RELP
	;
	D DEM^VADPT
	;ETHNICITY info
	I $G(VADM(11,1)) W !,"ETHNICITY INFORMATION",?31,": ",$P(VADM(11,1),"^",2)
	;
	;RACE multiple
	I $O(VADM(12,0)) D
	.W !,"RACE INFORMATION (multiple):"
	.S RACEMUL=0 F  S RACEMUL=$O(VADM(12,RACEMUL)) Q:'RACEMUL  W !?3,$P(VADM(12,RACEMUL),"^",2)
	;
	W !,"PRIMARY ELIGIBILITY CODE",?31,": ",ELIG
	W !,"PATIENT TYPE",?31,": ",PATTYPE  ;**876 - MVI_3432 (cml)
	W !,"VETERAN (Y/N)?",?31,": ",VET
	W !,"SERVICE CONNECTED PERCENT",?31,": ",SRVCPCT
	W !,"PERIOD OF SERVICE",?31,": ",POSRVC
	W !,"POW STATUS INDICATED?",?31,": ",POW
	;
	;Military Service Data multiple
	I $O(^DPT(DFN,.3216,0)) D
	.W !,"MILITARY SERVICE (multiple):"
	.W !,"Service Branch   Service #   Entry DT       Separation DT"
	.W !,"---------------------------------------------------------"
	.K MSDARR
	.S MSD=0 F  S MSD=$O(^DPT(DFN,.3216,MSD)) Q:'MSD  D
	..S NODE=^DPT(DFN,.3216,MSD,0)
	..S SRVEDT=$P(NODE,"^"),SRVSDT=$P(NODE,"^",2),SRVNUM=$P(NODE,"^",5),SRVBR=$$GET1^DIQ(23,$P(NODE,"^",3),.01)
	..S MSDARR(-SRVEDT)=SRVSDT_"^"_SRVNUM_"^"_SRVBR
	.S SRVEDT="" F  S SRVEDT=$O(MSDARR(SRVEDT)) Q:'SRVEDT  D
	..W !?0,$P(MSDARR(SRVEDT),"^",3),?17,$P(MSDARR(SRVEDT),"^",2),?29,$$FMTE^XLFDT($P(SRVEDT,"-",2)),?44,$$FMTE^XLFDT(+MSDARR(SRVEDT))
	;
	;ALIAS multiple
	I $O(^DPT(DFN,.01,0)) D 
	.W !,"ALIAS (multiple):"
	.S ALIAS=0 F  S ALIAS=$O(^DPT(DFN,.01,ALIAS)) Q:'ALIAS  W !?3,$E($P(^DPT(DFN,.01,ALIAS,0),"^"),1,30),?35,"SSN: "_$P($G(^DPT(DFN,.01,ALIAS,0)),"^",2)
	;
	W !,"DATE ENTERED IN PATIENT FILE",?31,": ",FILEDT
	;
	K ALIAS,XDATA,CHG,CHGNUM,CHGDT,TMSG,TREQ,SITE,STATUS,HIS,HISCMOR,CMORNODE,CHGNODE,RACEMUL,VADM,MSDARR
	Q
	;
CHISHDR	W !!,"CMOR History:",!,"--------------"
	Q
CCHGHDR	W !!,"CMOR Change Request History:",!,"----------------------------"
	Q
