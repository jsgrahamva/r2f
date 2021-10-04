ONCSRV01	;HIRMFO/RVD-SERVER ROUTINE FOR 160.16 AND REPORTS ;6/12/13
	;;2.2;ONCOLOGY;**1,4**;Jul 31, 2013;Build 5
	;
16016	;process if update, delete or new entry.
	;* separates the mailman message
	N ONC16016,ONCIEN
	S ONC16016=$P(XMRGONC1,"*",3),ONCIEN=$P(XMRGONC1,"*",4)
	I XMRGONC1["RULES" S IEN=0 G RULE  ;update RULES.
	I (XMRGONC1["DELETE")!(XMRGONC1["UPDATE") G DIK1  ;go to delete or update an entry.
	S IEN=0
	N DA,DR,ONC01,ONC1,ONC2,ONC3,ONCSS,ONCOLD,ONCRUDA
	;
NUE	;new and update an entry in file #160.16
	;#*^ seperate the message from the ien
	S ONCSS=$G(ONCSRDAT(IEN)) G:'$D(ONCSS)!(ONCSS="") EXIT
	S ONCOLD=$P(ONCSS,"#*^",1),ONCRUDA=$P(ONCSS,"#*^",2)
	I ONCOLD=0 G UP160
	I (ONCOLD=1),((IEN=2)!(IEN=3)) S ^ONCO(160.16,ONC16016,"FIELD",ONCIEN,1)=^ONCO(160.16,ONC16016,"FIELD",ONCIEN,1)_ONCRUDA S IEN=IEN+1 G NUE
	I ONCOLD=1 S ^ONCO(160.16,ONC16016,"FIELD",ONCIEN,1)=ONCRUDA
	I ONCOLD=2 S ^ONCO(160.16,ONC16016,"FIELD",ONCIEN,2)=ONCRUDA
	I ONCOLD=3 S ^ONCO(160.16,ONC16016,"FIELD",ONCIEN,3)=ONCRUDA
	I ONCOLD=4 S ^ONCO(160.16,ONC16016,"FIELD",ONCIEN,4)=ONCRUDA
	S IEN=IEN+1
	G NUE
	;
UP160	;add/update an entry in the extract.
	S DIC(0)="EL"
	S DA(1)=ONC16016,DA=ONCIEN
	S ONC01=$P(ONCSS,U,2),ONC1=$P(ONCSS,U,3),ONC2=$P(ONCSS,U,4),ONC3=$P(ONCSS,U,5)
	S DIE="^ONCO(160.16,"_DA(1)_",""FIELD"","
	S DR=".01///^S X=ONC01;1///^S X=ONC1;2///^S X=ONC2;3///^S X=ONC3" D ^DIE
	S IEN=IEN+1
	G NUE
	;
DIK1	;delete an entry in file #160.16
	N DIK,DA
	S DA(1)=ONC16016,DA=ONCIEN
	S DIK="^ONCO(160.16,"_DA(1)_",""FIELD""," D ^DIK
	G NUE
	;
RULE	;update RULES node
	;#*^ seperate the message from ien
	;K ^ONCO(150.16,ONC15016,"RULES")  ;clean-up before updating, remove comment when release
	N ONCSS,ONCOLD,ONCRUDA
	S ONCSS=$G(ONCSRDAT(IEN)),ONCOLD=$P(ONCSS,"#*^",1),ONCRUDA=$P(ONCSS,"#*^",2)
	S ^ONCO(160.16,ONC16016,"RULES",ONCOLD)=ONCRUDA
RULES	;
	S IEN=IEN+1
	S ONCSS=$G(ONCSRDAT(IEN)) G:'$D(ONCSS)!(ONCSS="") EXIT
	S ONCOLD=$P(ONCSS,"#*^",1),ONCRUDA=$P(ONCSS,"#*^",2)
	I $D(^ONCO(160.16,ONC16016,"RULES",ONCOLD,0)) S ^ONCO(160.16,ONC16016,"RULES",ONCOLD,0)=^ONCO(160.16,ONC16016,"RULES",ONCOLD,0)_ONCRUDA G RULES
	S ^ONCO(160.16,ONC16016,"RULES",ONCOLD,0)=ONCRUDA
	G RULES
	;
1655	;update or add a new DD in Oncology Primary file, for future use.
	Q
EXIT	;
	Q
