LEXABC2	;ISL/KER - Look-up by Code (part 2) ;04/21/2014
	;;2.0;LEXICON UTILITY;**4,80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^TMP("LEXFND"       SACC 2.3.2.5.1
	;    ^TMP("LEXL"         SACC 2.3.2.5.1
	;    ^TMP("LEXSCH"       SACC 2.3.2.5.1
	;               
	; External References
	;    None
	;               
REO	; Reorder list
	Q:'$D(^TMP("LEXL",$J))  N LEXS,LEXT,LEXP,LEXE,LEXEX,LEXFT,LEXM,LEXX S LEXS="" F  S LEXS=$O(^TMP("LEXL",$J,LEXS)) Q:LEXS=""  S LEXT=0 F  S LEXT=$O(^TMP("LEXL",$J,LEXS,LEXT)) Q:+LEXT=0  D
	. S LEXP=0 F  S LEXP=$O(^TMP("LEXL",$J,LEXS,LEXT,LEXP)) Q:+LEXP=0  S LEXE=0 F  S LEXE=$O(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE)) Q:+LEXE=0  D
	. . Q:LEXP=3
	. . I LEXP=1 D MC Q
	. . I LEXP=4,$G(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE))["ICD" D SP Q
	. . D OT
	Q
MC	; Major concept
	S LEXM=$P(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE),"^",1),LEXFT="A"
	S ^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXFT,LEXE)=^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE)
	K ^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE)
	Q
SP	; Joint term/code
	N LEXS2,LEXT2,LEXP2,LEXF2,LEXE2,LEXEX,LEXFT,LEXM,LEXF
	N LEXX,LEXTM,LEXTE,LEXHM,LEXHE,LEXHD,LEXOK
	S LEXOK=0,LEXS2="" F  S LEXS2=$O(^TMP("LEXL",$J,LEXS2)) Q:LEXS2=""!(LEXOK)  S LEXT2=0 F  S LEXT2=$O(^TMP("LEXL",$J,LEXS2,LEXT2)) Q:+LEXT2=0!(LEXOK)  D
	. S LEXP2=0 F  S LEXP2=$O(^TMP("LEXL",$J,LEXS2,LEXT2,LEXP2)) Q:+LEXP2=0!(LEXOK)  S LEXF=99999999999  F  S LEXF=$O(^TMP("LEXL",$J,LEXS2,LEXT2,LEXP2,LEXF)) Q:LEXF=""!(LEXOK)  D
	. . S LEXE2=0 F  S LEXE2=$O(^TMP("LEXL",$J,LEXS2,LEXT2,LEXP2,LEXF,LEXE2)) Q:+LEXE2=0!(LEXOK)  D
	. . . S LEXTM=$P(^TMP("LEXL",$J,LEXS2,LEXT2,LEXP2,LEXF,LEXE2),"^",1)
	. . . S LEXTE=$P(^TMP("LEXL",$J,LEXS2,LEXT2,LEXP2,LEXF,LEXE2),"^",2)
	. . . S LEXHM=$P(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE),"^",1)
	. . . S LEXHE=$P(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE),"^",2)
	. . . S LEXHD=$P(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE),"^",4)
	. . . I LEXTM=LEXHM,LEXTE=LEXHE S $P(^TMP("LEXL",$J,LEXS2,LEXT2,LEXP2,LEXF,LEXE2),"^",4)=LEXHD K ^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE) S LEXOK=1 Q
	I 'LEXOK D OT
	Q
OT	; Other than Major Concept
	S:LEXP>1 LEXX=$P(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE),"^",1)
	S LEXFT=$P(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE),"^",5)
	; Primary --> <major concept>=<primary concept>
	I +($G(LEXM))=+($G(LEXX)) D  Q
	. S:LEXFT="" LEXFT="B"
	. S:$P(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE),"^",6)="Other:    " $P(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE),"^",6)="Synonym: ",LEXFT="B"
	. S ^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXFT,LEXE)=^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE) K ^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE)
	Q:+($G(LEXM))=+($G(LEXX))
	; Other --> <major concept>'=<primary concept>
	S LEXFT="F"
	S $P(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE),"^",7)=$P(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE),"^",6)
	S $P(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE),"^",6)="Other:    "
	S ^TMP("LEXL",$J,LEXS,LEXT,3,LEXFT,LEXE)=^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE)
	K ^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXE)
	Q
SCH(LEXX)	; $Orderable variable
	S LEXX=$E(LEXX,1,($L(LEXX)-1))_$C($A($E(LEXX,$L(LEXX)))-1)_"~" Q LEXX
ADD	; Add codes expressions to the selection list
	;
	; Use local array LEXL
	;
	;   S ^TMP("LEXL",$J,<Code>,<Type>,<Preference>,<Form>,<IEN>)=
	;  <IEN 757>^<IEN 757.01>^<Description>^<Display>^<Form Type>^<Form>
	;
	N LEXS,LEXT,LEXP,LEXFT,LEXSIEN,LEXPM,LEXEXA
	S LEXS="" F  S LEXS=$O(^TMP("LEXL",$J,LEXS)) Q:LEXS=""  D
	. S LEXT=0 F  S LEXT=$O(^TMP("LEXL",$J,LEXS,LEXT)) Q:+LEXT=0  D
	. . S (LEXP,LEXPM)=0 F  S LEXP=$O(^TMP("LEXL",$J,LEXS,LEXT,LEXP)) Q:+LEXP=0  D
	. . . S LEXFT="" F  S LEXFT=$O(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXFT)) Q:LEXFT=""  D
	. . . . S LEXSIEN=0 F  S LEXSIEN=$O(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXFT,LEXSIEN)) Q:+LEXSIEN=0  D SAVE
	Q
SAVE	; Save in ^TMP
	N LEXMI,LEXEI,LEXDF,LEXDS,LEXFM,LEXTP,LEXPX,LEXSX,LEXFQ,LEXSTR,LEXTMP
	S LEXSTR="",LEXTMP=$G(^TMP("LEXL",$J,LEXS,LEXT,LEXP,LEXFT,LEXSIEN)),LEXMI=$P(LEXTMP,"^",1),LEXEI=$P(LEXTMP,"^",2),LEXDF=$P(LEXTMP,"^",3)
	S LEXDS=$P(LEXTMP,"^",4),LEXFM=$P(LEXTMP,"^",4),LEXTP=$P(LEXTMP,"^",6),(LEXSX,LEXPX)="" S:LEXP=1 LEXPM=LEXMI
	; Remove the following line of code if Mental Health either begins to use ICD-10 or DSM-V
	Q:$D(LEXEXA(+LEXEI))  S LEXEXA(+LEXEI)=""
	; Prefix
	I LEXP>1 S LEXPX=LEXTP S:LEXPX["Concept" LEXPX="Synonym:  " S:LEXPX="" LEXPX="Other:    "
	; Suffix
	I LEXP>1 S LEXSX="" S:LEXPX["Other:" LEXSX="classified as" S:LEXPX="" LEXSX="classified as",LEXPX="Other:    "
	; Display
	S:$L(LEXSX)&($G(LEXSO2)["+") LEXDS=LEXSX_" "_LEXDS S:$L(LEXDS) LEXDS="("_LEXDS_")"
	; String
	S LEXSTR=$$TERM(LEXEI) S:$L(LEXDF) LEXSTR=LEXSTR_" "_LEXDF S:$L(LEXDS) LEXSTR=LEXSTR_" "_LEXDS S:$L(LEXPX) LEXSTR=LEXPX_LEXSTR S:LEXP>1 LEXSTR="  "_LEXSTR
	; ^TMP("LEXFND",$J,FQ,IEN)
	S LEXFQ=$G(^TMP("LEXFND",$J,0)) S:+LEXFQ=0 LEXFQ=-999999 S LEXFQ=LEXFQ+1
	S:'$D(^TMP("LEXFND",$J,-LEXFQ,LEXEI)) ^TMP("LEXSCH",$J,"NUM",0)=$G(^TMP("LEXSCH",$J,"NUM",0))+1
	S ^TMP("LEXFND",$J,LEXFQ,LEXEI)=LEXSTR,^TMP("LEXFND",$J,0)=LEXFQ,LEX=$G(^TMP("LEXSCH",$J,"NUM",0))
	Q
TERM(LEXX)	; Get expression
	Q $G(^LEX(757.01,+($G(LEXX)),0))
