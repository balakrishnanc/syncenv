# About

`syncenv.sh` is a utility to parse ZSH configuration files and expose the exported environment variables to all applications using `launchctl`, based on [ersiner/osx-env-sync](https://github.com/ersiner/osx-env-sync).

# Installation

Copy the _plist_ file to `~/Library/LaunchAgents/syncenv.plist`, and load the launch agent as follows.

```
§ launchctl load ~/Library/LaunchAgents/syncenv.plist
``` 

To reload without restarting, or logging out and logging in, `unload` the agent and `load` it again (as before).

```
§ launchctl unload ~/Library/LaunchAgents/syncenv.plist
§ launchctl load ~/Library/LaunchAgents/syncenv.plist
``` 
