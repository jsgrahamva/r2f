ONCSSF4	;Hines OIFO/GWB - SITE-SPECIFIC FACTOR 4 (165.5,44.4) ;11/20/03
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;
	;SITE-SPECIFIC FACTOR 4 (165.5,44.4)
SSF4IT	;INPUT TRANSFORM
	;
	S PS=$P($G(^ONCO(165.5,D0,2)),U,1)
	I PS="" K X W "  No PRIMARY SITE defined for this primary" Q
	S MO=$$HIST^ONCFUNC(D0)
	;
	S SSFIEN=$S($D(^ONCO(164.52,"C",PS_"-4")):$O(^ONCO(164.52,"C",PS_"-4",0)),1:1)
	;
	;Malignant Melanoma of Skin, Vulva, Penis, Scrotum
	I $$MELANOMA^ONCOU55(D0) D
	.S MELIEN=$O(^ONCO(164.52,"B","LDH",0))
	.I $E(PS,3,4)=44 S SSFIEN=MELIEN Q
	.I $E(PS,3,4)=51 S SSFIEN=MELIEN Q
	.I $E(PS,3,4)=60 S SSFIEN=MELIEN Q
	.I PS=67632 S SSFIEN=MELIEN Q
	;
	;Hodgkin and Non-Hodgkin Lymphomas of All Sites
	I $$LYMPHOMA^ONCFUNC(D0) S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	;Mycosis Fungoides and Sezary Disease of Skin, Vulva, Penis, Scrotum
	;Kaposi Sarcoma of All Sites
	I (MO=97003)!(MO=97013)!($E(MO,1,4)=9140) S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	;Hematopoietic, Reticuloendothelial, Immunoproliferative, and
	;Myeloproliferative Neoplasms
	I (MO'<97310)&(MO'>99899) S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	;Retinoblastoma
	I $E(MO,1,3)=951 S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	I '$D(^ONCO(164.52,SSFIEN,1,"B",X)) K X Q
	S SSF=$O(^ONCO(164.52,SSFIEN,1,"B",X,0))
	W "  ",$P(^ONCO(164.52,SSFIEN,1,SSF,0),U,2)
ITEX	K PS,SSFIEN,SSF,MO,MELING Q
	;
SSF4OT	;OUTPUT TRANSFORM
	;
	S PS=$P($G(^ONCO(165.5,D0,2)),U,1)
	Q:PS=""
	S MO=$$HIST^ONCFUNC(D0)
	;
	S SSFIEN=$S($D(^ONCO(164.52,"C",PS_"-4")):$O(^ONCO(164.52,"C",PS_"-4",0)),1:1)
	;
	;Malignant Melanoma of Skin, Vulva, Penis, Scrotum
	I $$MELANOMA^ONCOU55(D0) D
	.S MELIEN=$O(^ONCO(164.52,"B","LDH",0))
	.I $E(PS,3,4)=44 S SSFIEN=MELIEN Q
	.I $E(PS,3,4)=51 S SSFIEN=MELIEN Q
	.I $E(PS,3,4)=60 S SSFIEN=MELIEN Q
	.I PS=67632 S SSFIEN=MELIEN Q
	;
	;Hodgkin and Non-Hodgkin Lymphomas of All Sites
	I $$LYMPHOMA^ONCFUNC(D0) S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	;Mycosis Fungoides and Sezary Disease of Skin, Vulva, Penis, Scrotum
	;Kaposi Sarcoma of All Sites
	I (MO=97003)!(MO=97013)!($E(MO,1,4)=9140) S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	;Hematopoietic, Reticuloendothelial, Immunoproliferative, and
	I (MO'<97310)&(MO'>99899) S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	;Retinoblastoma
	I $E(MO,1,3)=951 S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	S SSF=$O(^ONCO(164.52,SSFIEN,1,"B",Y,0)) I SSF="" G OTEX
	S Y=$P($G(^ONCO(164.52,SSFIEN,1,SSF,0)),U,2)
OTEX	K PS,SSFIEN,SSF,MO Q
	;
SSF4HP	;HELP
	;
	S PS=$P($G(^ONCO(165.5,D0,2)),U,1)
	Q:PS=""
	S MO=$$HIST^ONCFUNC(D0)
	;
	S SSFIEN=$S($D(^ONCO(164.52,"C",PS_"-4")):$O(^ONCO(164.52,"C",PS_"-4",0)),1:1)
	;
	;Malignant Melanoma of Skin, Vulva, Penis, Scrotum
	I $$MELANOMA^ONCOU55(D0) D
	.S MELIEN=$O(^ONCO(164.52,"B","LDH",0))
	.I $E(PS,3,4)=44 S SSFIEN=MELIEN Q
	.I $E(PS,3,4)=51 S SSFIEN=MELIEN Q
	.I $E(PS,3,4)=60 S SSFIEN=MELIEN Q
	.I PS=67632 S SSFIEN=MELIEN Q
	;
	;Hodgkin and Non-Hodgkin Lymphomas of All Sites
	I $$LYMPHOMA^ONCFUNC(D0) S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	;Mycosis Fungoides and Sezary Disease of Skin, Vulva, Penis, Scrotum
	;Kaposi Sarcoma of All Sites
	I (MO=97003)!(MO=97013)!($E(MO,1,4)=9140) S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	;Hematopoietic, Reticuloendothelial, Immunoproliferative, and
	I (MO'<97310)&(MO'>99899) S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	;Retinoblastoma
	I $E(MO,1,3)=951 S SSFIEN=$O(^ONCO(164.52,"B","NOT APPLICABLE FOR THIS SITE",0))
	;
	W !," SITE-SPECIFIC FACTOR 4 for " D
	.I MO=97003 W "MYCOSIS FUNGOIDES of ",$P(^ONCO(164,PS,0),U,1)," (",$P(^ONCO(164,PS,0),U,2),")" Q
	.I MO=97013 W "SEZARY SYNDROME of ",$P(^ONCO(164,PS,0),U,1)," (",$P(^ONCO(164,PS,0),U,2),")" Q
	.I $E(MO,1,3)=951 W "RETINOBLASTOMA of ",$P(^ONCO(164,PS,0),U,1)," (",$P(^ONCO(164,PS,0),U,2),")" Q
	.I $$MELANOMA^ONCOU55(D0),($E(PS,3,4)=44)!($E(PS,3,4)=51)!($E(PS,3,4)=60)!(PS=67632)!($E(PS,3,4)=69) W "MALIGNANT MELANOMA of ",$P(^ONCO(164,PS,0),U,1)," (",$P(^ONCO(164,PS,0),U,2),")" Q
	.I $E(MO,1,4)=9140 W "KAPOSI SARCOMA of ALL SITES" Q
	.I $$LYMPHOMA^ONCFUNC(D0) W "HODGKIN AND NON-HODGKIN LYMPHOMAS of ALL SITES" Q
	.I (MO'<97310)&(MO'>99899) W $P(^ONCO(169.3,MO,0),U,1)," (",$P(^ONCO(169.3,MO,0),U,2),")" Q
	.W $P(^ONCO(164,PS,0),U,1)," (",$P(^ONCO(164,PS,0),U,2),")"
	W !," ",$P(^ONCO(164.52,SSFIEN,0),U,1)
	;S SSF=0 F  S SSF=$O(^ONCO(164.52,SSFIEN,1,SSF)) Q:SSF'>0  D
	;.S TAB=6
	;.W " ",$P(^ONCO(164.52,SSFIEN,1,SSF,0),U,1),?TAB,$P(^ONCO(164.52,SSFIEN,1,SSF,0),U,2),!
	K PS,SSFIEN,SSF,MO Q
