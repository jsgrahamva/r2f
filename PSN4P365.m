PSN4P365	;ALB/HW-Post Install Routine removes incorrect data ; 02/18/14 13:09
	;;4.0;NATIONAL DRUG FILE;**365**;30 Oct 98;Build 9
	Q  ;Must be called at entry point
EN	;Find and delete incorrect entry and related cross-references
	N PSNDIEN,PSNIIEN,PSNFILE,PSNFDA,PSNRN,PSNCTR,PSNERR,Y
	S PSNDIEN=""
	F  S PSNDIEN=$O(^PS(50.416,"B","VARENICLINE",PSNDIEN)) Q:PSNDIEN=""  D
	.I $D(^PS(50.416,PSNDIEN,1,0))=10!($D(^PS(50.416,PSNDIEN,1,0))=0) D FZNODE
	.S PSNIIEN=""
	. F  S PSNIIEN=$O(^PS(50.416,PSNDIEN,1,"B","184A20598",PSNIIEN)) Q:PSNIIEN=""  D
	..S PSNFILE=50.4161
	..I $$GET1^DIQ(PSNFILE,PSNIIEN_","_PSNDIEN_",",.01)]"" D
	...S PSNFDA(PSNFILE,PSNIIEN_","_PSNDIEN_",",.01)="@"
	...D FILE^DIE("","PSNFDA","PSNERR")
	...K PSNFDA Q
	..Q
	I $D(PSNERR) W !,"CHECK ERROR LOG FOR ERRORS"
	Q
FZNODE	;If the zero multiple node is missing add it first
	S PSNRN="",PSNCTR=""
	F  S PSNRN=$O(^PS(50.416,PSNDIEN,1,PSNRN)) Q:PSNRN'>0  D
	.S PSNCTR=PSNCTR+1
	S ^PS(50.416,PSNDIEN,1,0)="^50.4161A^"_PSNCTR_"^"_PSNCTR_""
	Q
