В данном разделе опубликован Dockerfile, который соответствует требованиям верификации задания:
1. полученный репозиторий подключается к ubuntu bionic и не выдаёт ошибок при вызове apt update (допускаются ошибки из-за отсутствия gpg подписи)
2. собранный deb пакет устанавливается из репозитория, бинарный файл размещается в /usr/local/bin

Для начала работы нам необходимы следующие условия.
Должна быть машина с предустановленным docker на любой операционной системе и у ей необходим доступ в интернет для скачки необходимых образов и зависимостей, которые участвуют в сборке проекта.
После чего необходимо склонировать себе репозиторий с GitHub на эту машину и запустить run.sh
Начнется построение образа из Dockerfile на базе, которого далее запустится контейнер., который будет на порту 50080 отдавать наш deb пакет. Так же нам необходимо знать ip адрес хостовой машины.

На машине клиента необходимо  прописать в файле nano /etc/apt/sources.list
Следующую запись при условии того что подставить ip адрес сервера с docker
В моем случае выглядит так

deb [trusted=yes] http://172.17.87.53:50080/debian ./

Ключи gpg в данном случае я ничего не подписывал просто добавил параметр [trusted=yes]

Я преследовал задачу полной автоматизации процесса, но у данного подхода есть ряд минусов:
Для реализации полноценного ci\cd необходима была установка и настройка дополнительных инструментов, например, хранилища артефактов, самой системы ci\cd – что в свою очередь никак бы не повлияло на верификацию задания. Так же изначально хотел сделать несколько контейнеров под best practices на одном собирать проект в другом публиковать. Стал вопрос с сетями, а, чтобы более грамотно реализовать в docker-compose - хорошо бы иметь хранилище артефактов, чтобы облегчить жизнь и процесс написание. Про кубер речи не веду)
В итоге решил свалить все в один Dockerfile и сделать это рабочим.
Причесывать и оптимизировать можно разными способами, но на это надо время, а в рамках состояния здоровья и нагрузки на работе – такой возможности нет. При этом готов ответить на любые вопросы и порассуждать на тему выбранного решения, что я частично описал выше.
