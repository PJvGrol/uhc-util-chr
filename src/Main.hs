module Main where

import System.Environment
import System.Console.GetOpt
import System.Exit

import UHC.Util.CHR.Solve.TreeTrie.Examples.Term.Main

-- | Program options
data Opts
  = Opts
      { optVerbose :: Bool
      }

defaultOpts :: Opts
defaultOpts
  = Opts
      { optVerbose = False
      }

-- | Options for 'getOpt'
options :: [OptDescr (Opts -> Opts)]
options =
    [ Option ['v']
             ["verbose"]
             (NoArg $ \o -> o {optVerbose = True})
             "extra output, debugging output"
    ]
   
main = do
    args <- getArgs
    progname <- getProgName
    case getOpt Permute options args of
       (o,[fn],[]) -> do
           let opts = foldl (flip id) defaultOpts o
           runFile (if optVerbose opts then [RunOpt_DebugTrace] else []) fn
       (_,_,errs) -> do
           putStrLn $ concat errs ++ usageInfo header options
           exitFailure
         where header = "Usage: " ++ progname ++ " [OPTION...] file\n\nOptions:"
    return ()
