ICDTBL5	;ALB/EG/MRY - GROUPER UTILITY FUNCTIONS ; 11/8/07 1:44pm
	;;18.0;DRG Grouper;**31,32**;Oct 20, 2000;Build 1
DRG500	;
DRG501	;
DRG502	S ICDRG=$S(ICDMCC=2:500,ICDMCC=1:501,1:502) Q
DRG503	;
DRG504	;
DRG505	S ICDRG=$S(ICDMCC=2:503,ICDMCC=1:504,1:505) Q
DRG506	S ICDRG=506 Q
DRG507	;
DRG508	S ICDRG=$S(ICDMCC>0:507,1:508) Q
DRG509	S ICDRG=509 Q
DRG510	;
DRG511	;
DRG512	S ICDRG=$S(ICDMCC=2:510,ICDMCC=1:511,1:512) Q
DRG513	;
DRG514	S ICDRG=$S(ICDMCC>0:513,1:514) Q
DRG515	;
DRG516	;
DRG517	S ICDRG=$S(ICDMCC=2:515,ICDMCC=1:516,1:517) Q
DRG533	;
DRG534	S ICDRG=$S(ICDMCC=2:533,1:534) Q
DRG535	;
DRG536	S ICDRG=$S(ICDMCC=2:535,1:536) Q
DRG537	;
DRG538	S ICDRG=$S(ICDMCC>0:537,1:538) Q
DRG539	;
DRG540	;
DRG541	S ICDRG=$S(ICDMCC=2:539,ICDMCC=1:540,1:541) Q
DRG542	;
DRG543	;
DRG544	S ICDRG=$S(ICDMCC=2:542,ICDMCC=1:543,1:544) Q
DRG545	;
DRG546	;
DRG547	S ICDRG=$S(ICDMCC=2:545,ICDMCC=1:546,1:547) Q
DRG548	;
DRG549	;
DRG550	S ICDRG=$S(ICDMCC=2:548,ICDMCC=1:549,1:550) Q
DRG551	;
DRG552	S ICDRG=$S(ICDMCC=2:551,1:552) Q
DRG553	;
DRG554	S ICDRG=$S(ICDMCC=2:553,1:554) Q
DRG555	;
DRG556	S ICDRG=$S(ICDMCC=2:555,1:556) Q
DRG557	;
DRG558	S ICDRG=$S(ICDMCC=2:557,1:558) Q
DRG559	;
DRG560	;
DRG561	S ICDRG=$S(ICDMCC=2:559,ICDMCC=1:560,1:561) Q
DRG562	;
DRG563	S ICDRG=$S(ICDMCC=2:562,1:563) Q
DRG564	;
DRG565	;
DRG566	S ICDRG=$S(ICDMCC=2:564,ICDMCC=1:565,1:566) Q
DRG573	;
DRG574	;
DRG575	I ICDPD["U" S ICDRG=$S(ICDMCC=2:573,ICDMCC=1:574,1:575) Q
DRG576	;
DRG577	;
DRG578	S ICDRG=$S(ICDMCC=2:576,ICDMCC=1:577,1:578) Q
DRG579	;
DRG580	;
DRG581	S ICDRG=$S(ICDMCC=2:579,ICDMCC=1:580,1:581) Q
DRG582	;
DRG583	I ICDPD["M"!(ICDSD["M") S ICDRG=$S(ICDMCC>0:582,1:583) Q
	E  G DRG584
DRG584	;
DRG585	I ICDOR["M"!(ICDOR["m") S ICDRG=$S(ICDMCC>0:584,1:585) Q
	E  S ICDRG="" Q
DRG592	;
DRG593	;
DRG594	S ICDRG=$S(ICDMCC=2:592,ICDMCC=1:593,1:594) Q
DRG595	;
DRG596	S ICDRG=$S(ICDMCC=2:595,1:596) Q
DRG597	;
DRG598	;
DRG599	I ICDPD["r" S ICDRG=$S(ICDMCC=2:597,ICDMCC=1:598,1:599) Q
	Q
