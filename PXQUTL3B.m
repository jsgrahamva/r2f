PXQUTL3B ;ISL/JVS CLEAN OUT BAD XREF #3 ;6/9/97  09:05
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**29,35,100**;Aug 12, 1996
 ;
 Q
O ;---OTHER V FILES
 ;
 N IMMCNT,SKCNT,XAMCNT,TRTCNT,PEDCNT,HFCNT
 D I I Y="^" Q
 D S I Y="^" Q
 D X I Y="^" Q
 D T^PXQUTL3C I Y="^" Q
 D P^PXQUTL3C I Y="^" Q
 D H^PXQUTL3C I Y="^" Q
 Q
 ;
 ;
I W !!,"Checking the V IMMUNIZATION FILE #9000010.11 ",!
 S IMMCNT=0
 I Y="^" Q
 S I="" F  S I=$O(^AUPNVIMM("B",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVIMM("B",I,IEN)) W:IEN#1000=22 "." Q:IEN=""  D  Q:Y="^"
 ..S ARRAY="^AUPNVIMM(""B"",I,IEN)" S IMMCNT=IMMCNT+1 I IMMCNT#1000=2 D MON
 ..I '$D(^AUPNVIMM(IEN)) W !,"Entry "_IEN," IS NOT THERE! BAD REFERENCE IS ^AUPNVIMM(""B"","_I_",",IEN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 ;
 ;-----AD
 S I="" F  S I=$O(^AUPNVIMM("AD",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVIMM("AD",I,IEN)) W:IEN#1000=22 "." Q:IEN=""  D  Q:Y="^"
 ..S ARRAY="^AUPNVIMM(""AD"",I,IEN)" S IMMCNT=IMMCNT+1 I IMMCNT#1000=2 D MON
 ..I '$D(^AUPNVIMM(IEN)) W !,"Entry "_IEN," IS NOT THERE! BAD REFERENCE IS ^AUPNVIMM(""AD"","_I_",",IEN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 ;
 ;-----C
 S I="" F  S I=$O(^AUPNVIMM("C",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVIMM("C",I,IEN)) W:IEN#1000=22 "." Q:IEN=""  D  Q:Y="^"
 ..S ARRAY="^AUPNVIMM(""C"",I,IEN)" S IMMCNT=IMMCNT+1 I IMMCNT#1000=2 D MON
 ..I '$D(^AUPNVIMM(IEN)) W !,"Entry "_IEN," IS NOT THERE! BAD REFERENCE IS ^AUPNVIMM(""C"","_I_",",IEN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 ;
 ;-----AA
 S I="" F  S I=$O(^AUPNVIMM("AA",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVIMM("AA",I,IEN)) Q:IEN=""  D  Q:Y="^"
 ..S IENN="" F  S IENN=$O(^AUPNVIMM("AA",I,IEN,IENN)) Q:IENN=""  D  Q:Y="^"
 ...S IENNN="" F  S IENNN=$O(^AUPNVIMM("AA",I,IEN,IENN,IENNN)) W:IENNN#1000=22 "." Q:IENNN=""  D  Q:Y="^"
 ....S ARRAY="^AUPNVIMM(""AA"",I,IEN,IENN,IENNN)" S IMMCNT=IMMCNT+1 I IMMCNT#1000=2 D MON
 ....I '$D(^AUPNVIMM(IENNN)) W !,"Entry "_IENNN," IS NOT THERE! BAD REFERENCE IS ^AUPNVIMM(""AA"","_I_",",IEN_","_IENN_","_IENNN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 Q
 ;
 ;
 ;
S W !!,"Checking the V SKIN TEST FILE #9000010.12 ",!
 S SKCNT=0
 I Y="^" Q
 S I="" F  S I=$O(^AUPNVSK("B",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVSK("B",I,IEN)) W:IEN#1000=22 "." Q:IEN=""  D  Q:Y="^"
 ..S ARRAY="^AUPNVSK(""B"",I,IEN)" S SKCNT=SKCNT+1 I SKCNT#1000=2 D MON
 ..I '$D(^AUPNVSK(IEN)) W !,"Entry "_IEN," IS NOT THERE! BAD REFERENCE IS ^AUPNVSK(""B"","_I_",",IEN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 S I="" F  S I=$O(^AUPNVSK("AD",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVSK("AD",I,IEN)) W:IEN#1000=22 "." Q:IEN=""  D  Q:Y="^"
 ..S ARRAY="^AUPNVSK(""AD"",I,IEN)" S SKCNT=SKCNT+1 I SKCNT#1000=2 D MON
 ..I '$D(^AUPNVSK(IEN)) W !,"Entry "_IEN," IS NOT THERE! BAD REFERENCE IS ^AUPNVSK(""AD"","_I_",",IEN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 S I="" F  S I=$O(^AUPNVSK("AE",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVSK("AE",I,IEN)) W:IEN#1000=22 "." Q:IEN=""  D  Q:Y="^"
 ..S ARRAY="^AUPNVSK(""AE"",I,IEN)" S SKCNT=SKCNT+1 I SKCNT#1000=2 D MON
 ..I '$D(^AUPNVSK(IEN)) W !,"Entry "_IEN," IS NOT THERE! BAD REFERENCE IS ^AUPNVSK(""AE"","_I_",",IEN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 S I="" F  S I=$O(^AUPNVSK("C",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVSK("C",I,IEN)) W:IEN#1000=22 "." Q:IEN=""  D  Q:Y="^"
 ..S ARRAY="^AUPNVSK(""C"",I,IEN)" S SKCNT=SKCNT+1 I SKCNT#1000=2 D MON
 ..I '$D(^AUPNVSK(IEN)) W !,"Entry "_IEN," IS NOT THERE! BAD REFERENCE IS ^AUPNVSK(""C"","_I_",",IEN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 S I="" F  S I=$O(^AUPNVSK("AA",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVSK("AA",I,IEN)) Q:IEN=""  D  Q:Y="^"
 ..S IENN="" F  S IENN=$O(^AUPNVSK("AA",I,IEN,IENN)) Q:IENN=""  D  Q:Y="^"
 ...S IENNN="" F  S IENNN=$O(^AUPNVSK("AA",I,IEN,IENN,IENNN)) W:IENNN#1000=22 "." Q:IENNN=""  D  Q:Y="^"
 ....S ARRAY="^AUPNVSK(""AA"",I,IEN,IENN,IENNN)" S SKCNT=SKCNT+1 I SKCNT#1000=2 D MON
 ....I '$D(^AUPNVSK(IENNN)) W !,"Entry "_IENNN," IS NOT THERE! BAD REFERENCE IS ^AUPNVSK(""AA"","_I_",",IEN_","_IENN_","_IENNN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 Q
 ;
X W !!,"Checking the V EXAM FILE #9000010.13 ",!
 S XAMCNT=0
 I Y="^" Q
 S I="" F  S I=$O(^AUPNVXAM("B",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVXAM("B",I,IEN)) W:IEN#1000=22 "." Q:IEN=""  D  Q:Y="^"
 ..S ARRAY="^AUPNVXAM(""B"",I,IEN)" S XAMCNT=XAMCNT+1 I XAMCNT#1000=2 D MON
 ..I '$D(^AUPNVXAM(IEN)) W !,"Entry "_IEN," IS NOT THERE! BAD REFERENCE IS ^AUPNVXAM(""B"","_I_",",IEN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 S I="" F  S I=$O(^AUPNVXAM("AD",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVXAM("AD",I,IEN)) W:IEN#1000=22 "." Q:IEN=""  D  Q:Y="^"
 ..S ARRAY="^AUPNVXAM(""AD"",I,IEN)" S XAMCNT=XAMCNT+1 I XAMCNT#1000=2 D MON
 ..I '$D(^AUPNVXAM(IEN)) W !,"Entry "_IEN," IS NOT THERE! BAD REFERENCE IS ^AUPNVXAM(""AD"","_I_",",IEN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 S I="" F  S I=$O(^AUPNVXAM("C",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVXAM("C",I,IEN)) W:IEN#1000=22 "." Q:IEN=""  D  Q:Y="^"
 ..S ARRAY="^AUPNVXAM(""C"",I,IEN)" S XAMCNT=XAMCNT+1 I XAMCNT#1000=2 D MON
 ..I '$D(^AUPNVXAM(IEN)) W !,"Entry "_IEN," IS NOT THERE! BAD REFERENCE IS ^AUPNVXAM(""C"","_I_",",IEN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 S I="" F  S I=$O(^AUPNVXAM("AA",I)) Q:I=""  D  Q:Y="^"
 . S IEN="" F  S IEN=$O(^AUPNVXAM("AA",I,IEN)) Q:IEN=""  D  Q:Y="^"
 ..S IENN="" F  S IENN=$O(^AUPNVXAM("AA",I,IEN,IENN)) Q:IENN=""  D  Q:Y="^"
 ...S IENNN="" F  S IENNN=$O(^AUPNVXAM("AA",I,IEN,IENN,IENNN)) W:IENNN#1000=22 "." Q:IENNN=""  D  Q:Y="^"
 ....S ARRAY="^AUPNVXAM(""AA"",I,IEN,IENN,IENNN)" S XAMCNT=XAMCNT+1 I XAMCNT#1000=2 D MON
 ....I '$D(^AUPNVXAM(IENNN)) W !,"Entry "_IENNN," IS NOT THERE! BAD REFERENCE IS ^AUPNVXAM(""AA"","_I_",",IEN_","_IENN_","_IENNN_")" D @$S(AUTO="F":"KILL",AUTO'="F":"TT",1:"")
 Q
 ;
MON ;--MONITOR SITUATION
 D NOW^%DTC S NOW=% S:'$G(PAST) PAST=% I $G(PAST) D  S:'$G(PAST) PAST=%
 .I ($P(NOW,".",2)-$P(PAST,".",2))>60 D
 ..D CAL K PAST
 Q
CAL ;--CALCULATE TIME LEFT
 N IMMT,SKT,XAMT,TRTT,PEDT,HFT
 S:'$G(IMMCNT) IMMCNT=1 S:'$G(SKCNT) SKCNT=1
 S:'$G(XAMCNT) XAMCNT=1 S:'$G(TRTCNT) TRTCNT=1
 S:'$G(PEDCNT) PEDCNT=1 S:'$G(HFCNT) HFCNT=1
 ;
 S IMMT=$P($G(^AUPNVIMM(0)),"^",4)*4 S:IMMT'>0 IMMT=1 S IMMP=(($G(IMMCNT)/IMMT)*100)
 S SKT=$P($G(^AUPNVSK(0)),"^",4)*5 S:SKT'>0 SKT=1 S SKP=(($G(SKCNT)/SKT)*100)
 S XAMT=$P($G(^AUPNVXAM(0)),"^",4)*4 S:XAMT'>0 XAMT=1 S XAMP=(($G(XAMCNT)/XAMT)*100)
 S TRTT=$P($G(^AUPNVTRT(0)),"^",4)*4 S:TRTT'>0 TRTT=1 S TRTP=(($G(TRTCNT)/TRTT)*100)
 S PEDT=$P($G(^AUPNVPED(0)),"^",4)*4 S:PEDT'>0 PEDT=1 S PEDP=(($G(PEDCNT)/PEDT)*100)
 S HFT=$P($G(^AUPNVHF(0)),"^",4)*4 S:HFT'>0 HFT=1 S HFP=(($G(HFCNT)/HFT)*100)
 ;
 I IMMCNT=1 S IMMCNT=0,IMMP=0
 I SKCNT=1 S SKCNT=0,SKP=0
 I XAMCNT=1 S XAMCNT=0,XAMP=0
 I TRTCNT=1 S TRTCNT=0,TRTP=0
 I PEDCNT=1 S PEDCNT=0,PEDP=0
 I HFCNT=1 S HFCNT=0,HFP=0
 W !!,"       - - M O N I T O R  AT 1 MINUTE- -" N Y,% D YX^%DTC W " "_Y
 W !,"FILE",?20,"TOTAL",?35,"#FINISHED",?50,"%COMPLETED"
 W !,"V IMMUNIZATION",?20,IMMT,?35,IMMCNT,?50,$E(IMMP,1,5)_"%"
 W !,"V SKIN TEST",?20,SKT,?35,SKCNT,?50,$E(SKP,1,5)_"%"
 W !,"V EXAM",?20,XAMT,?35,XAMCNT,?50,$E(XAMP,1,5)_"%"
 W !,"V TREATMENT",?20,TRTT,?35,TRTCNT,?50,$E(TRTP,1,5)_"%"
 W !,"V PATIENT ED",?20,PEDT,?35,PEDCNT,?50,$E(PEDP,1,5)_"%"
 W !,"V HEALTH FACTOR",?20,HFT,?35,HFCNT,?50,$E(HFP,1,5)_"%"
 Q
 ;
 ;
TT ;--QUERY FOR CORRECT ENTRY
 S DIR("A")="Should I fix this one by removing the reference ??  "
 S DIR("B")="NO"
 S DIR(0)="YAO" D ^DIR
 I Y=1 D
 .K @ARRAY
 I Y="^" Q
 Q
KILL ;--AUTOMATIC
 ;W !,"KILL "_ARRAY
 K @ARRAY
 Q
PRMPT ;---PROMPT FOR PROMPTING
 S DIR("A")="Eliminate Prompting for Confirmation?  "
 S DIR("B")="NO"
 S DIR(0)="YAO"
 D ^DIR
 I Y=1 S AUTO="F"
 K DIR
 Q
