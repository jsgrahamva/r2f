PSS55	;BHM/DB/TSS - API FOR PHARMACY PATIENT FILE ;15 JUN 05
	;;1.0;PHARMACY DATA MANAGEMENT;**101,108,118,88,133**;9/30/97;Build 1
	;
PSS431(DFN,PO,PSDATE,PEDATE,LIST)	;
	G ^PSS551
PSS432(DFN,PO,LIST)	;SRS 3.2.43.2
	N D0,DA,DR,DIC,IEN,PSSTMP,PSSTMP2
	;DFN: IEN of Patient [REQUIRED]
	;PO: Order # IEN [optional] If left blank, all active orders will be returned
	;LIST: Subscript name used in ^TMP global [REQUIRED]
	N PSSPO,PSSDT,PSSIEN,PSSDATA,PSSQ
	Q:$G(LIST)=""  K ^TMP($J,LIST)
	I +$G(DFN)'>0 G NODATA
	S ^TMP($J,LIST,0)=0
	I '$D(^PS(55,DFN,0)) G NODATA
	I $G(PO)'="",$D(^PS(55,DFN,5,PO)) S PSSPO=$P(^PS(55,DFN,5,PO,0),"^") I $G(PSSPO)>0 S (DA(55.06),IEN)=PO G AUS2
	I $G(PO)'="",$G(PSSPO)="" G NODATA
	S PSSDT=0
AUS	;Loop through stop date/time xref
	F  S PSSDT=$O(^PS(55,DFN,5,"AUS",PSSDT)) Q:PSSDT'>0  S PSSIEN=0 D
	.F  S PSSIEN=$O(^PS(55,DFN,5,"AUS",PSSDT,PSSIEN)) Q:PSSIEN'>0  D
	..S (IEN,DA(55.06))=PSSIEN,PSSDATA=$G(^PS(55,DFN,5,PSSIEN,0)) I $P(PSSDATA,"^",9)'="A" Q
	..D AUSDIQ
	S ^TMP($J,LIST,0)=$S(^TMP($J,LIST,0)=0:"-1^NO DATA FOUND",1:^TMP($J,LIST,0))
	K PSSIEN,PSSDT,PSSDATA,LIST
	Q
AUSDIQ	K ^UTILITY("DIQ1",$J),DIQ
	S DA=DFN,DIC=55,DR=62,DR(55.06)=".01;.5;1;3;4;5;6;7;9;11;12;26;27;27.1;28",DIQ(0)="IE" D EN^DIQ1
	S PSSPO=$G(^UTILITY("DIQ1",$J,55.06,IEN,.01,"E")) F X=.01,.5,1,3,4,5,6,7,9,11,12,26,27,27.1,28 S ^TMP($J,LIST,IEN,X)=$G(^UTILITY("DIQ1",$J,55.06,IEN,X,"I"))
	F X=.5,1,3,4,5,6,7,9,27,27.1,28 S ^TMP($J,LIST,IEN,X)=$S($G(^UTILITY("DIQ1",$J,55.06,IEN,X,"E"))'="":^TMP($J,LIST,IEN,X)_"^"_$G(^UTILITY("DIQ1",$J,55.06,IEN,X,"E")),1:"")
	S PSSTMP=$P($G(^PS(55,DFN,5,IEN,.2)),U) S ^TMP($J,LIST,IEN,108)=$S($G(PSSTMP)="":"",1:$$ORDITEM(+PSSTMP))
	K ^UTILITY("DIQ1",$J),DIQ
	S ^TMP($J,LIST,"B",IEN)="",^TMP($J,LIST,0)=$G(^TMP($J,LIST,0))+1
	Q
ORDITEM(PSSTMP)	;
	;Reference to ^PSNDF(50.606 is supported by DBIA 2174
	S PSSTMP2=$G(^PS(50.7,PSSTMP,0))
	I PSSTMP2'="" S PSSTMP=PSSTMP_U_$P($G(PSSTMP2),U)_U_$P($G(PSSTMP2),U,2)_U_$P($G(^PS(50.606,$P($G(PSSTMP2),U,2),0)),U,1)
	Q PSSTMP
AUS2	;one PO
	S PSSQ=1 D AUSDIQ
	S ^TMP($J,LIST,0)=$S(^TMP($J,LIST,0)=0:"-1^NO DATA FOUND",1:^TMP($J,LIST,0))
AUSQ	K PSSDT,PSSIEN,PSSDATA,PSSPO,LIST,X,PSSQ,DA,DR,DIC Q
	;
PSS433(DFN,LIST)	;
	;DFN: IEN of Patient [REQUIRED]
	;LIST: Subscript name used in ^TMP global [REQUIRED]
	N X,DA,DR,PSSPO,PSSIEN,D0,IEN,PSSTMP,PSSTMP2
	Q:$G(LIST)=""  K ^TMP($J,LIST)
	I $G(DFN)'>0 S ^TMP($J,LIST,0)="-1^NO DATA FOUND" Q
	I '$D(^PS(55,DFN)) G NODATA
	S PSSIEN=0,^TMP($J,LIST,0)=0
BGN433	S PSSIEN=$O(^PS(55,DFN,5,PSSIEN)) G Q433:PSSIEN'>0 S PSSPO=$P($G(^PS(55,DFN,5,PSSIEN,0)),"^")
	S (IEN,DA(55.06))=PSSIEN,DIC=55,DA=DFN,DR=62,DR(55.06)=".5;9;25;26;34;41;42;70",DIQ(0)="IE" D EN^DIQ1
	F X=.5,9,25,26,34,41,42,70 S ^TMP($J,LIST,+PSSIEN,X)=$G(^UTILITY("DIQ1",$J,55.06,IEN,X,"I"))
	S PSSTMP=$P($G(^PS(55,DFN,5,PSSIEN,.2)),U) S ^TMP($J,LIST,IEN,108)=$S($G(PSSTMP)="":"",1:$$ORDITEM(+PSSTMP))
	F X=.5,9,25,34,70 S ^TMP($J,LIST,+PSSIEN,X)=$S($G(^UTILITY("DIQ1",$J,55.06,IEN,X,"E"))'="":^TMP($J,LIST,+PSSIEN,X)_"^"_$G(^UTILITY("DIQ1",$J,55.06,IEN,X,"E")),1:"")
	S ^TMP($J,LIST,0)=$G(^TMP($J,LIST,0))+1
	S ^TMP($J,LIST,"B",+PSSIEN)=""
	G BGN433
Q433	K ^UTILITY("DIQ1",$J),PSSIEN,X,DR,DIC,DA,LIST Q
PSS435(DFN,PO,LIST)	;SRS 3.2.43.5
	N D0,DA,DIC,DR,IEN,X,PSSPO,PSSDATA,PSSIEN,PSSDT,PSSTMP,PSSTMP2,PSSSTAT
	;DFN:  IEN of Patient [REQUIRED]
	;PO: Order # [optional] If left blank, all active orders will be returned. 
	;LIST: Subscript name used in ^TMP global [REQUIRED]
	;Active hyperal orders utilizing "AIT" cross reference
	Q:$G(LIST)=""  K ^TMP($J,LIST)
	I $G(DFN)'>0  S ^TMP($J,LIST,0)="-1^NO DATA FOUND" Q
	I '$D(^PS(55,DFN,"IV","AIT","H")) S ^TMP($J,LIST,0)="-1^NO DATA FOUND" Q
	S PSSDT=0,^TMP($J,LIST,0)=0
AIT	;loop trough AIT xref
	S PSSDT=$O(^PS(55,DFN,"IV","AIT","H",PSSDT)) G AITQ:PSSDT'>0 S PSSIEN=0
AIT1	S PSSIEN=$O(^PS(55,DFN,"IV","AIT","H",PSSDT,PSSIEN)) G AIT:PSSIEN'>0
	S PSSDATA=$G(^PS(55,DFN,"IV",PSSIEN,0)),PSSSTAT=$P($G(PSSDATA),"^",17) I PSSSTAT'="A",$G(PO)'>0 G AIT1
	I +$G(PO)>0 G AIT1:PSSIEN'=PO
	S PSSPO=$P(PSSDATA,"^",1),^TMP($J,LIST,"B",+PSSIEN)=""
AITDIQ	K ^UTILITY("DIQ1",$J) S DA=DFN,(IEN,DA(55.01))=PSSIEN,DIC=55,DR=100,DIQ(0)="IE",DR(55.01)=".01;.02;.03;.04;.06;.08;.09;.12;.17;.24;9;31;100;104;106;108;110;112;120;121;132" D EN^DIQ1
	F X=.01,.02,.03,.04,.06,.08,.09,.12,.17,.24,9,31,100,104,106,108,110,112,120,121,132 S ^TMP($J,LIST,PSSPO,X)=$G(^UTILITY("DIQ1",$J,55.01,IEN,X,"I"))
	F X=.02,.03,.04,.06,9,100,106,108,112,120,121,132 S ^TMP($J,LIST,PSSPO,X)=$S($G(^UTILITY("DIQ1",$J,55.01,IEN,X,"E"))'="":^TMP($J,LIST,PSSPO,X)_"^"_$G(^UTILITY("DIQ1",$J,55.01,IEN,X,"E")),1:"")
	S PSSTMP=$P($G(^PS(55,DFN,"IV",PSSIEN,.2)),U) S ^TMP($J,LIST,IEN,130)=$S($G(PSSTMP)="":"",1:$$ORDITEM(+PSSTMP))
	K ^UTILITY("DIQ1",$J)
	S ^TMP($J,LIST,0)=$G(^TMP($J,LIST,0))+1
	G AIT1
AITQ	I $G(^TMP($J,LIST,0))=0 K ^TMP($J,LIST) S ^TMP($J,LIST,0)="-1^NO DATA FOUND"
	K PSSIEN,PSSDT,PSSSTAT,PSSDATA,PO,X,LIST Q
	;
PSS436(DFN,ORDER,LIST)	;SRS 3.2.43.6
	N D0,IEN,X,PSSTMP,PSSTMP2,DA,PSSLOOP,PSSPO,DIC,DR,PSSTMP,PSSA,PSSS,PSSDATA
	;DFN: IEN of Patient [REQUIRED]
	;ORDER:  ORDER NUMBER [REQUIRED]
	;LIST: Subscript name used in ^TMP global [REQUIRED]
	;Active IV AD nodes
	K PSSLOOP Q:$G(LIST)=""  K ^TMP($J,LIST) I $G(DFN)'>0  S ^TMP($J,LIST,0)="-1^NO DATA FOUND" Q
	I '$D(^PS(55,DFN)) S ^TMP($J,LIST,0)="-1^NO DATA FOUND" Q
	K ^TMP($J,LIST) I $G(ORDER)="" S PSSLOOP=1 S ORDER=0 G LOOP436
	I $G(ORDER)'="" S PSSPO=$O(^PS(55,DFN,"IV","B",ORDER,0)) G PSS436Q:$G(PSSPO)'>0 G DIQ436
LOOP436	S ORDER=$O(^PS(55,DFN,"IV","B",ORDER)) G PSS436Q:ORDER'>0  S PSSPO=$O(^PS(55,DFN,"IV","B",ORDER,0))
DIQ436	K DA,DR S DA=DFN,(IEN,DA(55.01))=PSSPO,DIC=55,DR=100
	S DR(55.01)=".01;.02;.03;.04;.06;.08;.09;.12;.17;.24;9;31;100;104;106;108;110;112;120;121;132;147"
	S DIQ(0)="IE" D EN^DIQ1 I '$D(^UTILITY("DIQ1",$J)) G NODATA
	F X=.01,.02,.03,.04,.06,.08,.09,.12,.17,.24,9,31,100,104,106,108,110,112,120,121,132,147 S ^TMP($J,LIST,PSSPO,X)=$G(^UTILITY("DIQ1",$J,55.01,IEN,X,"I"))
	F X=.02,.03,.04,.06,9,100,106,108,112,120,121,132,147 S ^TMP($J,LIST,PSSPO,X)=$S($G(^UTILITY("DIQ1",$J,55.01,IEN,X,"E"))'="":^TMP($J,LIST,PSSPO,X)_"^"_$G(^UTILITY("DIQ1",$J,55.01,IEN,X,"E")),1:"")
	S PSSTMP=$P($G(^PS(55,DFN,"IV",PSSPO,.2)),U) S ^TMP($J,LIST,IEN,130)=$S($G(PSSTMP)="":"",1:$$ORDITEM(+PSSTMP))
	S ^TMP($J,LIST,"B",PSSPO)="",PSSA=0,^TMP($J,LIST,0)=$G(^TMP($J,LIST,0))+1
	S ^TMP($J,LIST,PSSPO,"ADD",0)=0
PSSA	S PSSA=$O(^PS(55,DFN,"IV",PSSPO,"AD",PSSA)) I PSSA'>0 S PSSS=0 S ^TMP($J,LIST,PSSPO,"SOL",0)=0 G PSSS
	S PSSDATA=$G(^PS(55,DFN,"IV",PSSPO,"AD",PSSA,0)),X1=$P(PSSDATA,"^"),X2=$P(PSSDATA,"^",2),X3=$P(PSSDATA,"^",3)
	S ^TMP($J,LIST,PSSPO,"ADD",PSSA,.01)=X1_"^"_$P($G(^PS(52.6,X1,0)),"^")
	S ^TMP($J,LIST,PSSPO,"ADD",PSSA,.02)=X2
	S ^TMP($J,LIST,PSSPO,"ADD",PSSA,.03)=X3
	S ^TMP($J,LIST,PSSPO,"ADD",0)=$G(^TMP($J,LIST,PSSPO,"ADD",0))+1
	G PSSA
PSSS	I ^TMP($J,LIST,PSSPO,"ADD",0)'>0 S ^TMP($J,LIST,PSSPO,"ADD",0)="-1^NO DATA FOUND"
	S PSSS=$O(^PS(55,DFN,"IV",PSSPO,"SOL",PSSS)) I PSSS'>0,$G(PSSLOOP)'=1 D  G PSS436Q
	.I ^TMP($J,LIST,PSSPO,"SOL",0)=0 S ^TMP($J,LIST,PSSPO,"SOL",0)="-1^NO DATA FOUND"
	I PSSS'>0 D  G LOOP436
	.I ^TMP($J,LIST,PSSPO,"SOL",0)=0 S ^TMP($J,LIST,PSSPO,"SOL",0)="-1^NO DATA FOUND"
	S PSSDATA=$G(^PS(55,DFN,"IV",PSSPO,"SOL",PSSS,0)),X1=$P(PSSDATA,"^"),X2=$P(PSSDATA,"^",2)
	S ^TMP($J,LIST,PSSPO,"SOL",PSSS,.01)=X1_"^"_$P($G(^PS(52.7,X1,0)),"^")
	S ^TMP($J,LIST,PSSPO,"SOL",PSSS,1)=X2
	S ^TMP($J,LIST,PSSPO,"SOL",0)=$G(^TMP($J,LIST,PSSPO,"SOL",0))+1
	G PSSS
PSS436Q	K ^UTILITY("DIQ1",$J),DIQ I '$D(^TMP($J,LIST,"B")) S ^TMP($J,LIST,0)="-1^NO DATA FOUND"
	K PSSPO,PSSA,PSSDATA,X,LIST,X1,X2,PSSS,ORDER,PSSLOOP,DA,DR,DIC Q
NODATA	S ^TMP($J,LIST,0)="-1^NO DATA FOUND"
Q	K IEN,PSSA,PSSS,PSSSTAT,X,LIST,X1,X2,X3,PSSDIY Q
