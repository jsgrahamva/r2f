ABSVDPRT ;EAP ALTOONA VOLUNTARY DONATIONS PROGRAM  ;4/22/02  3:50 PM
V ;;4.0;VOLUNTARY TIMEKEEPING;**25,26,29**;JULY 6, 1994
 ;VALUE PRINT ROUTINES-ASK FOR SITE INFO FIRST
ORG ;ORGANIZATION VALUE PRINT
 N DIC,Y,BY,FR,TO,L,FLDS,CTBX,ABSVXX,BDATE,EDATE
 D ^ABSVSITE Q:'%
 D GETDATE^ABSVDPNT
 D DRNG^ABSVU Q:'%
 S X=FR D CNVD^ABSVQ S BDATE=Y
 S X=TO D CNVD^ABSVQ S EDATE=Y
 S FR=ABSV("SITE")_",?,"_FR,TO=ABSV("SITE")_",?,"_TO
 S DIC=503340
 S L=0,BY="[ABSV DON ORG VALUE SORT]"
 S FLDS="[ABSV DON ORG VALUE PRINT]"
 D EN1^DIP
 K DIC,BY,FLDS,L,FR,TO
 QUIT
DATEREC ;DATE RECEIVED VALUE PRINT
 N DIC,Y,BY,FR,TO,L,FLDS,CTBX,ABSVXX,EDATE,BDATE
 D ^ABSVSITE Q:'%
 D GETDATE^ABSVDPNT
 D DRNG^ABSVU Q:'%
 S X=FR D CNVD^ABSVQ S BDATE=Y
 S X=TO D CNVD^ABSVQ S EDATE=Y
 S FR=ABSV("SITE")_","_FR,TO=ABSV("SITE")_","_TO
 S DIC=503340
 S L=0,BY="[ABSV DON RECEIVED SORT]"
 S FLDS="[ABSV DON RECEIVED PRINT]"
 D EN1^DIP
 K DIC,BY,FLDS,L,FR,TO
 QUIT
TYPE ;TYPE OF DONATION VALUE PRINT
 N DIC,Y,BY,FR,TO,L,FLDS,CTBX,ABSVXX,EDATE,BDATE
 D ^ABSVSITE Q:'%
 D GETDATE^ABSVDPNT
 D DRNG^ABSVU Q:'%
 S X=FR D CNVD^ABSVQ S BDATE=Y
 S X=TO D CNVD^ABSVQ S EDATE=Y
 S FR=ABSV("SITE")_",,"_FR,TO=ABSV("SITE")_",,"_TO
 S DIC=503340
 S BY="[ABSV DON TYPE VALUE SORT]"
 S FLDS="[ABSV DON TYPE VALUE PRINT]"
 S L=0
 D EN1^DIP
 K DIC,BY,FLDS,L,FR,TO
 QUIT
FISCAL ;MONTHLY REPORT TO FISCAL VALUE PRINT
 N DIC,Y,BY,FR,TO,L,FLDS,CTBX,ABSVXX,EDATE,BDATE
 D ^ABSVSITE Q:'%
 D GETDATE^ABSVDPNT
 D DRNG^ABSVU Q:'%
 S X=FR D CNVD^ABSVQ S BDATE=Y
 S X=TO D CNVD^ABSVQ S EDATE=Y
 S FR=ABSV("SITE")_",,"_FR,TO=ABSV("SITE")_",,"_TO
 S DIC=503340
 S BY="[ABSV DON FISCAL SORT]"
 S FLDS="[ABSV DON FISCAL PRINT]"
 S L=0
 D EN1^DIP
 K DIC,BY,FLDS,L,FR,TO
 QUIT
ACK ;DATE ACKNOWLEDGED VALUE PRINT
 N DIC,Y,BY,FR,TO,L,FLDS,CTBX,ABSVXX,EDATE,BDATE
 D ^ABSVSITE Q:'%
 D GETDATE^ABSVDPNT
 D DRNG^ABSVU Q:'%
 S X=FR D CNVD^ABSVQ S BDATE=Y
 S X=TO D CNVD^ABSVQ S EDATE=Y
 S FR=ABSV("SITE")_","_FR_",",TO=ABSV("SITE")_","_TO_","
 S DIC=503340
 S BY="[ABSV DON ACK VALUE SORT]"
 S FLDS="[ABSV DON ACK VALUE PRINT]"
 S L=0
 D EN1^DIP
 K DIC,BY,FLDS,L,FR,TO
 QUIT
POST ;PRINT POST/UNIT/CHAPTER
 N AFR,ATO,DIR,DIC,Y,BY,FR,TO,L,FLDS,CTBX,ABSVXX,EDATE,BDATE
 D ^ABSVSITE Q:'%
 S DIC("A")="Select VOLUNTEER ORGANIZATION: "
 S DIC=503334,DIC(0)="AEMNZ" D ^DIC Q:+Y<0  S ORG=$P(Y,"^",2)
 S DIR(0)="F^1:8",DIR("A")="Select POST",DIR("B")="ALL",DIR("?")="Enter the individual POST for the Organization you have selected, or ALL to print ALL Posts."
 D ^DIR Q:$$DIR^ABSVU2
 I X="ALL"!(X="all") S AFR="@",ATO="zzzzzz"
 E  S (AFR,ATO)=X
 D GETDATE^ABSVDPNT
 D DRNG^ABSVU Q:'%
 S X=FR D CNVD^ABSVQ S BDATE=Y
 S X=TO D CNVD^ABSVQ S EDATE=Y
 S DIC=503340,(BY,FLDS)="[ABSV DON POST]"
 S FR=ABSV("SITE")_","_ORG_","_AFR_",,"_FR,TO=ABSV("SITE")_","_ORG_","_ATO_",,"_TO
 D EN1^DIP
 QUIT
END ;;;;;;;;;;;;;;;;;;;
 QUIT
