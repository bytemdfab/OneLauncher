﻿///////////////////////////////////////////////////////////////////////////////////
// УПРАВЛЕНИЕ ЗАПУСКОМ 1С:Предприятия 8
//

Перем мКонфигурацияЗапуска;
Перем мВыводКоманды;
Перем мПуть;
Перем мИмяФайлаСценария;
Перем мКаталогСценария;

///////////////////////////////////////////////////////////////////////////////////
// Экспортные методы
//

Функция НоваяКонфигурация() Экспорт
	
	мКонфигурацияЗапуска = Новый КонфигурацияЗапуска;
	
	Возврат мКонфигурацияЗапуска;
	
КонецФункции

Функция Конфигурация() Экспорт
	
	Если мКонфигурацияЗапуска = Неопределено Тогда
		НоваяКонфигурация();
	КонецЕсли;
	
	Возврат мКонфигурацияЗапуска;
	
КонецФункции

Функция УстановитьКонфигурацию(Конфигурация) Экспорт
	
	мКонфигурацияЗапуска = Конфигурация;

КонецФункции

Функция ВыводКоманды() Экспорт
	Возврат мВыводКоманды;
КонецФункции


Процедура ВыполнитьВнешнююОбработку(Знач ПутьКОбработке, Знач ДополнительныеПараметрыЗапуска = "") Экспорт
	
	мКонфигурацияЗапуска.Предприятие()
	.Аргумент("/Execute "+мПуть.Составить(ПутьКОбработке));
	
	Если ДополнительныеПараметрыЗапуска <> Неопределено Тогда
		мКонфигурацияЗапуска.Аргумент("/C "+ДополнительныеПараметрыЗапуска);
	КонецЕсли;
	
	ВыполнитьКоманду();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////
// Служебные
//


Функция ЗапуститьИПодождать()
	
	КодВозврата = Неопределено;
	
	СтрокаЗапуска = мКонфигурацияЗапуска.КоманднаяСтрока();
	СообщениеСкрипта(СтрокаЗапуска);
	
	ЗапуститьПриложение(СтрокаЗапуска,,Истина, КодВозврата);
	
	Возврат КодВозврата;
	
КонецФункции

Функция ВыполнитьКоманду()
	
	КодВозврата = ЗапуститьИПодождать();
	
	мВыводКоманды = ПрочитатьФайлВывода();
	
	Если КодВозврата <> 0 Тогда
		ВызватьИсключение ВыводКоманды();
	КонецЕсли;
	
	Возврат КодВозврата;
	
КонецФункции

Функция ПрочитатьФайлВывода()
	
	Текст = "";

	Файл = Новый Файл(мКонфигурацияЗапуска.ПолучитьФайлВывода());
	Если Файл.Существует() Тогда
		Чтение = Новый ЧтениеТекста(Файл.ПолноеИмя);
		Текст = Чтение.Прочитать();
		Чтение.Закрыть();
	Иначе
		Текст = "Информации об ошибке нет";
	КонецЕсли;

	Возврат Текст;
	
КонецФункции

Функция РазложитьСтрокуВМассивПодстрок(ИсходнаяСтрока, Разделитель)

	МассивПодстрок = Новый Массив;
	ОстатокСтроки = ИсходнаяСтрока;
	
	Поз = -1;
	Пока Поз <> 0 Цикл
	
		Поз = Найти(ОстатокСтроки, Разделитель);
		Если Поз > 0 Тогда
			Подстрока = Лев(ОстатокСтроки, Поз-1);
			ОстатокСтроки = Сред(ОстатокСтроки, Поз+1);
		Иначе
			Подстрока = ОстатокСтроки;
		КонецЕсли;
		
		МассивПодстрок.Добавить(Подстрока);
	
	КонецЦикла;
	
	Возврат МассивПодстрок;

КонецФункции

Процедура СообщениеСкрипта(ТекстСообщения)

	Сообщить("[" + мИмяФайлаСценария + "] " + ТекстСообщения);

КонецПроцедуры


Процедура Инициализация()
	
	ФайлСценария = Новый Файл(ТекущийСценарий().Источник);
	мИмяФайлаСценария = ФайлСценария.Имя;
	мКаталогСценария = ФайлСценария.Путь;

	Попытка
		ТипПостроитель = Тип("ПостроительПути");
	Исключение
		ПодключитьСценарий(мКаталогСценария + "\path.os", "ПостроительПути");
	КонецПопытки;

	мПуть = Новый ПостроительПути;

	Попытка
		ТипПостроитель = Тип("КонфигурацияЗапуска");
	Исключение
		ПодключитьСценарий(мКаталогСценария + "\config.os", "КонфигурацияЗапуска");
	КонецПопытки;
	
	мКонфигурацияЗапуска = Неопределено;

КонецПроцедуры


Инициализация();