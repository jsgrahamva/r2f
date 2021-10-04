ICDTLB2	;ALB/EG - GROUPER UTILITY FUNCTIONS ; 9/19/03 1:09pm
	;;18.0;DRG Grouper;**2,10,34**;Oct 20, 2000;Build 1
DRG95	S ICDRG=$S(ICDCC:94,1:95) Q
DRG96	S ICDRG=$S(AGE<18:98,ICDCC:96,1:97) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG97	S ICDRG=$S(AGE<18:98,ICDCC:96,1:97) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG98	S ICDRG=$S(AGE<18:98,ICDCC:96,1:97) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG99	S ICDRG=$S(ICDCC!($D(ICDSDRG(99))):99,1:100) Q
DRG100	S ICDRG=$S(ICDCC:99,1:100) Q
DRG101	S ICDRG=$S(ICDCC:101,1:102) Q
DRG102	S ICDRG=$S(ICDCC:101,1:102) Q
DRG104	;valve procedure
	N ICDE1,ICDE2
	S ICDE1=$S($D(ICDOP(" 37.95"))&($D(ICDOP(" 37.96"))):1,1:0),ICDE2=$S($D(ICDOP(" 37.97"))&($D(ICDOP(" 37.98"))):1,1:0)
	I ICDOR'["P",'ICDE1&'ICDE2&($D(ICDOP(" 37.95"))!$D(ICDOP(" 37.96"))!$D(ICDOP(" 37.97"))!$D(ICDOP(" 37.98"))) S ICDRG=116 Q
	S:ICDOR["H" ICDRG=$S(ICDOR["N"&ICDE1:104,ICDOR["N"&ICDE2:104,ICDOR["O":104,1:ICDRG)
	S:ICDOR'["H" ICDRG=$S(ICDOR["N"&ICDE1:105,ICDOR["N"&ICDE2:105,ICDOR["O":105,1:ICDRG)
	I ICDOR["P"&(ICDE1+ICDE2=0) S ICDRG=$S(ICDOR["H":104,1:105)
	Q
DRG105	D DRG104 Q
	; NOIS ANN-0801-41869 ignore 37.26 which has "HN1" for identifier
DRG106	;S ICDRG=$S(ICDOR["b"&(ICDOR["6")&(ICDOR["1"):106,ICDOR["6"&(ICDOR'["1")&(ICDOR["H"):107,ICDOR["6"&(ICDOR'["1")&(ICDOR'["H"):109,1:470) I "106^107^109"'[ICDRG D 
	S ICDRG=470
	I ICDOR["b"&(ICDOR["6") S ICDRG=109
	I ICDOR["b"&(ICDOR["6") I $D(ICDOP(" 35.96"))!($D(ICDOP(" 36.01")))!($D(ICDOP(" 36.02")))!($D(ICDOP(" 36.05"))) S ICDRG=106 Q
	I ICDOR["b"&(ICDOR["6") I $D(ICDOP(" 37.21"))!($D(ICDOP(" 37.22")))!($D(ICDOP(" 37.23"))) S ICDRG=107
	I ICDOR["b"&(ICDOR["6") I $D(ICDOP(" 88.52"))!($D(ICDOP(" 88.53")))!($D(ICDOP(" 88.54")))!($D(ICDOP(" 88.55")))!($D(ICDOP(" 88.56")))!($D(ICDOP(" 88.57")))!($D(ICDOP(" 88.58"))) S ICDRG=107
	I ICDRG'=106&(ICDRG'=107)&(ICDRG'=109) S ICDRG=470 D
	.;I ICDCC D DRG110 Q
	.;I ICDOR'["b" D DRG112 I +ICDRG>0&(+ICDRG<470) Q
	.;I ICDOR'["b" D DRG516^ICDTLB6 I +ICDRG>0 Q
	.I ICDCC D DRG110 Q
	.D DRG111
	Q
DRG107	D DRG106 Q
DRG108	S ICDRG=$S(ICDOR["Oo":108,$D(ICDOP(" 38.44"))&$D(ICDOP(" 38.45")):108,ICDCC:110,1:111) Q
DRG109	D DRG106 Q
DRG110	D DRG111 Q
DRG111	S ICDRG=$S(ICDOR["Oo":108,ICDCC&(ICDOR[7):110,ICDOR[7:111,1:ICDRG)
	I "108^110^111"[ICDRG Q
	I $D(ICDJJ(478))&('$D(ICDJJ(110))&'($D(ICDJJ(111)))) D DRG478^ICDTLB6
	D DRG113 I ICDRG=113 Q
	I ICDOR["p" D DRG115
	I ICDOR["1" D DRG516^ICDTLB6
	Q
DRG112	S ICDRG=$S(ICDOR["Oo":108,(ICDOR["1")&($D(ICDOP(" 36.06"))):116,ICDOR["1":112,1:470) I ICDRG=470 D
	.I ICDPD["A" D DRG115 Q
	.I ICDOR["p" D DRG117 Q
	.D DRG111
	Q
DRG113	S ICDRG=$S($D(ICDJJ(113)):113,1:ICDRG) Q
DRG115	D EN1^ICDDRG5 S ICDRG=$S(ICDPD["A"&(ICDCC3=1):115,ICDCC2:115,ICDCC3=1:116,ICDPD'["I"&(ICDCC3=0):127,1:"") Q
DRG116	D EN1^ICDDRG5 S ICDRG=$S(ICDPD["A"&(ICDCC3=1):115,ICDCC3=1:116,1:"") D:ICDOR["p" DRG118 K:ICDRG="" ICDODRG(HICDRG) Q
DRG117	D EN1^ICDDRG5 Q:ICDOR'["7"&('ICDCC3)  S ICDRG=$S(ICDPD["A"&(ICDCC3):115,ICDCC3:116,1:117) Q
DRG118	D EN1^ICDDRG5 S ICDRG=$S(ICDPD["A"&(ICDCC3):115,ICDCC3:116,1:118) Q
DRG120	;dx combo's for DRG120
	N ICDE1,ICDE2
	S ICDE1=$S($D(ICDOP(" 37.95"))&($D(ICDOP(" 37.96"))):1,1:0),ICDE2=$S($D(ICDOP(" 37.97"))&($D(ICDOP(" 37.98"))):1,1:0)
	S ICDRG=$S((ICDE1&(ICDOR["H")):104,(ICDE1&(ICDOR'["H")):105,(ICDE2&(ICDOR["H")):104,(ICDE2&(ICDOR'["H")):105,1:120)
	Q
DRG121	S ICDRG=$S(ICDSD["CV":121,ICDEXP=0:122,ICDEXP=1:123,1:470) I ICDRG=470 S ICDRTC=5
	Q
DRG122	S ICDRG=$S(ICDSD["CV":121,ICDEXP=0:122,ICDEXP=1:123,1:470) I ICDRG=470 S ICDRTC=5
	Q
DRG123	S ICDRG=$S(ICDSD["CV":121,ICDEXP=0:122,ICDEXP=1:123,1:470) I ICDRG=470 S ICDRTC=5
	Q
DRG124	S ICDRG=$S(ICDPD["X"!(ICDSD["X"):124,1:125) Q
DRG125	S ICDRG=$S(ICDPD["X"!(ICDSD["X"):124,1:125) Q
DRG130	S ICDRG=$S(ICDCC:130,1:131) Q
DRG131	S ICDRG=$S(ICDCC!($D(ICDSDRG(130))):130,1:131) Q
DRG132	S ICDRG=$S(ICDCC:132,1:133) Q
DRG133	S ICDRG=$S(ICDCC:132,1:133) Q
DRG135	S ICDRG=$S(AGE<18:137,ICDCC:135,1:136) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG136	S ICDRG=$S(AGE<18:137,ICDCC:135,1:136) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG137	S ICDRG=$S(AGE<18:137,ICDCC:135,1:136) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG138	S ICDRG=$S(ICDCC:138,1:139) Q
DRG139	S ICDRG=$S(ICDCC:138,1:139) Q
DRG140	S ICDRG=$S(ICDOR["H":124,ICDNOR["H":124,1:140) Q
DRG141	S ICDRG=$S(ICDCC:141,1:142) Q
DRG142	S ICDRG=$S(ICDCC:141,1:142) Q
DRG144	S ICDRG=$S(ICDCC:144,1:145) Q
DRG145	S ICDRG=$S(ICDCC:144,1:145) Q
DRG146	S ICDRG=$S(ICDCC:146,1:147) Q
DRG147	S ICDRG=$S(ICDCC:146,1:147) Q
DRG148	S ICDRG=$S(ICDCC:148,1:149) Q
DRG149	S ICDRG=$S(ICDCC:148,1:149) Q
DRG150	S ICDRG=$S(ICDCC:150,1:151) Q
DRG151	S ICDRG=$S(ICDCC:150,1:151) Q
DRG152	S ICDRG=$S(ICDCC:152,1:153) Q
DRG153	S ICDRG=$S(ICDCC:152,1:153) Q
DRG154	S ICDRG=$S(AGE<18:156,ICDCC:154,1:155) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG155	S ICDRG=$S(AGE<18:156,ICDCC:154,1:155) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG156	S ICDRG=$S(AGE<18:156,ICDCC:154,1:155) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG157	S ICDRG=$S(ICDCC:157,1:158) Q
DRG158	S ICDRG=$S(ICDCC:157,1:158) Q
DRG159	S ICDRG=$S(AGE<18:163,ICDCC:159,1:160) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG160	S ICDRG=$S(AGE<18:163,ICDCC:159,1:160) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG161	S ICDRG=$S(AGE<18:163,ICDCC:161,ICDSD["J":161,1:162) I AGE="" S ICDRG=470,ICDRTC=3
	Q
DRG162	S ICDRG=$S(AGE<18:163,ICDCC:161,1:162) I AGE="" S ICDRG=470,ICDRTC=3
	Q
