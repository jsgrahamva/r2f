DGRPTX11 ; ;08/22/16
 S X=DG(DQ),DIC=DIE
 S ^DPT("D",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 D AUTOUPD^DGENA2(DA)
