/* $Id: sha1ossl.c 28341 2010-06-16 09:38:14Z knu $ */

#include "../defs.h"
#include "sha1ossl.h"

void
SHA1_Finish(SHA1_CTX *ctx, char *buf)
{
	SHA1_Final((unsigned char *)buf, ctx);
}
