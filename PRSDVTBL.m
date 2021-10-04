PRSDVTBL	;HISC/MGD-PAID EMPLOYEE INQUIRY TABLE ; 02/02/2012  4:01 PM
	;;4.0;PAID;**78,82,86,73,132**;Sep 21, 1995;Build 13
	;;Per VHA Directive 2004-038, this routine should not be modified.
PTBL	;05 array
	K CHOICE F LOOP=1:1:LIMIT S CHOICE(LOOP)=$T(PTABLE+LOOP)
	Q
FTBL	;04 array
	K CHOICE F LOOP=1:1:LIMIT S CHOICE(LOOP)=$T(FTABLE+LOOP)
	Q
PTABLE	;05
	;;1;POSITION INFORMATION;P1;1
	;;2;PERSONAL INFORMATION;P2;1
	;;3;VERIFICATION OF EMPLOYMENT;P3;1
	;;4;PAY INFORMATION;P4;1
	;;5;BENEFITS;P5;1
	;;6;LEAVE;P6;1
	;;7;TITLE 38;P7;1
	;;8;FOLLOWUPS;P8;1
	;;9;NURSING;P9;1
	;;10;LABOR DISTRIBUTION;;
	;;;
P1	;;1;POSITION INFORMATION;1
	;;458,20,16,3,12,13,38,604,28,19,9,11,591,15,23,37,39,53,52,17,18,451,450,755,755.1,634
P2	;;2;PERSONAL INFORMATION;1
	;;33,32,31,4,186.1,186.2,186.3,186.4,2,42,30,26,600,43,603,222,10,5,47,22,24,25,56,57,428,429,430,432,434
P3	;;3;VERIFICATION OF EMPLOYMENT;1
	;;80,32,20,16,13,38,604,28,556,83,142,255,42,95,19,9,591,15,450,30,2,48,49,50,87,51,27,600,231
P4	;;4;PAY INFORMATION;1
	;;20,74,16,13,73,38,604,605,28,29,21,82,83,142,143,144,701,702,703,704,705,44,27,600,601,19,9,69,609,591,15,530,11,76,77,78,79,70,452,453,454,517,520,515,602,456,564,565,529,544,556,548,54,68,69,606,606.1,607,607.1,608,608.1,595,596,597
P5	;;5;BENEFITS;1
	;;32,30,26,113,147,55,60,59,64,58,75,231,232,233,234,114,226,1,580,578,409,410,406,399,396,404,407,408,412,414,419,424,564,565
P6	;;6;LEAVE;1
	;;30,14,55,462,464,465,463,466,136,137,510,512,511,710:1:717,513,514,508,515,517,519,523,524,505,496,506,507,473,474,475,485,486,487,476,477,478,479,480,481,482,483,484,584
P7	;;7;TITLE 38;1
	;;154,152,90,140,148,141,121,112,94,99,109,122,105,106,107,139,120,132,123,124,119,125,126,127,128,129,131,134,135,138,142,143,144,108,145,146,149,151,153,155:1:180,115.01:.01:115.14
P8	;;8;FOLLOWUPS;1
	;;115.17,89:1:97,97.1,98,98.1,98.2,98.3,98.4,99,99.1,100:1:114,114.1,114.2,115.01,115.18,115.14,115.02,115.03,115.04,115.19,115.2,115.05,115.06,115.07,115.08,115.09,115.21,115.1,115.11,115.12,115.13,116.01:.01:116.2
P9	;;9;NURSING;1
	;;13,38,604,605,19,20,27,28,600,89:1:97,97.1,98.1,98.2,98.3,98.4,99,99.1,100:1:114,115.01:.01:115.17,116.01:.01:116.2
	;;
FTABLE	;04
	;; 1;POSITION INFORMATION;F1;1
	;; 2;PERSONAL INFORMATION;F2;1
	;; 3;VERIFICATION OF EMPLOYMENT;F3;1
	;; 4;PAY INFORMATION;F4;1
	;; 5;BENEFITS;F5;2
	;; 6;EARNINGS;F6;1
	;; 7;FEDERAL/STATE/CITY TAXES;F7;2
	;; 8;DEDUCTIONS/ALLOTMENTS;F8;4
	;; 9;LEAVE;F9;1
	;;10;SEPARATED EMPLOYEE INFORMATION;F10;1
	;;11;VCS;F11;1
	;;12;LABOR DISTRIBUTION;;
	;;;
F1	;; 1;POSITION INFORMATION;1
	;;458,20,16,3,12,13,38,604,27,44,600,28,19,9,11,591,15,39,53,52,17,18,451,450,548,755,755.1,634
F2	;; 2;PERSONAL INFORMATION;1
	;;2,42,95,48,49,50,30,14,33,34,32,31,4,43,603,26,535,536,443,444,185,753,440,441,442,181,182,183,184,186,186.1,186.2,186.3,186.4
F3	;; 3;VERIFICATION OF EMPLOYMENT;1
	;;20,16,13,38,604,28,556,83,142,255,42,95,19,9,591,15,450,30,2,154,48,49,50,87,51,27,600
F4	;; 4;PAY INFORMATION;1
	;;20,74,16,11,13,73,38,604,605,44,27,600,601,19,9,591,15,530,609,21,28,29,82,83,142:1:144,150,133,76:1:79,70,515,517,520,452:1:454,602,456,564,565,529,544,556,548,68,69,606,606.1,607,607.1,608,608.1,595:1:597
F5	;; 5;BENEFITS;2
	;;26,337,539,534,60,338,329:1:332,336,333:1:335,59,147,58,75,231,230,235,232,233,234,114,40,226,225,228,223,227,229,224,1,580,578,409,410,406,399,396,404,412,403,395,397,398,414,413,415,417,419,418,420,422,424,423
	;;425,427,400:1:402,405,407,408,564,565,304
F6	;; 6;EARNINGS;1
	;;537,540,594,83.1,83.2,113,82,533,538,541,542,448,445,446,447,530,562,554,555,531,549,550,551,558,560,561,546,547,552,553,559,557,527,528,529,543,545,587,587.1,587.2,589,588,563,532,457,525,526
F7	;; 7;FEDERAL/STATE/CITY TAXES;2
	;;222,217,216,213,214,540,218,215,219,212,754,293,290,296,294,291,297,295,292,298,299,256,250,253,251,254,252,255,257,459,448,446,445,447,381,383,382,377,378,375,380,376,373,374,379,392,394,393,388,389,387,386,391,384,385,390,372
	;;305,195,197,196,188,193,190,194,191,192,187,189,206,208,207,201,204,200,205,202,203,198,199,312:1:317,220,221
F8	;; 8;DEDUCTIONS/ALLOTMENTS;4
	;;210,209,211,430,428,432,431,429,434,433,343,718,353,347,351,352,354,355,356,344,345,346,357,348,349,350,719,367,361,365,366,368,369,370,358,359,360,371,362,363,364,734,729,723,727,728,730,731,732,720,721
	;;722,733,724,725,726,749,744,738,742,743,745,746,747,735,736,737,748,739,740,741,339,340,341,342,436,435,437,438,439,439.1,439.2,439.3,439.4,310,308,306,311,309,307,300,302,301,706,707,762,763
	;;708,709,764,765,303,281,288,287,289,276,280,279,277,278,284,282,285,283,286,258,261,264,267,270,273,259,265,268,271,274,260,262,266,263,269,272,275,323,326,324,325,320,328,327,319,318,322,321,241,236
	;;244,246,242,237,239,248,245,247,243,238,240,249,750,751,759,758,761,760,752
F9	;; 9;LEAVE;1
	;;30,14,467,462,464,465,592,468,463,466,461,136,137,460,469:1:472,525,526,584,510,512,593,511,710:1:717,513,514,509,508,515,68,516,517,520,518,519,523,524,599,521,522,130,598,505,496,488:1:495,497:1:504,506,507,473:1:475,485:1:487,476:1:484
F10	;;10;SEPARATED EMPLOYEE INFORMATION;1
	;;80,48,49,50,449,51,58,75,234,525,526,330,332,334,395,397,398,215,214,218,219,294,291,297,295,292,298,299,251,254,252,255,257,212,375,380,386,391,190,194,200,205,314,315,447,220,277,457
F11	;;11;VCS;1
	;;580,578,582,583,584,581,585,586,586.1,566:1:577
	;;;
