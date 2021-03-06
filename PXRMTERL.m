PXRMTERL	; SLC/PKR - Handle reminder terms for patient lists. ;04/02/2007
	;;2.0;CLINICAL REMINDERS;**4,6**;Feb 04, 2005;Build 123
	;
	;=============================================
EVALPL(FINDPA,TERMARR,PLIST)	;Build a list of patients based on a
	;term. The list is returned in:
	;^TMP($J,PLIST,T/F,DFN,ITEM,NFOUND,FILENUM)=DAS_U_DATE_U_VALUE
	;for findings with a start and stop date the list is
	;^TMP($J,PLIST,T/F,DFN,ITEM,NFOUND,FILENUM)=DAS_U_START_U_STOP_U_VALUE
	N ENODE
	K ^TMP($J,PLIST)
	S ENODE=""
	F  S ENODE=$O(TERMARR("E",ENODE)) Q:ENODE=""  D
	. I ENODE="AUTTEDT(" D EVALPL^PXRMEDU(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="AUTTEXAM(" D EVALPL^PXRMEXAM(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="AUTTHF(" D EVALPL^PXRMHF(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="AUTTIMM(" D EVALPL^PXRMIMM(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="AUTTSK(" D EVALPL^PXRMSKIN(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="GMRD(120.51," D EVALPL^PXRMVITL(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="LAB(60," D EVALPL^PXRMLAB(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="ORD(101.43," D EVALPL^PXRMORDR(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="PXRMD(810.9," D EVALPL^PXRMLOCL(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="PXD(811.2," D EVALPL^PXRMTAX(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="PXRMD(811.4," D EVALPL^PXRMCF(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="PS(50.605," D EVALPL^PXRMDRCL(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="PSDRUG(" D EVALPL^PXRMDRUG(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="PSNDF(50.6," D EVALPL^PXRMDGEN(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="RAMIS(71," D EVALPL^PXRMRAD(.FINDPA,ENODE,.TERMARR,PLIST) Q
	. I ENODE="YTT(601.71," D EVALPL^PXRMMH(.FINDPA,ENODE,.TERMARR,PLIST) Q
	Q
	;
