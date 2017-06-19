typedef union {
 number num;
 char id[16];
 char opr;
 bool boolean;
} YYSTYPE;
#define	ID	258
#define	NUM	259
#define	ADDOP	260
#define	MULOP	261
#define	RELOP	262
#define	LOGOP	263
#define	START	264
#define	DO	265
#define	ELSE	266
#define	IF	267
#define	ENDI	268
#define	INT	269
#define	PUT	270
#define	PROG	271
#define	GET	272
#define	REAL	273
#define	THEN	274
#define	VAR	275
#define	LOOP	276
#define	ENDL	277
#define	UNTIL	278
#define	ENDP	279
#define	DOT	280
#define	SEMICOL	281
#define	COL	282
#define	COMMA	283
#define	LPAR	284
#define	RPAR	285
#define	ASSIGNOP	286


extern YYSTYPE yylval;
