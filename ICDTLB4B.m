ICDTLB4B	;ALB/EG/KUM - GROUPER UTILITY FUNCTIONS FY 2006;10/23/00 11:48am
	;;18.0;DRG Grouper;**20,64**;Oct 20, 2000;Build 103
	;
DRG263	S ICDRG=$S(ICDPD["U"&(ICDCC):263,ICDPD["U":264,ICDCC:265,1:266) Q
DRG264	S ICDRG=$S(ICDPD["U"&(ICDCC):263,ICDPD["U":264,ICDCC:265,1:266) Q
DRG265	S ICDRG=$S(ICDPD["U"&(ICDCC):263,ICDPD["U":264,ICDCC:265,1:266) Q
DRG266	S ICDRG=$S(ICDPD["U"&(ICDCC):263,ICDPD["U":264,ICDCC:265,1:266) Q
DRG269	S ICDRG=$S(ICDCC:269,1:270) Q
DRG270	S ICDRG=$S(ICDCC:269,1:270) Q
DRG272	S ICDRG=$S(ICDCC:272,1:273) Q
DRG273	S ICDRG=$S(ICDCC:272,1:273) Q
DRG274	S ICDRG=$S(ICDCC:274,1:275) Q
DRG275	S ICDRG=$S(ICDCC:274,1:275) Q
DRG277	S ICDRG=$S(AGE<18:279,ICDCC:277,1:278) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG278	D DRG277 Q
	Q
DRG279	D DRG277 Q
	Q
DRG280	S ICDRG=$S(AGE<18:282,ICDCC:280,1:281) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG281	S ICDRG=$S(AGE<18:282,ICDCC:280,1:281) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG282	S ICDRG=$S(AGE<18:282,ICDCC:280,1:281) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG283	S ICDRG=$S('$D(ICDODRG)&(ICDORNR>0):468,ICDCC=1:283,1:284) Q
DRG284	S ICDRG=$S('$D(ICDODRG)&(ICDORNR>0):468,ICDCC:283,1:284) Q
DRG292	S ICDRG=$S($D(ICDOP(" 55.69")):302,ICDCC:292,1:293) Q
DRG293	S ICDRG=$S($D(ICDOP(" 55.69")):302,ICDCC:292,1:293) Q
DRG294	S ICDRG=$S(AGE<36:295,1:294) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG295	S ICDRG=$S(AGE<36:295,1:294) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG296	S ICDRG=$S(AGE<18:298,ICDCC:296,1:297) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG297	S ICDRG=$S(AGE<18:298,ICDCC:296,1:297) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG298	S ICDRG=$S(AGE<18:298,ICDCC:296,1:297) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG299	S ICDRG=299 Q
DRG300	S ICDRG=$S(ICDCC:300,1:301) Q
DRG301	S ICDRG=$S(ICDCC:300,1:301) Q
DRG302	S ICDRG=$S($D(ICDOP(" 55.69")):302,1:ICDRG) Q
DRG303	S ICDRG=$S(ICDPD["M":303,ICDCC:304,1:305) Q
DRG304	S ICDRG=$S(ICDPD["M":303,ICDCC:304,1:305) Q
DRG305	S ICDRG=$S(ICDPD["M":303,ICDCC:304,1:305) Q
DRG306	S ICDRG=$S($D(ICDODRG(308))!($D(ICDODRG(309))):$S(ICDCC:308,1:309),ICDCC:306,1:307) Q
DRG307	S ICDRG=$S($D(ICDODRG(308))!($D(ICDODRG(309))):$S(ICDCC:308,1:309),ICDCC:306,1:307) Q
DRG308	S ICDRG=$S($D(ICDODRG(308))!($D(ICDODRG(309))):$S(ICDCC:308,1:309),ICDCC:306,1:307) Q
DRG309	S ICDRG=$S($D(ICDODRG(308))!($D(ICDODRG(309))):$S(ICDCC:308,1:309),ICDCC:306,1:307) Q
DRG310	S ICDRG=$S(ICDCC:310,1:311) Q
DRG311	S ICDRG=$S(ICDCC:310,1:311) Q
DRG312	S ICDRG=$S(AGE<18:314,ICDCC:312,1:313) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG313	S ICDRG=$S(AGE<18:314,ICDCC:312,1:313) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG314	S ICDRG=$S(AGE<18:314,ICDCC:312,1:313) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG315	I ICDORNI["V"&($D(ICDOP(" 86.07")))!((ICDDX(1)=$$CODEBA^ICDEX("V250.41",80)!(ICDDX(1)=$$CODEBA^ICDEX("V250.43",80)))&($D(ICDOP(" 52.84"))!$D(ICDOP(" 52.85")))) S ICDDRG=315
	Q
DRG318	S ICDRG=$S(ICDCC:318,1:319) Q
DRG319	S ICDRG=$S(ICDCC:318,1:319) Q
DRG320	S ICDRG=$S(AGE<18:322,ICDCC:320,1:321) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG321	S ICDRG=$S(AGE<18:322,ICDCC:320,1:321) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG322	S ICDRG=$S(AGE<18:322,ICDCC:320,1:321) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG323	S ICDRG=$S('$D(ICDPDRG(323)):"",ICDCC!($D(ICDOP(" 98.51")))!($D(ICDSDRG(323))):323,1:324) Q
DRG324	S ICDRG=$S(ICDCC!($D(ICDOP(" 98.51")))!($D(ICDSDRG(323))):323,1:324) Q
DRG325	S ICDRG=$S(AGE<18:327,ICDCC:325,1:326) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG326	S ICDRG=$S(AGE<18:327,ICDCC:325,1:326) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG327	S ICDRG=$S(AGE<18:327,ICDCC:325,1:326) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG328	S ICDRG=$S(AGE<18:330,ICDCC:328,1:329) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG329	S ICDRG=$S(AGE<18:330,ICDCC:328,1:329) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG330	S ICDRG=$S(AGE<18:330,ICDCC:328,1:329) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG331	S ICDRG=$S(AGE<18:333,ICDCC:331,1:332) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG332	S ICDRG=$S(AGE<18:333,ICDCC:331,1:332) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG333	S ICDRG=$S(AGE<18:333,ICDCC:331,1:332) I AGE="" S ICDRG=470,ICDRTC=3
	Q
