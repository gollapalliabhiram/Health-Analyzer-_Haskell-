{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_health_dashboard (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/gollapalliabhiram/Desktop/health/health-dashboard/.stack-work/install/x86_64-linux-tinfo6/c1070b400e840faf99cadc4ce456d2a85a6294011583f00f41756edade65cc19/9.8.4/bin"
libdir     = "/home/gollapalliabhiram/Desktop/health/health-dashboard/.stack-work/install/x86_64-linux-tinfo6/c1070b400e840faf99cadc4ce456d2a85a6294011583f00f41756edade65cc19/9.8.4/lib/x86_64-linux-ghc-9.8.4/health-dashboard-0.1.0.0-7RkbmyPu2N5CqFrss6jLjR-health-dashboard"
dynlibdir  = "/home/gollapalliabhiram/Desktop/health/health-dashboard/.stack-work/install/x86_64-linux-tinfo6/c1070b400e840faf99cadc4ce456d2a85a6294011583f00f41756edade65cc19/9.8.4/lib/x86_64-linux-ghc-9.8.4"
datadir    = "/home/gollapalliabhiram/Desktop/health/health-dashboard/.stack-work/install/x86_64-linux-tinfo6/c1070b400e840faf99cadc4ce456d2a85a6294011583f00f41756edade65cc19/9.8.4/share/x86_64-linux-ghc-9.8.4/health-dashboard-0.1.0.0"
libexecdir = "/home/gollapalliabhiram/Desktop/health/health-dashboard/.stack-work/install/x86_64-linux-tinfo6/c1070b400e840faf99cadc4ce456d2a85a6294011583f00f41756edade65cc19/9.8.4/libexec/x86_64-linux-ghc-9.8.4/health-dashboard-0.1.0.0"
sysconfdir = "/home/gollapalliabhiram/Desktop/health/health-dashboard/.stack-work/install/x86_64-linux-tinfo6/c1070b400e840faf99cadc4ce456d2a85a6294011583f00f41756edade65cc19/9.8.4/etc"

getBinDir     = catchIO (getEnv "health_dashboard_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "health_dashboard_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "health_dashboard_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "health_dashboard_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "health_dashboard_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "health_dashboard_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
