<<<<<<< HEAD
# Installing Git and Creating Your First Repository

This tutorial is for Windows users. Mac users should use the [gitAppple]() tutorial. Proceed in chronological order and do not deviate from the script.

## Make a GitHub Account

Step 1: Go to [github.com](https://github.com/) and make an account.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure1.PNG" align="center" height="450" width="500" ></a>

Step 2: Immediately proceed to your profile.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure2.PNG" align="center" height="450" width="500" ></a>

Step 3: Your profile should currently be empty of any repositories, public activity, or contributions. Do nothing and proceed to the next step, [Downloading Git](#downloading-git)

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure3.PNG" align="center" height="450" width="500" ></a>

## Downloading Git

Step 4: Go to https://git-scm.com/download/win. Download the program and install it using the default settings.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure4.PNG" align="center" height="450" width="500" ></a>

Step 5: Find and open the program **git bash**

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure5.PNG" align="center" height="450" width="500" ></a>

Step 6: You must configure your machine to your GitHub account. **You only ever need to do this once.** Type the following code into bash, but substitute your GitHub account name for Kylo Ren and your email address for kylo@firstorder.org.

````
git config --global user.name "Kylo Ren"
git config --global user.email kylo@firstorder.org
````

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure6.PNG" align="center" height="450" width="500" ></a>

## Creating the local copy of your repository

Your git repository exists in two places simultaneously: online at GitHub and on your machine. You need to decide where on your machine you want the **local copy** of the repository.

Step 7: Create the new folder for your repository wherever you choose.

Step 8: Copy the directory path to your clipboard.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure8.PNG" align="center" height="450" width="500" ></a>

## Initiate git in the local repository

Step 9: Return to git bash. Use the ````cd```` command to 'change directory' to where your newly made repository is saved. If you do not know where this is, you can just paste the directory path you copied in Step 8. 

My specific example is...

````cd "C:\Users\Andrew\Box Sync\GitRepositories"````

Your example will be something like

````cd "C::\Users\You\Repository"````

Step 10: Initialize git using the ````git init```` command. **LEAVE GIT BASH OPEN**.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure9.PNG" align="center" height="450" width="500" ></a>

## Creating the GitHub copy of the repository

Step 11: Return to your GitHub profile page. Click on create a new repository. Give the repository a name.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure10.PNG" align="center" height="450" width="500" ></a>

Step 12: Copy the code under the section header "...or push an existing repository from the command line" into git bash. Type it in precisely. You will be asked to enter your GitHub username and password in git bash.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure11.PNG" align="center" height="450" width="500" ></a>

## The End

You now have a repository that is linked between GitHub and your local machine. To see how to add, edit, delete, or sync files between your local machine and GitHub, see the [gitTutorial]().
=======
# Installing Git and Creating Your First Repository

This tutorial is for Windows users. Mac users should use the [gitAppple](https://github.com/aazaff/teachPaleobiology/blob/master/GitTutorial/gitApple.md) tutorial. Proceed in chronological order and do not deviate from the script.

## Make a GitHub Account

Step 1: Go to [github.com](https://github.com/) and make an account.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure1.PNG" align="center" height="450" width="500" ></a>

Step 2: Immediately proceed to your profile.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure2.PNG" align="center" height="450" width="500" ></a>

Step 3: Your profile should currently be empty of any repositories, public activity, or contributions. Do nothing and proceed to the next step, [Downloading Git](#downloading-git)

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure3.PNG" align="center" height="450" width="500" ></a>

## Downloading Git

Step 4: Go to https://git-scm.com/download/win. Download the program and install it using the default settings.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure4.PNG" align="center" height="450" width="500" ></a>

Step 5: Find and open the program **git bash**

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure5.PNG" align="center" height="450" width="500" ></a>

Step 6: You must configure your machine to your GitHub account. **You only ever need to do this once.** Type the following code into bash, but substitute your GitHub account name for Kylo Ren and your email address for kylo@firstorder.org.

````
git config --global user.name "Kylo Ren"
git config --global user.email kylo@firstorder.org
````

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure6.PNG" align="center" height="450" width="500" ></a>

## Creating the local copy of your repository

Your git repository exists in two places simultaneously: online at GitHub and on your machine. You need to decide where on your machine you want the **local copy** of the repository.

Step 7: Create the new folder for your repository wherever you choose.

Step 8: Copy the directory path to your clipboard.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure8.PNG" align="center" height="450" width="500" ></a>

## Initiate git in the local repository

Step 9: Return to git bash. Use the ````cd```` command to 'change directory' to where your newly made repository is saved. If you do not know where this is, you can just paste the directory path you copied in Step 8. 

My specific example is...

````cd "C:\Users\Andrew\Box Sync\GitRepositories"````

Your example will be something like

````cd "C::\Users\You\Repository"````

Step 10: Initialize git using the ````git init```` command. **LEAVE GIT BASH OPEN**.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure9.PNG" align="center" height="450" width="500" ></a>

## Creating the GitHub copy of the repository

Step 11: Return to your GitHub profile page. Click on create a new repository. Give the repository a name.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure10.PNG" align="center" height="450" width="500" ></a>

Step 12: Copy the code under the section header "...or push an existing repository from the command line" into git bash. Type it in precisely. You will be asked to enter your GitHub username and password in git bash.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure11.PNG" align="center" height="450" width="500" ></a>

## The End

You now have a repository that is linked between GitHub and your local machine. To see how to add, edit, delete, or sync files between your local machine and GitHub, see the [gitTutorial]().
>>>>>>> 6cf30224e8b417f8ac9196fbeee64a9bcfe82b6a
