ICDTBL1D	;ALB/MJB - GROUPER UTILITY FUNCTIONS;08/09/2010
	;;18.0;DRG Grouper;**56,69**;Oct 20, 2000;Build 1
DRG100	;100-101
DRG101	;
	S ICDRG=$S(ICDMCC=2:100,1:101) Q
DRG102	;102-103
DRG103	;
	S ICDRG=$S(ICDMCC=2:102,1:103) Q
DRG113	;113-114
DRG114	;
	S ICDRG=$S(ICDMCC>0:113,1:114) Q
DRG115	S ICDRG=115 Q
DRG116	;
DRG117	S ICDRG=$S(ICDMCC>0:116,1:117) Q
DRG121	;
DRG122	S ICDRG=$S(ICDMCC>0:121,1:122) Q
DRG123	S ICDRG=123 Q
DRG124	;
DRG125	S ICDRG=$S(ICDMCC=2:124,1:125) Q
DRG129	;
DRG130	I $D(ICDOP(" 31.1")) S ICDRG=011 D DRG11^ICDTBL0D Q
	   S ICDRG=$S(ICDMCC>0:129,1:130)
	      I $D(ICDOP(" 20.96"))!$D(ICDOP(" 20.97"))!$D(ICDOP(" 20.98")) S ICDRG=129
	      Q
DRG131	;
DRG132	S ICDRG=$S(ICDMCC>0:131,1:132) Q
DRG133	;
DRG134	S ICDRG=$S(ICDMCC>0:133,1:134) Q
DRG135	;
DRG136	S ICDRG=$S(ICDMCC>0:135,1:136) Q
DRG137	;
DRG138	S ICDRG=$S(ICDMCC>0:137,1:138) Q
DRG139	S ICDRG=139 Q
DRG146	;
DRG147	;
DRG148	S ICDRG=$S(ICDMCC=2:146,ICDMCC=1:147,1:148) Q
DRG149	S ICDRG=149 Q
DRG150	;
DRG151	S ICDRG=$S(ICDMCC=2:150,1:151) Q
DRG152	;
DRG153	S ICDRG=$S(ICDMCC=2:152,1:153) Q
DRG154	;
DRG155	;
DRG156	S ICDRG=$S(ICDMCC=2:154,ICDMCC=1:155,1:156) Q
DRG157	;
DRG158	;
DRG159	S ICDRG=$S(ICDMCC=2:157,ICDMCC=1:158,1:159) Q
DRG163	;
DRG164	;
DRG165	S ICDRG=$S(ICDMCC=2:163,ICDMCC=1:164,1:165) Q
DRG166	;
DRG167	;
DRG168	S ICDRG=$S(ICDMCC=2:166,ICDMCC=1:167,1:168) Q
DRG175	;
DRG176	S ICDRG=$S(ICDMCC=2:175,1:176) Q
DRG177	;
DRG178	;
DRG179	I ICDDX(1)=9136,ICDSD["k" S ICDMCC=0
	S ICDRG=$S(ICDMCC=2:177,ICDMCC=1:178,1:179) Q
DRG180	;
DRG181	;
DRG182	S ICDRG=$S(ICDMCC=2:180,ICDMCC=1:181,1:182) Q
DRG183	;
DRG184	;
DRG185	S ICDRG=$S(ICDMCC=2:183,ICDMCC=1:184,1:185) Q
DRG186	;
DRG187	;
DRG188	S ICDRG=$S(ICDMCC=2:186,ICDMCC=1:187,1:188) Q
DRG189	I $D(ICDPDRG(205)) D DRG205^ICDTBL2D Q
	S ICDRG=189 Q
DRG190	;
DRG191	;
DRG192	S ICDRG=$S(ICDMCC=2:190,ICDMCC=1:191,1:192) Q
DRG193	;
DRG194	;
DRG195	S ICDRG=$S(ICDMCC=2:193,ICDMCC=1:194,1:195) Q
DRG196	;
DRG197	;
DRG198	S ICDRG=$S(ICDMCC=2:196,ICDMCC=1:197,1:198) Q
DRG199	I ICDSD["c" S ICDRG=200 Q
	S ICDRG=$S(ICDMCC=2:199,ICDMCC=1:200,1:201) Q
	Q
