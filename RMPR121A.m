RMPR121A	;PHX/HNC -CREATE GUI PURCHASE CARD TRANSACTION CONT. ;3/1/2003
	;;3.0;PROSTHETICS;**90,157**;Feb 09, 1996;Build 11
	;Per VHA Directive 2004-038, this routine should not be modified.
	;04/01/05 Note some codeing for future use such as pt address.
DELIV	I RMPRY=1 D
	.S RMPRDDF="1^Y"
	.S DFN=$P(^RMPR(664,RMPRA,0),U,2)
	.D ALL^VADPT
	.S RMPRADD1=VADM(1)
	.S RMPRADD2=VAPA(1)
	.S RMPRCITY=VAPA(4)
	.S RMPRST=VAPA(5)
	.S RMPRZIP=VAPA(6)
	.I RMPRZIP="" S RMPRZIP="00000"
	I RMPRY=2 S RMPRDDF="2^N"
	I RMPRY=3 S RMPRDDF="3^N"
	I RMPRY=4 D
	.S RMPRDDF="4^Y"
	.S RMPRADD1=$P(^RMPR(664,RMPRA,3),U,5)
	.S RMPRADD2=$P(^RMPR(664,RMPRA,3),U,6)
	.S RMPRCITY=$P(^RMPR(664,RMPRA,3),U,7)
	.S RMPRST=$P(^RMPR(664,RMPRA,3),U,8)_"^"_$P(^DIC(5,$P(^RMPR(664,RMPRA,3),U,8),0),U,1)
	.S RMPRZIP=$P(^RMPR(664,RMPRA,3),U,9)
	;deliver to other
	S RMPRDELN=RMPRY(0),$P(^RMPR(664,RMPRA,3),U)=RMPRDELN
	S RMPRDLVD=$P(^RMPR(664,RMPRA,3),U,2)
	I RMPRY=3 S RMPRDELN=$P(^RMPR(664,RMPRA,3),U,4)
	I RMPRY=4 S RMPRDELN=$P(^RMPR(664,RMPRA,3),U,4)
	Q
