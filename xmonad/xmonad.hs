-- Imports
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.SetWMName

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Renamed
import qualified XMonad.Layout.MultiToggle as MT
import XMonad.Layout.MultiToggle.Instances


import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.SpawnOnce

import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.IO
import Graphics.X11.Xlib.Types (Rectangle(..))
import Graphics.X11.Xinerama (getScreenInfo)
import Graphics.X11.ExtraTypes.XF86

halfScreen :: W.RationalRect
halfScreen = W.RationalRect 0 0 0.5 1


--Gapped Layout
myGappedLayout = renamed [Replace "Gapped"]
               $ noBorders
               $ gaps [(U,20),(D,20),(L,20),(R,20)]
               $ spacing 10
               $ tiled ||| Mirror tiled ||| ThreeCol 1 (3/100) (1/3)
  where
    tiled = ResizableTall 1 (3/100) (1/2) []


--Plain Layout
myPlainLayout = renamed [Replace "Plain"]
              $ noBorders
              $ tiled ||| Mirror tiled ||| ThreeCol 1 (3/100) (1/3)
  where
    tiled = ResizableTall 1 (3/100) (1/2) []

--FullScreen
myFullScreenLayout = noBorders Full

myLayoutHook = avoidStruts
    $ MT.mkToggle (NOBORDERS MT.?? FULL MT.?? MT.EOT)
    $ myGappedLayout ||| myPlainLayout ||| myFullScreenLayout




gappedGroup = renamed [Replace "Gapped"] myGappedLayout
plainGroup  = renamed [Replace "Plain"] myPlainLayout
fullGroup   = renamed [Replace "Fullscreen"] myFullScreenLayout


--StartupHook
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "nm-applet &"
    spawn "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --alpha 0 --tint 0x1e1e2e --height 22 &"
    spawnOnce "killall picom; picom --config ~/.config/picom/picom.conf &"
    spawnOnce "~/.local/bin/monitors.sh &"



-- Extra keybindings
addKeys = (`additionalKeys`
    [ ((mod4Mask, xK_p), spawn "dmenu_run")
    , ((mod4Mask, xK_e), spawn "pcmanfm")
    , ((mod4Mask, xK_Pause), spawn "systemctl poweroff")
    , ((mod1Mask, xK_BackSpace), spawn "firefox")
    , ((mod1Mask, xK_s), spawn "chromium")
    , ((mod1Mask, xK_z), spawn "vivaldi")
    , ((mod1Mask, xK_v), spawn "vlc")
    , ((mod1Mask, xK_g), spawn "android-studio")
    , ((mod4Mask, xK_g), spawn "davinci-resolve")
    , ((mod4Mask, xK_Home), spawn "systemctl reboot")
    , ((mod4Mask, xK_Return), spawn "alacritty")
    , ((mod4Mask, xK_q), kill)
    , ((mod4Mask, xK_Print), spawn "flameshot gui")
    , ((mod4Mask .|. shiftMask, xK_Print), spawn "flameshot gui -p ~/Pictures/Screenshots")

    -- Volume control
    , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

    -- Brightness control
    , ((0, xF86XK_MonBrightnessUp), spawn "brightnessctl set +10%")
    , ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 10%-")

    -- Toggle power mode
    , ((mod4Mask, xK_F5), spawn "~/.local/bin/power-mode.sh")

    --Toggle Layout
    , ((0, xF86XK_ScreenSaver), sendMessage NextLayout)
    , ((mod4Mask, xK_f), sendMessage $ MT.Toggle FULL)

    --Recompile
    ,((mod1Mask, xK_1), spawn "xmonad --recompile && xmonad --restart")
    ])


-- Main function
main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobarrc"
    xmonad $ addKeys $ docks $ def
        { terminal    = "alacritty"
        , modMask     = mod4Mask
        , manageHook = manageDocks <+> manageHook def
        , layoutHook = myLayoutHook
        , logHook     = dynamicLogWithPP $ xmobarPP
            { ppOutput          = hPutStrLn xmproc
            , ppCurrent         = xmobarColor "#98be65" "" . wrap "[" "]"
            , ppVisible         = xmobarColor "#c678dd" ""
            , ppHidden          = xmobarColor "#51afef" ""
            , ppHiddenNoWindows = xmobarColor "#5c6370" ""
            , ppUrgent          = xmobarColor "#ff6c6b" "" . wrap "!" "!"
            , ppTitle           = xmobarColor "#b3afc2" "" . shorten 40
            , ppSep             = " | "
            , ppOrder           = id   -- default order, keeps formatting
            }
        , startupHook = myStartupHook
        }
