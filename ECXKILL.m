ECXKILL	;BIR/DMA,PTD-Kill Local Variables ;11/23/10  13:49
	;;3.0;DSS EXTRACTS;**9,8,21,24,31,39,49,84,89,105,112,127,132,136,144**;Dec 22, 1997;Build 9
	;
	K %,%DT,%Y,%ZIS,A,A1,A2,ABR,B,BY,D,D0,D1,DA,DAT,DATA,DATA1,DATA2,DATA6
	K DATAOP,DD,DFN,DHDH,DIC,DIE,DIK,DINUM,DIQ
	K ECDAPRNP,ECDPRNPI,ECISNPI,ECDOCNPI,ECX4CHAR,ECXDRGC,ECXIVAC,ECXIVSC,UNITCOST
	K ECU1NPI,ECU2NPI,ECU3NPI,ECU4NPI,ECU5NPI,ECU4A,ECU5A,ECXPPC4,ECXPPC5
	K DIR,DIRUT,DO,DR,DTOUT,DUOUT,EC,EC0,EC1,EC10,EC11,EC16,EC2,EC23,EC2NODE
	K EC3,EC42,EC50,EC6,EC7,ECA,ECAC,ECACA,ECAD,ECADM,ECALL
	K ECANE,ECAO,ECARG,ECAS,ECAT,ECATSV,ECB,ECC,ECCA,ECCAN,ECCAT,ECCH,ECCN
	K ECCNT,ECCS,ECCSC,ECD,ECD0,ECD1,ECDA,ECDAL,ECDAT,ECASA
	K ECDATA,ECDATA1,ECDATE,ECDEN,ECDEX,ECDF,ECDFN,ECDFN0,ECDI,ECDIA,ECDIF
	K ECDIV,ECDL,ECDN,ECDNEW,ECDO,ECDOC,ECDR,ECDRG,ECDS,ECDSSU,ECDT,ECDTTM
	K ECDU,ECEC0,ECED,ECED1,ECEDN,ECEDNEW,ECF,ECF1,ECFD,ECFDT,ECFILE,ECFK
	K ECFL,ECFR,ECGRP,ECH,ECHD,ECHEAD,ECI,ECID,ECIEN,ECIFN,ECIN,CCDORD
	K ECINST,ECINV,ECIV,ECJ,ECK,ECL,ECL1,ECLAN,ECLAST,ECLDT,ECLINK,ECLIST
	K ECLL,ECLN,ECLNC,ECLOC,ECLRN,ECLX,ECLY,ECM,ECMAX,ECMIN,CCDGVN,CCUNIT
	K ECXMISS,ECMN,ECMOD,ECMODS,ECMORE,ECMS,ECMSG,ECMSN,ECMT,ECMW,ECMY,ECN
	K ECNA,ECNDC,ECNDF,ECNFC,ECNL,ECNO,ECNODE,ECNOGO,ECXADT,ECXATM,CCIEN
	K ECNT,ECO,ECO0,ECO1,ECO2,ECODE,ECODE0,ECODE1,ECODE2,ECODE3,ECONE,ECOPAY
	K ECOB,ECATTNPI,ECPWNPI,ECXUSNPI,ECPWNPI,ECXOEF,ECXOEFDT,ECPLACE,CCTYPE
	K ECOPAYT,ECORTY,ECOS,ECP,ECPACK,ECPCE,ECPCE1,ECPCE2,ECPCE3,ECPCE4,ECOLD
	K ECPCE5,ECPCE6,ECPCE7,ECPIECE,ECPN,ECPRC,ECPRO,ECODE2,ECXASTA,ECXAMED
	K ECPROF,ECPT,ECPTF,ECPTPR,ECPTTM,ECQ,ECQT,ECQTY,ECRD,ECRE,ECRED,ECREF
	K ECRFL,ECRN,ECROU,ECRR,ECRS,ECRSD,ECRTN,ECRX,ECS,ECSA,ECSC,ECXSCADT
	K ECSD,ECSD1,ECSDN,ECSN,ECSR,ECSS,ECST,ECSTOP,ECSU,ECT,ECT1,ECTD,ECTD1
	K ECTEMP,ECTM,ECTNTL,ECTOTAL,ECTREAT,ECTRT,ECTS,ECTY,ECXLOGIC,ECXDATES,ECXEST,ECXECE
	K ECLRBILL,ECDSSFK,ECLRTNM,ECLRDTNM,ECXPROPC,ECPRONPI,ECCLAS,ECPTNPI,ECXORN,ECXORT,ECXTSTNM
	K ACTDT,DRG,DRUG,ECPROPC,ECVACL,ECVNDC,ECXENC,ECXENRL,ECXERI,ECXERR,ECXIVID,ECXNOD,ECXNPRFI,ECXOX,ECXOSC,ECXSCATM,ECXUSRTN,IDAT,OK,PIEN,PLACEHLD,SCADT
	D ^ECXKILL1
	;
AUDIT	;kill audit report variables, close slave printer
	K %DT,ECX,ECXARRAY,ECXACC,ECXALL,ECXAUD,ECXCODE,ECXD,ECXDEF,ECXDESC,ECXDIV
	K ECXRCST,ECXRQST,ECXEND,ECXERR,ECXEXT,ECXHEAD,ECXLOC,ECXPGM,ECXPHCPC
	K ECXPRIME,ECXPRO,ECXREPT,ECXRUN,ECXSAVE,ECXSTART,ECXSRCE
	K ECXCTAMT,ECXFEKEY,ECXFELOC,ECXFORM,ECXGRPR,ECXHCPC,ECXPHCPC,ECXHCPCS
	K ECXPODX,ECXPODX1,ECXPODX2,ECXPODX3,ECXPODX4,ECXPODX5,ECPANPI
	K ECXLAB,ECXLLC,ECXLMC,ECXQTY,ECXREQ,ECXSTAT,ECXTYPE
	K IO("Q"),POP,DIR,DIC,DIE,DA,DR,DO,DIRUT,DUOUT,DTOUT
	K ^TMP($J)
	I IO=IO(0),IOST'="C" D ^%ZISC
	Q