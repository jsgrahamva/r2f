RADLQ2	;HISC/GJC-Delq Status/Incomplete Rpt's ;3/6/97  08:50
	;;5.0;Radiology/Nuclear Medicine;**15,47**;Mar 16, 1998;Build 21
DATE	; Sort by date
	S RADIV="" F  S RADIV=$O(^TMP($J,"RADLQ",RADIV)) Q:RADIV']""  D  Q:RAXIT
	. S RA1=$P($G(^DIC(4,RADIV,0)),"^"),RAITYPE=""
	. F  S RAITYPE=$O(^TMP($J,"RADLQ",RADIV,RAITYPE)) Q:RAITYPE']""  D  Q:RAXIT
	.. S RA2=RAITYPE,RAVAR=""
	.. F  S RAVAR=$O(^TMP($J,"RADLQ",RADIV,RAITYPE,RAVAR)) Q:RAVAR']""  D  Q:RAXIT
	... S RADTE=0
	... F  S RADTE=$O(^TMP($J,"RADLQ",RADIV,RAITYPE,RAVAR,RADTE)) Q:RADTE'>0  D  Q:RAXIT
	.... S RANME=""
	.... F  S RANME=$O(^TMP($J,"RADLQ",RADIV,RAITYPE,RAVAR,RADTE,RANME)) Q:RANME']""  D  Q:RAXIT
	..... S RACN=0
	..... F  S RACN=$O(^TMP($J,"RADLQ",RADIV,RAITYPE,RAVAR,RADTE,RANME,RACN)) Q:RACN'>0  D  Q:RAXIT
	...... S RANODE=$G(^TMP($J,"RADLQ",RADIV,RAITYPE,RAVAR,RADTE,RANME,RACN))
	...... D:RANODE]"" OUTPUT^RADLQ3
	...... Q
	..... Q
	.... Q
	... Q
	.. D:'RAXIT IMGCHK
	.. Q
	. D:'RAXIT DIVCHK
	. Q
	Q
HDR	; Header for reports
	I RAPG!($E(IOST,1,2)="C-") W @IOF
	S RAPG=RAPG+1 W !?(IOM-$L(RAHD(0))\2),RAHD(0)
	W !,"Division: ",$S($D(RAFLAG):"",1:RA1),?RATAB("HEAD"),"Page: ",RAPG
	W !,"Imaging Type: ",$S($D(RAFLAG):"",1:RA2),?RATAB("HEAD"),"Date: "
	W $$FMTE^XLFDT($$DT^XLFDT,1)
	W !,RALN2
	I $$USESSAN^RAHLRU1() W !,"Patient Name",?RATAB(1),"Case #",?RATAB(2)+6,"Pt ID"
	I '$$USESSAN^RAHLRU1() W !,"Patient Name",?RATAB(1),"Case #",?RATAB(2),"Pt ID"
	W ?RATAB(3),"Date",?RATAB(4),"Ward/Clinic"
	W ?RATAB(5),"Rpt Stat",!?RATAB(6),"Procedure"
	W ?RATAB(7),"Exam Status",?RATAB(8),"Rpt Text"
	W ?RATAB(9),"Interp. Phys.",?RATAB(10),"Tech",!,RALN2
	I $D(ZTQUEUED) D STOPCHK^RAUTL9 S:$G(ZTSTOP)=1 RAXIT=1
	Q
PATIENT	; Sort by patient
	S RADIV="" F  S RADIV=$O(^TMP($J,"RADLQ",RADIV)) Q:RADIV']""  D  Q:RAXIT
	. S RA1=$P($G(^DIC(4,RADIV,0)),"^"),RAITYPE=""
	. F  S RAITYPE=$O(^TMP($J,"RADLQ",RADIV,RAITYPE)) Q:RAITYPE']""  D  Q:RAXIT
	.. S RA2=RAITYPE,RAVAR=""
	.. F  S RAVAR=$O(^TMP($J,"RADLQ",RADIV,RAITYPE,RAVAR)) Q:RAVAR']""  D  Q:RAXIT
	... S RANME=""
	... F  S RANME=$O(^TMP($J,"RADLQ",RADIV,RAITYPE,RAVAR,RANME)) Q:RANME']""  D  Q:RAXIT
	.... S RADTE=0
	.... F  S RADTE=$O(^TMP($J,"RADLQ",RADIV,RAITYPE,RAVAR,RANME,RADTE)) Q:RADTE'>0  D  Q:RAXIT
	..... S RACN=0
	..... F  S RACN=$O(^TMP($J,"RADLQ",RADIV,RAITYPE,RAVAR,RANME,RADTE,RACN)) Q:RACN'>0  D  Q:RAXIT
	...... S RANODE=$G(^TMP($J,"RADLQ",RADIV,RAITYPE,RAVAR,RANME,RADTE,RACN))
	...... D:RANODE]"" OUTPUT^RADLQ3
	...... Q
	..... Q
	.... Q
	... Q
	.. D:'RAXIT IMGCHK
	.. Q
	. D:'RAXIT DIVCHK
	. Q
	Q
PRINT	; Outputting the data
	S RATAB(1)=$S(IOM=132:40,1:22),RATAB(2)=$S(IOM=132:54,1:32)
	S RATAB(3)=$S(IOM=132:74,1:45),RATAB(4)=$S(IOM=132:90,1:55)
	S RATAB(5)=$S(IOM=132:120,1:72),RATAB(6)=1 ; for 132 & 80 column
	S RATAB(7)=$S(IOM=132:40,1:23),RATAB(8)=$S(IOM=132:75,1:36)
	S RATAB(9)=$S(IOM=132:90,1:46),RATAB(10)=$S(IOM=132:114,1:63)
	S RATAB("HEAD")=$S(IOM=132:102,1:62)
	S RADIV=$O(^TMP($J,"RADLQ","")),RA2=$O(^TMP($J,"RADLQ",RADIV,""))
	S RA1=$P($G(^DIC(4,RADIV,0)),"^") D HDR
	D @$S(RASORT2="P":"PATIENT",1:"DATE")
	Q
DIVCHK	; Output statistics within division
	N RA3 I $Y>(IOSL-4) S RAXIT=$$EOS^RAUTL5() D:'RAXIT HDR Q:RAXIT
	W !!?RATAB(6),"Division Total '"_RA1_"': ",+$G(^TMP($J,"RADLQ",RADIV))
	S RA3=+$O(^TMP($J,"RADLQ",RADIV))
	I RA3 N RA1,RA4 S RA1=$P($G(^DIC(4,RA3,0)),"^") D
	. S RA4=$O(^TMP($J,"RADLQ",RA3,"")) S:RA4]"" RA2=RA4
	. S:$E(IOST,1,2)="C-" RAXIT=$$EOS^RAUTL5() D:'RAXIT HDR
	. Q
	Q
IMGCHK	; Output statistics within Imaging Type
	N RA5
	I $Y>(IOSL-4) S RAXIT=$$EOS^RAUTL5() D:'RAXIT HDR Q:RAXIT
	W !!?RATAB(6),"Imaging Type Total '"_RA2_"': "
	W +$G(^TMP($J,"RADLQ",RADIV,RA2))
	S RA5=$O(^TMP($J,"RADLQ",RADIV,RAITYPE))
	I RA5]"" S RA2=RA5 D
	. N RA1 S RA1=$P($G(^DIC(4,RADIV,0)),"^")
	. S:$E(IOST,1,2)="C-" RAXIT=$$EOS^RAUTL5() D:'RAXIT HDR
	. Q
	Q
