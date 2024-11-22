https://askubuntu.com/questions/1442124/how-to-access-windows-files-from-linux-in-wsl

If you want to easily access your Windows "Documents" folder from WSL, you can create a symbolic link from your home directory:

```
ln -s '/mnt/c/Users/YourUserNameHere/Documents' ./WinDocuments
```

You can do that for Documents or you could just link your Windows home directory.

You appear to be wondering why this isn't taking you to the `Documents` folder in your _Windows_ home directory.

It's important to understand that the home directory in Ubuntu/WSL is _not_ the same as your Windows home directory, nor should it be. Your Ubuntu home directory is in a virtual SSD provided by WSL. This virtual SSD provides the _Linux_ compatible filesystem that Ubuntu needs, whereas your Windows drive is formatted as NTFS and won't have 100% compatibility.

WSL _does_ provide a way to get to the Windows files (including your home directory), as mentioned by @Tooster.

From inside Ubuntu:

```
cd /mnt/c/Users/<your_Windows_username>
ls
```

That should show you all the files and directories in your Windows profile (a.k.a. home) folder.

Also perhaps reading as additional background -- My answer to [Where is WSL located on my computer?](https://askubuntu.com/q/1380253/1165986).