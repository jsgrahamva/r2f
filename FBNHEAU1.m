FBNHEAU1	;AISC/dmk - continue FBNHEAUT cnh authorization ;4/28/93  11:04
	;;3.5;FEE BASIS;**103**;JAN 30, 1995;Build 19
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
END	K DA,DR,F,FBAASKV,FBAADDYS,FBAALT,FBAAP79,FBAATT,FBANEW,FBAOLD,FBCOUNTY,FBDX,FBI,FBRR,FBSITE,FBTYPE,FBXX,I,J,K,PI,S,T,Z,ZZ,FBPROG,PRC,PRCS,PRCSCPAN,DFN,CNT,X1,X2,FBMM
	K DIC,DIE,FB7078,FBAA78,FBAADA,FBAAASKV,FBBEGDT,FBCD,FBDAYS,FBDEFP,FBDEV,FBENDDT,FBERR,FBNAME,FBNUM,FBO,FBOBN,FBPAYDT,FBPAYEDT,FBPOSDT,FBPSADF,FBSEQ,FBSSN,FBT,FBVEN,FBVCAR,FTP,IFN,PGM,VAL,VAR,X,Y
	K FB("SITE"),FBAAADA,FBABD,FBDD,FBEDT,FBEND,FBFLAG,FBLG,FBMULT,FBONE,FBOUT,FBPOP,FBRIFN,FBTDT,FBTOT,FBTRDYS,FBTWO,FBZZ,FB,FBRIFN,FBRATE,FBC,FBID,FBAAOUT,FBVIEN,FBX,FBATODT,FBCNUM,FBFR
	K FBRP
	Q
	;
NOGOOD	;ERROR
	W !!,"No valid Obligation Number selected" G END
	;
PROB	;ERROR
	W !!,"Unable to get Obligation Sequence number from IFCAP!",!,"Check with IFCAP package coordinator!" Q
	;
PROB2	;ERROR
	W !!,"Unable to add an entry in the VA Form 7078 file.  Please see Computer Staff!" Q
	Q
