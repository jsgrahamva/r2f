LEX2073A	;ISL/KER - LEX*2.0*73 Post Install - Fixes ;01/03/2011
	;;2.0;LEXICON UTILITY;**73**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^DIC(81.3
	;               
	; External References
	;    ^DIK                ICR  10013
	;    IX1^DIK             ICR  10013
	;    IX2^DIK             ICR  10013
	;    $$FMTE^XLFDT        ICR  10103
	;    BMES^XPDUTL         ICR  10141
	;    MES^XPDUTL          ICR  10141
	;    
	;    351846    Wrong Diagnosis in CPRS (PSPO #1575)
	;    395459    Help Text added to retrieve correct description for 477.9
	;    408418    Still's Disease, Adult-Onset re-coded to 714.2
	;    410604    ICD Code 733.6 for Costochondritis
	;    412442    CPT range expanded to use Modifier G1-G6/V8-V9 with 90999
	;    418654    CPT range expanded to use AI Modifier with 99304/5/6
	;    423394    Spelling corrected for Arrhythmia
	;    423417    Cardiomyopathy, Ischemic re-coded as 414.8
	;    424248    Seizure Disorder re-coded as 345.90
	;    432728    GT/GQ Modifiers with G0270/97802/97803
	;    449242    CPT range expanded to use Modifier 50 with 60260
	;    449810    LT/RT/50 Modifiers with 32422
	;    
	Q
POST	; LEX*2.0*73 Post-Install
	N LEXCT,DA,DIK,LEXEX,LEXIEN,LEXMOD,LEXNOD,LEXRIEN,LEXSAB,LEXTXT,X,Y
	D F1,F2,REM,T38
	Q
REM	; Remedy Tickets
	D BM(" Remedy Tickets"),M(" ") D R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12
	Q
T38	; Title 38 Update
	D EN^LEX2073B
	Q
F1	;   Fix 1   AVA Cross-Reference
	D BM(" Fixing AVA cross-reference to include SNOMED CT and BI-RADS") W ! N LEXCT,DA,DIK,LEXEX,LEXIEN,LEXSAB,X
	S LEXEX="N LEXSAB S LEXSAB=$E(^LEX(757.03,X,0),1,3) S:""^ICD^10D^ICP^10P^CPT^CPC^BIR^DS4^NAN^HHC^NIC^SNM^OMA^SCC^SCT^""[LEXSAB ^LEX(757.02,""AVA"",($P(^LEX(757.02,DA,0),U,2)_"" ""),$P(^LEX(757.02,DA,0),U),LEXSAB,DA)="""""
	S (LEXCT,LEXIEN)=0 F  S LEXIEN=$O(^LEX(757.02,"ASRC","SCT",LEXIEN)) Q:+LEXIEN'>0  D
	. N X,DA,LEXSAB S DA=LEXIEN,X=$P($G(^LEX(757.02,+DA,0)),"^",3) Q:+X'=56  X LEXEX S LEXCT=LEXCT+1 I LEXCT>5705 W ?4,"." S LEXCT=0
	S (LEXCT,LEXIEN)=0 F  S LEXIEN=$O(^LEX(757.02,"ASRC","BIR",LEXIEN)) Q:+LEXIEN'>0  D
	. N X,DA,LEXSAB S DA=LEXIEN,X=$P($G(^LEX(757.02,+DA,0)),"^",3) Q:+X'=57  X LEXEX S LEXCT=LEXCT+1 I LEXCT>5705 W ?4,"." S LEXCT=0
	Q
F2	; Multiple active preferred terms 238.4
	N DA,DIC,DIK,LEXTXT,LEXMOD S LEXTXT=" Fixing multiple active preferred terms for ICD Code 238.4" D BM(LEXTXT)
	S DA=326024,DIK="^LEX(757.02," D IX2^DIK S ^LEX(757.02,326024,0)="304816^238.4^1^180725^1^^0" K ^LEX(757.02,"ACODE","238.4 ",326024)
	K ^LEX(757.02,"ACT","238.4 ",1,3031001,326024,1),^LEX(757.02,"ACT","238.4 ",3,3031001,326024,1),^LEX(757.02,"AMC",180725,326024)
	K ^LEX(757.02,"APCODE","238.4 ",326024),^LEX(757.02,"ASRC","ICD",326024),^LEX(757.02,"AVA","238.4 ",304816,"ICD",326024)
	K ^LEX(757.02,"B",304816,326024),^LEX(757.02,"CODE","238.4 ",326024) S DA=326024,DIK="^LEX(757.02," D IX1^DIK
	Q
R1	;   Remedy 1   HD0000000351846 - Wrong DX in CPRS (PSPO #1575)
	N LEXTXT S LEXTXT=$T(QMH^LEXAR3) Q:'$L(LEXTXT)
	S LEXTXT="351846",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"Wrong Diagnosis in CPRS (PSPO #1575)" D M(("     "_LEXTXT))
	Q
R2	;   Remedy 2   HD0000000395459 - Incorrect Description - 477.9
	N LEXTXT S LEXTXT=$T(QMH^LEXAR3) Q:'$L(LEXTXT)
	S LEXTXT="395459",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"Incorrect Description for 477.9" D M(("     "_LEXTXT))
	Q
R3	;   Remedy 3   HD0000000408418 - Still's Disease AO - 714.2
	N DA,DIC,DIK,LEXTXT
	S LEXTXT="408418",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"Still's Disease, Adult-Onset - 714.2" D M(("     "_LEXTXT))
	 S DA=270091,DIK="^LEX(757.02," D ^DIK S ^LEX(757.02,DA,0)="185264^714.2^1^63352^0^^1"
	S ^LEX(757.02,DA,4,0)="^757.28D^1^1",^LEX(757.02,DA,4,1,0)="2781001^1",DIK="^LEX(757.02," D IX1^DIK
	Q
R4	;   Remedy 4  HD0000000410604 - ICD Code 733.6 for Costochondritis
	N DA,DIC,DIK,LEXTXT,LEXMOD S LEXTXT="410604",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"ICD Code 733.6 for Costochondritis" D M(("     "_LEXTXT))
	S DA=30644,DIK="^LEX(757.02," D IX2^DIK S ^LEX(757.02,30644,0)="28852^733.6^1^6038^0^^0" S DA=30644,DIK="^LEX(757.02," D IX1^DIK
	Q
R5	;   Remedy 5   HD0000000412442 - Modifier G1-G6/V8-V9 with 90999
	N DA,DIC,DIK,LEXTXT,LEXMOD S LEXTXT="412442",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"Modifier G1-G6/V8-V9 with 90999" D M(("     "_LEXTXT))
	F LEXMOD="G1","G2","G3","G4","G5","G6" D
	. N LEXIEN,LEXRIEN,DA,DIK,LEXNOD S LEXIEN=$O(^DIC(81.3,"BA",(LEXMOD_" "),0)) Q:+LEXIEN'>0  S LEXRIEN=$O(^DIC(81.3,+LEXIEN,10,"B",90918,0)) Q:+LEXRIEN'>0
	. S LEXNOD=$G(^DIC(81.3,+LEXIEN,10,+LEXRIEN,0)) Q:$P(LEXNOD,"^",1)'=90918  Q:$P(LEXNOD,"^",2)'?5N  S $P(LEXNOD,"^",2)=90999
	. S DA(1)=LEXIEN,DA=LEXRIEN,DIK="^DIC(81.3,"_DA(1)_",10," D IX2^DIK S ^DIC(81.3,+LEXIEN,10,+LEXRIEN,0)=LEXNOD
	. S DA(1)=LEXIEN,DA=LEXRIEN,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	F LEXMOD="V8","V9" D
	. N LEXIEN,LEXRIEN,DA,DIK,LEXNOD S LEXIEN=$O(^DIC(81.3,"BA",(LEXMOD_" "),0)) Q:+LEXIEN'>0  S LEXRIEN=$O(^DIC(81.3,+LEXIEN,10,"B",90918,0))
	. S:LEXRIEN'>0 LEXRIEN=+($O(^DIC(81.3,+LEXIEN,10," "),-1))+1 S LEXNOD=90918_"^"_90999_"^"_2990101_"^"
	. S DA(1)=LEXIEN,DA=LEXRIEN,DIK="^DIC(81.3,"_DA(1)_",10," D IX2^DIK S ^DIC(81.3,+LEXIEN,10,+LEXRIEN,0)=LEXNOD
	. S DA(1)=LEXIEN,DA=LEXRIEN,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	Q
R6	;   Remedy 6   HD0000000418654 - AI Modifier for 99304/99305/99306
	N DA,DIC,DIK,LEXTXT,LEXMOD S LEXTXT="418654",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"Modifier AI with 99304/5/6" D M(("     "_LEXTXT))
	N LEXMIEN,LEXRIEN,DA,DIK S LEXMIEN=668,LEXRIEN=$O(^DIC(81.3,LEXMIEN,10,"B",99304,0))
	S:+LEXRIEN'>0 LEXRIEN=3 S DA(1)=LEXMIEN,DA=LEXRIEN,DIK="^DIC(81.3,"_DA(1)_",10," D IX2^DIK
	S ^DIC(81.3,LEXMIEN,10,LEXRIEN,0)="99304^99306^3100101^" S DA(1)=LEXMIEN,DA=LEXRIEN,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	Q
R7	;   Remedy 7   HD0000000423394 - Two Spellings for Arrhythmia
	N LEXTXT,LEXMOD S LEXTXT="423394",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"Two Spellings for Arrhythmia" D M(("     "_LEXTXT))
	N DA,DIC,DIK,LEXEXC,LEXNEW,LEXOLD,LEXUP,LEXLO,LEXMX,LEXMIEN,LEXEIEN,LEXSIEN,LEXREP,LEXWIT
	S LEXWIT="Arrhythmia",LEXREP="Arrythmia",LEXUP=$$UP(LEXREP),LEXLO=$$LO(LEXREP),LEXMX=$$MX(LEXREP)
	S LEXMIEN=0 F  S LEXMIEN=$O(^LEX(757.01,"AWRD",LEXUP,LEXMIEN)) Q:+LEXMIEN'>0  D
	. S LEXEIEN=0 F  S LEXEIEN=$O(^LEX(757.01,"AWRD",LEXUP,LEXMIEN,LEXEIEN)) Q:+LEXEIEN'>0  D
	. . N LEXNEW,LEXOLD,LEXEXC,LEXSIEN S (LEXNEW,LEXOLD)=$G(^LEX(757.01,+LEXEIEN,0))
	. . F LEXEXC=LEXUP,LEXLO,LEXMX D  Q:LEXNEW'=LEXOLD
	. . . Q:LEXOLD'[LEXEXC
	. . . S LEXNEW=$P(LEXOLD,LEXEXC,1)_LEXWIT_$P(LEXOLD,LEXEXC,2.299)
	. . S LEXSIEN=$O(^LEX(757.01,"B",LEXNEW,0)) K ^LEX(757.01,+LEXEIEN,5)
	. . S:+LEXSIEN'>0 LEXSIEN=$O(^LEX(757.01,+LEXEIEN,5," "),-1)+1
	. . I LEXEIEN=10169 D  Q
	. . . S DA(1)=LEXEIEN,DA=+LEXSIEN,DIK="^LEX(757.01,"_DA(1)_",5," D ^DIK K DA,DIK
	. . . S DA=+LEXEIEN,DIK="^LEX(757.01," D IX2^DIK
	. . . S $P(^LEX(757.01,+LEXEIEN,0),"^",1)="Abnormal Cardiac Rhythm"
	. . . K ^LEX(757.01,"AWRD","ARRYTHMIA",10164,10169)
	. . . K ^LEX(757.01,"AWRD","ARRYTHMIA",10169,10164,1)
	. . . S DA=+LEXEIEN,DIK="^LEX(757.01," D IX1^DIK
	. . S DA=LEXEIEN,DIK="^LEX(757.01," D IX2^DIK
	. . S ^LEX(757.01,+LEXEIEN,5,0)="^757.18^"_LEXSIEN_"^"_LEXSIEN
	. . S ^LEX(757.01,+LEXEIEN,5,LEXSIEN,0)=LEXUP
	. . S $P(^LEX(757.01,+LEXEIEN,0),"^",1)=LEXNEW
	. . S DA=LEXEIEN,DIK="^LEX(757.01," D IX1^DIK
	. . Q
	Q 
R8	;   Remedy 8   HD0000000423417 - Re-Code Cardiomyopathy, Ischemic 414.8
	N DA,DIC,DIK,LEXTXT,LEXMOD S LEXTXT="423417",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"Cardiomyopathy, Ischemic - 414.8" D M(("     "_LEXTXT))
	S DA=316481,DIK="^LEX(757.02," D IX2^DIK K ^LEX(757.02,"ACODE","425.4 ",316481),^LEX(757.02,"AVA","425.4 ",303907,"ICD",316481)
	K ^LEX(757.02,"CODE","425.4 ",316481) S $P(^LEX(757.02,316481,0),"^",2)=414.8 S DA=316481,DIK="^LEX(757.02," D IX1^DIK
	Q
R9	;   Remedy 9   HD0000000424248 - Re-Code Seizure Disorder - 345.90
	N DA,DIC,DIK,LEXTXT,LEXMOD S LEXTXT="424248",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"Seizure Disorder - 345.90" D M(("     "_LEXTXT))
	S DA=316458,DIK="^LEX(757.02," D IX2^DIK K ^LEX(757.02,"ACODE","780.39 ",316458),^LEX(757.02,"AVA","780.39 ",108977,"ICD",316458)
	K ^LEX(757.02,"CODE","780.39 ",316458) S $P(^LEX(757.02,316458,0),"^",2)="345.90" S DA=316458,DIK="^LEX(757.02," D IX1^DIK
	Q
R10	;   Remedy 10   HD0000000432728 - GT/GQ Modifiers with G0270/97802/97803 
	N DA,DIC,DIK,LEXTXT,LEXMOD S LEXTXT="432728",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"GT/GQ Modifiers with G0270/97802/97803" D M(("     "_LEXTXT))
	F DA(1)=371,392 F DA=92,93 I $D(^DIC(81.3,DA(1),10,DA,0)) S DIK="^DIC(81.3,"_DA(1)_",10," D ^DIK
	K DA S ^DIC(81.3,371,10,92,0)="G0270^G0270^3060101^" S DA(1)=371,DA=92,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	K DA S ^DIC(81.3,371,10,93,0)="97802^97803^3060101^" S DA(1)=371,DA=93,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	K DA S ^DIC(81.3,392,10,92,0)="G0270^G0270^3060101^" S DA(1)=392,DA=92,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	K DA S ^DIC(81.3,392,10,93,0)="97802^97803^3060101^" S DA(1)=392,DA=93,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	Q
R11	;   Remedy 11   HD0000000449242 - 50 Modifier with 60260
	N DA,DIC,DIK,LEXTXT,LEXMOD S LEXTXT="449242",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"50 Modifier with 60260" D M(("     "_LEXTXT))
	K DA S ^DIC(81.3,10,10,619,0)="60260^60260^3100101^" S DA(1)=10,DA=619,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	Q
R12	;   Remedy 12   HD0000000449810 - LT/RT/50 Modifiers with 32422
	N DA,DIC,DIK,LEXTXT,LEXMOD S LEXTXT="449810",LEXTXT=LEXTXT_$J(" ",(10-$L(LEXTXT)))_"LT/RT/50 Modifiers with 32422" D M(("     "_LEXTXT))
	S DA(1)=83,DA=136,DIK="^DIC(81.3,"_DA(1)_",10," D IX2^DIK S ^DIC(81.3,83,10,136,0)="32200^32422^2990101" S DA(1)=83,DA=136,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	S DA(1)=109,DA=136,DIK="^DIC(81.3,"_DA(1)_",10," D IX2^DIK S ^DIC(81.3,109,10,136,0)="32200^32422^2990101" S DA(1)=109,DA=136,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	S DA(1)=10,DA=620,DIK="^DIC(81.3,"_DA(1)_",10," D IX2^DIK S ^DIC(81.3,10,10,98,0)="32420^32422^2990101^" S DA(1)=10,DA=620,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	Q
	;    
	; Miscellaneous
LO(X)	;   Lower Case
	Q $TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
UP(X)	;   Upper Case
	Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
MX(X)	;   Mixed Case
	Q $TR($E(X,1),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")_$TR($E(X,2,$L(X)),"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
BM(X)	;   Blank/Text
	D BMES^XPDUTL($G(X)) Q
M(X)	;   Text
	D MES^XPDUTL($G(X)) Q
ED(X)	;   External Date
	N Y S Y=$$FMTE^XLFDT($G(X)) S:Y["@" Y=$P(Y,"@",1)_"  "_$P(Y,"@",2,299) S:$L(Y) X=Y
	Q X
