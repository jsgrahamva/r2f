PSN441E	;BIR/HW-Environment Check to make sure PSN*4.0*441 can be installed; 23 June 2015  3:18 PM
	;;4.0;NATIONAL DRUG FILE;**441**; 30 Oct 98;Build 15
	;Check if the data update required for this patch has been installed
	I $P($G(^PSNDF(50.68,23393,0)),"^")="TRAMADOL HCL 150MG CAP,SA"&($P($G(^PSNDF(50.68,23393,3)),"^")'=73) D  Q
	.W !!,"This patch shouldn't be installed until the correct Data Update patch is installed"
	.S XPDQUIT=1
	Q
