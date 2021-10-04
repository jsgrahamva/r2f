ORY2212 ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*221) ;AUG 30,2005 at 11:41
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**221**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;  Record Utilities
 Q
 ;
ADDREC(OCXCREF) ;
 ;
 N QUIT,OCXDD,OCXDA,OCXGREF,OCXNAME
 S OCXDD=$O(@OCXCREF@("")) Q:'OCXDD 0
 S OCXNAME=$G(@OCXCREF@(OCXDD,.01,"E"))
 ;
 W "   record missing..."
 I (OCXFLAG["D") Q 0
 ;
 S OCXDA=0 D CREATE(OCXCREF,OCXDD,.OCXDA,0)
 S:$L(OCXNAME) ^TMP("OCXRULE",$J,"A",+OCXDD,OCXNAME)=""
 ;
 Q 0
 ;
CREATE(OCXCREF,OCXDD,OCXDA,OCXLVL) ;
 ;
 N OCXFLD,OCXGREF,OCXKEY
 ;
 I $L(OCXDA),'(OCXDA=+OCXDA) W !!,"Unresolved subscript." Q
 ;
 S OCXKEY=@OCXCREF@(OCXDD,.01,"E")
 S OCXGREF=$$GETREF(+OCXDD,.OCXDA,OCXLVL) Q:'$L(OCXGREF)
 I 'OCXDA D
 .S OCXDA=$O(^TMP("OCXRULE",$J,"B",+OCXDD,OCXKEY,0)) Q:OCXDA
 .S OCXDA=$O(@(OCXGREF_""" "")"),-1)+1
 .F OCXDA=OCXDA:1 Q:'$D(@(OCXGREF_OCXDA_",0)"))
 .I $D(@(OCXGREF_OCXDA_",0)")) S OCXDA=0
 ;
 I 'OCXDA W !!,"Error adding record..." Q
 ;
 I '$D(@(OCXGREF_"0)")) S @(OCXGREF_"0)")=U_$$FILEHDR^OCXSENDD(+OCXDD)_U_U
 ;
 S OCXFLD=0 F  S OCXFLD=$O(@OCXCREF@(OCXDD,OCXFLD)) Q:'OCXFLD  Q:(OCXFLD[":")  I '$$EXFLD^ORY2211(+OCXDD,OCXFLD) D
 .I $L($G(@OCXCREF@(OCXDD,OCXFLD,"E"))) D DIE(OCXDD,OCXGREF,OCXFLD,@OCXCREF@(OCXDD,OCXFLD,"E"),.OCXDA,OCXLVL)
 .I $O(@OCXCREF@(OCXDD,OCXFLD,0)) D WORD(OCXDD,OCXGREF,OCXFLD,.OCXDA,OCXCREF)
 ;
 D PUSH(.OCXDA)
 S OCXFLD="" F  S OCXFLD=$O(@OCXCREF@(OCXDD,OCXFLD)) Q:'$L(OCXFLD)  I (OCXFLD[":") D
 .S OCXDA=$P(OCXFLD,":",2) W ! D CREATE($$APPEND(OCXCREF,OCXDD),OCXFLD,.OCXDA,OCXLVL+1)
 D POP(.OCXDA)
 Q
 ;
LOADWORD(RREF,OCXDD,OCXFLD,OCXSUB) ;
 ;
 N QUIT,DDPATH,INDEX,OCXDA,OCXGREF
 S DDPATH=$P($P($$APPEND(RREF,OCXDD),"(",2),")",1)
 F INDEX=1:1:$L(DDPATH,",") S OCXDA($L(DDPATH,",")-INDEX)=+$P($P(DDPATH,",",INDEX),":",2)
 S OCXDA=$G(OCXDA(0)) K OCXDA(0)
 Q:(OCXFLAG["D") 0
 I (OCXFLAG["A") S QUIT=$$READ("Y"," Do you want to reload the local '"_$$FIELD^OCXSENDD(+OCXDD,+OCXFLD,"LABEL")_"' field ?","YES") Q:'QUIT (QUIT[U)
 S OCXGREF=$$GETREF(+OCXDD,.OCXDA,$L(DDPATH,",")-1) Q:'$L(OCXGREF)
 D WORD(OCXDD,OCXGREF,OCXFLD,.OCXDA,RREF)
 Q 0
 ;
GETREF(OCXDD,OCXDA,OCXLVL) ;
 ;
 Q:'OCXDD ""
 ;
 N OCXIENS,OCXERR,OCXX
 S OCXIENS=$$IENS^DILF(.OCXDA),OCXERR=""
 S OCXX=$$ROOT^DILFD(OCXDD,OCXIENS,0,OCXERR)
 Q OCXX
 ;
WORD(DD,GREF,FLD,DA,RREF) ;
 ;
 N SUB,GLROOT,LINE
 S SUB=$P($$FIELD^OCXSENDD(+DD,FLD,"GLOBAL SUBSCRIPT LOCATION"),";",1) S:'(SUB=+SUB) SUB=""""_SUB_""""
 S GLROOT=GREF_DA_","_SUB_")" K @GLROOT
 S LINE=0 F  S LINE=$O(@RREF@(DD,FLD,LINE)) Q:'LINE  D
 .S @GLROOT@($O(@GLROOT@(""),-1)+1,0)=@RREF@(DD,FLD,LINE)
 S LINE=$O(@GLROOT@(""),-1),@GLROOT@(0)=U_U_LINE_U_LINE_U_$$DATE("T")_U
 ;
 Q
 ;
DATE(X) N %DT,Y S %DT="" D ^%DT Q +Y
 ;
DIE(OCXDD,OCXDIC,OCXFLD,OCXVAL,OCXDA,OCXLVL) ;
 ;
 N DIC,DIE,X,Y,DR,DA,OCXDVAL,OCXPTR,OCXGREF,D0,OCXSCR
 S (D0,DA)=OCXDA,(DIC,DIE)=OCXDIC,DR=""
 S:OCXLVL D0=OCXDA(1),DR="S DA(1)="_(+D0)_",D0="_(+D0)_";"
 S:OCXVAL="?" OCXVAL="? " S DR=DR_OCXFLD_"///^S X=OCXVAL"
 I '(OCXVAL="@") W !,?(OCXLVL*5),$$FIELD^OCXSENDD(+OCXDD,OCXFLD,"LABEL"),": ",OCXVAL
 ;
 I '(OCXVAL="@") D
 .N OCXIEN,SHORT
 .S OCXPTR=+$P($$FIELD^OCXSENDD(+OCXDD,OCXFLD,"SPECIFIER"),"P",2)
 .Q:'OCXPTR
 .S OCXGREF="^"_$$FIELD^OCXSENDD(+OCXDD,OCXFLD,"POINTER")
 .I '($E(OCXGREF,1,4)="^OCX"),'(OCXGREF="^ORD(100.9,"),'(OCXGREF="^ORD(100.8,") Q
 .Q:$$DIC(OCXGREF,OCXVAL,0)
 .S OCXIEN=$$DIC(OCXGREF,OCXVAL,1)
 .S ^TMP("OCXRULE",$J,"B",OCXPTR,OCXVAL,OCXIEN)=""
 ;
 S OCXSCR=1
 D ^DIE
 ;
 ; I $D(Y) -> DIE FILER ERROR
 I $D(Y) W "   ^DIE filer data error..." S OCXDIER=$G(OCXDIER)+1
 I '$D(Y) W "    ...Correct data Filed"
 ;
 Q
 ;
DIC(DIC,X,OCXADD) N OCXSCR S DIC(0)="",OCXSCR=1 S:OCXADD DIC(0)="L" D ^DIC Q:(+Y>0) +Y Q 0
 ;
PUSH(OCXDA) ;
 N OCXSUB S OCXSUB="" F  S OCXSUB=$O(OCXDA(OCXSUB),-1) Q:'OCXSUB  S OCXDA(OCXSUB+1)=OCXDA(OCXSUB)
 S OCXDA(1)=OCXDA,OCXDA=0
 Q
 ;
POP(OCXDA) ;
 N OCXSUB S OCXSUB="" F  S OCXSUB=$O(OCXDA(OCXSUB)) Q:'OCXSUB  S OCXDA(OCXSUB)=$G(OCXDA(OCXSUB+1))
 S OCXDA=OCXDA(1) K OCXDA($O(OCXDA(""),-1))
 Q
 ;
APPEND(ARRAY,OCXSUB) ;
 S:'(OCXSUB=+OCXSUB) OCXSUB=""""_OCXSUB_""""
 Q:'(ARRAY["(") ARRAY_"("_OCXSUB_")"
 Q $E(ARRAY,1,$L(ARRAY)-1)_","_OCXSUB_")"
 ;
READ(OCXZ0,OCXZA,OCXZB,OCXZL) ;
 N OCXLINE,DIR,DTOUT,DUOUT,DIRUT,DIROUT
 Q:'$L($G(OCXZ0)) U
 S DIR(0)=OCXZ0
 S:$L($G(OCXZA)) DIR("A")=OCXZA
 S:$L($G(OCXZB)) DIR("B")=OCXZB
 F OCXLINE=1:1:($G(OCXZL)-1) W !
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) Q U
 Q Y
 ;
PAUSE() W "  Press Enter " R X:DTIME W ! Q (X[U)
 ;
