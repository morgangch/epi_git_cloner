# :gb: epi_git_cloner
Simple little program that allows to easily clone multiple types of personnal (or professional/educational) repositories. Mainly made for Epitech projects, it can be edited to allow you to easily clone anything.

## How can you setup it ?
How can you run this simple little script ?
You'll need to fill a file named ".cloner.env" with the following datas (replacing [] with the actual data) :

user1="[X]" // Nickname for the first github account

git_user1="[X]" // Github name for your first github account

user2="[X]" // Same here

git_user2="[X]" // ...

perso_path="[X]" // Absolue path to the directory you want your personnal projects to be cloned in.

epi_path="[X]" // Absolute path to the directory you want your professionnal (actually Epitech projects) projects to be cloned in.

gitswitch_path="[X]" // Absolue path to my git_switcher.sh script, that allows you to switch github accounts on Linux.

promo="[X]" // Year of graduation of your Epitech promo

city="[X]" // 3 letters code for your city (BDX for Bordeaux, MPL for Montpellier, etc...)

fname="[X]" // Your first name

name="[X]" // Your last name

If you do not want to setup it manually, you can also execute it for the first time, prompts will ask you to give the code datas that will then fill the file.
I also recommend you putting the directory in your environment PATH to avoid useless bugs.

## How can you run it ?
Simple as that, once the script is setup, the datas are given, you only need to run it this way :

**[path_to_program].sh**

**Example : ./git_cloner.sh**

Once executed, the program will ask a bunch of questions, that will allow you to gain some time than to remember perfectly the github url to the repository.


# :fr: git_cloner