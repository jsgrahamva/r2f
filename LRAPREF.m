LRAPREF ;AVAMC/REG - SNOMED REFERENCE OPTION SELECTOR ;3/9/94  13:20 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
L D END W ! S (DIC,DIE)=95,DIC(0)="AEOQLM",DLAYGO=95 D ^DIC K DIC,DLAYGO G:Y<1 END S DA=+Y,DR="0:99" D ^DIE G L
 ;
END D V^LRU Q
