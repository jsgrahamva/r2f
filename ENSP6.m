ENSP6	;(WASH ISC)/WDS@Charleston-Lease/Planned Space Edit Driver ; 3/10/14 2:08pm
V	;;7.0;ENGINEERING;**93**;Aug 17, 1993;Build 2
	;
L	;EDIT/ENTER LEASE SPACE INFORMATION FIELDS
	W !! S DIC="^ENG(6928.3,",DR=".5:99" G FMUT
	;
VEN	;ENTER/EDIT LEASE VENDOR DATA
	W !! S DIC="^ENG(6928.3,",DR="1:5.1" G FMUT
	;
P	;PRINT LEASE SPACE SURVEY
	S L="0",DIC="^ENG(""SP"",",DHD="ENGINEERING SPACE SURVEY OF LEASED ROOMS",BY=$S($D(^DIBT("B","ENZLEASE")):"[ENZLEASE]",1:"[ENLEASE]") D FLDS^ENSP1 G PRINT
	;
EP	;ENTER/EDIT SPACE PLANNING DATA
	W !!,"Enter Planning Data for this Room Number" S DIC(0)="AEQLM",DIC="^ENG(""SP"",",DR=".01;1.5;2.6;4.5;4.7;4.9;6;17" G FMUT
	;
PP	;PRINT PLANNING SPACE DATA
	W !!,"     Report will be segregated by PROJECT NUMBER in the Building File.",! S L="0",DIC="^ENG(""SP"",",BY=".51:20;""PROJECT NO."",.51,+4.9;S1",FLDS="[ENSP-H08-9]" G PRINT
	;
PRINT	I $D(%) Q:%<0
	S DIOEND="I IOST[""C-"" R !!,""Press <RETURN> to continue"",X:DTIME" D EN1^DIP
	G EXIT
FMUT	;FILE MANAGER UTILITY HANDLER
	S DIE=DIC S:'$D(DIC(0)) DIC(0)="AEQM"
FMUT1	D ^DIC S DA=+Y G:DA<1 EXIT D LOCK G:ENL=0 FMUT S:$D(DR)=0 DR=".01:99" S ENDA=+Y D ^DIE L -@(DIC_ENDA_")") W !! G FMUT
LOCK	;LOCK GLOBAL THAT IS BEING ACCESSED BY ANOTHER USER
	S X=DIC_DA_")" L +@X:1 S ENL=$T Q:ENL'=0  I ENL=0 W !!,$C(7),"THIS ENTRY IS BEING EDITED BY ANOTHER USER.  TRY LATER." Q
EXIT	K A,BY,C,DIC,DIE,DA,DP,DR,D0,ENDA,ENL,FLDS,FR,I,IOP,J,K,L,O,S,TO,X,Y,%DT Q
	;
	;ENSP6
