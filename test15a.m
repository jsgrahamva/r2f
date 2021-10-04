test15a	;
RXC(IEN,OIEN,DATA,FS,CS,ERR)    ; process RXC (IV orders: additives/solutions) segment...
        I ALPBGNOD=0 D ERRBLD^ALPBUTL1("RXC","Unable to determine Additive or Solution in RXC segment",.ERR) Q
        S ALPBFNOD="53.7021"_$S(ALPBGNOD=8:3,1:4),ALPBFNOD="THE END"
        S ALPBFILE(ALPBFNOD,"+"_ALPBNEXT_","_OIEN_","_IEN_",",2)=ALPBUNIT
        D UPDATE^DIE("","ALPBFILE","ALPBNEXT","ERR")
        Q
