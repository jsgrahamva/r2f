FBCHCO ;AISC/DMK-CONTRACT HOSPITAL OUTPATIENT PAYMENTS ;16MAY90
 ;;3.5;FEE BASIS;;JAN 30, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
EN583 ;entry point for 583
 S FBCHCO=1 D ^FBAACO
Q K FB583,FB7078,FBCHCO,FBCNUM,FBCONT,FBD1,FBLOC,FBPOP,FBPSA,FBSITE,FBVEN,PRC,PRCSI,FBFLG,FBSW,FBTV,PSA,TBN,XCNP,X,Y Q
 ;
PRBT ;entry point for patient reimbursement
 S FBAAPTC="R"
 G FBCHCO
