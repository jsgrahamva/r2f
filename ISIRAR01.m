ISIRAR01 ;ISI/BT RAD Report ;4/5/2016  14:08
 ;;1.0;ISI RAD Report RPCs;**local**;April 5,2016;Build 1
 ;
 QUIT
 ;
 ; ##### Get RAD 'Standard' reports
 ; 
 ; OUTPUT
 ;   ISIOUT       Array contains all of RAD 'Standard' reports
 ;   ISIOUT(1)    = Number of Records or 0^Error Message
 ;   ISIOUT(2..n) = IEN ^ 'Standard' Report Name
 ;
GETSTD(ISIOUT) ;RPC [ISI GET RAD STANDARD REPORTS]
 K ISIOUT
 S ISIOUT(1)=0_U_"No 'Standard' Report found"
 N LST D LIST^DIC(74.1,,"@;.01",,,,,,,,"LST")
 N ID,CNT S (ID,CNT)=0
 F  S ID=$O(LST("DILIST","ID",ID)) Q:'ID  S CNT=CNT+1,ISIOUT(CNT+1)=ID_U_LST("DILIST","ID",ID,.01)
 S:CNT ISIOUT(1)=CNT
 QUIT
