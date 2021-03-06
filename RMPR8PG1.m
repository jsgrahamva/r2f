RMPR8PG1	;VM/RB - check/purge file ^RMPR(668) 'L'/'L1' x-ref not matching zero node info ;03/27/08
	;;3.0;Prosthetics;**163**;13/27/08;Build 9
	;;
	Q
AUDIT	;   Post suspense purge audit to check for any 'L' and 'L1' x-ref that
	;   no longer have an associated master record to ien data that
	;   matches File ^RMPR(668,ien,0) data
	;
	Q:$D(^XTMP("RMPR8PG1"))    ;Will run this index cleanse portion no sooner than 90 days after the last cleansing.
	N U,TOT1,TOT2,TOT3,TOT4,TOT5,TOT6,RMPRSS,RMPRDT,RMPRST,RMPRIEN,DFN,RDPT0,SSN,SSN2,RMSTART,RMEND,R0
	D NOW^%DTC S RMSTART=%
	S ^XTMP("RMPR8PG1","START COMPILE")=RMSTART
	S ^XTMP("RMPR8PG1","END COMPILE")="RUNNING"
	S ^XTMP("RMPR8PG1",0)=$$FMADD^XLFDT(RMSTART,90)_"^"_RMSTART
0	;FIND 668 'L' and 'L1' x-refs with missing master record
	S U="^",(TOT1,TOT2,TOT3,TOT4,TOT5,TOT6)=0,RMPRSS=0
1	F  S RMPRSS=$O(^RMPR(668,"L",RMPRSS)),RMPRDT=0 Q:RMPRSS=""  D
	. F  S RMPRDT=$O(^RMPR(668,"L",RMPRSS,RMPRDT)),RMPRST="" Q:RMPRDT=""  D
	.. F  S RMPRST=$O(^RMPR(668,"L",RMPRSS,RMPRDT,RMPRST)),RMPRIEN=0 Q:RMPRST=""  D
	... F  S RMPRIEN=$O(^RMPR(668,"L",RMPRSS,RMPRDT,RMPRST,RMPRIEN)) Q:RMPRIEN=""  D
	.... I '$D(^RMPR(668,RMPRIEN,0)) D  Q
	..... S ^XTMP("RMPR8PG1","L",0,RMPRSS,RMPRDT,RMPRST,RMPRIEN)="PAT POINTER MISSING IN NODE 0"
	..... S TOT1=TOT1+1
	..... K ^RMPR(668,"L",RMPRSS,RMPRDT,RMPRST,RMPRIEN)
	.... S R0=$G(^RMPR(668,RMPRIEN,0)),DFN=$P(R0,U,2)
	.... I +$G(DFN)>0,$D(^DPT(+$G(DFN),0)) D  Q
	..... S RDPT0=$G(^DPT(DFN,0)),SSN=$P(RDPT0,U,9),SSN2=$E(SSN,8,9)
	..... I RMPRSS'=SSN2!(RMPRDT'=$P($P(R0,U),"."))!(RMPRST'=$P(R0,U,10)) D
	...... S ^XTMP("RMPR8PG1","L",2,RMPRSS,RMPRDT,RMPRST,RMPRIEN)=SSN_U_$P(R0,U)_U_$P(R0,U,10)
	...... S TOT2=TOT2+1
	...... K ^RMPR(668,"L",RMPRSS,RMPRDT,RMPRST,RMPRIEN)
	...... I +R0>0,SSN2>0,$P(R0,U,10)'="" S ^RMPR(668,"L",$P($P(R0,U),"."),SSN2,$P(R0,U,10),RMPRIEN)=""
	.... S ^XTMP("RMPR8PG1","L",3,RMPRSS,RMPRDT,RMPRST,RMPRIEN)="BAD DFN IN 0 RECORD"
	.... S TOT3=TOT3+1
	.... K ^RMPR(668,"L",RMPRSS,RMPRDT,RMPRST,RMPRIEN)
5	S RMPRSS=0
	F  S RMPRSS=$O(^RMPR(668,"L1",RMPRSS)),RMPRST="" Q:RMPRSS=""  D
	. F  S RMPRST=$O(^RMPR(668,"L1",RMPRSS,RMPRST)),RMPRIEN=0 Q:RMPRST=""  D
	.. F  S RMPRIEN=$O(^RMPR(668,"L1",RMPRSS,RMPRST,RMPRIEN)) Q:RMPRIEN=""  D
	... I '$D(^RMPR(668,RMPRIEN,0)) D  Q
	.... S ^XTMP("RMPR8PG1","L1",0,RMPRSS,RMPRST,RMPRIEN)="PAT POINTER MISSING IN NODE 0"
	.... S TOT4=TOT4+1
	.... K ^RMPR(668,"L1",RMPRSS,RMPRST,RMPRIEN)
	... S R0=$G(^RMPR(668,RMPRIEN,0)),DFN=$P(R0,U,2)
	... I +$G(DFN)>0,$D(^DPT(+$G(DFN),0)) D  Q
	.... S RDPT0=$G(^DPT(DFN,0)),SSN=$P(RDPT0,U,9),SSN2=$E(SSN,8,9)
	.... I RMPRSS'=SSN2!(RMPRST'=$P(R0,U,10)) D
	..... S ^XTMP("RMPR8PG1","L1",1,RMPRSS,RMPRST,RMPRIEN)=SSN_U_$P(R0,U)_U_$P(R0,U,10)
	..... S TOT5=TOT5+1
	..... K ^RMPR(668,"L1",RMPRSS,RMPRST,RMPRIEN)
	..... I SSN2>0,$P(R0,U,10)'="" S ^RMPR(668,"L1",SSN2,$P(R0,U,10),RMPRIEN)=""
	... S ^XTMP("RMPR8PG1","L1",2,RMPRSS,RMPRST,RMPRIEN)="BAD DFN IN 0 RECORD"
	... S TOT6=TOT6+1
	... K ^RMPR(668,"L",RMPRSS,RMPRST,RMPRIEN)
9	W !!!!,"MISSING 'L' 0 NODE TOTAL:  ",TOT1
	W !,"MISSING 'L' MISMATCH W/DFN TOTAL:  ",TOT2
	W !,"MISSING 'L' MISMATCH W/O DFN TOTAL:  ",TOT3
	W !,"MISSING 'L1' 0 NODE TOTAL:  ",TOT4
	W !,"MISSING 'L1' MISMATCH W/DFN TOTAL:  ",TOT5
	W !,"MISSING 'L1' MISMATCH W/O DFN TOTAL:  ",TOT6
	D NOW^%DTC S RMEND=%
	S ^XTMP("RMPR8PG1","TOTALS")=TOT1_U_TOT2_U_TOT3_U_TOT4_U_TOT5_U_TOT6
	S ^XTMP("RMPR8PG1","END COMPILE")=RMEND
	K %
	Q
