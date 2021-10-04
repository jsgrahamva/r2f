CRHDAM	; CAIRO/CLC -  ;04-Mar-2008 16:00;CLC;CLC
	;;1.0;CRHD;****;Jan 28, 2008;Build 19
	;=================================================================
	;copied from CWCVR0I
PSGI(CRHDY,DFN)	;
	N CRHDLST,CRHDAMED,CRHDNUM,CRHDCT,CRHDFG,CRHDDRGN,CRHDSEC,CRHDNUM2,CRHDLSTR,CRHDPFN
	K CRHDY,CRHDLST,CRHDDRG
	D ACTIVE^ORWPS(.CRHDLST,DFN)
	S CRHDLSTR=$O(CRHDLST(999),-1),CRHDFG=1
	I '$D(CRHDLST) S CRHDY="" Q CRHDY
	S CRHDNUM=0 F  S CRHDNUM=$O(CRHDLST(CRHDNUM)) Q:'CRHDNUM!('CRHDFG)  D
	.Q:$P(CRHDLST(CRHDNUM),U,10)'="ACTIVE"
	.I CRHDLST(CRHDNUM)["~OP" Q
	.S CRHDSEC=$E($P(CRHDLST(CRHDNUM),U,1),2,999)
	.S CRHDDRGN=$P(CRHDLST(CRHDNUM),U,3)
	.S CRHDPFN=+$P(CRHDLST(CRHDNUM),"^",2)
	.S CRHDNUM2=CRHDNUM F  S CRHDNUM2=$O(CRHDLST(CRHDNUM2)) Q:$G(CRHDLST(+CRHDNUM2))["~"!('CRHDNUM2)  D
	..I $L($G(CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN)))+$L(CRHDLST(CRHDNUM2))<80 S CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN)=$G(CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN))_$$STRIP(CRHDLST(CRHDNUM2)," ")_" "
	..E  S CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN)=$$STR($G(CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN))_" "_CRHDLST(CRHDNUM2),80)
	..I CRHDNUM2=CRHDLSTR S CRHDFG=0
	. S CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN)=DFN_"^"_CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN)_"^^^"_CRHDPFN_$S($P(CRHDLST(CRHDNUM),"^",2)["U":"|5",1:"|IV")
	. S:CRHDFG CRHDNUM=CRHDNUM2-1
	S CRHDY(2)="0^<==UNIT DOSE==>",CRHDCT=2
	S CRHDSEC=""
	F CRHDSEC="UD","CP","IV" S CRHDFG=0,CRHDDRG="" F  S CRHDDRG=$O(CRHDAMED(CRHDSEC,CRHDDRG)) Q:CRHDDRG=""  D
	.  S CRHDNUM=0 F  S CRHDNUM=$O(CRHDAMED(CRHDSEC,CRHDDRG,CRHDNUM)) Q:'CRHDNUM  D
	.. I (CRHDSEC="UD"!(CRHDSEC="CP"))&'CRHDFG S CRHDY(CRHDCT)="0^<==UNIT DOSE==>",CRHDFG=1,CRHDCT=CRHDCT+1
	.. I CRHDSEC="IV"&('CRHDFG) S CRHDY(CRHDCT)="0^<==IV DOSE==>",CRHDFG=1,CRHDCT=CRHDCT+1
	.. S CRHDY(CRHDCT)=CRHDAMED(CRHDSEC,CRHDDRG,CRHDNUM),CRHDCT=CRHDCT+1
	S CRHDY(-9900)=CRHDCT-2
	Q $O(CRHDY(2))
STR(CRHDSTR,CRHDLEN)	;
	N CRHDX,CRHDCHAR,CRHDK
	S CRHDX=""
	I $L(CRHDSTR)>CRHDLEN S CRHDX=$E(CRHDSTR,1,CRHDLEN) D
	.F CRHDK=132:-1 S CRHDCHAR=$E(CRHDX,CRHDK) Q:CRHDCHAR=" "  S CRHDX=$E(CRHDX,1,CRHDK-1)
	.S CRHDX=CRHDX_"..."
	I $L(CRHDSTR)<CRHDLEN S CRHDX=$E(CRHDSTR,1,CRHDLEN)
	Q CRHDX
STRIP(CRHDSTR,CRHDSTRP)	;
	F  Q:$E(CRHDSTR,1)'=CRHDSTRP  S CRHDSTR=$E(CRHDSTR,2,$L(CRHDSTR))
	Q CRHDSTR
OUTPT(CRHDY,CRHDDFN)	;get outpatient active meds
	N CRHDLST,CRHDAMED,CRHDNUM,CRHDCT,CRHDFG,CRHDDRGN,CRHDSEC,CRHDNUM2,CRHDLSTR,CRHDPFN
	K CRHDY,CRHDLST
	D ACTIVE^ORWPS(.CRHDLST,CRHDDFN)
	S CRHDLSTR=$O(CRHDLST(999),-1),CRHDFG=1
	I '$D(CRHDLST) S CRHDY="" Q CRHDY
	S CRHDNUM=0 F  S CRHDNUM=$O(CRHDLST(CRHDNUM)) Q:'CRHDNUM!('CRHDFG)  D
	.Q:$P(CRHDLST(CRHDNUM),U,10)'="ACTIVE"
	.I CRHDLST(CRHDNUM)'["~OP" Q
	.S CRHDSEC=$E($P(CRHDLST(CRHDNUM),U,1),2,999)
	.S CRHDDRGN=$P(CRHDLST(CRHDNUM),U,3)
	.S CRHDPFN=+$P(CRHDLST(CRHDNUM),"^",2)
	.S CRHDNUM2=CRHDNUM F  S CRHDNUM2=$O(CRHDLST(CRHDNUM2)) Q:$G(CRHDLST(+CRHDNUM2))["~"!('CRHDNUM2)  D
	..I $L($G(CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN)))+$L(CRHDLST(CRHDNUM2))<80 S CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN)=$G(CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN))_$$STRIP(CRHDLST(CRHDNUM2)," ")_" "
	..E  S CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN)=$$STR(CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN)_" "_CRHDLST(CRHDNUM2),80)
	..I CRHDNUM2=CRHDLSTR S CRHDFG=0
	. S CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN)=CRHDDFN_"^"_CRHDAMED(CRHDSEC,CRHDDRGN,CRHDPFN)_"^^^"_CRHDPFN_$S($P(CRHDLST(CRHDNUM),"^",2)["U":"|5",1:"|IV")
	. S:CRHDFG CRHDNUM=CRHDNUM2-1
	S CRHDCT=1
	;S CRHDY(2)="0^<==OUTPATIENT MEDS==>",CRHDCT=2
	S CRHDSEC="OP"
	S CRHDFG=0,CRHDDRG="" F  S CRHDDRG=$O(CRHDAMED(CRHDSEC,CRHDDRG)) Q:CRHDDRG=""  D
	.  S CRHDNUM=0 F  S CRHDNUM=$O(CRHDAMED(CRHDSEC,CRHDDRG,CRHDNUM)) Q:'CRHDNUM  D
	.. I 'CRHDFG S CRHDY(CRHDCT)="0^<==OUTPATIENT MEDS==>",CRHDFG=1,CRHDCT=CRHDCT+1
	.. S CRHDY(CRHDCT)=CRHDAMED(CRHDSEC,CRHDDRG,CRHDNUM),CRHDCT=CRHDCT+1
	S CRHDY(-9900)=CRHDCT-2,$P(CRHDY(1),"^",1)=CRHDCT-2
	Q $O(CRHDY(1))
