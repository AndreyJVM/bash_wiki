### Конструируем и проверяем команду rename, обратите внимание на echo
for file in *.JPEG; do echo mv -v $file ${file/JPEG/jpg}; done

### Выполняем команду SSH на нескольких узлах, обратите внимание на первую команду echo

for node in web-server{00..09}; do
  echo ssh $node 'echo -e "$HOSTNAME\t$(date "+%F") $(uptime)"';
done