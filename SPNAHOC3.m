SPNAHOC3 ;HISC/DAD-AD HOC REPORTS: MACRO MANAGEMENT ;9/9/96  08:42
 ;;2.0;Spinal Cord Dysfunction;;01/02/1997
 ;
 S SPNSELOP=$E(SPNSELOP,2,$L(SPNSELOP))
 S:SPNSELOP?1L SPNSELOP=$C($A(SPNSELOP)-32)
 I "^S^L^I^D^O^"'[(U_SPNSELOP_U) S SPNSELOP=-1 Q
 W $P($P("^Save^Load^Inquire^Delete^Output^",U_SPNSELOP,2),U)
 W $S(SPNSELOP'="O":" "_SPNTYPE(0),1:"")," macro]"
 I $$VFILE^DILFD(154.8)=0 D  Q
 . W $C(7),!!?3,"The Ad Hoc Macro file does not exist !!"
 . S SPNSELOP=0 R SP:SPNDTIME
 . Q
 I SPNSELOP="S" D SETSAVE^SPNAHOC5 Q
 I SPNSELOP="O" D EN1^SPNAHOC4 Q
 D LOAD:SPNSELOP="L"
 D INQUIRE:SPNSELOP="I"
 D DELETE:SPNSELOP="D"
 D UNLOCK(SPND0)
 Q
SAVE ; *** Save macro
 D SAV,UNLOCK(SPND0)
 Q
SAV K DIC,SPNMACRO(SPNTYPE) S DIC(0)="AELMNQZ",DIC("A")="Save"
 D ASKMAC Q:Y'>0
 I $P(Y,U,3)'>0 W $C(7) D  G SAVE:SPNREPLC=2 Q:SPNREPLC=-1
 . F  D  Q:%
 .. W !!?3,SPNTEMP," already exists, OK to replace"
 .. S %=2 D YN^DICN S SPNREPLC=% I '% W !!?5,SPNYESNO
 .. Q
 . Q:%'=1
 . S SPND1=0 F  S SPND1=$O(^SPNL(154.8,SPND0,"FLD",SPND1)) Q:SPND1'>0  D
 .. S (D0,DA(1))=SPND0,(D1,DA)=SPND1,DIK="^SPNL(154.8,"_SPND0_",""FLD"","
 .. D ^DIK
 .. Q
 . Q
 S (SPNFLDNO,SPNORDER,SPNOK)=0
 F  S SPNORDER=$O(SPNOPTN(SPNTYPE,SPNORDER)) Q:(SPNORDER'>0)!(SPNOK<0)  S SPNFIELD=0 F  S SPNFIELD=$O(SPNOPTN(SPNTYPE,SPNORDER,SPNFIELD)) Q:(SPNFIELD'>0)!(SPNOK<0)  D
 . I SPNTYPE="S" F  D  Q:SPNOK
 .. W !!?3,"Ask user BEGINNING/ENDING values for "
 .. W $P(SPNMENU(SPNFIELD),U,2) S %=2 D YN^DICN S SPNOK=%
 .. I 'SPNOK W !!?5,SPNYESNO
 .. Q
 . Q:SPNOK<0
 . S X=SPNPREFX(SPNTYPE,SPNORDER)_SPNFIELD_SPNSUFFX(SPNTYPE,SPNORDER)_U_SPNOPTN(SPNTYPE,SPNORDER,SPNFIELD)_U_$S(SPNTYPE="S":(SPNOK=1),1:"")
 . S ^SPNL(154.8,SPND0,"FLD",SPNORDER,0)=X,SPNFLDNO=SPNFLDNO+1
 . I SPNTYPE="S" S ^SPNL(154.8,SPND0,"FLD",SPNORDER,"FRTO")=$S(SPNOK=2:FR(SPNORDER)_U_TO(SPNORDER),1:U)
 . E  K ^SPNL(154.8,SPND0,"FLD",SPNORDER,"FRTO")
 . Q
 I SPNOK<0 D  Q
 . S DIK="^SPNL(154.8,",DA=SPND0 D ^DIK S SPNMSAVE=0
 . W !!?3,"Sort macro ",SPNTEMP," not saved !! ",$C(7) R SP:SPNDTIME
 . Q
 S $P(^SPNL(154.8,SPND0,0),U,2,4)=$TR(SPNTYPE,"SP","sp")_U_SPNDIC_U_SPNCHKSM
 S ^SPNL(154.8,SPND0,"FLD",0)=U_$$GET1^DID(154.8,1,"","SPECIFIER")_U_SPNFLDNO_U_SPNFLDNO
 S DIK="^SPNL(154.8,",DA=SPND0 D IX1^DIK
 S SPNMACRO(SPNTYPE)=SPNTEMP(SPNTYPE)
 S $P(SPNMACRO(SPNTYPE),U,4)="SAVE"
 Q
LOAD ; *** Load macro
 S SPNMLOAD=0 I SPNSEQ>1 D  Q
 . W !!?3,SPNTYPE(1)," macros may only be loaded at the first "
 . W SPNTYPE(0)," selection prompt !! ",$C(7) R SP:SPNDTIME
 . Q
 K DIC,SPNMACRO(SPNTYPE) S DIC(0)="AEMNQZ",DIC("A")="Load"
 D ASKMAC Q:Y'>0
 S (SPNQUIT,SPNNEXT,SPNORDER)=0,SPNMLOAD=1 K:SPNTYPE="S" FR,TO
 F  S SPNORDER=$O(^SPNL(154.8,SPND0,"FLD",SPNORDER)) Q:SPNORDER'>0!SPNQUIT!SPNNEXT  D
 . S X=^SPNL(154.8,SPND0,"FLD",SPNORDER,0),X("FRTO")=$G(^("FRTO"))
 . S X(1)=$P($P(X,U),";"),SPNFIELD=$TR(X(1),"&!+#-@'")
 . S SP=$G(SPNMENU(+SPNFIELD))
 . I SP=""!((SPNTYPE="S")&(SP'>0)) D  Q
 .. W !!?3,"Corrupted ",SPNTYPE(0)," macro !! ",$C(7)
 .. R SP:SPNDTIME S SPNQUIT=1
 .. Q
 . S SPNOPTN(SPNTYPE,SPNSEQ,SPNFIELD)=$P(X,U,2)
 . I SPNTYPE="S" D
 .. I $P(X,U,3)'>0 D  Q
 ... S FR(SPNSEQ)=$P(X("FRTO"),U),TO(SPNSEQ)=$P(X("FRTO"),U,2)
 ... Q
 .. W !!?3,"Sort by: ",$P(SPNMENU(SPNFIELD),U,2)
 .. S SPNDIR(0)=$P($P(SPNMENU(SPNFIELD),U,4,99),"|")
 .. S SPNDIR("S")=$P(SPNMENU(SPNFIELD),"|",2)
 .. D ^SPNAHOC2
 .. Q
 . S SPNSEQ=SPNSEQ+1
 . Q
 S SPNMACRO(SPNTYPE)=SPNTEMP(SPNTYPE)
 S $P(SPNMACRO(SPNTYPE),U,4)="LOAD"
 I SPNQUIT!SPNNEXT D
 . S (SPNQUIT,SPNNEXT,SPNMLOAD)=0,SPNSEQ=1
 . K SPNCHOSN,SPNMACRO(SPNTYPE),SPNOPTN(SPNTYPE) K:SPNTYPE="S" FR,TO
 . Q
 Q
INQUIRE ; *** Inquire macro
 K DIC S DIC(0)="AEMNQZ",DIC("A")="Inquire" D ASKMAC Q:Y'>0
 S SPNORDER=0,SPNTYP=SPNTYPE,X=SPNTYPE(1)_" macro: "_SPNTEMP
 W !!,X,!,$TR($E(SPNUNDL,1,$L(X)),"_","-")
 S SPND1=0 F  S SPND1=$O(^SPNL(154.8,SPND0,"FLD",SPND1)) Q:SPND1'>0  D
 . S SP=^SPNL(154.8,SPND0,"FLD",SPND1,0),SPN=$G(^("FRTO"))
 . S SPNORDER=SPNORDER+1,X(1)=$P(SP,U),SPNFIELD=$P(X(1),";")
 . S SPNFIELD=$TR(SPNFIELD,"&!+#-@'") S:SPNFIELD'?1.N SPNFIELD=0
 . F SPI=1,2 S X(SPI+1)=$S(SPNTYPE="P":"",$P(SP,U,3):"Ask User",$P(SPN,U,SPI)]"":$P(SPN,U,SPI),SPI=1:"Beginning",1:"Ending")
 . D PRNTFLD^SPNAHOC4
 . Q
 I SPNTYPE="S" D SORTHDR^SPNAHOC4(SPND0)
 I SPNTYPE="P" D PRNTHDR^SPNAHOC4(SPND0)
 R !,SP:(2*SPNDTIME)
 Q
DELETE ; *** Delete macro
 K DIC S DIC(0)="AEMNQZ",DIC("A")="Delete" D ASKMAC Q:Y'>0
 F  D  Q:%
 . W !!?3,"Delete ",SPNTEMP,", are you sure"
 . S %=2 D YN^DICN I '% W !!?5,SPNYESNO
 . Q
 I %=1 S DIK="^SPNL(154.8,",DA=SPND0 D ^DIK K SPNMACRO(SPNTYPE)
 Q
ASKMAC ; *** Prompt for a macro name
 S DIC="^SPNL(154.8,",DLAYGO=154.8
 S DIC("A")="   "_DIC("A")_" "_SPNTYPE(0)_" macro name: "
 S DIC("S")="I $P(^(0),U,2,4)="""
 S DIC("S")=DIC("S")_$TR(SPNTYPE,"SP","sp")_U_SPNDIC_U_SPNCHKSM_""""
 F  D  Q:SPND0
 . W ! D ^DIC S SPND0=+Y Q:SPND0'>0
 . S SPNTEMP=Y(0,0),SPNTEMP(SPNTYPE)=Y
 . L +^SPNL(154.8,SPND0):0 I '$T D  S SPND0=0
 .. W !!?10,"Someone else is currently using this macro !!",$C(7)
 .. Q
 . Q
 Q
UNLOCK(Y) ; *** Unlock macro
 I $G(Y) L -^SPNL(154.8,Y)
 Q
