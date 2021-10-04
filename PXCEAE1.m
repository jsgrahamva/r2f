PXCEAE1	;ISL/dee,ISA/KWP,SLC/ajb - Builds the List Manager display of a visit and related v-files ;11/16/2015
	;;1.0;PCE PATIENT CARE ENCOUNTER;**22,73,199,201,210,215**;Aug 12, 1996;Build 10
	;; ;
	Q
	;
BUILD(VISITIEN,AEVIEW,ARRAY,ARRAYIX)	;
	;AEVIEW is "B" for brief display and "D" for expanded display.
	I '$D(^AUPNVSIT(VISITIEN)) S VALMBCK="Q" Q
	N PXCECNT
	D FULL^VALM1
	D CLEAN^VALM10
	K @ARRAYIX
	S (VALMCNT,PXCECNT)=0
	;
	;
	N IEN,FILE,VFILE,VROUTINE
	F FILE="SIT","CSTP","PRV","POV","CPT","TRT","IMM","PED","SK","HF","XAM","ICR" D  ; PX*1*215
	. S VROUTINE="PXCE"_$S(FILE="IMM":"VIMM",1:FILE)
	. S VFILE=$P($T(FORMAT^@VROUTINE),"~",5)
	. I FILE="SIT" D
	.. S IEN=VISITIEN
	.. D AFILE(IEN,FILE,VFILE,VROUTINE,ARRAY,ARRAYIX,.VALMCNT,.PXCECNT,AEVIEW)
	.. S VALMCNT=VALMCNT+1
	.. S @ARRAY@(VALMCNT,0)=""
	. E  D
	.. S IEN=""
	.. F  S IEN=$O(@VFILE@("AD",VISITIEN,IEN)) Q:'IEN  D AFILE(IEN,FILE,VFILE,VROUTINE,ARRAY,ARRAYIX,.VALMCNT,.PXCECNT,AEVIEW)
	S @ARRAYIX@(0)=PXCECNT
	I VALMCNT=0 S VALMBCK="Q"
	Q
	;
AFILE(IEN,FILE,VFILE,VROUTINE,ARRAY,ARRAYIX,VALMCNT,PXCECNT,AEVIEW)	;
	N ENTRY,NODE,NODES,NODECNT
	S PXCECNT=PXCECNT+1
	S NODES=$P($T(FORMAT^@VROUTINE),"~",3)
	F NODECNT=1:1 S NODE=$P(NODES,",",NODECNT) Q:NODE']""  S ENTRY(NODE)=$G(@VFILE@(IEN,NODE))
	D DISPLAY(.ENTRY,VROUTINE,ARRAY,ARRAYIX,.VALMCNT,PXCECNT,AEVIEW)
	I FILE="SIT" S @ARRAYIX@(PXCECNT)=VISITIEN_"^VST"
	E  S @ARRAYIX@(PXCECNT)=IEN_"^"_FILE
	Q
	;
DISPLAY(ENTRY,PXCECODE,ARRAY,ARRAYIX,LINE,COUNT,VIEW)	; -- display the data
	N PXCEFILE,PXCELINE,PXCETEXT,PXCEINT,PXCEEXT
	S PXCEFILE=$P($T(FORMAT^@PXCECODE),"~",2)
	F PXCELINE=1:1 S PXCETEXT=$P($T(FORMAT+PXCELINE^@PXCECODE),";;",2) Q:PXCETEXT']""  D
	. ; save original PXCETEXT for multiple diagnosis ouput ; ajb
	. I VFILE="^AUPNVIMM",+PXCETEXT=3 N TMPTXT S TMPTXT=PXCETEXT ; ajb
	. I VFILE="^AUPNVIMM",+PXCETEXT=2 N TMPTXT S TMPTXT=PXCETEXT ; PX*1*210
	. S (PXCEEXT,PXCEINT)=$P(ENTRY($P(PXCETEXT,"~",1)),"^",$P(PXCETEXT,"~",2))
	. ; get entries from diagnosis multiple ; ajb
	. I VFILE="^AUPNVIMM",+PXCETEXT=3 D  S:PXCEINT="" PXCEINT="^" S PXCEEXT=PXCEINT ; ajb
	. . N CNT,NIEN S (CNT,NIEN)=0 F  S NIEN=$O(^AUPNVIMM(IEN,3,NIEN)) Q:'+NIEN  D  ; ajb
	. . . S CNT=CNT+1,$P(PXCEINT,U,CNT)=$G(^AUPNVIMM(IEN,3,NIEN,0)) ; ajb
	. ; ajb - above / PX*1*210 - below
	. ; get entries from vis offered/given to patient multiple ; PX*1*210
	. I VFILE="^AUPNVIMM",+PXCETEXT=2 D  S:PXCEINT="" PXCEINT="^" S PXCEEXT=PXCEINT
	. . N CNT,NIEN S (CNT,NIEN)=0 F  S NIEN=$O(^AUPNVIMM(IEN,2,NIEN)) Q:'+NIEN  D
	. . . S CNT=CNT+1,$P(PXCEINT,U,CNT)=$P($G(^AUPNVIMM(IEN,2,NIEN,0)),"^")
	. ; PX*1*210
	. I PXCETEXT'["CPT Modifier",PXCEINT="" Q  ;Q:PXCEINT=""
	. Q:$P(PXCETEXT,"~",10)="N"
	. I VIEW'="D",$P(PXCETEXT,"~",10)="D" Q
	. I PXCECODE="PXCECSTP",$P(PXCETEXT,"~",3)=.01 Q
	. I VFILE="^AUPNVIMM",+PXCETEXT=2,+PXCEINT D VIS Q
	. I $P(PXCETEXT,"~",6)]"" D  Q:PXCEEXT=""
	.. ;I PXCECODE["CPT",$P(PXCETEXT,"~",6)["DNAR" B  
	.. S @("PXCEEXT="_$P(PXCETEXT,"~",6)_"("""_$S($P(PXCETEXT,"~",3)=.01:ENTRY($P(PXCETEXT,"~",1)),1:PXCEINT)_""")")
	. E  D
	.. N PXCEDILF,DIERR,PXCEI
	.. S PXCEEXT=$$EXTERNAL^DILFD(PXCEFILE,$P(PXCETEXT,"~",3),"",PXCEINT,"PXCEDILF")
	.. S PXCEEXT=$S('$D(DIERR):PXCEEXT,1:PXCEINT)
	. ; get ICD info for multiple diagnosis ; ajb
	. I VFILE="^AUPNVIMM",+PXCETEXT=3,+PXCEINT D  ; ajb
	. . S PXCEEXT="" ; ajb
	. . N CNT F CNT=1:1:$L(PXCEINT,U) S $P(PXCEEXT,U,CNT)=$$DISPLY01^PXCEPOV($P(PXCEINT,U,CNT)) ; ajb
	. N TEMP S TEMP=PXCEEXT
	. N PXI F PXI=1:1 Q:$P(TEMP,"^",PXI)=""  S PXCEEXT=$P(TEMP,"^",PXI) D ADDLINE S:+$D(TMPTXT) PXCETEXT=TMPTXT ; replace modified with original for multiple diagnosis ; ajb
	Q
ADDLINE	;
	S LINE=LINE+1
	I PXCELINE=1!(PXCECODE="PXCECSTP") S @ARRAY@(LINE,0)=$J(COUNT,3)_" "
	E  S @ARRAY@(LINE,0)="    "
	I $P(PXCETEXT,"~",5)["Diagnosis" D
	. N PXDATE,PXACSREC,PXACS
	. S PXDATE=$S($D(PXCEVIEN)=1:$$CSDATE^PXDXUTL(PXCEVIEN),$D(PXCEAPDT)=1:PXCEAPDT,1:DT)
	. S PXACSREC=$$ACTDT^PXDXUTL(PXDATE),PXACS=$P(PXACSREC,"^",3)
	. I PXACS["-" S PXACS=$P(PXACS,"-",1,2)
	. I $P(PXCETEXT,"~",5)'["ICD Code or Diagnosis" D
	.. S $P(PXCETEXT,"~",5)=$P($P(PXCETEXT,"~",5),"Diagnosis",1)_PXACS_" Diagnosis"_$P($P(PXCETEXT,"~",5),"Diagnosis",2)
	. I $P(PXCETEXT,"~",5)["ICD Code or Diagnosis" D
	.. S $P(PXCETEXT,"~",5)=PXACS_$P($P(PXCETEXT,"~",5),"ICD",2)
	S @ARRAY@(LINE,0)=@ARRAY@(LINE,0)_$P(PXCETEXT,"~",5)
	I ($L(@ARRAY@(LINE,0))+$L(PXCEEXT))'>80 D
	. S @ARRAY@(LINE,0)=@ARRAY@(LINE,0)_PXCEEXT
	E  D
	. N PXCEWRAP,PXCECOUN,PXCEHEAD
	. S PXCEHEAD=$L(@ARRAY@(LINE,0))
	. D WRAP^PXCEVFI4(PXCEEXT,80-PXCEHEAD,.PXCEWRAP)
	. S @ARRAY@(LINE,0)=@ARRAY@(LINE,0)_$G(PXCEWRAP(1))
	. S PXCECOUN=1
	. F  S PXCECOUN=$O(PXCEWRAP(PXCECOUN)) Q:PXCECOUN']""  D
	.. S LINE=LINE+1
	.. S @ARRAY@(LINE,0)=$J("",PXCEHEAD)_PXCEWRAP(PXCECOUN)
	Q
VIS	; get vaccine information statement info ; adm
	S PXCEEXT=""
	N CNT F CNT=1:1:$L(PXCEINT,U) S $P(PXCEEXT,U,CNT)=$$DISPVIS^PXCEVIS($P(PXCEINT,U,CNT))
	N TEMP S TEMP=PXCEEXT
	N PXI F PXI=1:1 Q:$P(TEMP,"^",PXI)=""  S PXCEEXT=$P(TEMP,"^",PXI) D ADDLINE S:+$D(TMPTXT) PXCETEXT=TMPTXT
	Q
	;
