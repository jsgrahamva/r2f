ONCOANC9	;Hines OIFO/GWB - CLEANS UP SYMBOL TABLE AFTER NCDB CALL FOR DATA ;8/12/93
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
CLEANUP	;    entry point from ONCOANC0
	K AASAY,AASAY1,D0,AASBLNK,AASDT,AASDTCV,AASRI,AASDXH,AASAVD0,AASZERO,MLHIX,ONCOECNT,ONCOUT,ONCOY,AASTYPNC,INDEX,BYR,EYR,AC,MMDDCCYY,DR,DA,DIC,PD0
CU1P	;
	K AASRXBR,AASD0160,AAS160,AAS165,AAS1655
	K AASACCH,AASACYR,AASACDS,AASAJCS,AASAJSM,AASCSTA,AASCASE,AASCOD,AASD1A
	K AASDIA,AASDPT,AASDTLC,AASEODE,AASEODL,AASEODS,AASEODT
	K AASFSIT,AASGDIF,AASHAD,AASHDD,AASICDR,AASMC,AASITME,AASMORC
	K AASMHIS,AASNC,AASNE,AASNP,AASPS,AASQS,AASROT
	K AASRPT,AASRT,AASRXCH,AASRXCN,AASRXBDT,AASRDBR,AASRDCH,AASRDHO
	K AASRDOT,AASRDRA,AASRDSB,AASRDSR,AASRHRA,AASRHSR,AASROC,AASRXREA
	K AASRXSEQ,AASRST,AASRTR,AASITC,AASTNME,AASVSTA,AASAYT,AASAGE
	K AASCITY,AASCNTY,AASD1,AASDOB,AASDXDT,AASZIP,AASLAT,AASMS
	K AASPOB,AASRAC,AASRCS,AASREL,AASEQ,AASEX,AASPAN,AASTAT,AASX
	K AASTM1,AASTM2,ONCOX1,^TMP($J)
	K AASRDSB1,AASRHSR1,AASRHRA1,AASRXCH1,AASRST1,AASRXBR1,AASROC1
	K AASRDSB2,AASRHSR2,AASRHRA2,AASRXCH2,AASRST2,AASRXBR2,AASROC2
	K AASRDSB3,AASRHSR3,AASRHRA3,AASRXCH3,AASRST3,AASRXBR3,AASROC3
	K AASRDSB4,AASRHSR4,AASRHRA4,AASRXCH4,AASRST4,AASRXBR4,AASROC4
	K AASRVER,AASTC2,AASNC2,AASMC2,AASASM2,AASVNAM
	K AASNM,AASFSSN,AASNMBLK,AASNMF,AASNML,AASNMM,AASDXCIT
	Q