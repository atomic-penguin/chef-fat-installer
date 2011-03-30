# $RoughId: extconf.rb,v 1.4 2001/08/14 19:54:51 knu Exp $
# $Id: extconf.rb 28345 2010-06-17 08:39:22Z mrkn $

require "mkmf"

$defs << "-DHAVE_CONFIG_H"

$objs = [ "sha2init.#{$OBJEXT}" ]

dir_config("openssl")

if !with_config("bundled-sha2") &&
    have_library("crypto") &&
    %w[SHA256 SHA512].all? {|d| have_func("#{d}_Transform", "openssl/sha.h")} &&
    %w[SHA256 SHA512].all? {|d| have_type("#{d}_CTX", "openssl/sha.h")}
  $objs << "sha2ossl.#{$OBJEXT}"
  $defs << "-DSHA2_USE_OPENSSL"
else
  have_type("u_int8_t")
  $objs << "sha2.#{$OBJEXT}"
end

have_header("sys/cdefs.h")

$preload = %w[digest]

create_makefile("digest/sha2")
