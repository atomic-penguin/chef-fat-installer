# $RoughId: extconf.rb,v 1.3 2001/08/14 19:54:51 knu Exp $
# $Id: extconf.rb 28341 2010-06-16 09:38:14Z knu $

require "mkmf"

$defs << "-DHAVE_CONFIG_H"

$objs = [ "sha1init.#{$OBJEXT}" ]

dir_config("openssl")

if !with_config("bundled-sha1") &&
    have_library("crypto") && have_header("openssl/sha.h")
  $objs << "sha1ossl.#{$OBJEXT}"
else
  $objs << "sha1.#{$OBJEXT}"
end

have_header("sys/cdefs.h")

$preload = %w[digest]

create_makefile("digest/sha1")
