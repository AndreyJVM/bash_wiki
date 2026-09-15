### 1. Добавляем файлы 
```bahs
git add src/main/resources/static/css/style.css \
src/main/resources/templates/fragments/layout.html \
src/main/resources/templates/index.html
```

### 2. Коммитим изменения интерфейса
```bash
git commit -m "feat(ui): migrate top navigation to responsive left sidebar"
```

### 3. Пушим изменения в основную ветку
```bahs
git push origin master
```

### 4. Создаем тег v0.3.0 с описанием мажорных изменений этого спринта
```bash
git tag -a v0.3.0 -m "Release v0.3.0: SSH key authentication, custom ports, and new responsive sidebar UI"
```

### 5. Пушим тег (это запустит GitHub Actions)
```bash
git push origin v0.3.0
```
