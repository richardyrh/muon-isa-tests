AC_INIT([riscv-tests],[1.0])

cross_compiling=yes
AC_PROG_CC

AC_ARG_WITH(xlen,
        [AS_HELP_STRING([--with-xlen=XLEN],
                [Set XLEN, the X-register bit width (default is 32)])],
        AC_SUBST(XLEN, $withval),
        AC_SUBST(XLEN, 32)
        )


AC_CONFIG_FILES([Makefile
])
AC_OUTPUT
