ISIXUT31 ;ISI/GEK,SAF - Non application utilities
 ;;1.0;ISI IMAGING;;Jan 03, 2008;Build 2
 ;;
 ;Show Tags in this routine, IF LVL=1 then show COMMENTS also 
TAGS(RTN) ;
 S LVL=+$G(LVL)
 W !,"TAGs in "_RTN,! S LVL=+$G(LVL)
 I 'LVL W "Set LVL =1 to show COMMENTS also",!
 S STOP=0,I=1,X="" F  Q:STOP  D
 . S LN=$T(+I^@RTN) I LN="" S STOP=1 Q
 . I $E(LN)]" " W !,LN
 . I 'LVL S I=I+1 Q
 . S LN1=$TR(LN," ")
 . I $E(LN1)=";" W !,"  ",LN
 . S I=I+1
 Q
