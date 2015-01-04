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

#define GRID_SIZE 4

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
  VAR grid : array 0..15 of {0,1};

  #if GRID_BLINKER == 1
  DEFINE grid_init_blinker := [ 0, 0, 0, 0
                              , 0, 1, 0, 0
                              , 0, 1, 0, 0
                              , 0, 1, 0, 0 ];
  DEFINE grid_init := grid_init_blinker;
  #endif

  #if GRID_BLOCK == 1
  DEFINE grid_init_block := [ 0, 0, 0, 0
                            , 0, 0, 0, 0
                            , 1, 1, 0, 0
                            , 1, 1, 0, 0 ];
  DEFINE grid_init := grid_init_block;
  #endif

  #if GRID_DIE == 1
  DEFINE grid_init_die := [ 0, 0, 0, 0
                          , 0, 1, 0, 0
                          , 0, 0, 0, 0
                          , 0, 0, 0, 1 ];
  DEFINE grid_init := grid_init_die;
  #endif


  DEFINE grid_sum := grid[0] + grid[1] + grid[2] + grid[3] + grid[4] + grid[5] + grid[6] + grid[7] +
                     grid[8] + grid[9] + grid[10] + grid[11] + grid[12] + grid[13] + grid[14] + grid[15];

ASSIGN
  -- Rules:
  -- Live cells with 2 or 3 live neighbours live on.
  -- Dead cells with 3 live neighbours come alive.
  -- Anything else dies or remains dead.

  UPPER_LEFT(0);
  UPPER_RIGHT(3);
  LOWER_LEFT(12);
  LOWER_RIGHT(15);
  UPPER(1);
  UPPER(2);
  LEFT(4);
  LEFT(8);
  RIGHT(7);
  RIGHT(11);
  LOWER(13);
  LOWER(14);
  CENTER(5);
  CENTER(6);
  CENTER(9);
  CENTER(10);

#define APPLY_ALL(F, SEP) F(0) SEP F(1) SEP F(2) SEP F(3) SEP F(4) SEP \
  F(5) SEP F(6) SEP F(7) SEP F(8) SEP F(9) SEP F(10) SEP F(11) SEP \
  F(12) SEP F(13) SEP F(14) SEP F(15)

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

#if CHECK_PERIOD1 == 1 | CHECK_PERIOD2 == 1
#define PERIOD1(N) ((grid[N] = 1 -> (AX(grid[N] = 1))) & (grid[N] = 0 -> (AX(grid[N] = 0))))
#define PERIOD2(N) ((grid[N] = 1 -> (AX(AX(grid[N] = 1)))) & (grid[N] = 0 -> (AX(AX(grid[N] = 0)))))
#if CHECK_PERIOD2 == 1
-- Period 2 of an oscilator.
SPEC
(!AG(APPLY_ALL(PERIOD1, &))) & AG(APPLY_ALL(PERIOD2, &));
#endif

#if CHECK_PERIOD1 == 1
-- Period 1 of an oscilator.
#define PERIOD1(N) ((grid[N] = 1 -> (AX(grid[N] = 1))) & (grid[N] = 0 -> (AX(grid[N] = 0))))
SPEC
AG(APPLY_ALL(PERIOD1, &));
#endif
#endif

#if CHECK_ALLFLIPONCE == 1 | CHECK_ALLFLIPINF == 1 | CHECK_ONEFLIPONCE == 1 | CHECK_ONEFLIPINF == 1
-- Cell flipping.
#define FLIP(N) (((grid[N] = 1) -> (EF(grid[N] = 0))) & ((grid[N] = 0) -> (EF(grid[N] = 1))))
#if CHECK_ALLFLIPONCE == 1
-- All cells are flipped at least once.
SPEC
EF(APPLY_ALL(FLIP, &));
#endif

#if CHECK_ALLFLIPINF == 1
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
