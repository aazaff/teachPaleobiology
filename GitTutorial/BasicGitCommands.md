# Basic git commands

## clone
##### Description
Make a referential copy of a remote repository.  

##### Usage
`git clone [path to remote repository] [optional local location]`

##### Example
If you want to clone [this repository](https://github.com/braydie/HowToBeAProgrammer) to your computer in your user's home directory in a folder named `code`:

````
git clone https://github.com/braydie/HowToBeAProgrammer.git ~/code/HowToBeAProgrammer
````

If you first navigated into the `code` directory, you could achieve the same result as so:

````
cd ~/code
git clone https://github.com/braydie/HowToBeAProgrammer.git
````


## pull
##### Description
Update a the current branch of a repository with any changes from its remote

##### Usage
`git pull [optional remote name] [optional remote branch name]`

##### Example
By default, `git pull` will attempt to pull from the remote `origin` on branch `master`. Thus

````
git pull origin master
````

is identical to 

````
git pull
````

##### Gotchas
So you typed `git pull` and now you are staring at a screen asking you to update your merge commit. Simply typed `:wq` to make it go away.


## push
##### Description
Update a remote repository with new commits from a local repository

##### Usage
`git push [optional remote name] [optional remote branch name]`

##### Example
````
git push origin master
````

##### Gotchas
If the remote is ahead of your local repository you may be instructed to `git pull` and merge changes before you are able to push.


## add
##### Description
Add file(s) to the staging queue before committing.

##### Usage
`git add [optional flags] [name of file]`

##### Example
````
git add README.md
````

\#protip: add all *tracked* files that have been altered since the last commit

````
git add -u
````

## commit
##### Description
Create a new reference to the state of all files in the staging queue. Think of it as "saving" your work. It must include a brief description of the changes made, and optionally a longer more verbose description.

##### Usage
`git commit -m [commit message] [-m optional verbose commit message]`

##### Example
````
git commit -m "Added a new example"
````

With a verbose message:

````
git commit -m "Updated README" -m "A new example was added to better explain complex concepts"
````


## status
##### Description
Check the status of a repository to see which files have been edited, which are being tracked, and the current branch.

##### Usage
````
git status
````


## remote
##### Description
Check if a repository has an external reference to a remote repository

##### Usage
````
git remote -v
````


## log
##### Description
List previous commits

##### Usage
````
git log
````