LRORDK	;SLC/FHS - CLEAN UP AFTER ACCESSIONING PROCESS ;8/7/89  13:58
	;;5.2;LAB SERVICE;**61,100,121,153,201,427**;Sep 27, 1994;Build 33
EN	;
KILL	K LRSD,LRXDFN,LRXDPF,LR696IEN,LABTEST,LRCYWKLD
	K %,A,D,DO,DA,DFN,DIC,DQ,DTOUT,DX,H8,J,K,L,LRAA,LRACC,LRAD,LRAN,LRCCOM,LRCDT,LRCSN,LRD,LRDFN,LRDPF,LREAL,LREDO,LREND,LREXP,LRIDT,LRIN,LRIX,LRLBLBP,LRLLOC,LRM,LRN,LRNT,LRORD,LROUTINE,LRPR,LRPRAC,LRRB,LRSN,LRSSP,LRSSX,LRST,LRSUM
	K I9,LRTEST,LRZT,LRORDTIM,LRSX,LRSXN,LRTX,LRTSTNM,LRUNQ,LRWLC,LRWP,LRWPD,LRYR,PNM,S,SSN,X,Y,Z,LRFIRST,LRSAME,LRSAMP,LRSPEC,LRORDR,LRECT,LRODT,LRURG,LRFLOG,LRCS,LROT,LROLLOC,LRTREA
	K LRBED,LRCSS,LRDTO,LRK,LRLWC,LRORDER,LRTP,LRTSTS,LRUR,LRUSI,LRUSNM,LRSLIP,I7,%H,%X,%Y,DIWL,DIWR,DPF,I1,I2,I5,LABEL,LRADDTST,LRCE,LRDAT,LRECOM,LRINFW,LRIOZERO,LRNCWL,LRNIDT,LRNOLABL,LROCN,LROID,LROLRDFN,LRORIFN,LROSN,LRPHSET,LRPREF
	K LRSPCDSC,LRSVSN,LRTJ,LRTOP,LRTS,LRTXD,LRTXP,LRWL0,LRWPC,LRXL,S5,LRACD,LRACN,LRACN0,LRDOC,LRLL,LROD0,LROD1,LROD3,LROS,LROSD,LRROD,LRTT,T,X,X1,X2,X3,X4,Z,LRIDIV,LRCOM,LRNATURE,LRTCOM
	K LRIO,LRJ,LROOS,LRSS,LRTN,LRTIME,LRIO,LRURGG,LRLWCURG,LRCAPLOC,LRDAX,LRDMAX,LRDTST,LRTMAX,LRSAMPX,TT,LRMAX1,LROUT,LRSAVE,LRMAX2,LRMAXX,LRTY,LRSPN,DR,DIR,VA("PID"),VA("BID")
	D KVAR^VADPT
	K LRDPTDFN,LRI,LRIEN,LRNLT,LRODTSV,LRORU3,LRPAT,LRPCEVSO
	K LRREFBAR,LRRSITE,LRRUID,LRSNSV,LRTREAT,LRTSORU,LRUID,LRWRD
	K NOW,SEX,LRTNSV,LRORDRR,AGE,LRRSTAT,DUOUT,LRRIEN,DIRUT,DOB,C,LRVV
	K LRAFJDFN,LRDPTDFN,D0,ANS,LRY,D1,X,DI
	K ^TMP("LRSTIK",$J)
	D ^%ZISC
	Q
LROEND	;KILL LROE ROUTINE VARIABLES
	K %,A,AGE,DFN,DIC,DL,DOB,DR,DX,H8,J,K,LRAA,LRACC,LRAD,LRAN,LRCCOM,LRCDT,LRCHK,LRCOM,LRCS,LRCSN,LRCSP,LRCSX,LRD,LRDAX,LRDFN,LRDPF,LREAL,LREND,LREXP,LRIDT,LRIN,LRIX,LRLBLBP,LRLLOC,LRLWC,LRMAX,LRMOR,LRNN,LRNT,LRODT,LROLLOC,LRTREA,LRSPCDSC
	K LRORD,LRPR,LRPRAC,LRRB,LRSAMP,LRSNO,LRSPEC,LRSSP,LRST,LRSTATUS,LRTEST,LRTIM,LRTM7,LRTN,LRTS,LRTSTN,LRTY,LRUN,LRUNQ,LRURG,LRWL0,LRWLC,LRWRD,LRXS,LRXST,LRYR,M9,PNM,S,SEX,SSN,T,X,X1,X3,Y,Z,VA("BID"),VA("PID"),LRTCOM
	K %H,%X,%Y,DICS,DO,DPF,DSC,G1,G2,G4,I1,I2,I7,J1,LABEL,LOC,LRACD,LRADDTST,LRAOD,LRCE,LRDC,LRECOM,LRECT,LREDO,LREXEC,LRFLOG,LRGVP,LRINFW,LRIOZERO,LRK,LRNIDT,LRNONE,LROLRDFN,LRORDR,LRORDTIM,LRORIFN,LRPER,LRPHSET,LRPLOC,LRPREF
	K LRQUICK,LRRND,LRSLIP,LRSSQ,LRSSX,LRSVSN,LRSX,LRSXN,LRTEC,LRTJ,LRTOP,LRTSN,LRTXD,LRTXP,LRVOL,LRWP,LRWPC,LRWPD,LRWRDS,LRXL,LRZX,Z1,Z2,LRSN1,LRSAME,ZTSK,DIR,LRLABLIO,LRNATURE
	K ^TMP("LRSTIK",$J)
	D KVAR^VADPT D ^%ZISC
	Q
