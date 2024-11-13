------------------------------------------------------------------
-- Imports
------------------------------------------------------------------
import XMonad
import System.Exit (exitSuccess)

import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers (logTitles)
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
xmobar1 = statusBarPropTo "_XMONAD_LOG" "xmobar -x 0 ~/.config/xmobar/xmobarrc" (pure myXmobarPP)
xmobar2 = statusBarPropTo "_XMONAD_LOG" "xmobar -x 1 ~/.config/xmobar/xmobarrc" (pure myXmobarPP)

barSpawner :: ScreenId -> X StatusBarConfig
barSpawner 0 = pure $ xmobar1
barSpawner 1 = pure $ xmobar2
barSpawner _ = mempty

myXmobarPP :: PP
myXmobarPP = filterOutWsPP [scratchpadWorkspaceTag] $ def
    { ppSep     = red " • "
    , ppCurrent = wrap "" "" . xmobarBorder "Top" "#ff0000" 2
    , ppVisible = white
    , ppHidden  = offWhite
    , ppUrgent  = red . wrap (yellow "!") (yellow "!")
    , ppOrder   = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras  = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white "[") (white "]") . red . ppWindow
    formatUnfocused = wrap (offWhite "[") (offWhite "]") . brown . ppWindow

    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shortenLeft 25
 
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
promptedGoto = workspacePrompt prompt goto

-- Prompt to move the selected window to a topic.
promptedShift :: X ()
promptedShift = workspacePrompt prompt $ windows . W.shift

-- Toggle between the two most recently used topics.
toggleTopic :: X ()
toggleTopic = switchNthLastFocusedByScreen topicConfig 1

------------------------------------------------------------------
-- Prompt configuration.
------------------------------------------------------------------
prompt :: XPConfig
prompt = def
    { font = "xft: Mononoki Nerd Font Mono-14"
    , fgColor = "#f9f9ff"
    , bgColor = "#1d1d1d"
    , borderColor = "#ff5555"
    , height = 30
    , autoComplete = Just (2 * 10^3)
    , searchPredicate = fuzzyMatch
    , sorter = fuzzySort
    }

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
    ]
    ++
    [ ("M-" ++ m ++ k, f i)
    | (i, k) <- zip (topicNames topicItems) (map show [1 .. 9 :: Int])
    , (f, m) <- [(goto, ""), (windows . W.shift, "S-")]
    ]
