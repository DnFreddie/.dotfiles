---
date: "2024-10-15T20:49:21+02:00"
draft: false
title: Firefox custom css
---

## Instructions

1.  Enter `about:support`  
2.  Check the defualt profile
3.  Create `chrome/userChrome.css`

``` css
/* ##NAME:userChrome.css## */
#TabsToolbar {
  visibility: collapse !important;
}
/* Move the address bar to the bottom */
#navigator-toolbox toolbar:not(#nav-bar):not(#toolbar-menubar) {
  display: none !important;
}

#navigator-toolbox {
  display: flex;
  flex-direction: column-reverse;
}

#nav-bar {
  position: fixed !important;
  bottom: 0 !important;
  width: 100% !important;
  z-index: 1000 !important;
}

/* Adjust the main browser content */
#browser {
  margin-bottom: var(--tab-min-height) !important;
}

/* Optional: Hide the tab bar */
#TabsToolbar {
  visibility: collapse !important;
}
```
