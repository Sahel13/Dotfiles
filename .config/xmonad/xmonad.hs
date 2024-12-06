------------------------------------------------------------------
-- Imports
------------------------------------------------------------------
import XMonad
import System.Exit (exitSuccess)
import Data.List (find)

import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers (logTitlesOnScreen)
import XMonad.Hooks.ManageHelpers (isDialog)
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Actions.UpdatePointer

-- Layouts
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.ResizableTile
import XMonad.Layout.TwoPane
import XMonad.Layout.Magnifier
import XMonad.Layout.Renamed

-- Keybindings
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Actions.Submap
import XMonad.Actions.CycleWS

-- Scratchpads
import XMonad.Util.NamedScratchpad
import qualified XMonad.StackSet as W

-- Topics
import XMonad.Actions.TopicSpace
import XMonad.Prompt.Workspace
import XMonad.Util.Run
import XMonad.Hooks.WorkspaceHistory (workspaceHistoryHook)

-- For custom file prompt
import Control.Monad (forM)
import System.Directory (listDirectory, doesDirectoryExist)
import System.FilePath ((</>), makeRelative)
import XMonad.Prompt.Input

------------------------------------------------------------------
-- Main
------------------------------------------------------------------
main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . dynamicEasySBs barSpawner
     $ myConfig

-- Configuration
myConfig = def
    -- General settings
    { modMask = mod4Mask
    , terminal = myTerminal
    , focusFollowsMouse = False
    , borderWidth = 2
    , normalBorderColor = "#000000"
    , focusedBorderColor = "#076678"
    , workspaces = topicNames topicItems
    -- Hooks
    , startupHook = myStartupHook
    , layoutHook = myLayoutHook
    , manageHook = myManageHook
    , logHook = myLogHook
    } `additionalKeysP` myKeys

myTerminal :: String = "alacritty"

------------------------------------------------------------------
-- Xmobar
------------------------------------------------------------------
barSpawner :: ScreenId -> X StatusBarConfig
barSpawner 0 = pure $ statusBarPropTo "_XMONAD_LOG_0" "xmobar -x 0 ~/.config/xmobar/xmobarrc0" $ myXmobarPP 0
barSpawner 1 = pure $ statusBarPropTo "_XMONAD_LOG_1" "xmobar -x 1 ~/.config/xmobar/xmobarrc1" $ myXmobarPP 1
barSpawner _ = mempty

-- | A custom logger for the number of windows in a screen.
windowCount :: ScreenId -> X (Maybe String)
windowCount sid = withWindowSet $ \ws -> pure
    $ find ((== sid) . W.screen) (W.screens ws)
    >>= \screen -> let n = length . W.integrate' . W.stack . W.workspace $ screen
                   in if n < 2 then Just "" else Just (show n)

myXmobarPP :: ScreenId -> X PP
myXmobarPP sid = pure $ filterOutWsPP [scratchpadWorkspaceTag] $ def
    { ppSep     = red " • "
    , ppCurrent = wrap "" "" . xmobarBorder "Top" "#ff0000" 2
    , ppVisible = white
    , ppHidden  = offWhite
    , ppUrgent  = red . wrap (yellow "!") (yellow "!")
    , ppOrder   = \[ws, l, _, c, wins] -> [ws, l, c, wins]
    , ppExtras  = [windowCount sid, logTitlesOnScreen sid formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white "[") (white "]") . red . ppWindow True
    formatUnfocused = wrap (offWhite "[") (offWhite "]") . brown . ppWindow False

    ppWindow :: Bool -> String -> String
    ppWindow focused = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten titleLength
      where titleLength = if focused then 30 else 15
 
    offWhite, brown, red, white, yellow :: String -> String
    brown    = xmobarColor "#a52a2a" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    offWhite = xmobarColor "#bbbbbb" ""

------------------------------------------------------------------
-- StartupHook
------------------------------------------------------------------
myStartupHook :: X ()
myStartupHook = do
    setWMName "LG3D" -- Needed for PyCharm.

------------------------------------------------------------------
-- LogHook
------------------------------------------------------------------
myLogHook :: X ()
myLogHook = workspaceHistoryHookExclude [scratchpadWorkspaceTag]
          <> updatePointer (0.5, 0.5) (0, 0)

------------------------------------------------------------------
-- LayoutHook
------------------------------------------------------------------
myLayoutHook = smartBorders (tiled ||| Full)
  where
    tiled = renamed [Replace "Tall"] $ magnifierczOff' 1.3
                                       $ ResizableTall 1 delta ratio []
    twopane = TwoPane delta ratio
    delta = 3/100
    ratio = 1/2

------------------------------------------------------------------
-- ManageHook
------------------------------------------------------------------
myManageHook = composeAll
    [ className =? "firefox" --> doShift "web"
    , className =? "vlc" --> doShift "misc"
    , className =? "zoom" --> doShift "main"
    , className =? "zoom" --> doFloat
    , className =? "Signal" --> doShift "chat"
    , isDialog --> doFloat
    , namedScratchpadManageHook myScratchpads
    ]

------------------------------------------------------------------
-- Scratchpads
------------------------------------------------------------------
myScratchpads =
    [ NS "terminal" spawnTerm findTerm manageTerm
    , NS "network" spawnNetwork findNetwork manageNetwork 
    , NS "htop" spawnHtop findHtop manageHtop 
    , NS "thunar" spawnThunar findThunar manageThunar 
    ]
  where
    spawnTerm = myTerminal ++ " -t terminal"
    findTerm = title =? "terminal"
    manageTerm = customFloating $ W.RationalRect (1/5) (1/5) (3/5) (3/5)

    spawnNetwork = myTerminal ++ " -t network -e nmtui"
    findNetwork = title =? "network"
    manageNetwork = customFloating $ W.RationalRect (1/4) (1/5) (2/4) (3/5)

    spawnHtop = myTerminal ++ " -t htop -e htop"
    findHtop = title =? "htop"
    manageHtop = customFloating $ W.RationalRect (1/12) (1/6) (10/12) (4/6)

    spawnThunar = "thunar"
    findThunar = title =? "sahel - Thunar"
    manageThunar = customFloating $ W.RationalRect (0) (1/6) (1/3) (2/3)

------------------------------------------------------------------
-- Topics
------------------------------------------------------------------
topicItems :: [TopicItem]
topicItems =
    [ noAction "main" "~"
    , noAction "work" "~"
    , inHome "web" $ spawn "firefox"
    , noAction "code" "~"
    , noAction "chat" "~"
    , noAction "misc" "~"
    -- , inHome "python" $ customPythonAction 
    , TI "latex" "~/Documents/latex/" spawnTermInTopic
    , TI "pomdp" "~/Code/particle-pomdp/" $ spawn "pycharm-professional"
    , TI "haskell" "~/Code/haskell-mooc/exercises/" spawnTermInTopic
    ]
  -- where
  --   -- Just a demo.
  --   customPythonAction :: X ()
  --   customPythonAction = sendMessage (JumpToLayout "Full")
  --                      *> spawnTermInTopic 

topicConfig :: TopicConfig
topicConfig = def
  { topicDirs          = tiDirs    topicItems
  , topicActions       = tiActions topicItems
  , defaultTopicAction = const (pure ())
  , defaultTopic       = "main"
  }

-- Spawn a terminal in the current topic directory.
spawnTermInTopic :: X ()
spawnTermInTopic = proc $ termInDir >-$ currentTopicDir topicConfig

goto :: Topic -> X ()
goto = switchTopic topicConfig

-- Prompt to switch to a topic.
promptedGoto :: X ()
promptedGoto = workspacePrompt promptConfig goto

-- Prompt to move the selected window to a topic.
promptedShift :: X ()
promptedShift = workspacePrompt promptConfig $ windows . W.shift

-- Toggle between the two most recently used topics.
toggleTopic :: X ()
toggleTopic = switchNthLastFocusedByScreen topicConfig 1

------------------------------------------------------------------
-- Prompt configuration.
------------------------------------------------------------------
promptConfig :: XPConfig
promptConfig = def
    { font = "xft: Mononoki Nerd Font Mono-14"
    , fgColor = "#f9f9ff"
    , bgColor = "#1d1d1d"
    , bgHLight = "1d1d1d"
    , fgHLight = "#f9f9ff"
    , borderColor = "#ff5555"
    , position = CenteredAt 0.4 0.25
    , alwaysHighlight = True
    , height = 30
    , maxComplRows = Just 20
    , maxComplColumns = Just 1
    , autoComplete = Just (10^3)
    , searchPredicate = fuzzyMatch
    , sorter = fuzzySort
    }

------------------------------------------------------------------
-- Custom prompt to open my references.
------------------------------------------------------------------
-- | Recursively lists all files in a directory and its sub-directories,
-- returning file paths relative to the input directory.
listFiles :: String -> IO [String]
listFiles baseDir = listFiles' baseDir
  where
    listFiles' dir = do
        contents <- listDirectory dir
        let fullPaths = map (dir </>) contents
        paths <- forM fullPaths $ \path -> do
            isDir <- doesDirectoryExist path
            if isDir
                then listFiles' path
                else return [makeRelative baseDir path]
        return (concat paths)

filePrompt :: String -> (String -> X ()) -> X ()
filePrompt dir action = do
    files <- io $ listFiles dir
    inputPromptWithCompl promptConfig "open file" (mkComplFunFromList promptConfig files) ?+ action

-- Prompt to open files in a given directory with Zathura.
pdfPrompt :: String -> X ()
pdfPrompt dir = filePrompt dir (\file -> spawn $ "zathura " ++ dir </> file)

------------------------------------------------------------------
-- Keybindings
------------------------------------------------------------------
myKeys :: [(String, X ())]
myKeys =
    -- Essentials
    [ ("M-S-r", spawn "xmonad --recompile && xmonad --restart")
    , ("M-S-q", io exitSuccess)
    , ("M-q", kill)
    , ("M-<Return>", spawnTermInTopic)

    -- Utilities
    , ("M-d", spawn "dmenu_run")
    , ("<Print>", spawn "flameshot gui")
    , ("M-S-x", spawn "/home/sahel/.local/scripts/screen_lock.sh")

        -- Scratchpads
    , ("M-C-<Return>", namedScratchpadAction myScratchpads "terminal")
    , ("M-S-n", namedScratchpadAction myScratchpads "network")
    , ("M-S-h", namedScratchpadAction myScratchpads "htop")
    , ("M1-S-<Return>", namedScratchpadAction myScratchpads "thunar")

    -- Multi-monitor navigation
    , ("M-.", nextScreen)
    , ("M-,", prevScreen)

    -- Toggle magnification in the Tall layout.
    , ("M-S-m", sendMessage Toggle)

    -- Shrink/expand windows vertically in the Tall layout.
    , ("M-a", sendMessage MirrorShrink)
    , ("M-z", sendMessage MirrorExpand)

    -- Applications
    , ("M-S-<Return>", proc $ inTerm >-> setXClass "Ranger" >-> execute "ranger")
    , ("M-M1-f", spawn "firefox")
    , ("M-M1-s", spawn "signal-desktop")

    -- Function keys
    , ("<XF86MonBrightnessUp>", spawn "/home/sahel/.local/scripts/backlight.sh +")
    , ("<XF86MonBrightnessDown>", spawn "/home/sahel/.local/scripts/backlight.sh -")
    , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+")
    , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%-")
    , ("<XF86AudioMute>", spawn "amixer set Master toggle")

    -- Topic space keybindings.
    , ("M-<Tab>", toggleTopic)
    , ("M-g", promptedGoto)
    , ("M-S-g", promptedShift)

    -- File prompt.
    , ("M-f", pdfPrompt "/home/sahel/Documents/references")
    ]
    ++
    [ ("M-" ++ m ++ k, f i)
    | (i, k) <- zip (topicNames topicItems) (map show [1 .. 9 :: Int])
    , (f, m) <- [(goto, ""), (windows . W.shift, "S-")]
    ]
