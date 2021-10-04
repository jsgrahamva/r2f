PRCS150P	;MNT/RB-PURGE ALL OLD PRCS(410,"B" REQUEST REFERENCES 
	;;5.1;IFCAP;**150**;Oct 20, 2000;Build 24
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;  Pre install routine in patch PRC*5.1*150 that will purge temporary
	;  request entries in cross reference ^PRCS(410,"B") that were left 
	;  unkilled when the temporary request was changed via option
	;  'CHANGE EXISTING TRANSACTION NUMBER'
	;  Also, temporary transaction entries in file 410 that are prior to 
	;  10/01/2010 will be deleted. 
	;;
	Q
START	;Kill off extraneous index xref left behind when using CHANGE EXISTING TRANSACTION NUMBER option
	N RMSTART,REQ,IEN410,RMEND,R0,R1,TRANX,ENTDT,TOT,TOT1,HIEN
	K ^XTMP("PRCS150P")
	D NOW^%DTC S RMSTART=%
	S ^XTMP("PRCS150P","START COMPILE")=RMSTART
	S ^XTMP("PRCS150P","END COMPILE")="RUNNING"
	S ^XTMP("PRCS150P",0)=$$FMADD^XLFDT(RMSTART,120)_"^"_RMSTART
	S U="^",REQ="999-",(TOT,TOT1)=0
1	S REQ=$O(^PRCS(410,"B",REQ)),IEN410=0 G EXIT:REQ=""
	I REQ+0>0 G 1
2	S IEN410=$O(^PRCS(410,"B",REQ,IEN410)) G 1:IEN410=""
	S R0=$G(^PRCS(410,IEN410,0)),TRANX=$P(R0,U)
	I REQ=TRANX,$P(R0,U,3)'="",$P(R0,U,2)'="CA",'$D(^PRCS(410,"H",$P(R0,U,3),IEN410)) D
	. S ^PRCS(410,"H",$P(R0,U,3),IEN410)=$P($G(^PRCS(410,IEN410,1)),U,2)
	. S ^XTMP("PRCS150P","H",REQ,IEN410)=R0
	I REQ=TRANX G 4
3	;KILL EXTRANEOUS 'B' X-REFS
	K ^PRCS(410,"B",REQ,IEN410)
	S ^XTMP("PRCS150P","B",REQ,IEN410)=R0,TOT=TOT+1
	G 2
4	;CHECK TEMP TX ENTRY DATE FOR OLD ENTRIES AND DELETE ALL PRIOR TO 10/01/2010
	S R1=$G(^PRCS(410,IEN410,1)),ENTDT=+R1
	I ENTDT>3100930,$P(R0,U,2)'="CA" G 2
	S ^XTMP("PRCS150P","DT-CA",REQ,IEN410)=ENTDT_U_R0,TOT1=TOT1+1
	S HIEN=$P(^PRCS(410,0),U,3)+1
	S DA=IEN410,DIK="^PRCS(410," D ^DIK K DIK
	S $P(^PRCS(410,0),U,3)=HIEN
	G 2
EXIT	;
	D NOW^%DTC S RMEND=%
	S ^XTMP("PRCS150P","TOTALS")=TOT_U_TOT1
	S ^XTMP("PRCS150P","END COMPILE")=RMEND
	K %,DA,HIEN
	Q
