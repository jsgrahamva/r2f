LRMIAU2	;DALISC/RBN - AUDIT/ALERT BANNER GENERATOR ;03/07/12  16:25
	;;5.2;LAB SERVICE;**350**;Sep 27, 1994;Build 230
	;
	Q
	;
BANNER(LRABORT,LRPGDATA)	;
	; Displays the MI Audit Trail edit banner history
	N LR63539,X,HDRSHO
	N LRIEN,LRIENS,LRMSG,DIERR
	S LRABORT=$G(LRABORT)
	S HDRSHO=0
	;
	S LR63539=0
	F  S LR63539=$O(^LR(LRDFN,"MI",LRIDT,32,LR63539)) Q:'LR63539  D  Q:LRABORT  ;
	. ; first record?
	. I $$WILLSHO(LRDFN,LRIDT,LR63539) D  ;
	. . I 'HDRSHO D  ;
	. . . S X="*  *  *  Start Audit Log  *  *  *"
	. . . W !,$$CJ^XLFSTR(X,IOM)
	. . . S HDRSHO=1
	. . ;
	. . D NP Q:LRABORT
	. . D SHOW(LRDFN,LRIDT,LR63539,.LRPGDATA,.LRABORT)
	. Q:LRABORT
	. ;
	. ; last record?
	. I LR63539=$O(^LR(LRDFN,"MI",LRIDT,32," "),-1) D  ;
	. . Q:'HDRSHO
	. . D NP Q:LRABORT
	. . S X="*  *  *  End Audit Log  *  *  *"
	. . W !,$$CJ^XLFSTR(X,IOM)
	. . D NP
	. ;
	Q
	;
WILLSHO(LRDFN,LRIDT,R32)	;
	; Does this record qualify?
	N STATUS,DATA
	S STATUS=1
	S DATA=^LR(LRDFN,"MI",LRIDT,32,R32,0)
	I $P(DATA,U,4)=1 S STATUS=0 ;TYPE=ROUTINE EDIT
	Q STATUS
	;
SHOW(LRDFN,LRIDT,LR63539,LRPGDATA,LRABORT)	;
	; Displays a particular audit trail entry
	;
	N DATE,TECH,JUST,FAC,TEST,TYPE,SUBSCR,APPROV
	N LRIEN,DIERR,LRDATA,LRMSG,D63539
	S LR63539=$G(LR63539)
	S LRABORT=$G(LRABORT)
	S LRIEN=LR63539_","_LRIDT_","_LRDFN_","
	S ACCN=$P(^LR(LRDFN,"MI",LRIDT,0),U,6)
	D GETS^DIQ(63.539,LRIEN,".01;1;2;3;4;6;7;14;","EI","LRDATA","LRMSG")
	M D63539=LRDATA(63.539,LRIEN)
	K LRDATA
	S DATE=$G(D63539(1,"E"))
	S TECH=$G(D63539(2,"E"))
	S JUST=$G(D63539(4,"E"))
	S FAC=$G(D63539(7,"E"))
	S TEST=$G(D63539(14,"E"))
	S TYPE=$G(D63539(3,"E"))
	S SUBSCR=$G(D63539(6,"I"))
	I TYPE="" S TYPE="TEST NOT COMPLETED"
	I $$UP^XLFSTR(TYPE)["ROUTINE" Q
	S APPROV=1
	I "^1^5^8^11^16^"[("^"_SUBSCR_"^") D  ;
	. S X=$G(^LR(LRDFN,"MI",LRIDT,SUBSCR))
	. I '$P(X,U,1) S APPROV=0
	;
	D NP Q:LRABORT
	S X="  This report has been revised  "
	S X=$$CJ^XLFSTR(X,IOM,"*")
	W !,X
	D NP Q:LRABORT
	W !,"           Test: "_TEST_"           "_ACCN
	D NP Q:LRABORT
	W !,"     Revised by: "_TECH_" on "_DATE_" at "_FAC
	D NP Q:LRABORT
	W !,"  Revision type: "_TYPE
	D NP Q:LRABORT
	W !,"  Justification: "_JUST
	D NP Q:LRABORT
	;
	I 'APPROV D  Q:LRABORT  ;
	. W !,"     **** THIS REPORT HAS NOT BEEN REAPPROVED/REVALIDATED ****"
	. D NP Q:LRABORT
	;
	Q
	;
NP	;
	; Convenience method
	D NP^LRMIPSZ1
	Q
