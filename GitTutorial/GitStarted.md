# Getting started with git
This assumes you already have git installed on your computer (if you are running OS X or any flavor of Linux you do). To confirm, open up a terminal and type `which git`. If a directory is returned, you are good to go! If you are running Windows you can download git [here](https://git-scm.com/download/win) (install using all the defaults, and then open Git Bash).

## What
Git is an open-source application for tracking revisions of text-based documents. It is most commonly used to track code, but it can be used for managing myriad projects, such as [home renovations](http://www.wired.com/2013/01/this-old-house/). However, while it does not have a great reputation for [being user friendly](https://xkcd.com/1597/), it is fairly straightforward to master a few essential commands to leverage the power of git.


## Why
You're right, Microsoft Word can track changes, and Google Docs allows you to collaboratively track and edit documents with your colleagues in a far more user friendly way than git.

However, imagine this hypothetical situation: you are working on a paper (`FameAndGlory.md`) with a few colleagues, you all agree that the abstract is the definition of academic perfection (`branch:master`), but you have different ideas for how the rest of the paper should be organized. You don't want to offend your colleagues by simply deleting three of their paragraphs and rewriting them, so what do you do? 

If you are using git, you could create `branch:alternative-approach` and work on your own version while continuously updating your version from the `master` version. When you are ready to present your version to your colleagues, you could submit a *pull request* to *merge* your version of the document. At this point you and your colleagues and talk about the relative merits of each version, make their own changes, and *merge* your version into the `master` branch if it is determined to be superior (which it is).

While that is a far more complex example than what will be required for this class, it demonstrates the use of one of git's most powerful features -- branches. Branches allow you to experiment with different ideas without permanently altering a master copy.




## Setup
If you have never used `git` before, you should configure your name and email address.

````
git config --global user.name "Kylo Ren"
git config --global user.email kylo@firstorder.org
````

Use the same name and email address that you will use for Github.


## Making a repository
Repositories are simply a directory whose contents `git` is aware of. To initialize `git` in a given directory simply type `git init`. For example

````
mkdir newProject
cd newProject
git init

-> Initialized empty Git reposity in newProject/.git
````


## Adding and committing files
Git can only track files in the directory in which a repository has been initialized. If you add a file to the folder `newProject` and type `git status` you will see that git can see that file, but will say that it is "Untracked". This means that git is not watching that file for changes, nor will it be tracked for any reason. 

To track the file you must add it by typing `git add [name of file]`. If you type `git status` now, you will see that git has your file listed in "Changes to be committed" and that it is a new file. Right now, your new file is in the staging queue and has not been committed yet.

To commit the file, type `git commit -m "Added new file"`, or any other commit message. You will get a little message from git telling you that one file has been changed.

To see all the commits, type `git log`. 


## Using Github
Github is an online service that uses git for sharing and collaborating on projects. Many of the largest and most popular open source projects use it not only for collaborative coding, but also for issue tracking and documentation.

To get started, go to [https://github.com](https://github.com) and sign up for an account.

To create a new repository, click on your profile picture in the upper right corner, and select "Your profile". Once you are on your profile page, select the "Repositories" tab and select the green "New" button.

Create a name for repository, add an optional description, make sure it is public and do not initialize it with a `README` and license. 

On the next screen you will be presented with various options for adding code to your repository. Since you already created a repository on your computer, follow the instructions for "…or push an existing repository from the command line". Simply copy and paste those two commands into your terminal and then refresh the page. Voilà!

The last step is to add Dr. Zaffos as a collaborator on the repository so that he can make edits to your assignments. To do this, click on the "Settings" tab of the repository, select "Collaborators" on the left side, and then add `aazaff` as a collaborator.


## Workflow
Now that you have a local repository and remote repository you are ready to code. The basic worflow is as follows:

````
edit files -> add -> commit -> push
````

For example, let's say you have a file named `test.txt` in your repository that you just made some edits to. To create a new commit and push your changes to Github, the commands would be as follows:

````
git add test.txt
git commit -m "Update text.txt"
git push origin master
````

You will now see your new commit and the changes to `test.txt` show up on Github.


## Additional Commands

You can find a recap, plus some additional information, about many of the commands used in this tutorial [here](https://github.com/aazaff/teachPaleobiology/blob/master/GitTutorial/BasicGitCommands.md).
