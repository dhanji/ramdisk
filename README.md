# ramdisk
ramdisk for mac.

Spin up a 2G ram disk from the following dir.
```
./ramdisk.rb up 2 /path/to/real_dir
```

Then, symlink yourself into RAM:
```
sudo ln -s /Volumes/RAM\ Disk /path/to/ramized_dir
```

To safely eject (synchronizes to real_dir from RAM before ejecting):
```
./ramdisk.rb eject 2 /path/to/real_dir
```

To sync without ejecting:
```
./ramdisk.rb sync 2 /path/to/real_dir
```


### IntelliJ Caches Example
```
mv /Users/dhanji/Library/Caches/IntelliJIdea14 /Users/dhanji/Library/Caches/IntelliJIdea14_p

./ramdisk.rb up 2 /Users/dhanji/Library/Caches/IntelliJIdea14_p
sudo ln -s /Volumes/RAM\ Disk /Users/dhanji/Library/Caches/IntelliJIdea14

# now start IntelliJ
```

YMMV with IntelliJ caches as they're probably already heavily cached in memory.
This may be more useful for stuff like .git dir, .ssh etc.

_Note: A manual eject or system shutdown will destroy everything in the RAM disk_
