ORY313	;BP/SBR - Pre -init for patch OR*3*313 ; 11/4/10 2:00pm
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**313**;Dec 17, 1997;Build 12
	;
DLG	; update GMRCOR REQUEST order dialog
	N DLG,PRMT,DA
	S DLG=$$PTR("GMRCOR REQUEST")
	S PRMT=$$PTR("OR GTX REQUEST SERVICE")
	S DA=+$O(^ORD(101.41,DLG,10,"D",PRMT,0))
	I DA,^ORD(101.41,DLG,10,DA,3)="I $G(ORDIALOG(PROMPT,""LIST""))>1" D  ;
	. S ^ORD(101.41,DLG,10,DA,3)="I $G(ORDIALOG(PROMPT,""LIST""))>0"
	Q
	;
PTR(X)	Q +$O(^ORD(101.41,"B",X,0))
