-- _http_.e

include std/convert.e
include std/search.e
include _common_.e
include _types_.e
include _debug_.e
include _search_.e
include _conv_.e
include _sequence_.e

global constant HTML5_ENTITIES = {
  {"&Tab;", #09}, {"&NewLine;", #0A}, {"&excl;", #21}, {"&quot;", #22},
  {"&QUOT;", #22}, {"&num;", #23}, {"&dollar;", #24}, {"&percnt;", #25},
  {"&amp;", #26}, {"&AMP;", #26}, {"&apos;", #27}, {"&lpar;", #28},
  {"&rpar;", #29}, {"&ast;", #2A}, {"&midast;", #2A}, {"&plus;", #2B},
  {"&comma;", #2C}, {"&period;", #2E}, {"&sol;", #2F}, {"&colon;", #3A},
  {"&semi;", #3B}, {"&lt;", #3C}, {"&LT;", #3C}, {"&equals;", #3D},
  {"&gt;", #3E}, {"&GT;", #3E}, {"&quest;", #3F}, {"&commat;", #40},
  {"&lbrack;", #5B}, {"&lsqb;", #5B}, {"&bsol;", #5C}, {"&rbrack;", #5D},
  {"&rsqb;", #5D}, {"&Hat;", #5E}, {"&lowbar;", #5F},
  {"&DiacriticalGrave;", #60}, {"&grave;", #60}, {"&lbrace;", #7B},
  {"&lcub;", #7B}, {"&verbar;", #7C}, {"&vert;", #7C}, {"&VerticalLine;", #7C},
  {"&rbrace;", #7D}, {"&rcub;", #7D}, {"&nbsp;", #A0},
  {"&NonBreakingSpace;", #A0}, {"&iexcl;", #A1}, {"&cent;", #A2},
  {"&pound;", #A3}, {"&curren;", #A4}, {"&yen;", #A5}, {"&brvbar;", #A6},
  {"&sect;", #A7}, {"&die;", #A8}, {"&Dot;", #A8}, {"&DoubleDot;", #A8},
  {"&uml;", #A8}, {"&copy;", #A9}, {"&COPY;", #A9}, {"&ordf;", #AA},
  {"&laquo;", #AB}, {"&not;", #AC}, {"&shy;", #AD}, {"&circledR;", #AE},
  {"&reg;", #AE}, {"&REG;", #AE}, {"&macr;", #AF}, {"&OverBar;", #AF},
  {"&strns;", #AF}, {"&deg;", #B0}, {"&PlusMinus;", #B1}, {"&plusmn;", #B1},
  {"&pm;", #B1}, {"&sup2;", #B2}, {"&sup3;", #B3}, {"&acute;", #B4},
  {"&DiacriticalAcute;", #B4}, {"&micro;", #B5}, {"&para;", #B6},
  {"&CenterDot;", #B7}, {"&centerdot;", #B7}, {"&middot;", #B7},
  {"&cedil;", #B8}, {"&Cedilla;", #B8}, {"&sup1;", #B9}, {"&ordm;", #BA},
  {"&raquo;", #BB}, {"&frac14;", #BC}, {"&frac12;", #BD}, {"&half;", #BD},
  {"&frac34;", #BE}, {"&iquest;", #BF}, {"&Agrave;", #C0}, {"&Aacute;", #C1},
  {"&Acirc;", #C2}, {"&Atilde;", #C3}, {"&Auml;", #C4}, {"&Aring;", #C5},
  {"&AElig;", #C6}, {"&Ccedil;", #C7}, {"&Egrave;", #C8}, {"&Eacute;", #C9},
  {"&Ecirc;", #CA}, {"&Euml;", #CB}, {"&Igrave;", #CC}, {"&Iacute;", #CD},
  {"&Icirc;", #CE}, {"&Iuml;", #CF}, {"&ETH;", #D0}, {"&Ntilde;", #D1},
  {"&Ograve;", #D2}, {"&Oacute;", #D3}, {"&Ocirc;", #D4}, {"&Otilde;", #D5},
  {"&Ouml;", #D6}, {"&times;", #D7}, {"&Oslash;", #D8}, {"&Ugrave;", #D9},
  {"&Uacute;", #DA}, {"&Ucirc;", #DB}, {"&Uuml;", #DC}, {"&Yacute;", #DD},
  {"&THORN;", #DE}, {"&szlig;", #DF}, {"&agrave;", #E0}, {"&aacute;", #E1},
  {"&acirc;", #E2}, {"&atilde;", #E3}, {"&auml;", #E4}, {"&aring;", #E5},
  {"&aelig;", #E6}, {"&ccedil;", #E7}, {"&egrave;", #E8}, {"&eacute;", #E9},
  {"&ecirc;", #EA}, {"&euml;", #EB}, {"&igrave;", #EC}, {"&iacute;", #ED},
  {"&icirc;", #EE}, {"&iuml;", #EF}, {"&eth;", #F0}, {"&ntilde;", #F1},
  {"&ograve;", #F2}, {"&oacute;", #F3}, {"&ocirc;", #F4}, {"&otilde;", #F5},
  {"&ouml;", #F6}, {"&div;", #F7}, {"&divide;", #F7}, {"&oslash;", #F8},
  {"&ugrave;", #F9}, {"&uacute;", #FA}, {"&ucirc;", #FB}, {"&uuml;", #FC},
  {"&yacute;", #FD}, {"&thorn;", #FE}, {"&yuml;", #FF}, {"&Amacr;", #100},
  {"&amacr;", #101}, {"&Abreve;", #102}, {"&abreve;", #103}, {"&Aogon;", #104},
  {"&aogon;", #105}, {"&Cacute;", #106}, {"&cacute;", #107}, {"&Ccirc;", #108},
  {"&ccirc;", #109}, {"&Cdot;", #10A}, {"&cdot;", #10B}, {"&Ccaron;", #10C},
  {"&ccaron;", #10D}, {"&Dcaron;", #10E}, {"&dcaron;", #10F},
  {"&Dstrok;", #110}, {"&dstrok;", #111}, {"&Emacr;", #112}, {"&emacr;", #113},
  {"&Edot;", #116}, {"&edot;", #117}, {"&Eogon;", #118}, {"&eogon;", #119},
  {"&Ecaron;", #11A}, {"&ecaron;", #11B}, {"&Gcirc;", #11C}, {"&gcirc;", #11D},
  {"&Gbreve;", #11E}, {"&gbreve;", #11F}, {"&Gdot;", #120}, {"&gdot;", #121},
  {"&Gcedil;", #122}, {"&Hcirc;", #124}, {"&hcirc;", #125}, {"&Hstrok;", #126},
  {"&hstrok;", #127}, {"&Itilde;", #128}, {"&itilde;", #129}, {"&Imacr;", #12A},
  {"&imacr;", #12B}, {"&Iogon;", #12E}, {"&iogon;", #12F}, {"&Idot;", #130},
  {"&imath;", #131}, {"&inodot;", #131}, {"&IJlig;", #132}, {"&ijlig;", #133},
  {"&Jcirc;", #134}, {"&jcirc;", #135}, {"&Kcedil;", #136}, {"&kcedil;", #137},
  {"&kgreen;", #138}, {"&Lacute;", #139}, {"&lacute;", #13A},
  {"&Lcedil;", #13B}, {"&lcedil;", #13C}, {"&Lcaron;", #13D},
  {"&lcaron;", #13E}, {"&Lmidot;", #13F}, {"&lmidot;", #140},
  {"&Lstrok;", #141}, {"&lstrok;", #142}, {"&Nacute;", #143},
  {"&nacute;", #144}, {"&Ncedil;", #145}, {"&ncedil;", #146},
  {"&Ncaron;", #147}, {"&ncaron;", #148}, {"&napos;", #149}, {"&ENG;", #14A},
  {"&eng;", #14B}, {"&Omacr;", #14C}, {"&omacr;", #14D}, {"&Odblac;", #150},
  {"&odblac;", #151}, {"&OElig;", #152}, {"&oelig;", #153}, {"&Racute;", #154},
  {"&racute;", #155}, {"&Rcedil;", #156}, {"&rcedil;", #157},
  {"&Rcaron;", #158}, {"&rcaron;", #159}, {"&Sacute;", #15A},
  {"&sacute;", #15B}, {"&Scirc;", #15C}, {"&scirc;", #15D}, {"&Scedil;", #15E},
  {"&scedil;", #15F}, {"&Scaron;", #160}, {"&scaron;", #161},
  {"&Tcedil;", #162}, {"&tcedil;", #163}, {"&Tcaron;", #164},
  {"&tcaron;", #165}, {"&Tstrok;", #166}, {"&tstrok;", #167},
  {"&Utilde;", #168}, {"&utilde;", #169}, {"&Umacr;", #16A},  {"&umacr;", #16B},
  {"&Ubreve;", #16C}, {"&ubreve;", #16D}, {"&Uring;", #16E},  {"&uring;", #16F},
  {"&Udblac;", #170}, {"&udblac;", #171}, {"&Uogon;", #172},  {"&uogon;", #173},
  {"&Wcirc;", #174}, {"&wcirc;", #175}, {"&Ycirc;", #176},  {"&ycirc;", #177},
  {"&Yuml;", #178}, {"&Zacute;", #179}, {"&zacute;", #17A},  {"&Zdot;", #17B},
  {"&zdot;", #17C}, {"&Zcaron;", #17D}, {"&zcaron;", #17E},  {"&fnof;", #192},
  {"&imped;", #1B5}, {"&gacute;", #1F5}, {"&jmath;", #237}, {"&circ;", #2C6},
  {"&caron;", #2C7}, {"&Hacek;", #2C7}, {"&breve;", #2D8}, {"&Breve;", #2D8},
  {"&DiacriticalDot;", #2D9}, {"&dot;", #2D9}, {"&ring;", #2DA},
  {"&ogon;", #2DB}, {"&DiacriticalTilde;", #2DC}, {"&tilde;", #2DC},
  {"&dblac;", #2DD}, {"&DiacriticalDoubleAcute;", #2DD}, {"&DownBreve;", #311},
  {"&UnderBar;", #332}, {"&Alpha;", #391}, {"&Beta;", #392}, {"&Gamma;", #393},
  {"&Delta;", #394}, {"&Epsilon;", #395}, {"&Zeta;", #396}, {"&Eta;", #397},
  {"&Theta;", #398}, {"&Iota;", #399}, {"&Kappa;", #39A}, {"&Lambda;", #39B},
  {"&Mu;", #39C}, {"&Nu;", #39D}, {"&Xi;", #39E}, {"&Omicron;", #39F},
  {"&Pi;", #3A0}, {"&Rho;", #3A1}, {"&Sigma;", #3A3}, {"&Tau;", #3A4},
  {"&Upsilon;", #3A5}, {"&Phi;", #3A6}, {"&Chi;", #3A7}, {"&Psi;", #3A8},
  {"&Omega;", #3A9}, {"&alpha;", #3B1}, {"&beta;", #3B2}, {"&gamma;", #3B3},
  {"&delta;", #3B4}, {"&epsilon;", #3B5}, {"&epsiv;", #3B5},
  {"&varepsilon;", #3B5}, {"&zeta;", #3B6}, {"&eta;", #3B7}, {"&theta;", #3B8},
  {"&iota;", #3B9}, {"&kappa;", #3BA}, {"&lambda;", #3BB}, {"&mu;", #3BC},
  {"&nu;", #3BD}, {"&xi;", #3BE}, {"&omicron;", #3BF}, {"&pi;", #3C0},
  {"&rho;", #3C1}, {"&sigmaf;", #3C2}, {"&sigmav;", #3C2}, {"&varsigma;", #3C2},
  {"&sigma;", #3C3}, {"&tau;", #3C4}, {"&upsi;", #3C5}, {"&upsilon;", #3C5},
  {"&phi;", #3C6}, {"&phiv;", #3C6}, {"&varphi;", #3C6}, {"&chi;", #3C7},
  {"&psi;", #3C8}, {"&omega;", #3C9}, {"&thetasym;", #3D1}, {"&thetav;", #3D1},
  {"&vartheta;", #3D1}, {"&Upsi;", #3D2}, {"&upsih;", #3D2},
  {"&straightphi;", #3D5}, {"&piv;", #3D6}, {"&varpi;", #3D6},
  {"&Gammad;", #3DC}, {"&digamma;", #3DD}, {"&gammad;", #3DD},
  {"&kappav;", #3F0}, {"&varkappa;", #3F0}, {"&rhov;", #3F1},
  {"&varrho;", #3F1}, {"&epsi;", #3F5}, {"&straightepsilon;", #3F5},
  {"&backepsilon;", #3F6}, {"&bepsi;", #3F6}, {"&IOcy;", #401},
  {"&DJcy;", #402}, {"&GJcy;", #403}, {"&Jukcy;", #404}, {"&DScy;", #405},
  {"&Iukcy;", #406}, {"&YIcy;", #407}, {"&Jsercy;", #408}, {"&LJcy;", #409},
  {"&NJcy;", #40A}, {"&TSHcy;", #40B}, {"&KJcy;", #40C}, {"&Ubrcy;", #40E},
  {"&DZcy;", #40F}, {"&Acy;", #410}, {"&Bcy;", #411}, {"&Vcy;", #412},
  {"&Gcy;", #413}, {"&Dcy;", #414}, {"&IEcy;", #415}, {"&ZHcy;", #416},
  {"&Zcy;", #417}, {"&Icy;", #418}, {"&Jcy;", #419}, {"&Kcy;", #41A},
  {"&Lcy;", #41B}, {"&Mcy;", #41C}, {"&Ncy;", #41D}, {"&Ocy;", #41E},
  {"&Pcy;", #41F}, {"&Rcy;", #420}, {"&Scy;", #421}, {"&Tcy;", #422},
  {"&Ucy;", #423}, {"&Fcy;", #424}, {"&KHcy;", #425}, {"&TScy;", #426},
  {"&CHcy;", #427}, {"&SHcy;", #428}, {"&SHCHcy;", #429}, {"&HARDcy;", #42A},
  {"&Ycy;", #42B}, {"&SOFTcy;", #42C}, {"&Ecy;", #42D}, {"&YUcy;", #42E},
  {"&YAcy;", #42F}, {"&acy;", #430}, {"&bcy;", #431}, {"&vcy;", #432},
  {"&gcy;", #433}, {"&dcy;", #434}, {"&iecy;", #435}, {"&zhcy;", #436},
  {"&zcy;", #437}, {"&icy;", #438}, {"&jcy;", #439}, {"&kcy;", #43A},
  {"&lcy;", #43B}, {"&mcy;", #43C}, {"&ncy;", #43D}, {"&ocy;", #43E},
  {"&pcy;", #43F}, {"&rcy;", #440}, {"&scy;", #441}, {"&tcy;", #442},
  {"&ucy;", #443}, {"&fcy;", #444}, {"&khcy;", #445}, {"&tscy;", #446},
  {"&chcy;", #447}, {"&shcy;", #448}, {"&shchcy;", #449}, {"&hardcy;", #44A},
  {"&ycy;", #44B}, {"&softcy;", #44C}, {"&ecy;", #44D}, {"&yucy;", #44E},
  {"&yacy;", #44F}, {"&iocy;", #451}, {"&djcy;", #452}, {"&gjcy;", #453},
  {"&jukcy;", #454}, {"&dscy;", #455}, {"&iukcy;", #456}, {"&yicy;", #457},
  {"&jsercy;", #458}, {"&ljcy;", #459}, {"&njcy;", #45A}, {"&tshcy;", #45B},
  {"&kjcy;", #45C}, {"&ubrcy;", #45E}, {"&dzcy;", #45F}, {"&ensp;", #2002},
  {"&emsp;", #2003}, {"&emsp13;", #2004}, {"&emsp14;", #2005},
  {"&numsp;", #2007}, {"&puncsp;", #2008}, {"&thinsp;", #2009},
  {"&ThinSpace;", #2009}, {"&hairsp;", #200A}, {"&VeryThinSpace;", #200A},
  {"&NegativeMediumSpace;", #200B}, {"&NegativeThickSpace;", #200B},
  {"&NegativeThinSpace;", #200B}, {"&NegativeVeryThinSpace;", #200B},
  {"&ZeroWidthSpace;", #200B}, {"&zwnj;", #200C}, {"&zwj;", #200D},
  {"&lrm;", #200E}, {"&rlm;", #200F}, {"&dash;", #2010}, {"&hyphen;", #2010},
  {"&ndash;", #2013}, {"&mdash;", #2014}, {"&horbar;", #2015},
  {"&Verbar;", #2016}, {"&Vert;", #2016}, {"&lsquo;", #2018},
  {"&OpenCurlyQuote;", #2018}, {"&CloseCurlyQuote;", #2019}, {"&rsquo;", #2019},
  {"&rsquor;", #2019}, {"&lsquor;", #201A}, {"&sbquo;", #201A},
  {"&ldquo;", #201C}, {"&OpenCurlyDoubleQuote;", #201C},
  {"&CloseCurlyDoubleQuote;", #201D}, {"&rdquo;", #201D}, {"&rdquor;", #201D},
  {"&bdquo;", #201E}, {"&ldquor;", #201E}, {"&dagger;", #2020},
  {"&Dagger;", #2021}, {"&ddagger;", #2021}, {"&bull;", #2022},
  {"&bullet;", #2022}, {"&nldr;", #2025}, {"&hellip;", #2026},
  {"&mldr;", #2026}, {"&permil;", #2030}, {"&pertenk;", #2031},
  {"&prime;", #2032}, {"&Prime;", #2033}, {"&tprime;", #2034},
  {"&backprime;", #2035}, {"&bprime;", #2035}, {"&lsaquo;", #2039},
  {"&rsaquo;", #203A}, {"&oline;", #203E}, {"&caret;", #2041},
  {"&hybull;", #2043}, {"&frasl;", #2044}, {"&bsemi;", #204F},
  {"&qprime;", #2057}, {"&MediumSpace;", #205F}, {"&NoBreak;", #2060},
  {"&af;", #2061}, {"&ApplyFunction;", #2061}, {"&InvisibleTimes;", #2062},
  {"&it;", #2062}, {"&ic;", #2063}, {"&InvisibleComma;", #2063},
  {"&euro;", #20AC}, {"&tdot;", #20DB}, {"&TripleDot;", #20DB},
  {"&DotDot;", #20DC}, {"&complexes;", #2102}, {"&Copf;", #2102},
  {"&incare;", #2105}, {"&gscr;", #210A}, {"&hamilt;", #210B},
  {"&HilbertSpace;", #210B}, {"&Hscr;", #210B}, {"&Hfr;", #210C},
  {"&Poincareplane;", #210C}, {"&Hopf;", #210D}, {"&quaternions;", #210D},
  {"&planckh;", #210E}, {"&hbar;", #210F}, {"&hslash;", #210F},
  {"&planck;", #210F}, {"&plankv;", #210F}, {"&imagline;", #2110},
  {"&Iscr;", #2110}, {"&Ifr;", #2111}, {"&Im;", #2111}, {"&image;", #2111},
  {"&imagpart;", #2111}, {"&lagran;", #2112}, {"&Laplacetrf;", #2112},
  {"&Lscr;", #2112}, {"&ell;", #2113}, {"&naturals;", #2115}, {"&Nopf;", #2115},
  {"&numero;", #2116}, {"&copysr;", #2117}, {"&weierp;", #2118},
  {"&wp;", #2118}, {"&Popf;", #2119}, {"&primes;", #2119}, {"&Qopf;", #211A},
  {"&rationals;", #211A}, {"&realine;", #211B}, {"&Rscr;", #211B},
  {"&Re;", #211C}, {"&real;", #211C}, {"&realpart;", #211C}, {"&Rfr;", #211C},
  {"&reals;", #211D}, {"&Ropf;", #211D}, {"&rx;", #211E}, {"&trade;", #2122},
  {"&TRADE;", #2122}, {"&integers;", #2124}, {"&Zopf;", #2124},
  {"&ohm;", #2126}, {"&mho;", #2127}, {"&zeetrf;", #2128}, {"&Zfr;", #2128},
  {"&iiota;", #2129}, {"&angst;", #212B}, {"&bernou;", #212C},
  {"&Bernoullis;", #212C}, {"&Bscr;", #212C}, {"&Cayleys;", #212D},
  {"&Cfr;", #212D}, {"&escr;", #212F}, {"&Escr;", #2130},
  {"&expectation;", #2130}, {"&Fouriertrf;", #2131}, {"&Fscr;", #2131},
  {"&Mellintrf;", #2133}, {"&Mscr;", #2133}, {"&phmmat;", #2133},
  {"&order;", #2134}, {"&orderof;", #2134}, {"&oscr;", #2134},
  {"&alefsym;", #2135}, {"&aleph;", #2135}, {"&beth;", #2136},
  {"&gimel;", #2137}, {"&daleth;", #2138}, {"&CapitalDifferentialD;", #2145},
  {"&DD;", #2145}, {"&dd;", #2146}, {"&DifferentialD;", #2146}, {"&ee;", #2147},
  {"&ExponentialE;", #2147}, {"&exponentiale;", #2147}, {"&ii;", #2148},
  {"&ImaginaryI;", #2148}, {"&frac13;", #2153}, {"&frac23;", #2154},
  {"&frac15;", #2155}, {"&frac25;", #2156}, {"&frac35;", #2157},
  {"&frac45;", #2158}, {"&frac16;", #2159}, {"&frac56;", #215A},
  {"&frac18;", #215B}, {"&frac38;", #215C}, {"&frac58;", #215D},
  {"&frac78;", #215E}, {"&larr;", #2190}, {"&LeftArrow;", #2190},
  {"&leftarrow;", #2190}, {"&ShortLeftArrow;", #2190}, {"&slarr;", #2190},
  {"&ShortUpArrow;", #2191}, {"&uarr;", #2191}, {"&UpArrow;", #2191},
  {"&uparrow;", #2191}, {"&rarr;", #2192}, {"&RightArrow;", #2192},
  {"&rightarrow;", #2192}, {"&ShortRightArrow;", #2192}, {"&srarr;", #2192},
  {"&darr;", #2193}, {"&DownArrow;", #2193}, {"&downarrow;", #2193},
  {"&ShortDownArrow;", #2193}, {"&harr;", #2194}, {"&LeftRightArrow;", #2194},
  {"&leftrightarrow;", #2194}, {"&UpDownArrow;", #2195},
  {"&updownarrow;", #2195}, {"&varr;", #2195}, {"&nwarr;", #2196},
  {"&nwarrow;", #2196}, {"&UpperLeftArrow;", #2196}, {"&nearr;", #2197},
  {"&nearrow;", #2197}, {"&UpperRightArrow;", #2197},
  {"&LowerRightArrow;", #2198}, {"&searr;", #2198}, {"&searrow;", #2198},
  {"&LowerLeftArrow;", #2199}, {"&swarr;", #2199}, {"&swarrow;", #2199},
  {"&nlarr;", #219A}, {"&nleftarrow;", #219A}, {"&nrarr;", #219B},
  {"&nrightarrow;", #219B}, {"&rarrw;", #219D}, {"&rightsquigarrow;", #219D},
  {"&Larr;", #219E}, {"&twoheadleftarrow;", #219E}, {"&Uarr;", #219F},
  {"&Rarr;", #21A0}, {"&twoheadrightarrow;", #21A0}, {"&Darr;", #21A1},
  {"&larrtl;", #21A2}, {"&leftarrowtail;", #21A2}, {"&rarrtl;", #21A3},
  {"&rightarrowtail;", #21A3}, {"&LeftTeeArrow;", #21A4},
  {"&mapstoleft;", #21A4}, {"&mapstoup;", #21A5}, {"&UpTeeArrow;", #21A5},
  {"&map;", #21A6}, {"&mapsto;", #21A6}, {"&RightTeeArrow;", #21A6},
  {"&DownTeeArrow;", #21A7}, {"&mapstodown;", #21A7},
  {"&hookleftarrow;", #21A9}, {"&larrhk;", #21A9}, {"&hookrightarrow;", #21AA},
  {"&rarrhk;", #21AA}, {"&larrlp;", #21AB}, {"&looparrowleft;", #21AB},
  {"&looparrowright;", #21AC}, {"&rarrlp;", #21AC}, {"&harrw;", #21AD},
  {"&leftrightsquigarrow;", #21AD}, {"&nharr;", #21AE},
  {"&nleftrightarrow;", #21AE}, {"&lsh;", #21B0}, {"&Lsh;", #21B0},
  {"&rsh;", #21B1}, {"&Rsh;", #21B1}, {"&ldsh;", #21B2}, {"&rdsh;", #21B3},
  {"&crarr;", #21B5}, {"&cularr;", #21B6}, {"&curvearrowleft;", #21B6},
  {"&curarr;", #21B7}, {"&curvearrowright;", #21B7},
  {"&circlearrowleft;", #21BA}, {"&olarr;", #21BA},
  {"&circlearrowright;", #21BB}, {"&orarr;", #21BB}, {"&leftharpoonup;", #21BC},
  {"&LeftVector;", #21BC}, {"&lharu;", #21BC}, {"&DownLeftVector;", #21BD},
  {"&leftharpoondown;", #21BD}, {"&lhard;", #21BD}, {"&RightUpVector;", #21BE},
  {"&uharr;", #21BE}, {"&upharpoonright;", #21BE}, {"&LeftUpVector;", #21BF},
  {"&uharl;", #21BF}, {"&upharpoonleft;", #21BF}, {"&rharu;", #21C0},
  {"&rightharpoonup;", #21C0}, {"&RightVector;", #21C0},
  {"&DownRightVector;", #21C1}, {"&rhard;", #21C1},
  {"&rightharpoondown;", #21C1}, {"&dharr;", #21C2},
  {"&downharpoonright;", #21C2}, {"&RightDownVector;", #21C2},
  {"&dharl;", #21C3}, {"&downharpoonleft;", #21C3}, {"&LeftDownVector;", #21C3},
  {"&RightArrowLeftArrow;", #21C4}, {"&rightleftarrows;", #21C4},
  {"&rlarr;", #21C4}, {"&udarr;", #21C5}, {"&UpArrowDownArrow;", #21C5},
  {"&LeftArrowRightArrow;", #21C6}, {"&leftrightarrows;", #21C6},
  {"&lrarr;", #21C6}, {"&leftleftarrows;", #21C7}, {"&llarr;", #21C7},
  {"&upuparrows;", #21C8}, {"&uuarr;", #21C8}, {"&rightrightarrows;", #21C9},
  {"&rrarr;", #21C9}, {"&ddarr;", #21CA}, {"&downdownarrows;", #21CA},
  {"&leftrightharpoons;", #21CB}, {"&lrhar;", #21CB},
  {"&ReverseEquilibrium;", #21CB}, {"&Equilibrium;", #21CC},
  {"&rightleftharpoons;", #21CC}, {"&rlhar;", #21CC}, {"&nlArr;", #21CD},
  {"&nLeftarrow;", #21CD}, {"&nhArr;", #21CE}, {"&nLeftrightarrow;", #21CE},
  {"&nrArr;", #21CF}, {"&nRightarrow;", #21CF}, {"&DoubleLeftArrow;", #21D0},
  {"&lArr;", #21D0}, {"&Leftarrow;", #21D0}, {"&DoubleUpArrow;", #21D1},
  {"&uArr;", #21D1}, {"&Uparrow;", #21D1}, {"&DoubleRightArrow;", #21D2},
  {"&Implies;", #21D2}, {"&rArr;", #21D2}, {"&Rightarrow;", #21D2},
  {"&dArr;", #21D3}, {"&DoubleDownArrow;", #21D3}, {"&Downarrow;", #21D3},
  {"&DoubleLeftRightArrow;", #21D4}, {"&hArr;", #21D4}, {"&iff;", #21D4},
  {"&Leftrightarrow;", #21D4}, {"&DoubleUpDownArrow;", #21D5},
  {"&Updownarrow;", #21D5}, {"&vArr;", #21D5}, {"&nwArr;", #21D6},
  {"&neArr;", #21D7}, {"&seArr;", #21D8}, {"&swArr;", #21D9},
  {"&lAarr;", #21DA}, {"&Lleftarrow;", #21DA}, {"&rAarr;", #21DB},
  {"&Rrightarrow;", #21DB}, {"&zigrarr;", #21DD}, {"&larrb;", #21E4},
  {"&LeftArrowBar;", #21E4}, {"&rarrb;", #21E5}, {"&RightArrowBar;", #21E5},
  {"&DownArrowUpArrow;", #21F5}, {"&duarr;", #21F5}, {"&loarr;", #21FD},
  {"&roarr;", #21FE}, {"&hoarr;", #21FF}, {"&forall;", #2200},
  {"&ForAll;", #2200}, {"&comp;", #2201}, {"&complement;", #2201},
  {"&part;", #2202}, {"&PartialD;", #2202}, {"&exist;", #2203},
  {"&Exists;", #2203}, {"&nexist;", #2204}, {"&nexists;", #2204},
  {"&NotExists;", #2204}, {"&empty;", #2205}, {"&emptyset;", #2205},
  {"&emptyv;", #2205}, {"&varnothing;", #2205}, {"&Del;", #2207},
  {"&nabla;", #2207}, {"&Element;", #2208}, {"&in;", #2208}, {"&isin;", #2208},
  {"&isinv;", #2208}, {"&NotElement;", #2209}, {"&notin;", #2209},
  {"&notinva;", #2209}, {"&ni;", #220B}, {"&niv;", #220B},
  {"&ReverseElement;", #220B}, {"&SuchThat;", #220B}, {"&notni;", #220C},
  {"&notniva;", #220C}, {"&NotReverseElement;", #220C}, {"&prod;", #220F},
  {"&Product;", #220F}, {"&coprod;", #2210}, {"&Coproduct;", #2210},
  {"&sum;", #2211}, {"&Sum;", #2211}, {"&minus;", #2212},
  {"&MinusPlus;", #2213}, {"&mnplus;", #2213}, {"&mp;", #2213},
  {"&dotplus;", #2214}, {"&plusdo;", #2214}, {"&Backslash;", #2216},
  {"&setminus;", #2216}, {"&setmn;", #2216}, {"&smallsetminus;", #2216},
  {"&ssetmn;", #2216}, {"&lowast;", #2217}, {"&compfn;", #2218},
  {"&SmallCircle;", #2218}, {"&radic;", #221A}, {"&Sqrt;", #221A},
  {"&prop;", #221D}, {"&Proportional;", #221D}, {"&propto;", #221D},
  {"&varpropto;", #221D}, {"&vprop;", #221D}, {"&infin;", #221E},
  {"&angrt;", #221F}, {"&ang;", #2220}, {"&angle;", #2220},
  {"&angmsd;", #2221}, {"&measuredangle;", #2221}, {"&angsph;", #2222},
  {"&mid;", #2223}, {"&shortmid;", #2223}, {"&smid;", #2223},
  {"&VerticalBar;", #2223}, {"&nmid;", #2224}, {"&NotVerticalBar;", #2224},
  {"&nshortmid;", #2224}, {"&nsmid;", #2224}, {"&DoubleVerticalBar;", #2225},
  {"&par;", #2225}, {"&parallel;", #2225}, {"&shortparallel;", #2225},
  {"&spar;", #2225}, {"&NotDoubleVerticalBar;", #2226}, {"&npar;", #2226},
  {"&nparallel;", #2226}, {"&nshortparallel;", #2226}, {"&nspar;", #2226},
  {"&and;", #2227}, {"&wedge;", #2227}, {"&or;", #2228}, {"&vee;", #2228},
  {"&cap;", #2229}, {"&cup;", #222A}, {"&int;", #222B}, {"&Integral;", #222B},
  {"&Int;", #222C}, {"&iiint;", #222D}, {"&tint;", #222D}, {"&conint;", #222E},
  {"&ContourIntegral;", #222E}, {"&oint;", #222E}, {"&Conint;", #222F},
  {"&DoubleContourIntegral;", #222F}, {"&Cconint;", #2230}, {"&cwint;", #2231},
  {"&ClockwiseContourIntegral;", #2232}, {"&cwconint;", #2232},
  {"&awconint;", #2233}, {"&CounterClockwiseContourIntegral;", #2233},
  {"&there4;", #2234}, {"&Therefore;", #2234}, {"&therefore;", #2234},
  {"&becaus;", #2235}, {"&Because;", #2235}, {"&because;", #2235},
  {"&ratio;", #2236}, {"&Colon;", #2237}, {"&Proportion;", #2237},
  {"&dotminus;", #2238}, {"&minusd;", #2238}, {"&mDDot;", #223A},
  {"&homtht;", #223B}, {"&sim;", #223C}, {"&thicksim;", #223C},
  {"&thksim;", #223C}, {"&Tilde;", #223C}, {"&backsim;", #223D},
  {"&bsim;", #223D}, {"&ac;", #223E}, {"&mstpos;", #223E}, {"&acd;", #223F},
  {"&VerticalTilde;", #2240}, {"&wr;", #2240}, {"&wreath;", #2240},
  {"&NotTilde;", #2241}, {"&nsim;", #2241}, {"&eqsim;", #2242},
  {"&EqualTilde;", #2242}, {"&esim;", #2242}, {"&sime;", #2243},
  {"&simeq;", #2243}, {"&TildeEqual;", #2243}, {"&NotTildeEqual;", #2244},
  {"&nsime;", #2244}, {"&nsimeq;", #2244}, {"&cong;", #2245},
  {"&TildeFullEqual;", #2245}, {"&simne;", #2246}, {"&ncong;", #2247},
  {"&NotTildeFullEqual;", #2247}, {"&ap;", #2248}, {"&approx;", #2248},
  {"&asymp;", #2248}, {"&thickapprox;", #2248}, {"&thkap;", #2248},
  {"&TildeTilde;", #2248}, {"&nap;", #2249}, {"&napprox;", #2249},
  {"&NotTildeTilde;", #2249}, {"&ape;", #224A}, {"&approxeq;", #224A},
  {"&apid;", #224B}, {"&backcong;", #224C}, {"&bcong;", #224C},
  {"&asympeq;", #224D}, {"&CupCap;", #224D}, {"&bump;", #224E},
  {"&Bumpeq;", #224E}, {"&HumpDownHump;", #224E}, {"&bumpe;", #224F},
  {"&bumpeq;", #224F}, {"&HumpEqual;", #224F}, {"&doteq;", #2250},
  {"&DotEqual;", #2250}, {"&esdot;", #2250}, {"&doteqdot;", #2251},
  {"&eDot;", #2251}, {"&efDot;", #2252}, {"&fallingdotseq;", #2252},
  {"&erDot;", #2253}, {"&risingdotseq;", #2253}, {"&Assign;", #2254},
  {"&colone;", #2254}, {"&coloneq;", #2254}, {"&ecolon;", #2255},
  {"&eqcolon;", #2255}, {"&ecir;", #2256}, {"&eqcirc;", #2256},
  {"&circeq;", #2257}, {"&cire;", #2257}, {"&wedgeq;", #2259},
  {"&veeeq;", #225A}, {"&triangleq;", #225C}, {"&trie;", #225C},
  {"&equest;", #225F}, {"&questeq;", #225F}, {"&ne;", #2260},
  {"&NotEqual;", #2260}, {"&Congruent;", #2261}, {"&equiv;", #2261},
  {"&nequiv;", #2262}, {"&NotCongruent;", #2262}, {"&le;", #2264},
  {"&leq;", #2264}, {"&ge;", #2265}, {"&geq;", #2265},
  {"&GreaterEqual;", #2265}, {"&lE;", #2266}, {"&leqq;", #2266},
  {"&LessFullEqual;", #2266}, {"&gE;", #2267}, {"&geqq;", #2267},
  {"&GreaterFullEqual;", #2267}, {"&lnE;", #2268}, {"&lneqq;", #2268},
  {"&gnE;", #2269}, {"&gneqq;", #2269}, {"&ll;", #226A}, {"&Lt;", #226A},
  {"&NestedLessLess;", #226A}, {"&gg;", #226B}, {"&Gt;", #226B},
  {"&NestedGreaterGreater;", #226B}, {"&between;", #226C}, {"&twixt;", #226C},
  {"&NotCupCap;", #226D}, {"&nless;", #226E}, {"&nlt;", #226E},
  {"&NotLess;", #226E}, {"&ngt;", #226F}, {"&ngtr;", #226F},
  {"&NotGreater;", #226F}, {"&nle;", #2270}, {"&nleq;", #2270},
  {"&NotLessEqual;", #2270}, {"&nge;", #2271}, {"&ngeq;", #2271},
  {"&NotGreaterEqual;", #2271}, {"&lesssim;", #2272}, {"&LessTilde;", #2272},
  {"&lsim;", #2272}, {"&GreaterTilde;", #2273}, {"&gsim;", #2273},
  {"&gtrsim;", #2273}, {"&nlsim;", #2274}, {"&NotLessTilde;", #2274},
  {"&ngsim;", #2275}, {"&NotGreaterTilde;", #2275}, {"&LessGreater;", #2276},
  {"&lessgtr;", #2276}, {"&lg;", #2276}, {"&gl;", #2277},
  {"&GreaterLess;", #2277}, {"&gtrless;", #2277}, {"&NotLessGreater;", #2278},
  {"&ntlg;", #2278}, {"&NotGreaterLess;", #2279}, {"&ntgl;", #2279},
  {"&pr;", #227A}, {"&prec;", #227A}, {"&Precedes;", #227A}, {"&sc;", #227B},
  {"&succ;", #227B}, {"&Succeeds;", #227B}, {"&prcue;", #227C},
  {"&preccurlyeq;", #227C}, {"&PrecedesSlantEqual;", #227C}, {"&sccue;", #227D},
  {"&succcurlyeq;", #227D}, {"&SucceedsSlantEqual;", #227D},
  {"&PrecedesTilde;", #227E}, {"&precsim;", #227E}, {"&prsim;", #227E},
  {"&scsim;", #227F}, {"&SucceedsTilde;", #227F}, {"&succsim;", #227F},
  {"&NotPrecedes;", #2280}, {"&npr;", #2280}, {"&nprec;", #2280},
  {"&NotSucceeds;", #2281}, {"&nsc;", #2281}, {"&nsucc;", #2281},
  {"&sub;", #2282}, {"&subset;", #2282}, {"&sup;", #2283},
  {"&Superset;", #2283}, {"&supset;", #2283}, {"&nsub;", #2284},
  {"&nsup;", #2285}, {"&sube;", #2286}, {"&subseteq;", #2286},
  {"&SubsetEqual;", #2286}, {"&supe;", #2287}, {"&SupersetEqual;", #2287},
  {"&supseteq;", #2287}, {"&NotSubsetEqual;", #2288}, {"&nsube;", #2288},
  {"&nsubseteq;", #2288}, {"&NotSupersetEqual;", #2289}, {"&nsupe;", #2289},
  {"&nsupseteq;", #2289}, {"&subne;", #228A}, {"&subsetneq;", #228A},
  {"&supne;", #228B}, {"&supsetneq;", #228B}, {"&cupdot;", #228D},
  {"&UnionPlus;", #228E}, {"&uplus;", #228E}, {"&sqsub;", #228F},
  {"&sqsubset;", #228F}, {"&SquareSubset;", #228F}, {"&sqsup;", #2290},
  {"&sqsupset;", #2290}, {"&SquareSuperset;", #2290}, {"&sqsube;", #2291},
  {"&sqsubseteq;", #2291}, {"&SquareSubsetEqual;", #2291}, {"&sqsupe;", #2292},
  {"&sqsupseteq;", #2292}, {"&SquareSupersetEqual;", #2292}, {"&sqcap;", #2293},
  {"&SquareIntersection;", #2293}, {"&sqcup;", #2294}, {"&SquareUnion;", #2294},
  {"&CirclePlus;", #2295}, {"&oplus;", #2295}, {"&CircleMinus;", #2296},
  {"&ominus;", #2296}, {"&CircleTimes;", #2297}, {"&otimes;", #2297},
  {"&osol;", #2298}, {"&CircleDot;", #2299}, {"&odot;", #2299},
  {"&circledcirc;", #229A}, {"&ocir;", #229A}, {"&circledast;", #229B},
  {"&oast;", #229B}, {"&circleddash;", #229D}, {"&odash;", #229D},
  {"&boxplus;", #229E}, {"&plusb;", #229E}, {"&boxminus;", #229F},
  {"&minusb;", #229F}, {"&boxtimes;", #22A0}, {"&timesb;", #22A0},
  {"&dotsquare;", #22A1}, {"&sdotb;", #22A1}, {"&RightTee;", #22A2},
  {"&vdash;", #22A2}, {"&dashv;", #22A3}, {"&LeftTee;", #22A3},
  {"&DownTee;", #22A4}, {"&top;", #22A4}, {"&bot;", #22A5}, {"&bottom;", #22A5},
  {"&perp;", #22A5}, {"&UpTee;", #22A5}, {"&models;", #22A7},
  {"&DoubleRightTee;", #22A8}, {"&vDash;", #22A8}, {"&Vdash;", #22A9},
  {"&Vvdash;", #22AA}, {"&VDash;", #22AB}, {"&nvdash;", #22AC},
  {"&nvDash;", #22AD}, {"&nVdash;", #22AE}, {"&nVDash;", #22AF},
  {"&prurel;", #22B0}, {"&LeftTriangle;", #22B2}, {"&vartriangleleft;", #22B2},
  {"&vltri;", #22B2}, {"&RightTriangle;", #22B3}, {"&vartriangleright;", #22B3},
  {"&vrtri;", #22B3}, {"&LeftTriangleEqual;", #22B4}, {"&ltrie;", #22B4},
  {"&trianglelefteq;", #22B4}, {"&RightTriangleEqual;", #22B5},
  {"&rtrie;", #22B5}, {"&trianglerighteq;", #22B5}, {"&origof;", #22B6},
  {"&imof;", #22B7}, {"&multimap;", #22B8}, {"&mumap;", #22B8},
  {"&hercon;", #22B9}, {"&intcal;", #22BA}, {"&intercal;", #22BA},
  {"&veebar;", #22BB}, {"&barvee;", #22BD}, {"&angrtvb;", #22BE},
  {"&lrtri;", #22BF}, {"&bigwedge;", #22C0}, {"&Wedge;", #22C0},
  {"&xwedge;", #22C0}, {"&bigvee;", #22C1}, {"&Vee;", #22C1}, {"&xvee;", #22C1},
  {"&bigcap;", #22C2}, {"&Intersection;", #22C2}, {"&xcap;", #22C2},
  {"&bigcup;", #22C3}, {"&Union;", #22C3}, {"&xcup;", #22C3}, {"&diam;", #22C4},
  {"&Diamond;", #22C4}, {"&diamond;", #22C4}, {"&sdot;", #22C5},
  {"&sstarf;", #22C6}, {"&Star;", #22C6}, {"&divideontimes;", #22C7},
  {"&divonx;", #22C7}, {"&bowtie;", #22C8}, {"&ltimes;", #22C9},
  {"&rtimes;", #22CA}, {"&leftthreetimes;", #22CB}, {"&lthree;", #22CB},
  {"&rightthreetimes;", #22CC}, {"&rthree;", #22CC}, {"&backsimeq;", #22CD},
  {"&bsime;", #22CD}, {"&curlyvee;", #22CE}, {"&cuvee;", #22CE},
  {"&curlywedge;", #22CF}, {"&cuwed;", #22CF}, {"&Sub;", #22D0},
  {"&Subset;", #22D0}, {"&Sup;", #22D1}, {"&Supset;", #22D1}, {"&Cap;", #22D2},
  {"&Cup;", #22D3}, {"&fork;", #22D4}, {"&pitchfork;", #22D4},
  {"&epar;", #22D5}, {"&lessdot;", #22D6}, {"&ltdot;", #22D6},
  {"&gtdot;", #22D7}, {"&gtrdot;", #22D7}, {"&Ll;", #22D8}, {"&Gg;", #22D9},
  {"&ggg;", #22D9}, {"&leg;", #22DA}, {"&lesseqgtr;", #22DA},
  {"&LessEqualGreater;", #22DA}, {"&gel;", #22DB},
  {"&GreaterEqualLess;", #22DB}, {"&gtreqless;", #22DB}, {"&cuepr;", #22DE},
  {"&curlyeqprec;", #22DE}, {"&cuesc;", #22DF}, {"&curlyeqsucc;", #22DF},
  {"&NotPrecedesSlantEqual;", #22E0}, {"&nprcue;", #22E0},
  {"&NotSucceedsSlantEqual;", #22E1}, {"&nsccue;", #22E1},
  {"&NotSquareSubsetEqual;", #22E2}, {"&nsqsube;", #22E2},
  {"&NotSquareSupersetEqual;", #22E3}, {"&nsqsupe;", #22E3},
  {"&lnsim;", #22E6}, {"&gnsim;", #22E7}, {"&precnsim;", #22E8},
  {"&prnsim;", #22E8}, {"&scnsim;", #22E9}, {"&succnsim;", #22E9},
  {"&nltri;", #22EA}, {"&NotLeftTriangle;", #22EA}, {"&ntriangleleft;", #22EA},
  {"&NotRightTriangle;", #22EB}, {"&nrtri;", #22EB},
  {"&ntriangleright;", #22EB}, {"&nltrie;", #22EC},
  {"&NotLeftTriangleEqual;", #22EC}, {"&ntrianglelefteq;", #22EC},
  {"&NotRightTriangleEqual;", #22ED}, {"&nrtrie;", #22ED},
  {"&ntrianglerighteq;", #22ED}, {"&vellip;", #22EE}, {"&ctdot;", #22EF},
  {"&utdot;", #22F0}, {"&dtdot;", #22F1}, {"&disin;", #22F2},
  {"&isinsv;", #22F3}, {"&isins;", #22F4}, {"&isindot;", #22F5},
  {"&notinvc;", #22F6}, {"&notinvb;", #22F7}, {"&isinE;", #22F9},
  {"&nisd;", #22FA}, {"&xnis;", #22FB}, {"&nis;", #22FC}, {"&notnivc;", #22FD},
  {"&notnivb;", #22FE}, {"&barwed;", #2305}, {"&barwedge;", #2305},
  {"&Barwed;", #2306}, {"&doublebarwedge;", #2306}, {"&lceil;", #2308},
  {"&LeftCeiling;", #2308}, {"&rceil;", #2309}, {"&RightCeiling;", #2309},
  {"&LeftFloor;", #230A}, {"&lfloor;", #230A}, {"&rfloor;", #230B},
  {"&RightFloor;", #230B}, {"&drcrop;", #230C}, {"&dlcrop;", #230D},
  {"&urcrop;", #230E}, {"&ulcrop;", #230F}, {"&bnot;", #2310},
  {"&profline;", #2312}, {"&profsurf;", #2313}, {"&telrec;", #2315},
  {"&target;", #2316}, {"&ulcorn;", #231C}, {"&ulcorner;", #231C},
  {"&urcorn;", #231D}, {"&urcorner;", #231D}, {"&dlcorn;", #231E},
  {"&llcorner;", #231E}, {"&drcorn;", #231F}, {"&lrcorner;", #231F},
  {"&frown;", #2322}, {"&sfrown;", #2322}, {"&smile;", #2323},
  {"&ssmile;", #2323}, {"&cylcty;", #232D}, {"&profalar;", #232E},
  {"&topbot;", #2336}, {"&ovbar;", #233D}, {"&solbar;", #233F},
  {"&angzarr;", #237C}, {"&lmoust;", #23B0}, {"&lmoustache;", #23B0},
  {"&rmoust;", #23B1}, {"&rmoustache;", #23B1}, {"&OverBracket;", #23B4},
  {"&tbrk;", #23B4}, {"&bbrk;", #23B5}, {"&UnderBracket;", #23B5},
  {"&bbrktbrk;", #23B6}, {"&OverParenthesis;", #23DC},
  {"&UnderParenthesis;", #23DD}, {"&OverBrace;", #23DE},
  {"&UnderBrace;", #23DF}, {"&trpezium;", #23E2}, {"&elinters;", #23E7},
  {"&blank;", #2423}, {"&circledS;", #24C8}, {"&oS;", #24C8}, {"&boxh;", #2500},
  {"&HorizontalLine;", #2500}, {"&boxv;", #2502}, {"&boxdr;", #250C},
  {"&boxdl;", #2510}, {"&boxur;", #2514}, {"&boxul;", #2518},
  {"&boxvr;", #251C}, {"&boxvl;", #2524}, {"&boxhd;", #252C},
  {"&boxhu;", #2534}, {"&boxvh;", #253C}, {"&boxH;", #2550}, {"&boxV;", #2551},
  {"&boxdR;", #2552}, {"&boxDr;", #2553}, {"&boxDR;", #2554},
  {"&boxdL;", #2555}, {"&boxDl;", #2556}, {"&boxDL;", #2557},
  {"&boxuR;", #2558}, {"&boxUr;", #2559}, {"&boxUR;", #255A},
  {"&boxuL;", #255B}, {"&boxUl;", #255C}, {"&boxUL;", #255D},
  {"&boxvR;", #255E}, {"&boxVr;", #255F}, {"&boxVR;", #2560},
  {"&boxvL;", #2561}, {"&boxVl;", #2562}, {"&boxVL;", #2563},
  {"&boxHd;", #2564}, {"&boxhD;", #2565}, {"&boxHD;", #2566},
  {"&boxHu;", #2567}, {"&boxhU;", #2568}, {"&boxHU;", #2569},
  {"&boxvH;", #256A}, {"&boxVh;", #256B}, {"&boxVH;", #256C},
  {"&uhblk;", #2580}, {"&lhblk;", #2584}, {"&block;", #2588},
  {"&blk14;", #2591}, {"&blk12;", #2592}, {"&blk34;", #2593},
  {"&squ;", #25A1}, {"&Square;", #25A1}, {"&square;", #25A1},
  {"&blacksquare;", #25AA}, {"&FilledVerySmallSquare;", #25AA},
  {"&squarf;", #25AA}, {"&squf;", #25AA}, {"&EmptyVerySmallSquare;", #25AB},
  {"&rect;", #25AD}, {"&marker;", #25AE}, {"&fltns;", #25B1},
  {"&bigtriangleup;", #25B3}, {"&xutri;", #25B3}, {"&blacktriangle;", #25B4},
  {"&utrif;", #25B4}, {"&triangle;", #25B5}, {"&utri;", #25B5},
  {"&blacktriangleright;", #25B8}, {"&rtrif;", #25B8}, {"&rtri;", #25B9},
  {"&triangleright;", #25B9}, {"&bigtriangledown;", #25BD}, {"&xdtri;", #25BD},
  {"&blacktriangledown;", #25BE}, {"&dtrif;", #25BE}, {"&dtri;", #25BF},
  {"&triangledown;", #25BF}, {"&blacktriangleleft;", #25C2}, {"&ltrif;", #25C2},
  {"&ltri;", #25C3}, {"&triangleleft;", #25C3}, {"&loz;", #25CA},
  {"&lozenge;", #25CA}, {"&cir;", #25CB}, {"&tridot;", #25EC},
  {"&bigcirc;", #25EF}, {"&xcirc;", #25EF}, {"&ultri;", #25F8},
  {"&urtri;", #25F9}, {"&lltri;", #25FA}, {"&EmptySmallSquare;", #25FB},
  {"&FilledSmallSquare;", #25FC}, {"&bigstar;", #2605}, {"&starf;", #2605},
  {"&star;", #2606}, {"&phone;", #260E}, {"&female;", #2640}, {"&male;", #2642},
  {"&spades;", #2660}, {"&spadesuit;", #2660}, {"&clubs;", #2663},
  {"&clubsuit;", #2663}, {"&hearts;", #2665}, {"&heartsuit;", #2665},
  {"&diamondsuit;", #2666}, {"&diams;", #2666}, {"&sung;", #266A},
  {"&flat;", #266D}, {"&natur;", #266E}, {"&natural;", #266E},
  {"&sharp;", #266F}, {"&check;", #2713}, {"&checkmark;", #2713},
  {"&cross;", #2717}, {"&malt;", #2720}, {"&maltese;", #2720},
  {"&sext;", #2736}, {"&VerticalSeparator;", #2758}, {"&lbbrk;", #2772},
  {"&rbbrk;", #2773}, {"&LeftDoubleBracket;", #27E6}, {"&lobrk;", #27E6},
  {"&RightDoubleBracket;", #27E7}, {"&robrk;", #27E7}, {"&lang;", #27E8},
  {"&langle;", #27E8}, {"&LeftAngleBracket;", #27E8}, {"&rang;", #27E9},
  {"&rangle;", #27E9}, {"&RightAngleBracket;", #27E9}, {"&Lang;", #27EA},
  {"&Rang;", #27EB}, {"&loang;", #27EC}, {"&roang;", #27ED},
  {"&LongLeftArrow;", #27F5}, {"&longleftarrow;", #27F5}, {"&xlarr;", #27F5},
  {"&LongRightArrow;", #27F6}, {"&longrightarrow;", #27F6}, {"&xrarr;", #27F6},
  {"&LongLeftRightArrow;", #27F7}, {"&longleftrightarrow;", #27F7},
  {"&xharr;", #27F7}, {"&DoubleLongLeftArrow;", #27F8},
  {"&Longleftarrow;", #27F8}, {"&xlArr;", #27F8},
  {"&DoubleLongRightArrow;", #27F9}, {"&Longrightarrow;", #27F9},
  {"&xrArr;", #27F9}, {"&DoubleLongLeftRightArrow;", #27FA},
  {"&Longleftrightarrow;", #27FA}, {"&xhArr;", #27FA}, {"&longmapsto;", #27FC},
  {"&xmap;", #27FC}, {"&dzigrarr;", #27FF}, {"&nvlArr;", #2902},
  {"&nvrArr;", #2903}, {"&nvHarr;", #2904}, {"&Map;", #2905},
  {"&lbarr;", #290C}, {"&bkarow;", #290D}, {"&rbarr;", #290D},
  {"&lBarr;", #290E}, {"&dbkarow;", #290F}, {"&rBarr;", #290F},
  {"&drbkarow;", #2910}, {"&RBarr;", #2910}, {"&DDotrahd;", #2911},
  {"&UpArrowBar;", #2912}, {"&DownArrowBar;", #2913}, {"&Rarrtl;", #2916},
  {"&latail;", #2919}, {"&ratail;", #291A}, {"&lAtail;", #291B},
  {"&rAtail;", #291C}, {"&larrfs;", #291D}, {"&rarrfs;", #291E},
  {"&larrbfs;", #291F}, {"&rarrbfs;", #2920}, {"&nwarhk;", #2923},
  {"&nearhk;", #2924}, {"&hksearow;", #2925}, {"&searhk;", #2925},
  {"&hkswarow;", #2926}, {"&swarhk;", #2926}, {"&nwnear;", #2927},
  {"&nesear;", #2928}, {"&toea;", #2928}, {"&seswar;", #2929},
  {"&tosa;", #2929}, {"&swnwar;", #292A}, {"&rarrc;", #2933},
  {"&cudarrr;", #2935}, {"&ldca;", #2936}, {"&rdca;", #2937},
  {"&cudarrl;", #2938}, {"&larrpl;", #2939}, {"&curarrm;", #293C},
  {"&cularrp;", #293D}, {"&rarrpl;", #2945}, {"&harrcir;", #2948},
  {"&Uarrocir;", #2949}, {"&lurdshar;", #294A}, {"&ldrushar;", #294B},
  {"&LeftRightVector;", #294E}, {"&RightUpDownVector;", #294F},
  {"&DownLeftRightVector;", #2950}, {"&LeftUpDownVector;", #2951},
  {"&LeftVectorBar;", #2952}, {"&RightVectorBar;", #2953},
  {"&RightUpVectorBar;", #2954}, {"&RightDownVectorBar;", #2955},
  {"&DownLeftVectorBar;", #2956}, {"&DownRightVectorBar;", #2957},
  {"&LeftUpVectorBar;", #2958}, {"&LeftDownVectorBar;", #2959},
  {"&LeftTeeVector;", #295A}, {"&RightTeeVector;", #295B},
  {"&RightUpTeeVector;", #295C}, {"&RightDownTeeVector;", #295D},
  {"&DownLeftTeeVector;", #295E}, {"&DownRightTeeVector;", #295F},
  {"&LeftUpTeeVector;", #2960}, {"&LeftDownTeeVector;", #2961},
  {"&lHar;", #2962}, {"&uHar;", #2963}, {"&rHar;", #2964}, {"&dHar;", #2965},
  {"&luruhar;", #2966}, {"&ldrdhar;", #2967}, {"&ruluhar;", #2968},
  {"&rdldhar;", #2969}, {"&lharul;", #296A}, {"&llhard;", #296B},
  {"&rharul;", #296C}, {"&lrhard;", #296D}, {"&udhar;", #296E},
  {"&UpEquilibrium;", #296E}, {"&duhar;", #296F},
  {"&ReverseUpEquilibrium;", #296F}, {"&RoundImplies;", #2970},
  {"&erarr;", #2971}, {"&simrarr;", #2972}, {"&larrsim;", #2973},
  {"&rarrsim;", #2974}, {"&rarrap;", #2975}, {"&ltlarr;", #2976},
  {"&gtrarr;", #2978}, {"&subrarr;", #2979}, {"&suplarr;", #297B},
  {"&lfisht;", #297C}, {"&rfisht;", #297D}, {"&ufisht;", #297E},
  {"&dfisht;", #297F}, {"&lopar;", #2985}, {"&ropar;", #2986},
  {"&lbrke;", #298B}, {"&rbrke;", #298C}, {"&lbrkslu;", #298D},
  {"&rbrksld;", #298E}, {"&lbrksld;", #298F}, {"&rbrkslu;", #2990},
  {"&langd;", #2991}, {"&rangd;", #2992}, {"&lparlt;", #2993},
  {"&rpargt;", #2994}, {"&gtlPar;", #2995}, {"&ltrPar;", #2996},
  {"&vzigzag;", #299A}, {"&vangrt;", #299C}, {"&angrtvbd;", #299D},
  {"&ange;", #29A4}, {"&range;", #29A5}, {"&dwangle;", #29A6},
  {"&uwangle;", #29A7}, {"&angmsdaa;", #29A8}, {"&angmsdab;", #29A9},
  {"&angmsdac;", #29AA}, {"&angmsdad;", #29AB}, {"&angmsdae;", #29AC},
  {"&angmsdaf;", #29AD}, {"&angmsdag;", #29AE}, {"&angmsdah;", #29AF},
  {"&bemptyv;", #29B0}, {"&demptyv;", #29B1}, {"&cemptyv;", #29B2},
  {"&raemptyv;", #29B3}, {"&laemptyv;", #29B4}, {"&ohbar;", #29B5},
  {"&omid;", #29B6}, {"&opar;", #29B7}, {"&operp;", #29B9},
  {"&olcross;", #29BB}, {"&odsold;", #29BC}, {"&olcir;", #29BE},
  {"&ofcir;", #29BF}, {"&olt;", #29C0}, {"&ogt;", #29C1}, {"&cirscir;", #29C2},
  {"&cirE;", #29C3}, {"&solb;", #29C4}, {"&bsolb;", #29C5}, {"&boxbox;", #29C9},
  {"&trisb;", #29CD}, {"&rtriltri;", #29CE}, {"&LeftTriangleBar;", #29CF},
  {"&RightTriangleBar;", #29D0}, {"&race;", #29DA}, {"&iinfin;", #29DC},
  {"&infintie;", #29DD}, {"&nvinfin;", #29DE}, {"&eparsl;", #29E3},
  {"&smeparsl;", #29E4}, {"&eqvparsl;", #29E5}, {"&blacklozenge;", #29EB},
  {"&lozf;", #29EB}, {"&RuleDelayed;", #29F4}, {"&dsol;", #29F6},
  {"&bigodot;", #2A00}, {"&xodot;", #2A00}, {"&bigoplus;", #2A01},
  {"&xoplus;", #2A01}, {"&bigotimes;", #2A02}, {"&xotime;", #2A02},
  {"&biguplus;", #2A04}, {"&xuplus;", #2A04}, {"&bigsqcup;", #2A06},
  {"&xsqcup;", #2A06}, {"&iiiint;", #2A0C}, {"&qint;", #2A0C},
  {"&fpartint;", #2A0D}, {"&cirfnint;", #2A10}, {"&awint;", #2A11},
  {"&rppolint;", #2A12}, {"&scpolint;", #2A13}, {"&npolint;", #2A14},
  {"&pointint;", #2A15}, {"&quatint;", #2A16}, {"&intlarhk;", #2A17},
  {"&pluscir;", #2A22}, {"&plusacir;", #2A23}, {"&simplus;", #2A24},
  {"&plusdu;", #2A25}, {"&plussim;", #2A26}, {"&plustwo;", #2A27},
  {"&mcomma;", #2A29}, {"&minusdu;", #2A2A}, {"&loplus;", #2A2D},
  {"&roplus;", #2A2E}, {"&Cross;", #2A2F}, {"&timesd;", #2A30},
  {"&timesbar;", #2A31}, {"&smashp;", #2A33}, {"&lotimes;", #2A34},
  {"&rotimes;", #2A35}, {"&otimesas;", #2A36}, {"&Otimes;", #2A37},
  {"&odiv;", #2A38}, {"&triplus;", #2A39}, {"&triminus;", #2A3A},
  {"&tritime;", #2A3B}, {"&intprod;", #2A3C}, {"&iprod;", #2A3C},
  {"&amalg;", #2A3F}, {"&capdot;", #2A40}, {"&ncup;", #2A42}, {"&ncap;", #2A43},
  {"&capand;", #2A44}, {"&cupor;", #2A45}, {"&cupcap;", #2A46},
  {"&capcup;", #2A47}, {"&cupbrcap;", #2A48}, {"&capbrcup;", #2A49},
  {"&cupcup;", #2A4A}, {"&capcap;", #2A4B}, {"&ccups;", #2A4C},
  {"&ccaps;", #2A4D}, {"&ccupssm;", #2A50}, {"&And;", #2A53}, {"&Or;", #2A54},
  {"&andand;", #2A55}, {"&oror;", #2A56}, {"&orslope;", #2A57},
  {"&andslope;", #2A58}, {"&andv;", #2A5A}, {"&orv;", #2A5B}, {"&andd;", #2A5C},
  {"&ord;", #2A5D}, {"&wedbar;", #2A5F}, {"&sdote;", #2A66},
  {"&simdot;", #2A6A}, {"&congdot;", #2A6D}, {"&easter;", #2A6E},
  {"&apacir;", #2A6F}, {"&apE;", #2A70}, {"&eplus;", #2A71}, {"&pluse;", #2A72},
  {"&Esim;", #2A73}, {"&Colone;", #2A74}, {"&Equal;", #2A75},
  {"&ddotseq;", #2A77}, {"&eDDot;", #2A77}, {"&equivDD;", #2A78},
  {"&ltcir;", #2A79}, {"&gtcir;", #2A7A}, {"&ltquest;", #2A7B},
  {"&gtquest;", #2A7C}, {"&leqslant;", #2A7D}, {"&les;", #2A7D},
  {"&LessSlantEqual;", #2A7D}, {"&geqslant;", #2A7E}, {"&ges;", #2A7E},
  {"&GreaterSlantEqual;", #2A7E}, {"&lesdot;", #2A7F}, {"&gesdot;", #2A80},
  {"&lesdoto;", #2A81}, {"&gesdoto;", #2A82}, {"&lesdotor;", #2A83},
  {"&gesdotol;", #2A84}, {"&lap;", #2A85}, {"&lessapprox;", #2A85},
  {"&gap;", #2A86}, {"&gtrapprox;", #2A86}, {"&lne;", #2A87}, {"&lneq;", #2A87},
  {"&gne;", #2A88}, {"&gneq;", #2A88}, {"&lnap;", #2A89}, {"&lnapprox;", #2A89},
  {"&gnap;", #2A8A}, {"&gnapprox;", #2A8A}, {"&lEg;", #2A8B},
  {"&lesseqqgtr;", #2A8B}, {"&gEl;", #2A8C}, {"&gtreqqless;", #2A8C},
  {"&lsime;", #2A8D}, {"&gsime;", #2A8E}, {"&lsimg;", #2A8F},
  {"&gsiml;", #2A90}, {"&lgE;", #2A91}, {"&glE;", #2A92}, {"&lesges;", #2A93},
  {"&gesles;", #2A94}, {"&els;", #2A95}, {"&eqslantless;", #2A95},
  {"&egs;", #2A96}, {"&eqslantgtr;", #2A96}, {"&elsdot;", #2A97},
  {"&egsdot;", #2A98}, {"&el;", #2A99}, {"&eg;", #2A9A}, {"&siml;", #2A9D},
  {"&simg;", #2A9E}, {"&simlE;", #2A9F}, {"&simgE;", #2AA0},
  {"&LessLess;", #2AA1}, {"&GreaterGreater;", #2AA2}, {"&glj;", #2AA4},
  {"&gla;", #2AA5}, {"&ltcc;", #2AA6}, {"&gtcc;", #2AA7}, {"&lescc;", #2AA8},
  {"&gescc;", #2AA9}, {"&smt;", #2AAA}, {"&lat;", #2AAB}, {"&smte;", #2AAC},
  {"&late;", #2AAD}, {"&bumpE;", #2AAE}, {"&pre;", #2AAF},
  {"&PrecedesEqual;", #2AAF}, {"&preceq;", #2AAF}, {"&sce;", #2AB0},
  {"&SucceedsEqual;", #2AB0}, {"&succeq;", #2AB0}, {"&prE;", #2AB3},
  {"&scE;", #2AB4}, {"&precneqq;", #2AB5}, {"&prnE;", #2AB5}, {"&scnE;", #2AB6},
  {"&succneqq;", #2AB6}, {"&prap;", #2AB7}, {"&precapprox;", #2AB7},
  {"&scap;", #2AB8}, {"&succapprox;", #2AB8}, {"&precnapprox;", #2AB9},
  {"&prnap;", #2AB9}, {"&scnap;", #2ABA}, {"&succnapprox;", #2ABA},
  {"&Pr;", #2ABB}, {"&Sc;", #2ABC}, {"&subdot;", #2ABD}, {"&supdot;", #2ABE},
  {"&subplus;", #2ABF}, {"&supplus;", #2AC0}, {"&submult;", #2AC1},
  {"&supmult;", #2AC2}, {"&subedot;", #2AC3}, {"&supedot;", #2AC4},
  {"&subE;", #2AC5}, {"&subseteqq;", #2AC5}, {"&supE;", #2AC6},
  {"&supseteqq;", #2AC6}, {"&subsim;", #2AC7}, {"&supsim;", #2AC8},
  {"&subnE;", #2ACB}, {"&subsetneqq;", #2ACB}, {"&supnE;", #2ACC},
  {"&supsetneqq;", #2ACC}, {"&csub;", #2ACF}, {"&csup;", #2AD0},
  {"&csube;", #2AD1}, {"&csupe;", #2AD2}, {"&subsup;", #2AD3},
  {"&supsub;", #2AD4}, {"&subsub;", #2AD5}, {"&supsup;", #2AD6},
  {"&suphsub;", #2AD7}, {"&supdsub;", #2AD8}, {"&forkv;", #2AD9},
  {"&topfork;", #2ADA}, {"&mlcp;", #2ADB}, {"&Dashv;", #2AE4},
  {"&DoubleLeftTee;", #2AE4}, {"&Vdashl;", #2AE6}, {"&Barv;", #2AE7},
  {"&vBar;", #2AE8}, {"&vBarv;", #2AE9}, {"&Vbar;", #2AEB}, {"&Not;", #2AEC},
  {"&bNot;", #2AED}, {"&rnmid;", #2AEE}, {"&cirmid;", #2AEF},
  {"&midcir;", #2AF0}, {"&topcir;", #2AF1}, {"&nhpar;", #2AF2},
  {"&parsim;", #2AF3}, {"&parsl;", #2AFD}, {"&fflig;", #FB00},
  {"&filig;", #FB01}, {"&fllig;", #FB02}, {"&ffilig;", #FB03},
  {"&ffllig;", #FB04}, {"&Ascr;", #1D49C}, {"&Cscr;", #1D49E},
  {"&Dscr;", #1D49F}, {"&Gscr;", #1D4A2}, {"&Jscr;", #1D4A5},
  {"&Kscr;", #1D4A6}, {"&Nscr;", #1D4A9}, {"&Oscr;", #1D4AA},
  {"&Pscr;", #1D4AB}, {"&Qscr;", #1D4AC}, {"&Sscr;", #1D4AE},
  {"&Tscr;", #1D4AF}, {"&Uscr;", #1D4B0}, {"&Vscr;", #1D4B1},
  {"&Wscr;", #1D4B2}, {"&Xscr;", #1D4B3}, {"&Yscr;", #1D4B4},
  {"&Zscr;", #1D4B5}, {"&ascr;", #1D4B6}, {"&bscr;", #1D4B7},
  {"&cscr;", #1D4B8}, {"&dscr;", #1D4B9}, {"&fscr;", #1D4BB},
  {"&hscr;", #1D4BD}, {"&iscr;", #1D4BE}, {"&jscr;", #1D4BF},
  {"&kscr;", #1D4C0}, {"&lscr;", #1D4C1}, {"&mscr;", #1D4C2},
  {"&nscr;", #1D4C3}, {"&pscr;", #1D4C5}, {"&qscr;", #1D4C6},
  {"&rscr;", #1D4C7}, {"&sscr;", #1D4C8}, {"&tscr;", #1D4C9},
  {"&uscr;", #1D4CA}, {"&vscr;", #1D4CB}, {"&wscr;", #1D4CC},
  {"&xscr;", #1D4CD}, {"&yscr;", #1D4CE}, {"&zscr;", #1D4CF},
  {"&Afr;", #1D504}, {"&Bfr;", #1D505}, {"&Dfr;", #1D507}, {"&Efr;", #1D508},
  {"&Ffr;", #1D509}, {"&Gfr;", #1D50A}, {"&Jfr;", #1D50D}, {"&Kfr;", #1D50E},
  {"&Lfr;", #1D50F}, {"&Mfr;", #1D510}, {"&Nfr;", #1D511}, {"&Ofr;", #1D512},
  {"&Pfr;", #1D513}, {"&Qfr;", #1D514}, {"&Sfr;", #1D516}, {"&Tfr;", #1D517},
  {"&Ufr;", #1D518}, {"&Vfr;", #1D519}, {"&Wfr;", #1D51A}, {"&Xfr;", #1D51B},
  {"&Yfr;", #1D51C}, {"&afr;", #1D51E}, {"&bfr;", #1D51F}, {"&cfr;", #1D520},
  {"&dfr;", #1D521}, {"&efr;", #1D522}, {"&ffr;", #1D523}, {"&gfr;", #1D524},
  {"&hfr;", #1D525}, {"&ifr;", #1D526}, {"&jfr;", #1D527}, {"&kfr;", #1D528},
  {"&lfr;", #1D529}, {"&mfr;", #1D52A}, {"&nfr;", #1D52B}, {"&ofr;", #1D52C},
  {"&pfr;", #1D52D}, {"&qfr;", #1D52E}, {"&rfr;", #1D52F}, {"&sfr;", #1D530},
  {"&tfr;", #1D531}, {"&ufr;", #1D532}, {"&vfr;", #1D533}, {"&wfr;", #1D534},
  {"&xfr;", #1D535}, {"&yfr;", #1D536}, {"&zfr;", #1D537}, {"&Aopf;", #1D538},
  {"&Bopf;", #1D539}, {"&Dopf;", #1D53B}, {"&Eopf;", #1D53C},
  {"&Fopf;", #1D53D}, {"&Gopf;", #1D53E}, {"&Iopf;", #1D540},
  {"&Jopf;", #1D541}, {"&Kopf;", #1D542}, {"&Lopf;", #1D543},
  {"&Mopf;", #1D544}, {"&Oopf;", #1D546}, {"&Sopf;", #1D54A},
  {"&Topf;", #1D54B}, {"&Uopf;", #1D54C}, {"&Vopf;", #1D54D},
  {"&Wopf;", #1D54E}, {"&Xopf;", #1D54F}, {"&Yopf;", #1D550},
  {"&aopf;", #1D552}, {"&bopf;", #1D553}, {"&copf;", #1D554},
  {"&dopf;", #1D555}, {"&eopf;", #1D556}, {"&fopf;", #1D557},
  {"&gopf;", #1D558}, {"&hopf;", #1D559}, {"&iopf;", #1D55A},
  {"&jopf;", #1D55B}, {"&kopf;", #1D55C}, {"&lopf;", #1D55D},
  {"&mopf;", #1D55E}, {"&nopf;", #1D55F}, {"&oopf;", #1D560},
  {"&popf;", #1D561}, {"&qopf;", #1D562}, {"&ropf;", #1D563},
  {"&sopf;", #1D564}, {"&topf;", #1D565}, {"&uopf;", #1D566},
  {"&vopf;", #1D567}, {"&wopf;", #1D568}, {"&xopf;", #1D569},
  {"&yopf;", #1D56A}, {"&zopf;", #1D56B}
}

constant UTF8_URL_ENCODING = {
  {#80, "%E2%82%AC"},  {#81, "%81"},        {#82, "%E2%80%9A"},
  {#83, "%C6%92"},     {#84, "%E2%80%9E"},  {#85, "%E2%80%A6"},
  {#86, "%E2%80%A0"},  {#87, "%E2%80%A1"},  {#88, "%CB%86"},
  {#89, "%E2%80%B0"},  {#8A, "%C5%A0"},     {#8B, "%E2%80%B9"},
  {#8C, "%C5%92"},     {#8D, "%C5%8D"},     {#8E, "%C5%BD"},
  {#8F, "%8F"},        {#90, "%C2%90"},     {#91, "%E2%80%98"},
  {#92, "%E2%80%99"},  {#93, "%E2%80%9C"},  {#94, "%E2%80%9D"},
  {#95, "%E2%80%A2"},  {#96, "%E2%80%93"},  {#97, "%E2%80%94"},
  {#98, "%CB%9C"},     {#99, "%E2%84"},     {#9A, "%C5%A1"},
  {#9B, "%E2%80"},     {#9C, "%C5%93"},     {#9D, "%9D"},
  {#9E, "%C5%BE"},     {#9F, "%C5%B8"},     {#A0, "%C2%A0"},
  {#A1, "%C2%A1"},     {#A2, "%C2%A2"},     {#A3, "%C2%A3"},
  {#A4, "%C2%A4"},     {#A5, "%C2%A5"},     {#A6, "%C2%A6"},
  {#A7, "%C2%A7"},     {#A8, "%C2%A8"},     {#A9, "%C2%A9"},
  {#AA, "%C2%AA"},     {#AB, "%C2%AB"},     {#AC, "%C2%AC"},
  {#AD, "%C2%AD"},     {#AE, "%C2%AE"},     {#AF, "%C2%AF"},
  {#B0, "%C2%B0"},     {#B1, "%C2%B1"},     {#B2, "%C2%B2"},
  {#B3, "%C2%B3"},     {#B4, "%C2%B4"},     {#B5, "%C2%B5"},
  {#B6, "%C2%B6"},     {#B7, "%C2%B7"},     {#B8, "%C2%B8"},
  {#B9, "%C2%B9"},     {#BA, "%C2%BA"},     {#BB, "%C2%BB"},
  {#BC, "%C2%BC"},     {#BD, "%C2%BD"},     {#BE, "%C2%BE"},
  {#BF, "%C2%BF"},     {#C0, "%C3%80"},     {#C1, "%C3%81"},
  {#C2, "%C3%82"},     {#C3, "%C3%83"},     {#C4, "%C3%84"},
  {#C5, "%C3%85"},     {#C6, "%C3%86"},     {#C7, "%C3%87"},
  {#C8, "%C3%88"},     {#C9, "%C3%89"},     {#CA, "%C3%8A"},
  {#CB, "%C3%8B"},     {#CC, "%C3%8C"},     {#CD, "%C3%8D"},
  {#CE, "%C3%8E"},     {#CF, "%C3%8F"},     {#D0, "%C3%90"},
  {#D1, "%C3%91"},     {#D2, "%C3%92"},     {#D3, "%C3%93"},
  {#D4, "%C3%94"},     {#D5, "%C3%95"},     {#D6, "%C3%96"},
  {#D7, "%C3%97"},     {#D8, "%C3%98"},     {#D9, "%C3%99"},
  {#DA, "%C3%9A"},     {#DB, "%C3%9B"},     {#DC, "%C3%9C"},
  {#DD, "%C3%9D"},     {#DE, "%C3%9E"},     {#DF, "%C3%9F"},
  {#E0, "%C3%A0"},     {#E1, "%C3%A1"},     {#E2, "%C3%A2"},
  {#E3, "%C3%A3"},     {#E4, "%C3%A4"},     {#E5, "%C3%A5"},
  {#E6, "%C3%A6"},     {#E7, "%C3%A7"},     {#E8, "%C3%A8"},
  {#E9, "%C3%A9"},     {#EA, "%C3%AA"},     {#EB, "%C3%AB"},
  {#EC, "%C3%AC"},     {#ED, "%C3%AD"},     {#EE, "%C3%AE"},
  {#EF, "%C3%AF"},     {#F0, "%C3%B0"},     {#F1, "%C3%B1"},
  {#F2, "%C3%B2"},     {#F3, "%C3%B3"},     {#F4, "%C3%B4"},
  {#F5, "%C3%B5"},     {#F6, "%C3%B6"},     {#F7, "%C3%B7"},
  {#F8, "%C3%B8"},     {#F9, "%C3%B9"},     {#FA, "%C3%BA"},
  {#FB, "%C3%BB"},     {#FC, "%C3%BC"},     {#FD, "%C3%BD"},
  {#FE, "%C3%BE"},     {#FF, "%C3%BF"}
}

------------------------------------------------------------------------------

public function html_to_ascii(sequence s)
--<function>
--<name>html_to_ascii</name>
--<digest>converts an HTML string to an ASCII string</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- s = html_to_ascii("&amp;lt;tag&amp;nbsp;string=&amp;quot;&amp;eacute;l&amp;eacute;gant&amp;quot;&amp;nbsp;/&amp;gt;")
-- s is "&lt;tag&nbsp;string=&quot;&eacute;l&eacute;gant&quot;&nbsp;/&gt;"
--</example>
--<see_also>html_to_utf8(), ascii_to_html(), utf8_to_html()</see_also>
--</function>
  sequence htmlChar
  object htmlNum
  integer st, en

--  log_puts("\n"&s&"\n")
  htmlChar = ""
  st = find('&',s)
  while st>0 do
    en = find(';', s, st+1)
    if en>0 then
      htmlChar = s[st..en]
      --log_puts("htmlChar="&htmlChar&"\n")
      if s[st+1] = '#' then
        if s[st+2] = 'x' then
          s = replace_all(s, htmlChar, {to_number("#"&htmlChar[4..$-1])})
        else
          s = replace_all(s, htmlChar, {to_number(htmlChar[3..$-1])})
        end if
      else
        htmlNum = vlookup(htmlChar, HTML5_ENTITIES, 1, 2, "?")
        if integer(htmlNum) then
          s = replace_all(s, htmlChar, {htmlNum})
        end if
      end if
    else
      exit
    end if
    st = find('&', s, st+1)
  end while
--  log_puts(s&"\n\n")
  return s
end function

------------------------------------------------------------------------------

public function ascii_to_html(sequence s)
--<function>
--<name>ascii_to_html</name>
--<digest>converts an ASCII string to an HTML string</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to convert</desc>
--</param>
--<return>
--</return>
--<example>
-- s = ascii_to_html("&lt;tag&nbsp;string=&quot;&eacute;l&eacute;gant&quot;&nbsp;/&gt;")
-- s is &amp;lt;tag&amp;nbsp;string=&amp;quot;&amp;eacute;l&amp;eacute;gant&amp;quot;&amp;nbsp;/&amp;gt;
--</example>
--<see_also>html_to_ascii(), html_to_utf8(), utf8_to_html()</see_also>
--</function>
  object o
  sequence res

  res = ""
  for i = 1 to length(s) do
    o = vlookup(s[i], HTML5_ENTITIES, 2, 1, 0)
    -- analyze_object(o, "o", f_debug)
    if atom(o) then
      res &= s[i]
    else
      res &= o
    end if
  end for
  return res
end function

------------------------------------------------------------------------------

public function html_to_utf8(sequence s)
--<function>
--<name>html_to_utf8</name>
--<digest>converts an HTML string to an UTF-8 string</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to convert</desc>
--</param>
--<return>
--</return>
--<example>
-- s = html_to_utf8("&amp;lt;tag&amp;nbsp;string=&amp;quot;&amp;eacute;l&amp;eacute;gant&amp;quot;&amp;nbsp;/&amp;gt;")
-- s is "&lt;tag&nbsp;string=&quot;&Atilde;&#x81;l&Atilde;&#x81;gant&quot;&nbsp;/&gt;" (ascii)
-- s is "&lt;tag&nbsp;string=&quot;&eacute;l&eacute;gant&quot;&nbsp;/&gt;" (utf-8)
--</example>
--<see_also>html_to_ascii(), ascii_to_html(), utf8_to_html()</see_also>
--</function>
  return ascii_to_utf8(html_to_ascii(s))
end function

------------------------------------------------------------------------------

public function utf8_to_html(sequence s)
--<function>
--<name>utf8_to_html</name>
--<digest>converts an UTF-8 string to an HTML string</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to convert</desc>
--</param>
--<return>
--</return>
--<example>
-- s2 = "&lt;tag&nbsp;string=&quot;&Atilde;&#x81;l&Atilde;&#x81;gant&quot;&nbsp;/&gt;" (ascii)
-- s2 = "&lt;tag&nbsp;string=&quot;&eacute;l&eacute;gant&quot;&nbsp;/&gt;" (utf-8)
-- s = utf8_to_html(s2)
-- s is &amp;lt;tag&amp;nbsp;string=&amp;quot;&amp;eacute;l&amp;eacute;gant&amp;quot;&amp;nbsp;/&amp;gt;
--</example>
--<see_also>html_to_ascii(), html_to_utf8(), ascii_to_html()</see_also>
--</function>
  return ascii_to_html(utf8_to_ascii(s))
end function

------------------------------------------------------------------------------

public function encode_url(sequence s, integer utf8=0)
--<function>
--<name>encode_url</name>
--<digest>encodes and URL</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to ancode</desc>
--</param>
--<param>
--<type>integer</type>
--<name>utf8</name>
--<desc>
-- encode result in UTF-8 if present
--</desc>
--</param>
--<return>
--</return>
--<example>
-- request = "https://www.google.fr/search?q=&eacute;l&eacute;gant"
-- s = encode_url(request)
-- s is https%3A%2F%2Fwww%2Egoogle%2Efr%2Fsearch%3Fq%3D%E9l%E9gant
-- s = encode_url(request, 1)
-- s is https%3A%2F%2Fwww%2Egoogle%2Efr%2Fsearch%3Fq%3D%C3%A9l%C3%A9gant
--</example>
--<see_also>decode_url()</see_also>
--</function>
  sequence res

  res = ""
  for i = 1 to length(s) do
    if ((s[i] >= #20) and (s[i] <= #40)) or
       ((s[i] >= #5B) and (s[i] <= #60)) or
       ((s[i] >= #7B) and (s[i] <= #7F)) then
      res &= sprintf("%%%02x", s[i])
    elsif s[i] >= #80 then
      if utf8 then
        res &= vlookup(s[i], UTF8_URL_ENCODING, 1, 2, {})
      else
        res &= sprintf("%%%02x", s[i])
      end if
    else
      res &= s[i]
    end if
  end for
  return res
end function

------------------------------------------------------------------------------

public function decode_url(sequence s, integer utf8=0)
--<function>
--<name>decode_url</name>
--<digest>decodes an URL</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to decode</desc>
--</param>
--<param>
--<type>integer</type>
--<name>utf8</name>
--<desc>
-- decode UTF-8 url if present
--</desc>
--</param>
--<return>
--</return>
--<example>
-- s = https%3A%2F%2Fwww%2Egoogle%2Efr%2Fsearch%3Fq%3D%E9l%E9gant
-- s2 = decode_url(s)
-- s2 is https://www.google.fr/search?q=&eacute;l&eacute;gant
-- s = https%3A%2F%2Fwww%2Egoogle%2Efr%2Fsearch%3Fq%3D%C3%A9l%C3%A9gant
-- s2 = decode_url(s, 1)
-- s2 is:
-- https://www.google.fr/search?q=&Atilde;&#x81;l&Atilde;&#x81;gant (ascii)
-- https://www.google.fr/search?q=&eacute;l&eacute;gant (utf-8)
--</example>
--<see_also>encode_url</see_also>
--</function>
  sequence percent_code
  integer st, en, new

  st = find('%',s)
  while st>0 do
    en = st
    while s[en+2] = '%' do
      en += 3
    end while
    percent_code = s[st..en+2]
    if utf8 and (length(percent_code) > 3) then
      new = vlookup(percent_code, UTF8_URL_ENCODING, 2, 1, {})
    else
      new = to_number("#" & percent_code[2..$])
    end if
    s = replace_all(s, percent_code, {new})
    st = find('%', s)
  end while
  return s
end function

