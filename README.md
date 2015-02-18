# OneLauncher
OneLauncher - набор скриптов на языке [1Script](https://github.com/xDrivenDevelopment/1script) для запуска 1С:Предприятие 8.x в пакетном режиме.

Описание скриптов:

* [launcher.os](https://github.com/bytemdfab/OneLauncher/wiki/launcher.os)
* [config.os](https://github.com/bytemdfab/OneLauncher/wiki/config.os)
* [path.os](https://github.com/bytemdfab/OneLauncher/wiki/path.os)

### Примеры использования

```
ПодключитьСценарий("launcher.os", "МенеджерЗапуска");
мМенеджерЗапуска = Новый МенеджерЗапуска;

мМенеджерЗапуска.Конфигурация()
.Платформа("8.2")
.СервернаяБаза("server1", "test_ib")
.Авторизация1С("User1", "111");

мМенеджерЗапуска.ВыполнитьВнешнююОбработку("c:\Тест.epf");
```
