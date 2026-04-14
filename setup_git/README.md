## Git command
```shell
curl -sSL https://raw.githubusercontent.com/AndreyJVM/bash_wiki/setup_git/main/setup_git_config.sh \
    -o /tmp/setup_git_config.sh \
    && sudo bash /tmp/setup_git_config.sh
```

```shell
git config --global user.name "Andrey Vorobev"
```
```shell
git config --global user.email "Andrey.Vorobev.AQA@gmail.com"
```

```shell
git push origin main -f
```
```shell
git remote -v
git remote set-url origin "new_URI"
```
```shell
git add -f ./target/site/jacoco/
git commit -m "Add jacoco"
git push origin main
```
```shell
git rm --cached <file name>
```
```shell
git stash push --include-untracted
git merge origin/main main
```