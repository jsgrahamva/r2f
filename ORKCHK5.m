ORKCHK5	; SLC/CLA - Support routine called by ORKCHK to do ACCEPT mode order checks ;08/22/12  09:21
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**6,32,74,94,123,190,280,357,345**;Dec 17, 1997;Build 32
	Q
	;
EN(ORKS,ORKDFN,ORKA,ORENT,ORKTMODE,OROIL,ORDODSG)	;perform order checking for orderable item acceptance
	;ORDODSG: FLAG THAT DENOTES IF DOSAGE CHECKS SHOULD BE PERFORMED
	;         1 FOR PERFORM DOSAGE CHECKS
	;         0 FOR DO NOT PERFORM DOSAGE CHECKS
	Q:$$GET^XPAR("DIV^SYS^PKG","ORK SYSTEM ENABLE/DISABLE",1,"I")="D"
	;
	N OI,ORKDG,HL7,ODT,ORNUM,HL7NPTR,HL7NTXT,HL7NCOD,HL7LPTR,HL7LTXT,HL7LCOD
	N OCN,DNGR,ORKMSG,ORKPDATA,ORKOCNUM
	;
	S OI=$P(ORKA,"|"),ORKDG=$P(ORKA,"|",2),HL7=$P(ORKA,"|",3)
	S ODT=$P(ORKA,"|",4),ORNUM=$P(ORKA,"|",5),ORKPDATA=$P(ORKA,"|",6)
	S HL7NPTR=$P(HL7,U),HL7NTXT=$P(HL7,U,2),HL7NCOD=$P(HL7,U,3)
	S HL7LPTR=$P(HL7,U,4),HL7LTXT=$P(HL7,U,5),HL7LCOD=$P(HL7,U,6)
	I ORKDG="GMRC",'$L(ODT) S ODT=$$NOW^XLFDT  ;def consult order d/t is now
	;
	I $E(ORKDG,1,2)="PS" D PHARM
	I $E(ORKDG,1,2)'="PS",($E(ORKDG,1,2)'="LR"),($L($G(OI))),($L($G(ODT))),(ORKTMODE'="ALL") D DUPOR
	I $E(ORKDG,1,2)="LR",($L($G(OI))),($L($G(ODT))),(ORKTMODE'="ALL") D
	.D DUPLAB
	.D LABFREQ
	I $E(ORKDG,1,2)'="PS" D MLM^ORKCHK2(.ORKS,ORKDFN,ORKA,ORENT,"ACCEPT")
	D REMCHK(.ORKS,OI,ORKDFN) ;do reminder order checks
	Q
	;
PHARM	;process pharmacy order checks:
	N ORPSPKG,ORPSA,ORKDD
	N ORALLRN,ORALLRF,ORALLRD
	D PARAMS("ALLERGY-DRUG INTERACTION",.ORALLRN,.ORALLRF,.ORALLRD)
	;
	D:+ORDODSG DSGCHK(.ORKS,ORKDFN,.OROIL,ORKA) ;do pharmacy dosage checks
	;dispense drug selected:
	I $L($G(HL7LPTR)),($G(HL7LCOD)="99PSD") D
	.D RXOCS
	.D MLM^ORKCHK2(.ORKS,ORKDFN,ORKA,ORENT,"ACCEPT")
	;
	;dispense drug NOT selected, split OI into dispense drugs:
	I '$L($G(HL7LPTR)) D
	.S ORPSPKG=$E(ORKDG,3)
	.I ORPSPKG="H" S ORPSPKG="X"  ;change to "X" if "H"erbal/non-VA med
	.I "IOX"[ORPSPKG D OI2DD(.ORPSA,OI,ORPSPKG)
	.S ORKDD=0 F  S ORKDD=$O(ORPSA(ORKDD)) Q:'ORKDD  D
	..S HL7LTXT=ORPSA(ORKDD)
	..S HL7NPTR=$P(ORKDD,";",2)
	..S HL7LPTR=+ORKDD
	..S HL7LCOD="99PSD",HL7NCOD="99NDF"
	..S $P(HL7,U)=HL7NPTR,$P(HL7,U,3)=HL7NCOD
	..S $P(HL7,U,4)=HL7LPTR,$P(HL7,U,5)=HL7LTXT,$P(HL7,U,6)=HL7LCOD
	..S $P(ORKA,"|",3)=HL7  ;set these for MLM OCX call
	..D RXOCS
	..D MLM^ORKCHK2(.ORKS,ORKDFN,ORKA,ORENT,"ACCEPT")
	Q
	;
RXOCS	;drug-allergy interaction
	Q:ORALLRF="D"
	N ORKAL
	I $L($G(HL7NPTR)),($G(HL7NCOD)="99NDF") D
	.D RXN^ORQQAL(.ORKAL,ORKDFN,"DR",HL7NPTR,$G(HL7LPTR)) I (ORKAL>0) D
	..Q:$L($P(ORKAL,U,2))<1
	..S ORKMSG="Previous adverse reaction to: "_$P(ORKAL,U,2)
	..S ORKS("ORK",ORALLRD_","_$G(ORNUM)_","_$E(ORKMSG,1,225))=ORNUM_U_ORALLRN_U_ORALLRD_U_ORKMSG
	Q
	;
OI2DD(ORPSA,OROI,ORPSPKG)	      ;rtn dispense drugs for a PS OI
	N PSOI
	Q:'$D(^ORD(101.43,OROI,0))
	S PSOI=$P($P(^ORD(101.43,OROI,0),U,2),";")
	Q:+$G(PSOI)<1
	D DRG^PSSUTIL1(.ORPSA,PSOI,ORPSPKG)
	Q
	;
DUPOR	;duplicate orders for non-pharmacy and non-lab:
	S OCN=0,OCN=$O(^ORD(100.8,"B","DUPLICATE ORDER",OCN))
	Q:+$G(OCN)<1
	Q:$$GET^XPAR(ORENT,"ORK PROCESSING FLAG",OCN,"I")="D"
	N ORKOR S ORKOR=0
	D DUP^ORKOR(.ORKOR,ORKDFN,OI,ODT,ORKDG) I (ORKOR>0) D
	.S ORKOCNUM=+$P(ORKOR,U)
	.S DNGR=$$GET^XPAR("DIV^SYS^PKG","ORK CLINICAL DANGER LEVEL",OCN,"I")
	.S ORKMSG="Duplicate order: "_$P(ORKOR,U,2)
	.S ORKS("ORK",DNGR_","_$G(ORNUM)_","_ORKOCNUM_","_$E(ORKMSG,1,225))=ORNUM_U_OCN_U_DNGR_U_ORKMSG_U_ORKOCNUM
	Q
	;
DUPLAB	;duplicate laboratory orders:
	N ORKLR,OCI
	S ORKLR=0,OCI=""
	S OCN=0,OCN=$O(^ORD(100.8,"B","DUPLICATE ORDER",OCN))
	Q:+$G(OCN)<1
	Q:$$GET^XPAR(ORENT,"ORK PROCESSING FLAG",OCN,"I")="D"
	S DNGR=$$GET^XPAR("DIV^SYS^PKG","ORK CLINICAL DANGER LEVEL",OCN,"I")
	D DUP^ORKLR(.ORKLR,OI,ORKDFN,ODT,ORKPDATA)
	F  S OCI=$O(ORKLR(OCI)) Q:OCI=""  D
	.S ORKOCNUM=+$P(ORKLR(OCI),U)
	.S ORKMSG="Duplicate order: "_$P(ORKLR(OCI),U,2)
	.S ORKS("ORK",DNGR_","_$G(ORNUM)_","_ORKOCNUM_","_$E(ORKMSG,1,225))=ORNUM_U_OCN_U_DNGR_U_ORKMSG_U_ORKOCNUM
	Q
	;
LABFREQ	;lab order frequency restrictions:
	N ORKLR,OCI
	S ORKLR=0,OCI=""
	S OCN=0,OCN=$O(^ORD(100.8,"B","LAB ORDER FREQ RESTRICTIONS",OCN))
	Q:+$G(OCN)<1
	Q:$$GET^XPAR(ORENT,"ORK PROCESSING FLAG",OCN,"I")="D"
	S DNGR=$$GET^XPAR("DIV^SYS^PKG","ORK CLINICAL DANGER LEVEL",OCN,"I")
	D ORFREQ^ORKLR2(.ORKLR,OI,ORKDFN_";DPT(",ODT,ORKPDATA)
	S OCI="" F  S OCI=$O(ORKLR(OCI)) Q:OCI=""  D
	.S ORKMSG=$P(ORKLR(OCI),U,2)
	.S ORKS("ORK",DNGR_","_$G(ORNUM)_","_$E(ORKMSG,1,225))=ORNUM_U_OCN_U_DNGR_U_ORKMSG
	Q
	;
PARAMS(ORKNAME,ORKNUM,ORKFLAG,ORKDNGR)	; get parameter values for an order chk
	S ORKNUM=0,ORKNUM=$O(^ORD(100.8,"B",ORKNAME,ORKNUM))
	S ORKFLAG=$$GET^XPAR(ORENT,"ORK PROCESSING FLAG",ORKNUM,"I")
	S ORKDNGR=$$GET^XPAR("DIV^SYS^PKG","ORK CLINICAL DANGER LEVEL",ORKNUM,"I")
	Q
REMCHK(ORRET,OROI,ORDFN)	; DO REMINDER ORDER CHECKS
	;
	N ORKGLOB S ORKGLOB=$H
	;order check for TEST OC for this OI
	N ORKNUM,ORKFLAG,ORKDNGR
	D PARAMS("CLINICAL REMINDER TEST",.ORKNUM,.ORKFLAG,.ORKDNGR)
	I ORKFLAG'="D" D
	.D ORDERCHK^PXRMORCH(ORDFN,OROI,1,0,0)
	.Q:'$D(^TMP($J,OROI))
	.N ORCDL S ORCDL="" F  S ORCDL=$O(^TMP($J,OROI,ORCDL)) Q:'$L(ORCDL)  S ORKDNGR=$S(ORCDL="H":1,ORCDL="M":2,1:3) D
	..N ORRULE S ORRULE="" F  S ORRULE=$O(^TMP($J,OROI,ORCDL,ORRULE)) Q:'$L(ORRULE)  D
	...S ORRET("ORK",ORCDL_","_$G(ORNUM)_","_ORKNUM_","_ORRULE)=ORNUM_U_ORKNUM_U_ORCDL_U_"||"_ORKGLOB_"&"_ORRULE
	...M ^TMP($J,"ORK XTRA TXT",ORKGLOB,ORRULE)=^TMP($J,OROI,ORCDL,ORRULE)
	.K ^TMP($J,OROI)
	;order checks for LIVE OC for this OI
	K ORKNUM,ORKFLAG,ORKDNGR
	D PARAMS("CLINICAL REMINDER LIVE",.ORKNUM,.ORKFLAG,.ORKDNGR)
	Q:ORKFLAG="D"
	D ORDERCHK^PXRMORCH(ORDFN,OROI,0,0,0)
	Q:'$D(^TMP($J,OROI))
	N ORCDL S ORCDL="" F  S ORCDL=$O(^TMP($J,OROI,ORCDL)) Q:'$L(ORCDL)  S ORKDNGR=$S(ORCDL="H":1,ORCDL="M":2,1:3) D
	.N ORRULE S ORRULE="" F  S ORRULE=$O(^TMP($J,OROI,ORCDL,ORRULE)) Q:'$L(ORRULE)  D
	..S ORRET("ORK",ORCDL_","_$G(ORNUM)_","_ORKNUM_","_ORRULE)=ORNUM_U_ORKNUM_U_ORCDL_U_"||"_ORKGLOB_"&"_ORRULE
	..M ^TMP($J,"ORK XTRA TXT",ORKGLOB,ORRULE)=^TMP($J,OROI,ORCDL,ORRULE)
	K ^TMP($J,OROI)
	Q
	;
DSGCHK(ORRET,ORDFN,OROIL,ORKA)	;DO DOSAGE ORDER CHECKS
	Q:'$$PATCH^XPDUTL("PSS*1.0*117")
	Q:$G(XQY0)="OR BCMA ORDER COM"
	N ORTYPE,ORY,ORI,ORKNUM,ORKFLAG,ORKDNGR
	D PARAMS("DRUG DOSAGE",.ORKNUM,.ORKFLAG,.ORKDNGR)
	Q:ORKFLAG="D"  ;this checks if the order check is turned on or not
	I '$$DS^PSSDSAPI D  Q
	.N ORDWNMSG S ORDWNMSG=$$DSDWNMSG^ORDSGCHK
	.S ORRET("ORK",ORKDNGR_","_$G(ORNUM)_","_ORDWNMSG)=ORNUM_U_25_U_2_ORDWNMSG
	S ORTYPE=$P(ORKA,"|",2)
	D EN^ORDSGCHK(.ORY,ORDFN,ORTYPE,.OROIL)
	N ORI S ORI=0 F  S ORI=$O(ORY(ORI)) Q:'ORI  D
	.I $P(ORY(ORI),U)="ERR" S ORRET("ORK",ORKDNGR_","_$G(ORNUM)_","_$E($P(ORY(ORI),U,2),1,225))=ORNUM_U_25_U_2_U_$P(ORY(ORI),U,2)
	.I $P(ORY(ORI),U)="DS" S ORRET("ORK",ORKDNGR_","_$G(ORNUM)_","_$E($P(ORY(ORI),U,2),1,225))=ORNUM_U_ORKNUM_U_ORKDNGR_U_$P(ORY(ORI),U,2)
	Q
