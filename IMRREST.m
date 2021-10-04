IMRREST ;HCIOFO/NCA - Resetting the Category ;5/23/97  09:46
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
RESET ; Reset the Category according to CD4 Counts
 ; called from IMRCD4 and IMRLAB
 ; IMRCD4=CD4 value
 ; IMRPR4=CD4 percentage
 I $D(IMRXCAT),IMRCD4'="",IMRCD4>199,IMRCD4<500,IMRXCAT=1 D
 . S DR="4///2" S IMRSFLG=1,IMRXCAT=2
 . S IMRTEXT="CATEGORY 1 SET TO 2 - CD4 COUNT IS 200 - 499." Q
 I $D(IMRXCAT),IMRCD4'="",IMRCD4<200,IMRXCAT=1 D
 . S DR="4///3" S IMRSFLG=1,IMRXCAT=3
 . S IMRTEXT="CATEGORY 1 SET TO 3 - CD4 COUNT IS LESS THAN 200." Q
 I $D(IMRXCAT),IMRCD4'="",IMRCD4<200,IMRXCAT=2 D
 . S DR="4///3" S IMRSFLG=1,IMRXCAT=3
 . S IMRTEXT="CATEGORY 2 SET TO 3 - CD4 COUNT IS LESS THAN 200." Q
 I $D(IMRXCAT),IMRPR4'="",IMRPR4<14,IMRXCAT=1 D
 . S DR="4///3" S IMRSFLG=1,IMRXCAT=3
 . S IMRTEXT="CATEGORY 1 SET TO 3 - CD4 % IS LESS THAN 14." Q
 I $D(IMRXCAT),IMRPR4'="",IMRPR4<14,IMRXCAT=2 D
 . S DR="4///3" S IMRSFLG=1,IMRXCAT=3
 . S IMRTEXT="CATEGORY 2 SET TO 3 - CD4 % IS LESS THAN 14." Q
 I DR'="" D ^DIE
 Q
