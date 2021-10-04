ISIDPT01 ;ISI/BT - RPC for Patient ; 28 Jan 2016 11:35 AM
 ;;1.1;ISI;**local**;;Jan 28, 2016;Build 1
 ;;
 Q
 ;
 ;*****  Given Patient IEN (DFN), get additional info
 ;       
 ; RPC: ISI GET ADDITIONAL INFO
 ; 
 ; Input Parameters
 ; ================
 ; 
 ; [DFN] - Patient IEN
 ; 
 ; Return Values
 ; =============
 ; Global Array : ^TMP($J,"ISI_ADTNL") contains
 ;       (0)= 0^ error message 
 ;                  or
 ;       (0)= 1^ success message
 ;       (1..n)= FIELD NAME^FIELD VALUE
 ;
 ; Example Return Values
 ; =====================
 ; ^TMP($J,"ISI_ADTNL",0) = "0^User's Facility doesn't exist in the database."
 ;
 ; ^TMP($J,"ISI_ADTNL",0) = "1^ok"
 ;                    ,1) = "SSN^123-45-6789"
 ;                    ,2) = "MAILING ADDRESS-STREET^123 Doe St."
 ;                    ,3) = "MAILING ADDRESS-CITY^Stillwater"
 ;                    ,4) = "MAILING ADDRESS-STATE^OK"
 ;                    ,5) = "MAILING ADDRESS-ZIP^77777-1234"
 ;
ADTNL(ISIRSLT,DFN) ; RPC [ISI GET ADDITIONAL INFO]
 S ISIRSLT=$NA(^TMP($J,"ISI_ADTNL")) K @ISIRSLT
 N ER S ER=$$VALID($G(DFN))
 I ER'="" D SETER(ER) QUIT
 ;
 QUIT:'$$PAT(DFN)
 QUIT:'$$LOCADDR
 ;
 S @ISIRSLT@(0)=1_U_"ok"
 QUIT
 ;
SETER(ER) ;set error
 N OUT S OUT=$NA(^TMP($J,"ISI_ADTNL")) K @OUT
 S @OUT@(0)=0_U_ER
 QUIT
 ;
VALID(DFN) ;validate DFN, return message
 QUIT:DFN="" "Patient IEN is required"
 QUIT:'$D(^DPT(DFN,0)) "Patient doesn't exist in the database"
 ;
 N LOC S LOC=$G(DUZ(2))
 QUIT:'LOC "User's Facility doesn't exist"
 QUIT:'$D(^DIC(4,LOC)) "User's Facility doesn't exist in the database"
 QUIT ""
 ;
PAT(DFN) ;get patient info
 N VA,VADM D ^VADPT
 D SETRSLT("SSN",$P(VADM(2),U,2))
 QUIT 1
 ;
LOCADDR() ;get user's facility address
 N ISIOUT,ISIERR
 N FIL S FIL=9999999.06
 N LOC S LOC=$G(DUZ(2))_","
 D GETS^DIQ(FIL,LOC,".14;.15;.16;.17","I","ISIOUT","ISIERR")
 I $D(ISIERR("DIERR",1,"TEXT",1)) D SETER(ISIERR("DIERR",1,"TEXT",1)) QUIT 0
 ;
 D SETRSLT("MAILING ADDRESS-STREET",$G(ISIOUT(FIL,LOC,.14,"I")))
 D SETRSLT("MAILING ADDRESS-CITY",$G(ISIOUT(FIL,LOC,.15,"I")))
 N STATE S STATE=$G(ISIOUT(FIL,LOC,.16,"I"))
 I STATE'="" S STATE=$$GET1^DIQ(5,STATE_",","ABBREVIATION","E")
 D SETRSLT("MAILING ADDRESS-STATE",STATE)
 D SETRSLT("MAILING ADDRESS-ZIP",$G(ISIOUT(FIL,LOC,.17,"I")))
 QUIT 1
 ;
SETRSLT(FLD,VAL) ;save fld, value pair
 N OUT S OUT=$NA(^TMP($J,"ISI_ADTNL"))
 N CNT S CNT=$O(@OUT@(" "),-1)+1
 S @OUT@(CNT)=FLD_U_VAL
 QUIT
