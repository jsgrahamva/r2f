YTAPI4 ;ALB/ASF PSYCH TEST API PNOTES ;3/13/00  16:28
 ;;5.01;MENTAL HEALTH;**62**;Dec 30, 1994
 Q
PNTEXT(YSDATA,YS) ;
 Q
PREVIEW(YSDATA,YS) ;
 N DA,DIK,DFN,YSNCODE,YSCODE,YSADATE
 K ^TMP($J,"YTAPI4")
 D PARSE^YTAPI(.YS)
 I '$D(^DPT(DFN,0)) S YSDATA(1)="[ERROR]",YSDATA(2)="no such pt" Q
 I '$D(^YTT(601,"B",YSCODE)) S YSDATA(1)="[ERROR]",YSDATA(2)="INCORRECT TEST CODE" Q  ;---> bad code
 S YSNCODE=$O(^YTT(601,"B",YSCODE,-1))
 I YSADATE'=DT S YSDATA(1)="[ERROR]",YSDATA(2)="bad date needs DT" Q  ;---> bad date
 L +^YTD(601.2,DFN,1,YSNCODE,1,YSADATE):1 I '$T S YSDATA(1)="[ERROR]",YSDATA(2)="no lock" Q  ;--->
 D:$D(^YTD(601.2,DFN,1,YSNCODE,1,YSADATE)) INTMP ;save old testing for a day
 ;
 D SAVEIT^YTAPI1(.YSDATA,.YS) ; save responses
 I YSDATA(1)?1"[ERROR".E L -^YTD(601.2,DFN,1,YSNCODE,1,YSADATE) Q  ;---> bad save
 ;
 D SCOREIT^YTAPI2(.YSDATA,.YS)
DROP ;kill preview data
 S DIK="^YTD(601.2,DFN,1,YSNCODE,1,",DA=YSADATE,DA(1)=YSNCODE,DA(2)=DFN D ^DIK
 ;
 D:$D(^TMP($J,"YTAPI4")) OUTTMP ;place back old testing
 S DIK="^YTD(601.2,",DA=DFN D IX^DIK ; reindex
 L -^YTD(601.2,DFN,1,YSNCODE,1,YSADATE)
 Q
INTMP ; SAVE OLD
 M ^TMP($J,"YTAPI4")=^YTD(601.2,DFN,1,YSNCODE,1,YSADATE)
 Q
OUTTMP ;replace old testing
 M ^YTD(601.2,DFN,1,YSNCODE,1,YSADATE)=^TMP($J,"YTAPI4")
 Q
