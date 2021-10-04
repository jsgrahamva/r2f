LR7OSMZ4	;DALOI/STAFF - Silent Micro rpt - AFB, FUNGUS ;09/02/10  15:32
	;;5.2;LAB SERVICE;**121,244,350**;Sep 27, 1994;Build 230
	;
	;
TB	; from LR7OSMZ1
	;
	N LRTA,LRX
	;
	S LRX=^LR(LRDFN,"MI",LRIDT,11)
	I $P(LRX,U)="" Q:'$D(LRWRDVEW)  Q:LRSB'=11
	;
	S LRTUS=$P(LRX,U,2),DZ=$P(LRX,U,5),LRAFS=$P(LRX,U,3),LRAMT=$P(LRX,U,4),Y=$P(LRX,U)
	D D^LRU,LINE^LR7OSUM4
	S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"* MYCOBACTERIOLOGY "_$S(LRTUS="F":"FINAL",LRTUS="P":"PRELIMINARY",1:"")_" REPORT => "_Y_"   TECH CODE: "_DZ)
	S LRPRE=23
	D PRE^LR7OSMZU
	;
	S LRTA=""
	I $O(^LR(LRDFN,"MI",LRIDT,12,0)) S LRTA=0
	D:LRAFS'=""!(LRTA=0) AFS
	;
	I $O(^LR(LRDFN,"MI",LRIDT,13,0)) D
	. D LINE^LR7OSUM4,LINE^LR7OSUM4
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Mycobacteriology Remark(s):")
	. S B=0
	. F  S B=+$O(^LR(LRDFN,"MI",LRIDT,13,B)) Q:B<1  S X=^(B,0) D LINE^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(3,CCNT,X)
	;
	Q
	;
	;
AFS	; Acid Fast Stain results
	;
	N LRX,X
	;
	I LRAFS'="" D
	. S LRX="Acid Fast Stain:  "
	. I LRAFS?1(1"DP",1"DN",1"CP",1"CN") D
	. . S LRX=$S($E(LRAFS)="D":"Direct ",$E(LRAFS)="C":"Concentrate ",1:"")_LRX
	. . S LRX=LRX_$S($E(LRAFS,2)="P":"Positive",$E(LRAFS,2)="N":"Negative",1:LRAFS)
	. E  D
	. . S X=$$GET1^DIQ(63.05,LRIDT_","_LRDFN_",",24)
	. . I X'="" S LRX=LRX_X Q
	. . S LRX=LRX_LRAFS
	. D LINE^LR7OSUM4
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,LRX)
	. I LRAMT'="" D
	. . D LINE^LR7OSUM4
	. . S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(3,CCNT,"Quantity: "_LRAMT)
	;
	K ^TMP("LR",$J,"T"),LRTSTS
	;
	I $D(LRTA) D
	. S LRTSTS=0
	. F A=0:1 S LRTA=+$O(^LR(LRDFN,"MI",LRIDT,12,LRTA)) Q:LRTA<1  S (LRBUG(LRTA),LRTBC)=$P(^(LRTA,0),U),LRQU=$P(^(0),U,2),LRTBC=$P(^LAB(61.2,LRTBC,0),U) D LIST
	Q
	;
	;
LIST	;
	N CNT,LRTB,LRTBA,LRTBS
	D LINE^LR7OSUM4,LINE^LR7OSUM4
	S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Mycobacterium: "_LRTBC)
	S:$D(^LR(LRDFN,"MI",LRIDT,12,LRTA,2)) LRTSTS=LRTSTS+1
	I LRQU'="" D LINE^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(3,CCNT,"Quantity: "_LRQU)
	I $D(^LR(LRDFN,"MI",LRIDT,12,LRTA,1,0)) D
	. D LINE^LR7OSUM4
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"   Comment: ")
	. S (CNT,B)=0
	. F  S B=+$O(^LR(LRDFN,"MI",LRIDT,12,LRTA,1,B)) Q:B<1  S X=^(B,0) D
	. . I 'CNT S CNT=1,^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(13,CCNT,X) Q
	. . D LINE^LR7OSUM4
	. . S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(13,CCNT,X)
	. D LINE^LR7OSUM4
	;
SEN	;
	S LRTB=2
	F  S LRTB=+$O(^LR(LRDFN,"MI",LRIDT,12,LRTA,LRTB)) Q:LRTB'["2."!(LRTB="")  D
	. S LRTBS=^LR(LRDFN,"MI",LRIDT,12,LRTA,LRTB)
	. I LRTBS="" Q
	. S LRTBA=""
	. I $D(^LAB(62.06,"AD1",LRTB)) D
	. . S LRX=$O(^LAB(62.06,"AD1",LRTB,0)),LRX(0)=""
	. . I LRX S LRX(0)=$G(^LAB(62.06,LRX,0))
	. . S LRTBA=$P(LRX(0),"^")
	. I LRTBA="" D
	. . S LRTBA=$O(^DD(63.39,"GL",LRTB,1,0))
	. . S LRTBA=$P(^DD(63.39,LRTBA,0),U)
	. S LRTBA=$$LJ^XLFSTR(LRTBA,30,".")
	. D LINE^LR7OSUM4
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(3,CCNT,LRTBA)_$$S^LR7OS(34,CCNT,LRTBS)
	;
	Q
	;
	;
FUNG	;from LR7OSMZ1
	S X=^LR(LRDFN,"MI",LRIDT,8)
	I '$L($P(X,U)) Q:'$D(LRWRDVEW)  Q:LRSB'=8
	S LRTUS=$P(X,U,2),DZ=$P(X,U,3),Y=$P(X,U)
	D D^LRU,LINE^LR7OSUM4
	S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"* MYCOLOGY "_$S(LRTUS="F":"FINAL",LRTUS="P":"PRELIMINARY",1:"")_" REPORT => "_Y_"   TECH CODE: "_DZ)
	S LRPRE=22
	D PRE^LR7OSMZU
	I $D(^LR(LRDFN,"MI",LRIDT,15)) D
	. D LINE^LR7OSUM4
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"MYCOLOGY SMEAR/PREP:")
	. S LRMYC=0
	. F  S LRMYC=+$O(^LR(LRDFN,"MI",LRIDT,15,LRMYC)) Q:LRMYC<1  S X=^(LRMYC,0) D LINE^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(5,CCNT,X)
	;
	I $O(^LR(LRDFN,"MI",LRIDT,9,0)) D
	. D LINE^LR7OSUM4
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Fungus/Yeast: ")
	. D SHOW
	;
	I $O(^LR(LRDFN,"MI",LRIDT,10,0)) D
	. D LINE^LR7OSUM4
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Mycology Remark(s):")
	. S LRMYC=0
	. F  S LRMYC=+$O(^LR(LRDFN,"MI",LRIDT,10,LRMYC)) Q:LRMYC<1  S X=^(LRMYC,0) D LINE^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(3,CCNT,X)
	Q
	;
	;
SHOW	;
	S LRTA=0
	F  S LRTA=+$O(^LR(LRDFN,"MI",LRIDT,9,LRTA)) Q:LRTA<1  D
	. S (LRBUG(LRTA),LRTBC)=$P(^(LRTA,0),U),LRQU=$P(^(0),U,2),LRTBC=$P(^LAB(61.2,LRTBC,0),U)
	. D LIST1
	Q
	;
	;
LIST1	;
	N B,C
	D LINE^LR7OSUM4
	S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,LRTBC)
	I LRQU'="" D
	. D LINE^LR7OSUM4
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(3,CCNT,"Quantity: "_LRQU)
	;
	I $D(^LR(LRDFN,"MI",LRIDT,9,LRTA,1,0)) D
	. D LINE^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(3,CCNT,"Comment:")
	. S (B,C)=0
	. F  S B=+$O(^LR(LRDFN,"MI",LRIDT,9,LRTA,1,B)) Q:B<1  S X=^(B,0) D
	. . I 'C S C=1,^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(13,CCNT,X) Q
	. . D LINE^LR7OSUM4
	. . S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(13,CCNT,X)
	Q