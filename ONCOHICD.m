ONCOHICD	;Hines OIFO/GWB ICD-O HELP ;5/18/92
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;
HP	;PRIMARY SITE (165.5,20) EXECUTABLE HELP
	;HISTOLOGY (ICD-O-2) (165.5,22) EXECUTABLE HELP
	Q:'$D(ONCOX)
	S ONCOY=$S(ONCOX=164:2,1:3),ONCOS=$P(^ONCO(165.5,D0,0),U)
	W:$X !
	S XI=0 F  S XI=$O(^ONCO(164.2,ONCOS,ONCOY,"B",XI)) Q:XI'>0  S Y=$G(^ONCO(ONCOX,XI,0)) I Y'="" W !,?3,$P(Y,U,2),?12,$P(Y,U),?45,$P(Y,U,9)
	W:$X !
	K ONCOX,ONCOS,ONCOY
	Q
	;
ICDO3	;ICD-O-3 MORPHOLOGY help
	S ICDTOP=$P($G(^ONCO(165.5,D0,2)),U,1)
	I ICDTOP="" G ICDO3EX
	S ICDTOP=$E(ICDTOP,1,4)
	W:$X !
	S XI=0 F I=1:1 S XI=$O(^ONCO(169.3,"AC",ICDTOP,XI)) Q:XI'>0  S Y=^ONCO(169.3,XI,0) W:I=1 !,?3,"Common morphologies for topography ","(C",$E(ICDTOP,3,4),"._)",! W !,?3,$P(Y,U,2),"  ",$P(Y,U,1) I I#20=0 K DIR S DIR(0)="E" D ^DIR Q:'Y
	W:$X !
ICDO3EX	K ICDTOP,XI,I
	Q
	;
HIST23	;If HISTOLOGY (ICD-O-2) (165.5,22) value is changed and DATE DX is
	;prior to 2001, delete HISTOLOGY (ICD-O-3) (165.5,22.3) value
	S:$P(^ONCO(165.5,DA,0),U,16)<3010000 $P(^ONCO(165.5,DA,2.2),U,3)=""
	Q
	;
DEFH3	;HISTOLOGY (ICD-O-3) (165.5,22.3) default
	S H3DEF="",DATEDX=$P($G(^ONCO(165.5,D0,0)),U,16) I DATEDX>3001231 Q
	S H2VAL=$P($G(^ONCO(165.5,D0,2)),U,3),FND=0
	I H2VAL="" D  Q
	.S $P(^ONCO(165.5,D0,2.2),U,3)="",Y=101
	.W !,"HISTOLOGY (ICD-O-3): " Q
	F NNN=1:1 S VAL=$P($T(TABLE+NNN),";;",2) D  Q:VAL=""!(FND=1)
	.I $P(VAL,U,1)=H2VAL S H3DEF=$E($P(VAL,U,2),1,5),FND=1
	I H3DEF'="" S H3DEF=$P($G(^ONCO(169.3,H3DEF,0)),U,1) Q
	I H3DEF="" S H3DEF=$P($G(^ONCO(169.3,H2VAL,0)),U,1) Q
	;
TABLE	;Histology ICD-O-2 to ICD-O-3 Table
	;;82411^82401 ;CARCINOID TUMOR OF UNCERTAIN MALIG POTENTIAL
	;;85113^83453 ;MEDULLARY CARCINOMA WITH AMYLOID STROMA
	;;85112^83452 ;MEDULLARY CARCINOMA WITH AMYLOID STROMA IN SITU
	;;87240^91600 ;ANGIOFIBROMA, NOS
	;;91341^91333 ;EPITHELIOID HEMANGIOENDOTHELIOMA, MALIGNANT
	;;91260^91250 ;EPITHELIOID HEMANGIOMA
	;;91903^91923 ;PAROSTEAL OSTEOSARCOMA
	;;91902^91922 ;PAROSTEAL OSTEOSARCOMA IN SITU
	;;94223^94211 ;PILOCYTIC ASTROCYTOMA      
	;;94222^94212 ;JUVENILE ASTROCYTOMA IN SITU      
	;;94433^94233 ;POLAR SPONGIOBLASTOMA      
	;;94432^94232 ;POLAR SPONGIOBLASTOMA IN SITU      
	;;94813^94413 ;GIANT CELL GLIOBLASTOMA
	;;94812^94412 ;GIANT CELL GLIOBLASTOMA IN SITU      
	;;95360^91501 ;HEMANGIOPERICYTOMA, NOS      
	;;95923^95913 ;MALIGNANT LYMPHOMA, NON-HODGKIN, NOS
	;;95933^95913 ;MALIGNANT LYMPHOMA, NON-HODGKIN, NOS
	;;95943^95903 ;MALIGNANT LYMPHOMA, NOS
	;;95953^95913 ;MALIGNANT LYMPHOMA, NON-HODGKIN, NOS
	;;96573^96513 ;HODGKIN LYMPHOMA, LYMPHOCYTE-RICH
	;;96583^96513 ;HODGKIN LYMPHOMA, LYMPHOCYTE-RICH
	;;96603^96593 ;HODGKIN LYMPHOMA, NODULAR LYMPHOCYTE PREDOMIN
	;;96663^96653 ;HODGKIN LYMPHOMA, NODULAR SCLEROSIS, GRADE 1
	;;96723^95913 ;MALIGNANT LYMPHOMA, NON-HODGKIN, NOS
	;;96743^96733 ;MANTLE CELL LYMPHOMA
	;;96763^96753 ;MALIGNANT LYMPHOMA, MIXED SMALL/LARGE, DIFF
	;;96773^96733 ;MANTLE CELL LYMPHOMA
	;;96813^96803 ;MALIGNANT LYMPHOMA, LRGE B-CELL, DIFFUSE, NOS
	;;96823^96803 ;MALIGNANT LYMPHOMA, LRGE B-CELL, DIFFUSE, NOS
	;;96833^96803 ;MALIGNANT LYMPHOMA, LRGE B-CELL, DIFFUSE, NOS
	;;96853^97273 ;PRECURSOR CELL LYMPHOBLASTIC LYMPHOMA, NOS
	;;96863^95913 ;MALIGNANT LYMPHOMA, NON-HODGKIN, NOS
	;;96883^96803 ;MALIGNANT LYMPHOMA, LRGE B-CELL, DIFFUSE, NOS
	;;96923^96903 ;FOLLICULAR LYMPHOMA, NOS
	;;96933^96983 ;FOLLICULAR LYMPHOMA, GRADE 3
	;;96943^95913 ;MALIGNANT LYMPHOMA, NON-HODGKIN, NOS
	;;96963^96953 ;FOLLICULAR LYMPHOMA, GRADE 1
	;;96973^96983 ;FOLLICULAR LYMPHOMA, GRADE 3
	;;97033^97023 ;MATURE T-CELL LYMPHOMA, NOS
	;;97043^97023 ;MATURE T-CELL LYMPHOMA, NOS
	;;97063^97023 ;MATURE T-CELL LYMPHOMA, NOS
	;;97073^97023 ;MATURE T-CELL LYMPHOMA, NOS
	;;97103^96993 ;MARGINAL ZONE B-CELL LYMPHOMA, NOS
	;;97113^96993 ;MARGINAL ZONE B-CELL LYMPHOMA, NOS
	;;97123^96803 ;MALIGNANT LYMPHOMA, LRGE B-CELL, DIFFUSE, NOS
	;;97133^97193 ;NK/T-CELL LYMPHOMA, NASAL AND NASAL-TYPE
	;;97153^96993 ;MARGINAL ZONE B-CELL LYMPHOMA, NOS
	;;97203^97503 ;MALIGNANT HISTIOCYTOSIS
	;;97223^97543 ;LANGERHANS CELL HISTIOCYTOSIS, DISSEMINATED
	;;97233^97553 ;HISTIOCYTIC SARCOMA
	;;97633^97623 ;HEAVY CHAIN DISEASE, NOS
	;;98023^98003 ;LEUKEMIA, NOS
	;;98033^98003 ;LEUKEMIA, NOS
	;;98043^98003 ;LEUKEMIA, NOS
	;;98213^98353 ;PRECURSOR CELL LYMPHOBLASTIC LEUKEMIA, NOS
	;;98223^98203 ;LYMPHOID LEUKEMIA, NOS
	;;98243^98203 ;LYMPHOID LEUKEMIA, NOS
	;;98253^98323 ;PROLYMPHOCYTIC LEUKEMIA, NOS
	;;98283^98353 ;PRECURSOR CELL LYMPHOBLASTIC LEUKEMIA, NOS
	;;98303^97333 ;PLASMA CELL LEUKEMIA
	;;98413^98403 ;ACUTE MYELOID LEUKEMIA, M6 TYPE
	;;98423^99503 ;POLYCYTHEMIA VERA
	;;98503^98203 ;LYMPHOID LEUKEMIA, NOS
	;;98623^98603 ;MYELOID LEUKEMIA, NOS
	;;98643^98603 ;MYELOID LEUKEMIA, NOS
	;;98653^98743 ;ACUTE MYELOID LEUKEMIA WITH MATURATION
	;;98683^99453 ;CHRONIC MYELOMONOCYTIC LEUKEMIA, NOS
	;;98693^98723 ;ACUTE MYELOID LEUKEMIA, MINIMAL DIFF
	;;98803^98603 ;MYELOID LEUKEMIA, NOS
	;;98903^98603 ;MYELOID LEUKEMIA, NOS
	;;98923^98603 ;MYELOID LEUKEMIA, NOS
	;;98933^98603 ;MYELOID LEUKEMIA, NOS
	;;98943^98603 ;MYELOID LEUKEMIA, NOS
	;;99003^97423 ;MAST CELL LEUKEMIA
	;;99323^99313 ;ACUTE PANMYELOSIS WITH MYELOFIBROSIS
	;;99413^99403 ;HAIRY CELL LEUKEMIA
	;;99811^99803 ;REFRACTORY ANEMIA
	;;89311^89313 ;ENDOMETRIAL STROMAL SARCOMA, LOW GRADE
	;;93931^93933 ;PAPILLARY EPENDYMOMA
	;;95381^95383 ;PAPILLARY MENINGIOMA
	;;99501^99503 ;POLYCYTHEMIA VERA
	;;99601^99603 ;CHRONIC MYELOPROLIFERATIVE DISEASE, NOS
	;;99611^99613 ;MYELOSCLEROSIS WITH MYELOID METAPLASIA
	;;99621^99623 ;ESSENTIAL THROMBOCYTHEMIA
	;;99801^99803 ;REFRACTORY ANEMIA
	;;99821^99823 ;REFRACTORY ANEMIA WITH SIDEROBLASTS
	;;99831^99833 ;REFRACTORY ANEMIA WITH EXCESS BLASTS
	;;99841^99843 ;REFRACTORY ANEMIA W EXCESS BLASTS IN TRANS
	;;99891^99893 ;MYELODYSPLASTIC SYNDROME, NOS
	;;84423^84421 ;SEROUS CYSTADENOMA, BORDERLINE
	;;84513^84511 ;PAPILLARY CYSTADENOMA, BORDERLINE
	;;84623^84621 ;SEROUS PAPILLARY CYSTIC TUMOR, BORDERLINE
	;;84723^84721 ;MUCINOUS CYSTIC TUMOR, BORDERLINE
	;;84733^84731 ;PAPILLARY MUCINOUS CYSTADENOMA, BORDERLINE
	;;94213^94211 ;PILOCYTIC ASTROCYTOMA *** SEE APPENDIX E      
	;;81200^81201 ;UROTHELIAL PAPILLOMA, NOS
	;;81520^81521 ;GLUCAGONOMA, NOS
	;;86400^86401 ;SERTOLI CELL TUMOR, NOS
	;;95060^95061 ;CENTRAL NEUROCYTOMA
	;;82611^82610 ;VILLOUS ADENOMA, NOS
	;;83611^83610 ;JUXTAGLOMERULAR TUMOR
	;;88231^88230 ;DESMOPLASTIC FIBROMA
	;;90801^90800 ;MATURE TERATOMA
