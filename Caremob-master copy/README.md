# Caremob

Please work in your own branch and push up changes to your branch only.

git clone *repo-url*

git branch *branch-name*

git checkout *branch-name*

// Make changes, then:

git add .  (or git add -A)

git commit -m "my commit message"

git push origin *branch-name*

Then create a pull request in github.

## To revert changes to the last pulled commit: 

git reset --hard HEAD

## To delete your branch

git branch -d *branch-name*

## Example

*Note: Before starting work, pull down a clean copy!*

git checkout master

git pull

git branch mybranch

git checkout mybranch

...

git add -A

git commit -m "I changed x, y and z"

git push origin mybranch

git checkout master

git branch -d mybranch

*Finally, go to github and create a pull request for me to review*
