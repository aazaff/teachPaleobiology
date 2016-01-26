# Installing Git and Creating Your First Repository

This tutorial is for Apple users. Windows users should use the [gitWindows](https://github.com/aazaff/teachPaleobiology/blob/master/GitTutorial/gitWindows.md) tutorial. Proceed in chronological order and do not deviate from the script.

## Make a GitHub Account

Step 1: Go to [github.com](https://github.com/) and make an account.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure1.PNG" align="center" height="450" width="500" ></a>

Step 2: Immediately proceed to your profile.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure2.PNG" align="center" height="450" width="500" ></a>

Step 3: Your profile should currently be empty of any repositories, public activity, or contributions. Do nothing and proceed to the next step.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure3.PNG" align="center" height="450" width="500" ></a>

## Open Terminal

Step 4: Open the program **terminal** on your mac. Terminal is installed on all macs by default.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitApple/Figure1.PNG" align="center" height="450" width="500" ></a>

Step 5: Configure your machine to your GitHub account. **You only ever need to do this once.** Type the following code into bash, but substitute your GitHub account name for Kylo Ren and your email address for kylo@firstorder.org.

````
git config --global user.name "Kylo Ren"
git config --global user.email kylo@firstorder.org
````

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitApple/Figure2.PNG" align="center" height="450" width="500" ></a>

## Creating the local copy of your repository

Your git repository exists in two places simultaneously: online at GitHub and on your machine. You need to decide where on your machine you want the **local copy** of the repository.

Step 6: Create the new folder for your repository wherever you choose.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitApple/Figure3.PNG" align="center" height="450" width="500" ></a>

## Initiate git in the local repository

Step 8: Return to terminal. Use the ````cd```` command to 'change directory' to where your newly made repository is saved. If you do not know where this is, you can *drag* your folder into the terminal window.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitApple/Figure4.PNG" align="center" height="450" width="500" ></a>

My specific example is...

````cd /Users/zaffos/Box\ Sync/GitRepositories/````

Your example will be something like

````cd /Users/You/Repository/````

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitApple/Figure5.PNG" align="center" height="450" width="500" ></a>

Step 9: Initialize git using the ````git init```` command in terminal. **LEAVE TERMINAL OPEN**.

## Creating the GitHub copy of the repository

Step 10: Return to your GitHub profile page. Click on create a new repository. Give the repository a name.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure10.PNG" align="center" height="450" width="500" ></a>

Step 11: Copy the code under the section header "...or push an existing repository from the command line" into terminal. Type it in precisely. You will be asked to enter your GitHub username and password in git bash.

<a href="url"><img src="https://raw.githubusercontent.com/aazaff/teachPaleobiology/master/GitTutorial/gitWindows/Figure11.PNG" align="center" height="450" width="500" ></a>

## The End

You now have a repository that is linked between GitHub and your local machine. To see how to add, edit, delete, or sync files between your local machine and GitHub, see the [gitTutorial]().
