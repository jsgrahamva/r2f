ICD10TB7	;KUM - GROUPER UTILITY FUNCTIONS;05/04/2012
	;;18.0;DRG Grouper;**64**;Oct 20, 2000;Build 103
	;
	;DRG700 ; D DRG700^ICDTBL7D - See ICD10TB6
DRG701	;
DRG702	;
DRG703	;
DRG704	;
DRG705	;
DRG706	;
	Q
DRG707	;
DRG708	Q
DRG709	;
DRG710	Q
DRG711	;
DRG712	Q
DRG713	;
DRG714	S ICDRG=$S(ICDMCC>0:713,1:714)
	Q
DRG715	;
DRG716	;
DRG717	;
DRG718	;
	Q
DRG719	;
DRG720	;
DRG721	;
	Q
DRG722	;
DRG723	;
DRG724	;
	Q
DRG725	;
DRG726	S ICDRG=$S(ICDMCC=2:725,1:726) Q
DRG727	;
DRG728	;
	S ICDRG=$S(ICDMCC=2:727,1:728) Q
DRG729	;
DRG730	S ICDRG=$S(ICDMCC>0:729,1:730) Q
DRG734	;
DRG735	;
	Q
DRG736	;
DRG737	;
DRG738	;
DRG739	;
DRG740	;
DRG741	;
	Q
DRG742	;
DRG743	;
	S ICDRG=$S(ICDMCC>0:742,1:743) Q
DRG744	;
DRG745	S ICDRG=$S(ICDMCC>0:744,1:745) Q
	Q
DRG746	;
DRG747	Q
DRG748	;
	Q
DRG749	;
DRG750	;
	Q
DRG751	;
DRG752	;
DRG753	;
	Q
DRG754	;
DRG755	;
DRG756	;
	Q
DRG757	;
DRG758	;
DRG759	;
	S ICDRG=$S(ICDMCC=2:757,ICDMCC=1:758,1:759) Q
DRG760	;
DRG761	S ICDRG=$S(ICDMCC>0:760,1:761) Q
DRG762	;
DRG763	;
DRG764	;
DRG765	;
DRG766	;
	Q
DRG767	;
DRG768	;
	Q
DRG769	;
DRG770	;
DRG771	;
DRG772	;
DRG773	;
DRG774	;
DRG775	;
DRG776	;
DRG777	;
DRG778	;
DRG779	;
DRG780	;
DRG781	;
DRG782	;
DRG789	;
DRG790	;Q
	Q
DRG791	;
DRG792	;
	S ICDRG=$S($D(ICD10OR(290))!$D(ICD10SD("J")):791,1:792)
DRG793	;
DRG794	;
DRG795	;
DRG796	;
	Q
DRG799	;
DRG800	;
DRG801	;
	Q
