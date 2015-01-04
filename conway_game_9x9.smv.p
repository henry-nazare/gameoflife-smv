#ifndef CHECK_LONGEVITY
#define CHECK_LONGEVITY   0
#endif
#ifndef CHECK_DEATH
#define CHECK_DEATH       0
#endif
#ifndef CHECK_STABLE
#define CHECK_STABLE      0
#endif
#ifndef CHECK_PERIOD1
#define CHECK_PERIOD1     0
#endif
#ifndef CHECK_PERIOD2
#define CHECK_PERIOD2     0
#endif
#ifndef CHECK_ALLFLIPONCE
#define CHECK_ALLFLIPONCE 0
#endif
#ifndef CHECK_ALLFLIPINF
#define CHECK_ALLFLIPINF  0
#endif
#ifndef CHECK_ONEFLIPONCE
#define CHECK_ONEFLIPONCE 0
#endif
#ifndef CHECK_ONEFLIPINF
#define CHECK_ONEFLIPINF  0
#endif

#ifndef GRID_BLOCK
#define GRID_BLOCK   0
#endif
#ifndef GRID_BLINKER
#define GRID_BLINKER 0
#endif
#ifndef GRID_DIE
#define GRID_DIE     0
#endif

#define GRID_SIZE 9

#define INITWITH3(N, N0, N1, N2) \
  init(grid[N]) := grid_init[N]; \
  next(grid[N]) := \
  case \
    grid[N] = 1 & grid[N0] + grid[N1] + grid[N2] = 2: 1; \
    grid[N0] + grid[N1] + grid[N2] = 3: 1; \
    TRUE: 0; \
  esac

#define INITWITH5(N, N0, N1, N2, N3, N4) \
  init(grid[N]) := grid_init[N]; \
  next(grid[N]) := \
  case \
    grid[N] = 1 & grid[N0] + grid[N1] + grid[N2] + grid[N3] + grid[N4] = 2: 1; \
    grid[N0] + grid[N1] + grid[N2] + grid[N3] + grid[N4] = 3: 1; \
    TRUE: 0; \
  esac

#define INITWITH8(N, N0, N1, N2, N3, N4, N5, N6, N7) \
  init(grid[N]) := grid_init[N]; \
  next(grid[N]) := \
  case \
    grid[N] = 1 & grid[N0] + grid[N1] + grid[N2] + grid[N3] + grid[N4] + grid[N5] + grid[N6] + grid[N7] = 2: 1; \
    grid[N0] + grid[N1] + grid[N2] + grid[N3] + grid[N4] + grid[N5] + grid[N6] + grid[N7] = 3: 1; \
    TRUE: 0; \
  esac

#define UPPER_LEFT(N)  INITWITH3(N, N + 1, N + GRID_SIZE, N + GRID_SIZE + 1)
#define UPPER_RIGHT(N) INITWITH3(N, N - 1, N + GRID_SIZE - 1, N + GRID_SIZE)
#define LOWER_LEFT(N)  INITWITH3(N, N - GRID_SIZE, N - GRID_SIZE + 1, N + 1)
#define LOWER_RIGHT(N) INITWITH3(N, N - GRID_SIZE - 1, N - GRID_SIZE, N - 1)

#define LEFT(N)        INITWITH5(N, N - GRID_SIZE, N - GRID_SIZE + 1, N + 1, N + GRID_SIZE, N + GRID_SIZE + 1)
#define RIGHT(N)       INITWITH5(N, N - GRID_SIZE - 1, N - GRID_SIZE, N - 1, N + GRID_SIZE - 1, N + GRID_SIZE)
#define UPPER(N)       INITWITH5(N, N - 1, N + 1, N + GRID_SIZE - 1, N + GRID_SIZE, N + GRID_SIZE + 1)
#define LOWER(N)       INITWITH5(N, N - GRID_SIZE - 1, N - GRID_SIZE, N - GRID_SIZE + 1, N - 1, N + 1)

#define CENTER(N) INITWITH8(N, N - GRID_SIZE - 1, N - GRID_SIZE, N - GRID_SIZE + 1, N - 1, N + 1, N + GRID_SIZE - 1, N + GRID_SIZE, N + GRID_SIZE + 1)

MODULE main
  VAR grid : array 0..80 of {0,1};

  #if GRID_BLINKER == 1
  DEFINE grid_init_blinker := [ 0, 0, 0, 0, 0, 0, 0, 0, 0
                              , 0, 1, 0, 0, 0, 0, 0, 0, 0
                              , 0, 1, 0, 0, 0, 0, 0, 0, 0
                              , 0, 1, 0, 0, 0, 0, 0, 0, 0
                              , 0, 0, 0, 0, 0, 0, 0, 0, 0
                              , 0, 0, 0, 0, 0, 0, 0, 0, 0
                              , 0, 0, 0, 0, 0, 0, 0, 0, 0
                              , 0, 0, 0, 0, 0, 0, 0, 0, 0
                              , 0, 0, 0, 0, 0, 0, 0, 0, 0 ];

  DEFINE grid_init := grid_init_blinker;
  #endif

  #if GRID_BLOCK == 1
  DEFINE grid_init_block := [ 0, 0, 0, 0, 0, 0, 0, 0, 0
                            , 0, 0, 0, 0, 0, 0, 0, 0, 0
                            , 1, 1, 0, 0, 0, 0, 0, 0, 0
                            , 1, 1, 0, 0, 0, 0, 0, 0, 0
                            , 0, 0, 0, 0, 0, 0, 0, 0, 0
                            , 0, 0, 0, 0, 0, 0, 0, 0, 0
                            , 0, 0, 0, 0, 0, 0, 0, 0, 0
                            , 0, 0, 0, 0, 0, 0, 0, 0, 0
                            , 0, 0, 0, 0, 0, 0, 0, 0, 0 ];

  DEFINE grid_init := grid_init_block;
  #endif

  DEFINE grid_sum := grid[0] + grid[1] + grid[2] + grid[3] + grid[4] + grid[5] + grid[6] + grid[7] +
                     grid[8] + grid[9] + grid[10] + grid[11] + grid[12] + grid[13] + grid[14] + grid[15] +
                     grid[16] + grid[17] + grid[18] + grid[19] + grid[20] + grid[21] + grid[22] + grid[23] +
                     grid[24] + grid[25] + grid[26] + grid[27] + grid[28] + grid[29] + grid[30] + grid[31] +
                     grid[32] + grid[33] + grid[34] + grid[35] + grid[36] + grid[37] + grid[38] + grid[39] +
                     grid[40] + grid[41] + grid[42] + grid[43] + grid[44] + grid[45] + grid[46] + grid[47] +
                     grid[48] + grid[49] + grid[50] + grid[51] + grid[52] + grid[53] + grid[54] + grid[55] +
                     grid[56] + grid[57] + grid[58] + grid[59] + grid[60] + grid[61] + grid[62] + grid[63] +
                     grid[64] + grid[65] + grid[66] + grid[67] + grid[68] + grid[69] + grid[70] + grid[71] +
                     grid[72] + grid[73] + grid[74] + grid[75] + grid[76] + grid[77] + grid[78] + grid[79] +
                     grid[80];

ASSIGN
  -- Rules:
  -- Live cells with 2 or 3 live neighbours live on.
  -- Dead cells with 3 live neighbours come alive.
  -- Anything else dies or remains dead.

  UPPER_LEFT(0);
  UPPER_RIGHT(8);

  LOWER_LEFT(72);
  LOWER_RIGHT(80);

  UPPER(1);
  UPPER(2);
  UPPER(3);
  UPPER(4);
  UPPER(5);
  UPPER(7);

  LEFT(9);
  LEFT(18);
  LEFT(27);
  LEFT(36);
  LEFT(45);
  LEFT(54);
  LEFT(63);

  RIGHT(17);
  RIGHT(26);
  RIGHT(35);
  RIGHT(44);
  RIGHT(53);
  RIGHT(62);
  RIGHT(71);

  LOWER(73);
  LOWER(74);
  LOWER(75);
  LOWER(76);
  LOWER(77);
  LOWER(78);
  LOWER(79);

  CENTER(10);
  CENTER(11);
  CENTER(12);
  CENTER(13);
  CENTER(14);
  CENTER(15);
  CENTER(16);

  CENTER(19);
  CENTER(20);
  CENTER(21);
  CENTER(22);
  CENTER(23);
  CENTER(24);
  CENTER(25);

  CENTER(28);
  CENTER(29);
  CENTER(30);
  CENTER(31);
  CENTER(32);
  CENTER(33);
  CENTER(34);

  CENTER(37);
  CENTER(38);
  CENTER(39);
  CENTER(40);
  CENTER(41);
  CENTER(42);
  CENTER(43);

  CENTER(46);
  CENTER(47);
  CENTER(48);
  CENTER(49);
  CENTER(50);
  CENTER(51);
  CENTER(52);

  CENTER(55);
  CENTER(56);
  CENTER(57);
  CENTER(58);
  CENTER(59);
  CENTER(60);
  CENTER(61);

  CENTER(64);
  CENTER(65);
  CENTER(66);
  CENTER(67);
  CENTER(68);
  CENTER(69);
  CENTER(70);

#define APPLY_ALL(F, SEP) \
  F(0) SEP F(1) SEP F(2) SEP F(3) SEP F(4) SEP \
  F(5) SEP F(6) SEP F(7) SEP F(8) SEP F(9) SEP \
  F(10) SEP F(11) SEP F(12) SEP F(13) SEP F(14) SEP \
  F(15) SEP F(16) SEP F(17) SEP F(18) SEP (19) SEP \
  F(20) SEP F(21) SEP F(22) SEP F(23) SEP F(24) SEP \
  F(25) SEP F(26) SEP F(27) SEP F(28) SEP (29) SEP \
  F(30) SEP F(31) SEP F(32) SEP F(33) SEP F(34) SEP \
  F(35) SEP F(36) SEP F(37) SEP F(38) SEP (39) SEP \
  F(40) SEP F(41) SEP F(42) SEP F(43) SEP F(44) SEP \
  F(45) SEP F(46) SEP F(47) SEP F(48) SEP (49) SEP \
  F(50) SEP F(51) SEP F(52) SEP F(53) SEP F(54) SEP \
  F(45) SEP F(46) SEP F(47) SEP F(48) SEP (49) SEP \
  F(60) SEP F(61) SEP F(62) SEP F(63) SEP F(64) SEP \
  F(65) SEP F(66) SEP F(67) SEP F(68) SEP (69) SEP \
  F(70) SEP F(71) SEP F(72) SEP F(73) SEP F(74) SEP \
  F(75) SEP F(76) SEP F(77) SEP F(78) SEP (79) SEP F(80)

#if CHECK_LONGEVITY == 1
-- Longevity.
SPEC
AG(grid_sum != 0);
#endif

#if CHECK_DEATH == 1
-- Death.
SPEC
AG(grid_sum = 0);
#endif

#if CHECK_STABLE == 1
-- Stability / Halt.
#define STABLE(N) (((grid[N] = 1) -> (AG(grid[N] = 1))) & ((grid[N] = 0) -> (AG(grid[N] = 0))))
SPEC
EF(APPLY_ALL(STABLE, &));
#endif

#if CHECK_ALLFLIPONCE == 1 | CHECK_ALLFLIPINF == 1 | CHECK_ONEFLIPONCE == 1 | CHECK_ONEFLIPINF == 1
-- Cell flipping.
#define FLIP(N) (((grid[N] = 1) -> (EF(grid[N] = 0))) & ((grid[N] = 0) -> (EF(grid[N] = 1))))
#if CHECK_ALLFLIPONCE == 1
-- All cells are flipped at least once.
SPEC
EF(APPLY_ALL(FLIP, &));
#endif

#if CHECK_ALLFLIPINF
-- All cells are flipped infinetly frequently.
SPEC
AG(APPLY_ALL(FLIP, &));
#endif

#if CHECK_ONEFLIPONCE == 1
-- At least once cell is flipped -> initial configuration unstable.
SPEC
EF(APPLY_ALL(FLIP, |));
#endif

#if CHECK_ONEFLIPINF == 1
-- At least one cell is flipped infinetly frequently.
SPEC
AG(APPLY_ALL(FLIP, |));
#endif
#endif
