FSCGET ;SLC/STAFF-NOIS Get Call Info ;5/17/98  23:49
 ;;1.1;NOIS;;Sep 06, 1998
 ;
GET(VALUES,CALLNUM,ARRAY) ; from FSCED, FSCFORMB, FSCFORMC, FSCFORMD, FSCFORMS, FSCLMPE1, FSCLP, FSCRPCEC, FSCRPCF, FSCRPCWR, FSCRX
 ; (call number,array) returns array by reference with call info - except for word processing fields
 N ALL,KEY,STAMP,VALUE,WEB,ZERO
 S ALL=$S(VALUES="CUSTOM":0,1:1)
 S ZERO=$G(^FSCD("CALL",+CALLNUM,0)),STAMP=$G(^(120)),KEY=$G(^(1.5)),WEB=$G(^(1.7))
 I ALL!$D(ARRAY("SUBJECT")) S ARRAY("SUBJECT")=$G(^FSCD("CALL",+CALLNUM,1))
 I ALL!$D(ARRAY("DESC")) S ARRAY("DESC")=$S($D(^FSCD("CALL",+CALLNUM,30)):1,1:"")
 I ALL!$D(ARRAY("ACTIONS")) S ARRAY("ACTIONS")=$S($D(^FSCD("CALL",+CALLNUM,50)):1,1:"")
 I ALL!$D(ARRAY("SUM")) S ARRAY("SUM")=$S($D(^FSCD("CALL",+CALLNUM,80)):1,1:"")
 I ALL!$D(ARRAY("STATHIST")) S ARRAY("STATHIST")=$S($D(^FSCD("CALL",+CALLNUM,110)):1,1:"")
 I ALL!$D(ARRAY("DUPHIST")) S ARRAY("DUPHIST")=$S($D(^FSCD("CALL",+CALLNUM,103)):1,1:"")
 I ALL!$D(ARRAY("REF")) S ARRAY("REF")=$P(ZERO,U)
 I ALL!$D(ARRAY("PHONE")) S ARRAY("PHONE")=$P(ZERO,U,7)_U_$P(ZERO,U,7)
 I ALL!$D(ARRAY("HRSTOT")) S ARRAY("HRSTOT")=$P(ZERO,U,13)_U_$P(ZERO,U,13)
 I ALL!$D(ARRAY("STATUS")) S (ARRAY("STATUS"),VALUE)=$P(ZERO,U,2) I VALUE S $P(ARRAY("STATUS"),U,2)=$$VALUE(VALUE,7100,4)
 I ALL!$D(ARRAY("DATEO")) S (ARRAY("DATEO"),VALUE)=$P(ZERO,U,3) I VALUE S $P(ARRAY("DATEO"),U,2)=$$VALUE(VALUE,7100,10)
 I ALL!$D(ARRAY("DATEC")) S (ARRAY("DATEC"),VALUE)=$P(ZERO,U,4) I VALUE S $P(ARRAY("DATEC"),U,2)=$$VALUE(VALUE,7100,82)
 I ALL!$D(ARRAY("SITE")) S (ARRAY("SITE"),VALUE)=$P(ZERO,U,5) I VALUE S $P(ARRAY("SITE"),U,2)=$$VALUE(VALUE,7100,2)
 I ALL!$D(ARRAY("IRM")) S (ARRAY("IRM"),VALUE)=$P(ZERO,U,6) I VALUE S $P(ARRAY("IRM"),U,2)=$$VALUE(VALUE,7100,2.1)
 I ALL!$D(ARRAY("MOD")) S (ARRAY("MOD"),VALUE)=$P(ZERO,U,8) I VALUE S $P(ARRAY("MOD"),U,2)=$$VALUE(VALUE,7100,3)
 I ALL!$D(ARRAY("SPEC")) S (ARRAY("SPEC"),VALUE)=$P(ZERO,U,9) I VALUE S $P(ARRAY("SPEC"),U,2)=$$VALUE(VALUE,7100,5)
 I ALL!$D(ARRAY("PRI")) S (ARRAY("PRI"),VALUE)=$P(ZERO,U,10) I VALUE S $P(ARRAY("PRI"),U,2)=$$VALUE(VALUE,7100,6)
 I ALL!$D(ARRAY("SPECC")) S (ARRAY("SPECC"),VALUE)=$P(ZERO,U,11) I VALUE S $P(ARRAY("SPECC"),U,2)=$$VALUE(VALUE,7100,81)
 I ALL!$D(ARRAY("FUNC")) S (ARRAY("FUNC"),VALUE)=$P(ZERO,U,14) I VALUE S $P(ARRAY("FUNC"),U,2)=$$VALUE(VALUE,7100,8)
 I ALL!$D(ARRAY("TASK")) S (ARRAY("TASK"),VALUE)=$P(ZERO,U,15) I VALUE S $P(ARRAY("TASK"),U,2)=$$VALUE(VALUE,7100,9)
 I ALL!$D(ARRAY("ISC")) S (ARRAY("ISC"),VALUE)=$P(ZERO,U,16) I VALUE S $P(ARRAY("ISC"),U,2)=$$VALUE(VALUE,7100,2.3)
 I ALL!$D(ARRAY("ISCD")) S (ARRAY("ISCD"),VALUE)=$P(ZERO,U,20) I VALUE S $P(ARRAY("ISCD"),U,2)=$$VALUE(VALUE,7100,2.4)
 I ALL!$D(ARRAY("SPECD")) S (ARRAY("SPECD"),VALUE)=$P(ZERO,U,21) I VALUE S $P(ARRAY("SPECD"),U,2)=$$VALUE(VALUE,7100,5.1)
 I ALL!$D(ARRAY("REOPEN")) S (ARRAY("REOPEN"),VALUE)=$P(ZERO,U,22) I VALUE S $P(ARRAY("REOPEN"),U,2)=$$VALUE(VALUE,7100,2.6)
 I ALL!$D(ARRAY("RTDIN")) S (ARRAY("RTDIN"),VALUE)=$P(STAMP,U,16) I VALUE S $P(ARRAY("RTDIN"),U,2)=$$VALUE(VALUE,7100,4.7)
 I ALL!$D(ARRAY("RTDOUT")) S (ARRAY("RTDOUT"),VALUE)=$P(STAMP,U,17) I VALUE S $P(ARRAY("RTDOUT"),U,2)=$$VALUE(VALUE,7100,4.8)
 I ALL!$D(ARRAY("RTDRE")) S (ARRAY("RTDRE"),VALUE)=$P(STAMP,U,18) I VALUE S $P(ARRAY("RTDRE"),U,2)=$$VALUE(VALUE,7100,4.9)
 I ALL!$D(ARRAY("RECD")) S (ARRAY("RECD"),VALUE)=$P(STAMP,U) I VALUE S $P(ARRAY("RECD"),U,2)=$$VALUE(VALUE,7100,120)
 I ALL!$D(ARRAY("PRIMARY")) S (ARRAY("PRIMARY"),VALUE)=$P(STAMP,U,24) I VALUE S $P(ARRAY("PRIMARY"),U,2)=$$VALUE(VALUE,7100,101)
 I ALL!$D(ARRAY("DUP")) S (ARRAY("DUP"),VALUE)=$P(STAMP,U,25) I VALUE S $P(ARRAY("DUP"),U,2)=$$VALUE(VALUE,7100,102)
 I ALL!$D(ARRAY("STATD")) S (ARRAY("STATD"),VALUE)=$P(STAMP,U,2) I VALUE S $P(ARRAY("STATD"),U,2)=$$VALUE(VALUE,7100,121)
 I ALL!$D(ARRAY("CLOSED")) S (ARRAY("CLOSED"),VALUE)=$P(STAMP,U,3) I VALUE S $P(ARRAY("CLOSED"),U,2)=$$VALUE(VALUE,7100,122)
 I ALL!$D(ARRAY("EDITD")) S (ARRAY("EDITD"),VALUE)=$P(STAMP,U,4) I VALUE S $P(ARRAY("EDITD"),U,2)=$$VALUE(VALUE,7100,123)
 I ALL!$D(ARRAY("EDITBY")) S (ARRAY("EDITBY"),VALUE)=$P(STAMP,U,5) I VALUE S $P(ARRAY("EDITBY"),U,2)=$$VALUE(VALUE,7100,124)
 I ALL!$D(ARRAY("PACK")) S (ARRAY("PACK"),VALUE)=$P(STAMP,U,9) I VALUE S $P(ARRAY("PACK"),U,2)=$$VALUE(VALUE,7100,3.1)
 I ALL!$D(ARRAY("ISCP")) S (ARRAY("ISCP"),VALUE)=$P(STAMP,U,10) I VALUE S $P(ARRAY("ISCP"),U,2)=$$VALUE(VALUE,7100,2.55)
 I ALL!$D(ARRAY("DEVSUB")) S (ARRAY("DEVSUB"),VALUE)=$P(STAMP,U,11) I VALUE S $P(ARRAY("DEVSUB"),U,2)=$$VALUE(VALUE,7100,3.2)
 I ALL!$D(ARRAY("LTYPE")) S (ARRAY("LTYPE"),VALUE)=$P(STAMP,U,12) I VALUE S $P(ARRAY("LTYPE"),U,2)=$$VALUE(VALUE,7100,2.7)
 I ALL!$D(ARRAY("SYS")) S (ARRAY("SYS"),VALUE)=$P(STAMP,U,19) I VALUE S $P(ARRAY("SYS"),U,2)=$$VALUE(VALUE,7100,2.9)
 I ALL!$D(ARRAY("PATCH")) S (ARRAY("PATCH"),VALUE)=$P(STAMP,U,14)_U_$P(STAMP,U,14)
 I ALL!$D(ARRAY("VISN")) S (ARRAY("VISN"),VALUE)=$P(STAMP,U,15)_U_$P(STAMP,U,15)
 I ALL!$D(ARRAY("KEYWORDS")) S (ARRAY("KEYWORDS"),VALUE)=$P(KEY,U,1)_U_$P(KEY,U,1)
 I ALL!$D(ARRAY("WEB")) S (ARRAY("WEB"),VALUE)=$P(WEB,U,1)_U_$P(WEB,U,1)
 I ALL!$D(ARRAY("PACKG")) S (ARRAY("PACKG"),VALUE)=$P(STAMP,U,13) I VALUE S $P(ARRAY("PACKG"),U,2)=$$VALUE(VALUE,7100,3.3)
 I ALL!$D(ARRAY("EP")) S (ARRAY("EP"),VALUE)=$P(STAMP,U,20) I VALUE S $P(ARRAY("EP"),U,2)=$$VALUE(VALUE,7100,5.2)
 I ALL!$D(ARRAY("EPT")) S (ARRAY("EPT"),VALUE)=$P(STAMP,U,21) I VALUE S $P(ARRAY("EPT"),U,2)=$$VALUE(VALUE,7100,5.3)
 I ALL!$D(ARRAY("DEVSTAT")) S (ARRAY("DEVSTAT"),VALUE)=$P(ZERO,U,17) I VALUE S $P(ARRAY("DEVSTAT"),U,2)=$$VALUE(VALUE,7100,4.1)
 I ALL!$D(ARRAY("AGE")) S ARRAY("AGE")=$P(ZERO,U,18)_U_$P(ZERO,U,18)
 I ALL!$D(ARRAY("AGEEDIT")) S ARRAY("AGEEDIT")=$P(ZERO,U,19)_U_$P(ZERO,U,19)
 I ALL!$D(ARRAY("AGESTAT")) S ARRAY("AGESTAT")=$P(ZERO,U,23)_U_$P(ZERO,U,23)
 I ALL!$D(ARRAY("PT")) S ARRAY("PT")=$P(STAMP,U,23)_U_$P(STAMP,U,23)
 I ALL!$D(ARRAY("PDT")) S (ARRAY("PDT"),VALUE)=$P(STAMP,U,22) I VALUE S $P(ARRAY("PDT"),U,2)=$$VALUE(VALUE,7100,125)
 D PFIELDS^FSCGETP
 Q
 ;
VALUE(Y,FILE,FIELD) ; $$(internal value,file,field) -> external value or ""
 I 'Y Q ""
 I FILE=7100 Q $$NOISCALL(Y,FIELD)
 N C S C=$P(^DD(FILE,FIELD,0),U,2) D Y^DIQ Q Y
 ;
NOISCALL(Y,FIELD) ; $$(internal value,field) -> external value in 7100
 I FIELD=2 Q $P($G(^FSC("SITE",Y,0)),U)
 I FIELD=2.1 Q $P($G(^VA(200,Y,0)),U)
 I FIELD=2.3 Q $P($G(^FSC("ISC",Y,0)),U)
 I FIELD=2.4 Q $P($G(^FSC("ISC",Y,0)),U)
 I FIELD=2.55 Q $P($G(^FSC("ISC",Y,0)),U)
 I FIELD=2.6 Q $$FMTE^XLFDT(Y)
 I FIELD=2.7 Q $P($G(^FSC("LTYPE",Y,0)),U)
 I FIELD=2.8 Q $P($G(^FSC("VISN",Y,0)),U)
 I FIELD=2.9 Q $P($G(^FSC("SYSTEM",Y,0)),U)
 I FIELD=3 Q $P($G(^FSC("MOD",Y,0)),U)
 I FIELD=3.1 Q $P($G(^FSC("PACK",Y,0)),U)
 I FIELD=3.2 Q $P($G(^FSC("SUB",Y,0)),U)
 I FIELD=3.3 Q $P($G(^FSC("PACKG",Y,0)),U)
 I FIELD=4 Q $P($G(^FSC("STATUS",Y,0)),U)
 I FIELD=4.1 Q $P($G(^FSC("STATUS",Y,0)),U)
 I FIELD=4.5 Q $P($G(^FSC("STATUS",Y,0)),U)
 I FIELD=4.6 Q $P($G(^FSC("STATUS",Y,0)),U)
 I FIELD=4.7 Q $$FMTE^XLFDT(Y)
 I FIELD=4.8 Q $$FMTE^XLFDT(Y)
 I FIELD=4.9 Q $$FMTE^XLFDT(Y)
 I FIELD=5 Q $P($G(^VA(200,Y,0)),U)
 I FIELD=5.1 Q $P($G(^VA(200,Y,0)),U)
 I FIELD=5.2 Q $P($G(^VA(200,Y,0)),U)
 I FIELD=5.3 Q $P($G(^FSC("EPTYPE",Y,0)),U)
 I FIELD=6 Q $P($G(^FSC("PRI",Y,0)),U)
 I FIELD=8 Q $P($G(^FSC("FUNC",Y,0)),U)
 I FIELD=9 Q $P($G(^FSC("TASK",Y,0)),U)
 I FIELD=10 Q $$FMTE^XLFDT(Y)
 I FIELD=81 Q $P($G(^VA(200,Y,0)),U)
 I FIELD=82 Q $$FMTE^XLFDT(Y)
 I FIELD=101 Q $P($G(^FSCD("CALL",Y,0)),U)
 I FIELD=102 Q $P($G(^FSCD("CALL",Y,0)),U)
 I FIELD=120 Q $$FMTE^XLFDT(Y)
 I FIELD=121 Q $$FMTE^XLFDT(Y)
 I FIELD=122 Q $$FMTE^XLFDT(Y)
 I FIELD=123 Q $$FMTE^XLFDT(Y)
 I FIELD=124 Q $P($G(^VA(200,Y,0)),U)
 I FIELD=125 Q $$FMTE^XLFDT(Y)
 Q Y
