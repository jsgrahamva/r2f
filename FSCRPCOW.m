FSCRPCOW ;SLC/STAFF-NOIS RPC Other Workload ;1/18/97  21:32
 ;;1.1;NOIS;;Sep 06, 1998
 ;
WKLD(IN,OUT) ; from FSCRPX (RPCCallWorkload)
 N CALL,CNT,DATE,HRS,TOTHRS,USER,WKLD
 S CALL=+$G(^TMP("FSCRPC",$J,"INPUT",1))
 I 'CALL S ^TMP("FSCRPC",$J,"OUTPUT",1)="no information" Q
 S CNT=0
 K ^TMP("FSCWKLD",$J)
 S TOTHRS=+$P(^FSCD("CALL",CALL,0),U,13)
 I 'TOTHRS D
 .S CNT=CNT+1,^TMP("FSCRPC",$J,"OUTPUT",CNT)="No time entries."
 E  D
 .S CNT=CNT+1,^TMP("FSCRPC",$J,"OUTPUT",CNT)="     Total hours: "_TOTHRS
 .S WKLD=0 F  S WKLD=$O(^FSCD("WKLD","B",CALL,WKLD)) Q:WKLD<1  D
 ..S DATE=$P(^FSCD("WKLD",WKLD,0),U,3),HRS=+$P(^(0),U,4),USER=$P(^(0),U,2),USER=$$VALUE^FSCGET(USER,7103.5,1)
 ..I $L(DATE),$L(USER) D
 ...S ^TMP("FSCWKLD",$J,"DU",DATE,USER)=HRS
 ...S ^TMP("FSCWKLD",$J,"UD",USER,DATE)=HRS
 ...S ^(DATE)=$G(^TMP("FSCWKLD",$J,"D",DATE))+HRS
 ...S ^(USER)=$G(^TMP("FSCWKLD",$J,"U",USER))+HRS
 .S CNT=CNT+1,^TMP("FSCRPC",$J,"OUTPUT",CNT)="By Date | Specialist:"
 .S DATE=0 F  S DATE=$O(^TMP("FSCWKLD",$J,"DU",DATE)) Q:DATE<1  D
 ..S CNT=CNT+1,^TMP("FSCWKLD",$J,"OUTPUT",CNT)="     "_$$FMTE^XLFDT(DATE)_"  ("_^TMP("FSCWKLD",$J,"D",DATE)_")"
 ..S USER="" F  S USER=$O(^TMP("FSCWKLD",$J,"DU",DATE,USER)) Q:USER=""  S HRS=^(USER) D
 ...S CNT=CNT+1,^TMP("FSCRPC",$J,"OUTPUT",CNT)="                  "_USER
 ...S ^TMP("FSCRPC",$J,"OUTPUT",CNT)=$$SETSTR^VALM1(HRS,^TMP("FSCRPC",$J,"OUTPUT",CNT),50,$L(HRS))
 .S CNT=CNT+1,^TMP("FSCRPC",$J,"OUTPUT",CNT)="By Specialist | Date:"
 .S USER="" F  S USER=$O(^TMP("FSCWKLD",$J,"UD",USER)) Q:USER=""  D
 ..S CNT=CNT+1,^TMP("FSCRPC",$J,"OUTPUT",CNT)=USER_"  ("_^TMP("FSCWKLD",$J,"U",USER)_")"
 ..S DATE=0 F  S DATE=$O(^TMP("FSCWKLD",$J,"UD",USER,DATE)) Q:DATE<1  S HRS=^(DATE) D
 ...S CNT=CNT+1,^TMP("FSCRPC",$J,"OUTPUT",CNT)="                    "_$$FMTE^XLFDT(DATE)
 ...S ^TMP("FSCRPC",$J,"OUTPUT",CNT)=$$SETSTR^VALM1(HRS,^TMP("FSCRPC",$J,"OUTPUT",CNT),50,$L(HRS))
 K ^TMP("FSCWKLD",$J)
 Q
