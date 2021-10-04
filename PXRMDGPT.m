PXRMDGPT	; SLC/PKR - Code to handle DGPT (Patient Treatment File) data. ;10/11/2012
	;;2.0;CLINICAL REMINDERS;**4,26**;Feb 04, 2005;Build 404
	;
	;============================================
FPDAT(DFN,TAXARR,NGET,SDIR,BDT,EDT,FLIST)	;Find data for a patient.
	N CODE,CODESYS,DA,DAS,DATE,DNODE,DS,EDTT,IND
	N NFOUND,NODE,NODEAT,NNODES,TDATE,TIND,TLIST
	S NNODES=TAXARR("APDS",45,"NNODES")
	I NNODES=0 Q
	I $G(^PXRMINDX(45,"DATE BUILT"))="" D  Q
	. D NOINDEX^PXRMERRH("TX",TAXARR("IEN"),45)
	S EDTT=$S(EDT[".":EDT+.0000001,1:EDT+.240001)
	S DS=$S(SDIR=+1:BDT-.000001,1:EDTT)
	S CODESYS="",NFOUND=0
	F  S CODESYS=$O(TAXARR("AE",CODESYS)) Q:CODESYS=""  D
	. I '$D(^PXRMINDX(45,CODESYS,"PNI",DFN)) Q
	. F IND=1:1:NNODES D
	.. S NODE=TAXARR("APDS",45,IND)
	.. I '$D(^PXRMINDX(45,CODESYS,"PNI",DFN,NODE)) Q
	.. S CODE=""
	.. F  S CODE=$O(TAXARR("AE",CODESYS,CODE)) Q:CODE=""  D 
	... I '$D(^PXRMINDX(45,CODESYS,"PNI",DFN,NODE,CODE)) Q
	... S DATE=DS
	... F  S DATE=+$O(^PXRMINDX(45,CODESYS,"PNI",DFN,NODE,CODE,DATE),SDIR) Q:$S(DATE=0:1,DATE<BDT:1,DATE>EDTT:1,1:0)  D
	.... S DAS=""
	.... F  S DAS=$O(^PXRMINDX(45,CODESYS,"PNI",DFN,NODE,CODE,DATE,DAS)) Q:DAS=""  D
	..... S NFOUND=NFOUND+1
	..... S TLIST(DATE,NFOUND)=DAS_U_DATE_U_CODESYS_U_CODE_U_NODE
	..... I NFOUND>NGET D
	...... S TDATE=$O(TLIST(""),-SDIR),TIND=$O(TLIST(TDATE,""))
	...... K TLIST(TDATE,TIND)
	;
	;Return up to NGET of the most recent entries.
	S NFOUND=0
	S DATE=""
	F  S DATE=$O(TLIST(DATE),SDIR) Q:(DATE="")!(NFOUND=NGET)  D
	. S IND=0
	. F  S IND=$O(TLIST(DATE,IND)) Q:(IND="")!(NFOUND=NGET)  D
	.. S NFOUND=NFOUND+1
	.. S FLIST(DATE,NFOUND,45)=TLIST(DATE,IND)
	Q
	;
	;============================================
GETDATA(DAS,FIEVT)	;Return data for a specificed PTF entry.
	;DBIA #4457
	D PTF^DGPTPXRM(DAS,.FIEVT)
	Q
	;
	;============================================
GPLIST(TAXARR,NOCC,BDT,EDT,PLIST)	;Get data for a patient.
	N CODE,CODESYS,DA,DA1,DAS,DATE,DFN,DNODE,DS
	N NFOUND,NODE,NNODES,TEMP,TLIST
	I $G(^PXRMINDX(45,"DATE BUILT"))="" D  Q
	. D NOINDEX^PXRMERRH("TX",TAXARR("IEN"),45)
	S TLIST="GPLIST_PXRMDGPT"
	K ^TMP($J,TLIST)
	S NNODES=TAXARR("APDS",45,"NNODES")
	I NNODES=0 Q
	S DS=$S(EDT[".":EDT+.0000001,1:EDT+.240001)
	S CODESYS=""
	F  S CODESYS=$O(TAXARR("AE",CODESYS)) Q:CODESYS=""  D
	. I '$D(^PXRMINDX(45,CODESYS,"INP")) Q
	. S CODE=""
	. F  S CODE=$O(TAXARR("AE",CODESYS,CODE)) Q:CODE=""  D
	.. I '$D(^PXRMINDX(45,CODESYS,"INP",CODE)) Q
	.. F IND=1:1:NNODES D
	... S NODE=TAXARR("APDS",45,IND)
	... I '$D(^PXRMINDX(45,CODESYS,"INP",CODE,NODE)) Q
	... S DFN=0
	... F  S DFN=$O(^PXRMINDX(45,CODESYS,"INP",CODE,NODE,DFN)) Q:DFN=""  D
	.... S DATE=DS
	.... F  S DATE=+$O(^PXRMINDX(45,CODESYS,"INP",CODE,NODE,DFN,DATE),-1) Q:(DATE=0)!(DATE<BDT)  D
	..... S DAS=$O(^PXRMINDX(45,CODESYS,"INP",CODE,NODE,DFN,DATE,""))
	..... S ^TMP($J,TLIST,DFN,DATE,DAS)=CODE_U_CODESYS_U_NODE
	;Return up to NOCC of the most recent entries for each patient.
	S DFN=0
	F  S DFN=$O(^TMP($J,TLIST,DFN)) Q:DFN=""  D
	. S NFOUND=0
	. S DATE=""
	. F  S DATE=$O(^TMP($J,TLIST,DFN,DATE),-1) Q:(DATE="")!(NFOUND=NOCC)  D
	.. S DAS=""
	.. F  S DAS=$O(^TMP($J,TLIST,DFN,DATE,DAS)) Q:DAS=""  D
	... S NFOUND=NFOUND+1
	... S TEMP=^TMP($J,TLIST,DFN,DATE,DAS)
	... S ^TMP($J,PLIST,1,DFN,DATE,45)=DAS_U_DATE_U_TEMP
	K ^TMP($J,TLIST)
	Q
	;
	;============================================
MHVOUT(INDENT,OCCLIST,IFIEVAL,NLINES,TEXT)	;Produce the MHV output.
	N CDATA,CODE,CODESYS,CODESYSA,CODESYSL,CODESYSN,DATE,IND,JND,NAME,NOUT
	N RESULT,TEMP,TEXTIN,TEXTOUT
	;Since the results may contain both diagnosis and procedures group
	;them for display.
	S IND=0
	F  S IND=$O(OCCLIST(IND)) Q:IND=""  S CODESYSL(IFIEVAL(IND,"CODESYS"),IND)=""
	S CODESYS=""
	F  S CODESYS=$O(CODESYSL(CODESYS)) Q:CODESYS=""  D
	.;DBIA #5679
	. S TEMP=$$CSYS^LEXU(CODESYS)
	. S CODESYSA=$P(TEMP,U,4)
	. S CODESYSN=$$UP^XLFSTR($P(TEMP,U,5))
	. S TEMP=$S(CODESYSN["PROCEDURE":"Procedure",CODESYSN["DIAGNOSIS":"Diagnosis",1:"Unknown")
	. S NAME="Hospitalization "_TEMP
	. S IND=""
	. F  S IND=$O(CODESYSL(CODESYS,IND)) Q:IND=""  D
	.. S CODE=IFIEVAL(IND,"CODE")
	.. S DATE=IFIEVAL(IND,"DATE")
	.. K CDATA
	.. ;DBIA #5679
	.. S RESULT=$$CSDATA^LEXU(CODE,CODESYS,DATE,.CDATA)
	.. S TEXTIN(1)=NAME
	.. S TEXTIN(2)=$P(CDATA("LEX",1),U,2)
	.. S TEXTIN(3)=" ("_$$EDATE^PXRMDATE(DATE)_")"
	.. D FORMAT^PXRMTEXT(INDENT+2,PXRMRM,3,.TEXTIN,.NOUT,.TEXTOUT)
	.. F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
	S NLINES=NLINES+1,TEXT(NLINES)=""
	Q
	;
	;============================================
OUTPUT(INDENT,OCCLIST,IFIEVAL,NLINES,TEXT)	;Produce the clinical
	;maintenance output.
	N CDATA,CODE,CODESYS,CODESYSA,CODESYSL,CODESYSN,DATE,IND
	N JND,NODE,NOUT,RESULT,TEMP,TEXTIN,TEXTOUT
	;Since the results may contain both diagnosis and procedures group
	;them for display.
	S IND=0
	F  S IND=$O(OCCLIST(IND)) Q:IND=""  S CODESYSL(IFIEVAL(IND,"CODESYS"),IND)=""
	S CODESYS=""
	F  S CODESYS=$O(CODESYSL(CODESYS)) Q:CODESYS=""  D
	.;DBIA #5679
	. S TEMP=$$CSYS^LEXU(CODESYS)
	. S CODESYSA=$P(TEMP,U,4)
	. S CODESYSN=$$UP^XLFSTR($P(TEMP,U,5))
	. S TEMP=$S(CODESYSN["PROCEDURE":"Procedure",CODESYSN["DIAGNOSIS":"Diagnosis",1:"Unknown")
	. S NLINES=NLINES+1
	. S TEXT(NLINES)=$$INSCHR^PXRMEXLC(INDENT," ")_"Hospitalization "_TEMP
	. S IND=""
	. F  S IND=$O(CODESYSL(CODESYS,IND)) Q:IND=""  D
	.. S CODE=IFIEVAL(IND,"CODE")
	.. S DATE=IFIEVAL(IND,"DATE")
	.. S NODE=IFIEVAL(IND,"NODE")
	.. K CDATA
	.. ;DBIA #5679
	.. S RESULT=$$CSDATA^LEXU(CODE,CODESYS,DATE,.CDATA)
	.. S TEXTIN(1)=$$EDATE^PXRMDATE(DATE)_" "_CODE_" ("_CODESYSA_")"
	.. S TEXTIN(2)=$P(CDATA("LEX",1),U,2)_";"
	.. S TEXTIN(3)="data node: "_NODE
	.. I $G(IFIEVAL(IND,"FEE BASIS")) S TEXTIN(3)=TEXTIN(3)_"; (Fee)"
	.. D FORMAT^PXRMTEXT(INDENT+2,PXRMRM,3,.TEXTIN,.NOUT,.TEXTOUT)
	.. F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
	S NLINES=NLINES+1,TEXT(NLINES)=""
	Q
	;
