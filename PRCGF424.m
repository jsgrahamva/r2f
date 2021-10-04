PRCGF424	;;VMP/RGB  IFCAP 424/424.1 FILE CLEANSING ;12/10/97  9:48 AM
V	;;5.1;IFCAP;**115,190**;Oct 20, 2000;Build 3
	;Per VA Directive 6402, this routine should not be modified.
	;
	;Cleanse files 424 and 424.1:
	;Identify OLD 424 & 424.1-1358 DETAIL WITH 10 YEAR OLD 424-1358 DAILY REC
TXT	;Cleanse files for:
	;  1. File 424 entry with missing 0 node
	;  2. File 424 entry with null file #442-Obligation pointer
	;  3. File 424 entry with invalid file #442-Obligation pointer
	;  4. File 424 entry with null Auth # (field .01)
	;  5. File 424 entry with missing sequence number in field .01
	;  6. File 424 entry older than 9 years from current FY
	;
	;  7. File 424.1 entry with missing 0 node
	;  8. File 424.1 entry with missing Bill Number in field .01
	;  9. File 424.1 entry with invalid file #424-1358 Daily record pointer
	; 20. File 424.1 entry older than 9 years from current FY
	;
	Q
CHK	;START FILE 424 CLEANSING
	W ! F PRCII=0:1:13 W !,$P($T(TXT+PRCII),";",2)
	S U="^",PRCFY=$E(DT,1,3)_"1001"
	S:$E(DT,4,5)>9 PRCFY=($E(DT,1,3)+1)_"1001"
	S PRCFY10=PRCFY-90000
0	;SAVE FILES
BUILD	W ! K ^XTMP("PRCGF424") D NOW^%DTC S PRCSTART=%
	S ^XTMP("PRCGF424","START COMPILE")=PRCSTART
	S ^XTMP("PRCGF424","END COMPILE")="RUNNING"
	S ^XTMP("PRCGF424",0)=$$FMADD^XLFDT(PRCSTART,90)_"^"_PRCSTART
1	;CHECK 424 OBLIGATION POINTER TO 442
	S PRCIEN=0,U="^",PRCTH=1,PRCT=0
2	S PRCIEN=$O(^PRC(424,PRCIEN)),PRCTYP=0 G CHK1:PRCIEN=""!(PRCIEN]"@")
	S PRCX=$P($H,",",2) I PRCX'=PRCTH,PRCX#5=0 W "." S PRCTH=PRCX
	S PRCR=$G(^PRC(424,PRCIEN,0)),PRCOBNO=$P(PRCR,U,2),PRCAUTH=$P(PRCR,U),PRCDTA=$P(PRCR,U,7)
	D  G:PRCTYP>0 3
	. I PRCR="" S PRCTYP=1 Q
	. I PRCAUTH="" S PRCTYP=4 Q
	. I $P(PRCAUTH,"-",3)="" K ^PRC(424,"B",PRCAUTH) S $P(PRCAUTH,"-",3)=9999,$P(^PRC(424,PRCIEN,0),U)=PRCAUTH,PRCTYP=5 Q
	. I PRCOBNO="" S PRCTYP=2 Q
	. I '$D(^PRC(442,PRCOBNO,0)) S PRCTYP=3 Q
	. I +PRCDTA<PRCFY10 S PRCTYP=6 Q
	. Q
	G 2
3	;KILL BAD 424 RECORD
	M ^XTMP("PRCGF424",424,PRCTYP,PRCIEN)=^PRC(424,PRCIEN) S PRCT=PRCT+1
	S DA=PRCIEN,DIK="^PRC(424," D ^DIK K DA,DIK
	W !,"424: ",?8,PRCIEN,?17,PRCTYP,?21,PRCR
	G 2
CHK1	;START FILE 424.1 CLEANSING
	S PRCIEN=0
10	S PRCIEN=$O(^PRC(424.1,PRCIEN)),PRCTYP=0 G EXIT:PRCIEN=""!(PRCIEN]"@")
	S PRCXX=$P($H,",",2) I PRCX'=PRCTH,PRCX#5=0 W "." S PRCTH=PRCX
	S PRCR=$G(^PRC(424.1,PRCIEN,0)),PRCBILNO=$P(PRCR,U),PRCEN424=$P(PRCR,U,2),PRCDTA=$P(PRCR,U,4)
	D  I PRCTYP>0 G 11
	. I PRCR="" S PRCTYP=7 Q
	. I PRCBILNO="" S PRCTYP=8 Q
	. I PRCEN424="" S PRCTYP=9 Q
	. S PRCR424=$G(^PRC(424,PRCEN424,0)) I PRCR424="" S PRCTYP=9 Q
	. I +PRCDTA<PRCFY10 S PRCTYP=20 Q
	. Q
	G 10
11	;KILL BAD 424.1 RECORD
	M ^XTMP("PRCGF424",424.1,PRCTYP,PRCIEN)=^PRC(424.1,PRCIEN) S PRCT=PRCT+1
	S DA=PRCIEN,DIK="^PRC(424.1," D ^DIK K DA,DIK
	W !,"424.1: ",?8,PRCIEN,?18,PRCTYP,?22,PRCR
	G 10
EXIT	;
	I PRCT=0 W !!,"<<  ***NO*** FILE ISSUES FOUND TO BE CLEANED  >>"
	D NOW^%DTC S PRCEND=%
	S ^XTMP("PRCGF424","END COMPILE")=PRCEND
	W !!,"CLEANSING OF FILES 424/424.1 COMPLETED"
	K %,PRCII,PRCAUTH,PRCBILNO,PRCDTA,PRCEN424,PRCEND,PRCFY,PRCFY10,PRCIEN,PRCOBNO
	K PRCR,PRCR424,PRCSTART,PRCT,PRCTH,PRCTYP,PRCX,PRCXX
	Q
