# Presale landing static HTML page docker

- Service: `presale` (nginx) on `172.16.5.3` (`www.druidsme.dock`).
- Static files come from `./` (linked from druids.me repo).
- Uses external network `dev_druidsme_net` (created by `../network-create.sh`).

## Quick start
From `dockerization ROOT dir`:
```
./console.sh link presale PATH-TO-REPO-CLONE-druids.me
./console.sh build presale
./console.sh up presale
```

## Now You can open browser

👉 [http://www.druidsme.dock/](http://www.druidsme.dock/)  