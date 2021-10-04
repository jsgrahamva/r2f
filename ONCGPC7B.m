ONCGPC7B	;Hines OIFO/GWB - 2001 Gastric Cancers PCE Study ;05/02/01
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;Print (continued)
III	S TABLE="FIRST COURSE OF TREATMENT - SURGERY"
	I IOST'?1"C".E W ! I ($Y'<(LIN-4)) D HEAD^ONCGPC0
	K LINE S $P(LINE,"-",35)="-"
	W !?4,TABLE,!?4,LINE
	D P Q:EX=U
ITEM28	W !,"28. ADHERENCE OF RESECTED PRIMARY"
	D P Q:EX=U
	W !,"     SPECIMEN.....................: ",$$GET1^DIQ(165.5,IE,1556)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM29	W !,"29. MARGIN STATUS OF RESECTED"
	W !,"     PRIMARY SPECIMAN.............: ",$$GET1^DIQ(165.5,IE,1557)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM30	W !,"30. EXTENT OF FREE MARGIN:"
	D P Q:EX=U
	W !,"     PROXIMAL MARGIN..............: ",$$GET1^DIQ(165.5,IE,1558)
	D P Q:EX=U
	W !,"     DISTAL MARGIN................: ",$$GET1^DIQ(165.5,IE,1558.1)
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCGPC0 G ITEM31
	W !
	D P Q:EX=U
ITEM31	W !,"31. RESECTION BEYOND STOMACH:"
	D P Q:EX=U
	W !,"     SPLEEN.......................: ",$$GET1^DIQ(165.5,IE,1559)
	D P Q:EX=U
	W !,"     TRANVERSE COLON..............: ",$$GET1^DIQ(165.5,IE,1559.1)
	D P Q:EX=U
	W !,"     LIVER........................: ",$$GET1^DIQ(165.5,IE,1559.2)
	D P Q:EX=U
	W !,"     DIAPHRAGM....................: ",$$GET1^DIQ(165.5,IE,1559.3)
	D P Q:EX=U
	W !,"     PANCREAS.....................: ",$$GET1^DIQ(165.5,IE,1559.4)
	D P Q:EX=U
	W !,"     ABDOMINAL WALL...............: ",$$GET1^DIQ(165.5,IE,1559.5)
	D P Q:EX=U
	W !,"     ADRENAL GLAND................: ",$$GET1^DIQ(165.5,IE,1559.6)
	D P Q:EX=U
	W !,"     KIDNEY.......................: ",$$GET1^DIQ(165.5,IE,1559.7)
	D P Q:EX=U
	W !,"     SMALL INTESTINE..............: ",$$GET1^DIQ(165.5,IE,1559.8)
	D P Q:EX=U
	W !,"     RETROPERITONEUM..............: ",$$GET1^DIQ(165.5,IE,1559.9)
	D P Q:EX=U
	W !,"     PERIGASTRIC LYMPH NODES......: ",$$GET1^DIQ(165.5,IE,1560)
	D P Q:EX=U
	W !,"     COMMON HEPATIC LYMPH NODES...: ",$$GET1^DIQ(165.5,IE,1560.1)
	D P Q:EX=U
	W !,"     CELIAC LYMPH NODES...........: ",$$GET1^DIQ(165.5,IE,1560.2)
	D P Q:EX=U
	W !,"     SPLENIC LYMPH NODES..........: ",$$GET1^DIQ(165.5,IE,1560.3)
	D P Q:EX=U
	W !,"     OTHER INTRA-ABDOMINAL NODES..: ",$$GET1^DIQ(165.5,IE,1560.4)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM32	W !,"32. GROSSLY INVOLVED REGIONAL"
	D P Q:EX=U
	W !,"     LYMPH NODES..................: ",$$GET1^DIQ(165.5,IE,1561)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM33	W !,"33. HCT (HEMATOCRIT) VALUES BEFORE"
	D P Q:EX=U
	W !,"     TRANSFUSION..................: ",$$GET1^DIQ(165.5,IE,1562)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM34	W !,"34. TOTAL OPERATIVE BLOOD"
	D P Q:EX=U
	W !,"     REPLACEMENT..................: ",$$GET1^DIQ(165.5,IE,1563)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM35	W !,"35. INTRA/PERI-OPERATIVE DEATH....: ",$$GET1^DIQ(165.5,IE,1564)
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCGPC0 G ITEM36
	W !
	D P Q:EX=U
ITEM36	W !,"36. COMPLICATIONS REQUIRING RE-OPERATION:"
	D P Q:EX=U
	W !,"     ANASTOMOTIC LEAK.............: ",$$GET1^DIQ(165.5,IE,1565)
	D P Q:EX=U
	W !,"     STUMP LEAK...................: ",$$GET1^DIQ(165.5,IE,1565.1)
	D P Q:EX=U
	W !,"     BLEEDING.....................: ",$$GET1^DIQ(165.5,IE,1565.2)
	D P Q:EX=U
	W !,"     WOUND INFECTION..............: ",$$GET1^DIQ(165.5,IE,1565.3)
	D P Q:EX=U
	W !,"     SEPSIS.......................: ",$$GET1^DIQ(165.5,IE,1565.4)
	D P Q:EX=U
	W !,"     PANCREATITIS.................: ",$$GET1^DIQ(165.5,IE,1565.5)
	D P Q:EX=U
	W !,"     DEAD BOWEL...................: ",$$GET1^DIQ(165.5,IE,1565.6)
	D P Q:EX=U
	W !,"     OTHER........................: ",$$GET1^DIQ(165.5,IE,1565.7)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM37	W !,"37. DATE OF SURGICAL DISCHARGE....: ",$$GET1^DIQ(165.5,IE,1566)
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCGPC0
	S TABLE="FIRST COURSE OF TREATMENT - RADIATION"
	I IOST'?1"C".E W ! I ($Y'<(LIN-4)) D HEAD^ONCGPC0
	K LINE S $P(LINE,"-",37)="-"
	W !?4,TABLE,!?4,LINE
	D P Q:EX=U
ITEM38	W !,"38. REGIONAL DOSE (cGy)...........: ",$$GET1^DIQ(165.5,IE,442)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM39	W !,"39. BOOST DOSE (cGy)..............: ",$$GET1^DIQ(165.5,IE,1575)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM40	W !,"40. INTRA-OPERATIVE RADIATION"
	D P Q:EX=U
	W !,"     THERAPY, DOSE (cGy)..........: ",$$GET1^DIQ(165.5,IE,1567)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM41	W !,"41. CONCURRENT CHEMOTHERAPY.......: ",$$GET1^DIQ(165.5,IE,1568)
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCGPC0
	S TABLE="FIRST COURSE OF TREATMENT - CHEMOTHERAPY"
	I IOST'?1"C".E W ! I ($Y'<(LIN-4)) D HEAD^ONCGPC0
	K LINE S $P(LINE,"-",40)="-"
	W !?4,TABLE,!?4,LINE
	D P Q:EX=U
ITEM42	W !,"42. TYPE OF CHEMOTHERAPEUTIC AGENTS ADMINISTERED:"
	D P Q:EX=U
	W !,"     AGENT #1.....................: ",$$GET1^DIQ(165.5,IE,1576)
	D P Q:EX=U
	W !,"     AGENT #2.....................: ",$$GET1^DIQ(165.5,IE,1576.1)
	D P Q:EX=U
	W !,"     AGENT #3.....................: ",$$GET1^DIQ(165.5,IE,1576.2)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM43	W !,"43. INTRAPERITONEAL CHEMOTHERAPY..: ",$$GET1^DIQ(165.5,IE,1569)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM44	W !,"44. CHEMOTHERAPEUTIC TOXICITY.....: ",$$GET1^DIQ(165.5,IE,1577)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM45	W !,"45. CHEMOTHERAPY/SURGERY SEQUENCE.: ",$$GET1^DIQ(165.5,IE,1578)
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCGPC0
	S TABLE="FIRST COURSE OF TREATMENT - IMMUNOTHERAPY"
	I IOST'?1"C".E W ! I ($Y'<(LIN-4)) D HEAD^ONCGPC0
	K LINE S $P(LINE,"-",41)="-"
	W !?4,TABLE,!?4,LINE
	D P Q:EX=U
ITEM46	W !,"46. ADMINISTRATION OF INTERFERON..: ",$$GET1^DIQ(165.5,IE,1570)
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCGPC0
IV	S TABLE="TREATMENT COMPLICATIONS"
	I IOST'?1"C".E W !
	W !?4,TABLE,!?4,"-----------------------"
ITEM47	W !,"47. COMPLICATIONS:"
	D P Q:EX=U
	I TC="No" D  G TC2
	.W !,"     CO-MORBID CONDITION #1.......: 000.00 No co-morbidities"
	W !,"     COMPLICATION #1..............: ",$P($$GET1^DIQ(165.5,IE,1579)," ",1),?43,$P($$GET1^DIQ(165.5,IE,1579)," ",2,99)
TC2	D P Q:EX=U
	W !,"     COMPLICATION #2..............: ",$P($$GET1^DIQ(165.5,IE,1579.1)," ",1),?43,$P($$GET1^DIQ(165.5,IE,1579.1)," ",2,99)
	D P Q:EX=U
	W !,"     COMPLICATION #3..............: ",$P($$GET1^DIQ(165.5,IE,1579.2)," ",1),?43,$P($$GET1^DIQ(165.5,IE,1579.2)," ",2,99)
	D P Q:EX=U
	W !,"     COMPLICATION #4..............: ",$P($$GET1^DIQ(165.5,IE,1579.3)," ",1),?43,$P($$GET1^DIQ(165.5,IE,1579.3)," ",2,99)
	D P Q:EX=U
	W !,"     COMPLICATION #5..............: ",$P($$GET1^DIQ(165.5,IE,1579.4)," ",1),?43,$P($$GET1^DIQ(165.5,IE,1579.4)," ",2,99)
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCGPC0
V	S TABLE="CASE REGISTRATION"
	I IOST'?1"C".E W !
	W !?4,TABLE,!?4,"-----------------"
	D P Q:EX=U
ITEM48	W !,"48. INITIALS OF CASE ABSTRACTOR...: ",$$GET1^DIQ(165.5,IE,81)
	D P Q:EX=U
	W !
	D P Q:EX=U
ITEM49	W !,"49. DATE CASE WAS ABSTRACTED......: ",$$GET1^DIQ(165.5,IE,90)
	D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR
	Q
P	;Print
	I ($Y'<(LIN-1)) D  Q:EX=U
	.I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR I 'Y S EX=U Q
	.D HEAD^ONCGPC0 Q
	Q
