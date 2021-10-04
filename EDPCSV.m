EDPCSV	;SLC/MKB - CSV format utilities ;2/28/12 08:33am
	;;2.0;EMERGENCY DEPARTMENT;**6**;Feb 24, 2012;Build 200
	;
EN(REQ)	; Controller for HTTP request
	;
	;S:'$G(EDPTEST) $ETRAP="D ^%ZTER H"
	;
	N EDPSITE,EDPHTTP,EDPNULL,EDPFAIL,EDPCSV,I
	D UESREQ^EDPX(.REQ) ; unescape the posted data
	;
	;D SET^EDPZCTRL       ; set up the environment, use null device
	;
	D EN^EDPRPT($$VAL("start"),$$VAL("stop"),$$VAL("report"),$$VAL("id"),1)
	;
	U EDPHTTP
	;W "<results>",!
	S I=0 F  S I=$O(EDPCSV(I)) Q:'I  W EDPCSV(I),!
	;W "</results>",!
	Q
	;
VAL(X)	; return value from request
	Q $G(REQ(X,1))
	;
ADD(X)	; -- add line X
	S EDPCSV=+$G(EDPCSV)+1,EDPCSV(EDPCSV)=X
	Q
ADDG(X,EDPCSV,EDPXML)	; -- add line x
	S EDPCSV=+$G(EDPCSV)+1,@EDPXML@(EDPCSV)=$$ESC^EDPX(X)
	;S @EDPXML@(EDPCSV)=X
	Q
	;
BLANK	; -- add blank line
	S EDPCSV=+$G(EDPCSV)+1,EDPCSV(EDPCSV)=""
	Q
