# Introduction

The following is a revised version of the git and GitHub tutorial. You can (and should) use the new [gitWindows](https://github.com/aazaff/teachPaleobiology/blob/master/GitTutorial/gitWindows.md or [gitApple](https://github.com/aazaff/teachPaleobiology/blob/master/GitTutorial/gitApple.md) tutorials to install and setup git on your computer. You can still access the [old git tutorial](https://github.com/aazaff/teachPaleobiology/blob/master/GitTutorial/GitStarted.md) and list of [basic git commands](https://github.com/aazaff/teachPaleobiology/blob/master/GitTutorial/BasicGitCommands.md). However, everything you need to get started with git (other than installation) is included in this tutorial.

## How to use git

A git repository exists both on **GitHub** (online) and on your **local** machine. It can also exist on machines other than yours (e.g., a project collaborator), but we will ignore that possiblity for the moment.

The key to successfully working with git is navigating the relationship between the **local copy** and the **GitHub** copy. This relationship is summarized by the concepts of ````pushing```` and ````pulling````.

## Pulling and Pushing

1. Pulling is when you take a file that you added or edited on GitHub and sync it with your local machine.
2. Pushing is when you take a file that you added or edited to your local machine and sync it with GitHub.

The primary issue then for you, as a git user, is whether you (1) want to add and edit files on the GitHub website, and only sync to your computer after the fact or (2) want to add and edit your computer and only sync (upload) your files to GitHub after the fact. I discuss the first scenario in the [Working from GitHub First](#working-from-github-first) section and the latter scenario in the [Local Machine First](#local-machine-first) section.

**Importantly, you ideally do NOT want to do both. Choose one of the two workflows. Either [GitHub First](#working-from-github-first) or [Local Machine First](#local-machine-first).**

## Working from GitHub First

Step 1: Navigate to your repository on the GitHub website.

Step 2: Create a new file

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitTutorial/Figure1.png" align="center" height="450" width="500" ></a>

Step 3: Write your answers in the new file. Scroll down to the bottom of the page and click the Commit changes button

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitTutorial/Figure2.png" align="center" height="450" width="500" ></a>

Step 4: Now that you have successfully commited your file to GitHub, you need to sync the file with your local machine. To do this you need to open terminal, and move to the folder using the ````cd```` command.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitTutorial/Figure3.png" align="center" height="350" width="500" ></a>

Step 5: Then use the ````git pull``` command.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitTutorial/Figure4.png" align="center" height="450" width="500" ></a>

Step 6: Your files are now synced, and you will now see the file you uploaded on GitHub downloaded to your computer and in the repository folder. You are done! DONE!

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitTutorial/Figure5.png" align="center" height="450" width="500" ></a>

## Local Machine First

Step 1: Write your answers down in a text editor (e.g., sublime text) and save them to your computer repository.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitTutorial/Figure5.png" align="center" height="450" width="500" ></a>

Step 2: Open terminal and move to the folder using the ````cd```` command.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitTutorial/Figure3.png" align="center" height="350" width="500" ></a>

Step 3: Type the following three commands inot terminal. Substitute any message in the ````" "```` that you want associated with the file. GitHub requires that you leave a message of some kind. This could be something as simple as "Upload" or "New File" or "Screw You GitHub I don't want to leave a message".

````
git add .
git commit -m "Your Message"
git push
````

Step 4: You are done! DONE! You will now see the file online in your GitHub Repository. Repeat Steps 2-3 if you make any changes to the file on your local machine and want them uploaded to GitHub.
