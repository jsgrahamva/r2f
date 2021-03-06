RAFLH2	;HISC/GJC-Utility determines if flash cards print. ;4/3/97  07:57
	;;5.0;Radiology/Nuclear Medicine;**47**;Mar 16, 1998;Build 21
	;
	;Integration Agreements
	;----------------------
	;$$NS^XUAF4(2171); $$KSP^XUPARAM(2541)
	;
PRINT(RADIV,RALOC,RAPRC)	;
	; Pass in 'RAMDIV', 'RAMLC' & proc. array i.e, 'RAPX'.
	; Pass back '0' if the print is to be aborted, '>0' to print.
	N I,RA71,RA79,RA791,RAFLG,X,X1
	S RA79(.1)=$G(^RA(79,RADIV,.1)),RA791(0)=$G(^RA(79.1,+RALOC,0))
	S RA79(.12)=$S($P(RA79(.1),"^",2)']"":0,"Nn"[$P(RA79(.1),"^",2):0,1:1)
	S RA79(.18)=$S($P(RA79(.1),"^",8)']"":0,"Nn"[$P(RA79(.1),"^",8):0,1:1)
	S RA791(2)=$S('+$P(RA791(0),"^",2):0,1:1) ; '0' if null or zero
	S RA791(4)=$S('+$P(RA791(0),"^",4):0,1:1) ; '0' if null or zero
	S RA791(8)=$S('+$P(RA791(0),"^",8):0,1:1) ; '0' if null or zero
	; 'RAPRC' in format of: Case #_^_$G(^RAMIS(71,proc,0))
	; where 'proc' is the procedure IEN.  created in [RA REGISTER]
	S I=0 F  S I=$O(RAPRC(I)) Q:I'>0  D
	. S X=$G(RAPRC(I)),X1=$P(X,"^",5)
	. S RA71=+$G(RA71)+($S(X1']"":0,1:1))
	. Q
	S RAFLG=+$G(RA71)+RA791(2)+RA791(4)+RA791(8)+RA79(.12)+RA79(.18)
	Q RAFLG
KILFLH(X)	; Kill Flash Card Formats variables.
	; X -> IEN of file of the Label Print Fields file.
	; Called from 6^RAMAIN & Q^RAFLH1
	Q:$G(^RA(78.7,X,0))']""  S RA787(0)=$G(^RA(78.7,X,0))
	K @$P(RA787(0),"^",5),RA787(0)
	Q
SETFLH(Y)	; Set Flash Card Formats variables.
	; Y -> IEN of file of the Label Print Fields file.
	; Called from 6^RAMAIN & START^RAFLH1
	Q:$G(^RA(78.7,Y,0))']""  S RA787(0)=$G(^RA(78.7,Y,0))
	I $P(RA787(0),U)="LONG CASE NUMBER" D LONGCASE(RA787(0)) Q 
	S @$P(RA787(0),"^",5)=$P(RA787(0),"^",4)
	Q
XECFLH(X,Y)	; Execute the "E" node for the Flash Card Formats file (78.2).
	; X -> IEN of the top level ; Y -> IEN at the first subfile level.
	; Called from RAFLH & RAFLH1
	N I S I=0
	F  S I=$O(RAIND1(I)) Q:'+I  S ^TMP($J,"RA FLASH",I)=RAIND1(I)
	I '$D(RATEST) X ^RA(78.2,X,"E",Y,0) Q
	N RASAV,RATMP S RASAV=$G(^RA(78.2,X,"E",Y,0))
	S RATMP=$P(RASAV,"@")_$P(RASAV,"@",2) X RATMP
	S ^RA(78.2,X,"E",Y,0)=RASAV
	Q
	;
LONGCASE(X)	;Set the INTERNAL VARIABLE (78.7 field 5) to the TEST VALUE (78.7 field 4)
	;when the LABEL PRINT FIELD record is: LONG CASE NUMBER (p47)
	;
	;Input: X-zero node of a file 78.7 record
	;
	;"081194-234" is generic; it is not a direct reference to any specific patient exam.
	;
	N RAI S RAI=$$USESSAN^RAHLRU1() ;if RAI use LONG CASE NUMBER w/site prefix
	S @$P(X,U,5)=$S(RAI:$E($P($$NS^XUAF4($$KSP^XUPARAM("INST")),U,2),1,3)_"-",1:"")_"081194-234"
	Q
	;
