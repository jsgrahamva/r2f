SROACAR	;BIR/MAM - OPEATIVE DATA ;12/03/07
	;;3.0;Surgery;**38,71,93,95,100,125,142,153,166,174,182**;24 Jun 93;Build 49
	I '$D(SRTN) W !!,"A Surgery Risk Assessment must be selected prior to using this option.",!!,"Press <RET> to continue  " R X:DTIME G END
	S SRACLR=0,SRSOUT=0,SRSUPCPT=1 D ^SROAUTL
START	D:SRACLR RET G:SRSOUT END S SRACLR=0 K SRA,SRAO D ^SROACR2
	;
END	W @IOF D ^SRSKILL
	Q
RET	Q:SRSOUT  W ! K DIR S DIR(0)="E" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
	Q
