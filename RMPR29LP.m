RMPR29LP	;HIN/RVD-PRINT LAB STOCK ISSUE PENDING COMPLETION ;2/09/1998
	;;3.0;PROSTHETICS;**33,159**;Feb 09, 1996;Build 2
	D DIV4^RMPRSIT I $D(Y),(Y<0) Q
	;
EN	S %ZIS="MQ" K IOP D ^%ZIS G:POP EXIT
	I '$D(IO("Q")) U IO G PRINT
	K IO("Q") S ZTDESC="LAB STOCK ISSUE PENDING COMPLETION REPORT",ZTRTN="PRINT^RMPR29LP",ZTIO=ION,ZTSAVE("RMPR(""STA"")")="",ZTSAVE("RMPR(""L"")")=""
	D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED!" H 1 G EXIT
	;
PRINT	;Entry point of printing report.
	S RMPAGE=1,RMPRT=1,REND=0 D HEAD
	F I=0:0 S I=$O(^RMPR(664.1,"E","S",I)) Q:I'>0  Q:$G(REND)  S R40=$G(^RMPR(664.1,I,0)) F J=0:0 S J=$O(^RMPR(664.1,I,2,J)) Q:J'>0  Q:$G(REND)  S R421=$G(^RMPR(664.1,I,2,J,0)) D:R421 WRI
	;
EXIT	;EXIT FROM REPORT HERE
	D ^%ZISC
	N RMPRSITE,RMPR D KILL^XUSCLEAN
	Q
	;
WRI	;write Lab Stock Issue Pending Completion
	S RMPAT=$P($G(^DPT($P(R40,U,2),0)),U,1),RSSN=$P(^(0),U,9)
	S X1=DT
	S (RMDTIN,X2)=$P(R40,U,1) D ^%DTC S RMDTOP=X
	S RMDATE=$E(RMDTIN,4,5)_"/"_$E(RMDTIN,6,7)_"/"_$E(RMDTIN,2,3)
	S RMWOOR=$P(R40,U,13)
	S RMIT=$P(R421,U,1)
	S RMITEM=$P($G(^PRC(441,$P($G(^RMPR(661,RMIT,0)),U,1),0)),U,2)
	I RMPRT'=I W !,$E(RMPAT,1,14),?16,$E(RSSN,6,9),?24,RMDATE,?34,RMWOOR,?55,RMDTOP,?63,$E(RMITEM,1,16)
	I RMPRT=I W !,?63,$E(RMITEM,1,16)
	S RMPRT=I
	I $E(IOST)["C"&($Y>(IOSL-7)) K DIR S DIR(0)="E" D ^DIR S:$D(DTOUT)!$D(DUOUT)!(Y'>0) REND=1 Q:$G(REND)  W @IOF D HEAD Q
	I $Y>(IOSL-6) W @IOF D HEAD
	Q
	;
HEAD	W !,"LAB STOCK ISSUE PENDING COMPLETION",?65,"Page: ",RMPAGE,!,"for station: ",$E($P($G(^DIC(4,RMPR("STA"),0)),U,1),1,20)
	S RMPAGE=RMPAGE+1
HEAD1	;write heading
	;I $E(IOST)["C"&($Y>(IOSL-7)) S DIR(0)="E" D ^DIR W @IOF D HEAD
	W !,RMPR("L")
	W !,"PATIENT",?17,"SSN",?24,"DATE INIT",?36,"WORK ORDER #",?50,"# DAYS OPEN",?68,"ITEM"
	W !,"-------",?17,"---",?24,"---------",?36,"------------",?50,"-----------",?68,"----"
	Q
