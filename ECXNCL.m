ECXNCL	;ALB/DAN - Print national clinic list ;2/12/14  13:26
	;;3.0;DSS EXTRACTS;**149,154**;Dec 22, 1997;Build 13
	N ECXPORT,DIC,L,FLDS,BY,CNT,NUM,CODE
	S ECXPORT=$$EXPORT^ECXUTL1 Q:ECXPORT=-1
	I 'ECXPORT D  Q
	.S DIC="^ECX(728.441,",L=0,(FLDS,BY)="[ECX CLINIC CODE]" D EN1^DIP
	K ^TMP($J)
	S ^TMP($J,"ECXPORT",0)="CHAR4 CODE^SHORT DESCRIPTION",CNT=1
	S CODE=0 F  S CODE=$O(^ECX(728.441,"B",CODE)) Q:CODE=""  S NUM=0 F  S NUM=$O(^ECX(728.441,"B",CODE,NUM)) Q:'+NUM  D
	.I $P($G(^ECX(728.441,NUM,2)),U)'="" Q  ;Don't show inactive codes
	.S ^TMP($J,"ECXPORT",CNT)=$G(^ECX(728.441,NUM,0)),CNT=CNT+1
	D EXPDISP^ECXUTL1
	K ^TMP($J)
	Q
