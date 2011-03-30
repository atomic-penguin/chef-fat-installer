/* $Id: rmd160ossl.c 28341 2010-06-16 09:38:14Z knu $ */

#include "../defs.h"
#include "rmd160ossl.h"

void RMD160_Finish(RMD160_CTX *ctx, char *buf) {
	RIPEMD160_Final((unsigned char *)buf, ctx);
}
