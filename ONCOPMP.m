ONCOPMP	;Hines OIFO/GWB - PRINT MULTIPLE ABSTRACTS ;12/16/99
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;
PRT1	;QA ABSTRACT
	S FLDS="[ONCQA]",(FR,TO)=NUMBER,BY="@NUMBER",DIC="^ONCO(165.5,",L=0
	D EN1^DIP
	Q
	;
PRT2	;SET VARIABLES AND @PRINT
	K DXS S DIOEND="S DN=1,D0=ONCODA F XI=50:1:58 K DXS D @(""^ONCOY""_XI)"
	S FLDS="[ONCOY49]",FR=NUMBER,TO=NUMBER,BY="@NUMBER",DIC="^ONCO(165.5,",L=0 D EN1^DIP
	Q
PRT3	;Report 3
	S ONCOIEN=ONCODA D MULT^ONCOPA1
	; K DXS S DIOEND="S DN=1,D0=ONCODA F XI=2:1:11 K DXS D @(""^ONCOX""_XI) K DXS"
	; S FLDS="[ONCOX1]",FR=NUMBER,TO=NUMBER,BY="@NUMBER",DIC="^ONCO(165.5,",L=0 D EN1^DIP
	Q
	;
PRT4	;Report 4
	N XD0
	S FLDS="[ONCO XINCIDENCE RPRT]",(FR,TO)=NUMBER,BY="@NUMBER",DIC="^ONCO(165.5,",L=0 D EN1^DIP
	Q
	;
	;QA FORM
8	S DIWF=$S($G(ESPD)=1:"^ONCO(160.2,9,1,",1:"^ONCO(160.2,8,1,")
	S DIWF(1)="165.5",BY="NUMBER",(FR,TO)=ONCODA S TMPIO=IO W !! D EN2^DIWF S IOP=ONCOION D ^%ZIS
	Q
	;
CK	;Check entry TO PREVENT DELETION
	I DUZ=231,DUZ(2)=10688 Q  ;    package developer can kill
	I DA>3 K ^ONCO(160.2,"B",$E(X,1,30),DA) Q
	W !!?5,"CANNOT DELETE THIS ENTRY" ;TO prevent deletion of exported entries.
H	G ^XUSCLEAN ;HALT
	Q
EX	;EXIT
	K DIC,DIR,ONCOXD0,ONCOXD1,ONCOS,DIOEND,FR,TO,BY,L,^TMP("ONCO",$J)
	D ^%ZISC
	Q