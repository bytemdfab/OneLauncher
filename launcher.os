﻿///////////////////////////////////////////////////////////////////////////////////
// УПРАВЛЕНИЕ ЗАПУСКОМ 1С:Предприятия 8
//

Перем мКонфигурацияЗапуска;
Перем мВыводКоманды;
Перем мПуть;

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
	Сообщить(СтрокаЗапуска);
	
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

Функция КаталогСценария()

	ПутьКФайлуСценария = ТекущийСценарий().Источник;

	Состав = РазложитьСтрокуВМассивПодстрок(ПутьКФайлуСценария, "\");

	Каталог = "";

	Для Инд = 0 По Состав.Количество()-2 Цикл
		НуженРазделитель = ЗначениеЗаполнено(Каталог) И ЗначениеЗаполнено(Состав[Инд]);
		Разделитель = ?(НуженРазделитель, "\", "");
		Каталог = Каталог + Разделитель + Состав[Инд];
	КонецЦикла;

	Возврат Каталог;

КонецФункции

Процедура Инициализация()
	
	Попытка
		ТипПостроитель = Тип("ПостроительПути");
	Исключение
		ПодключитьСценарий(КаталогСценария() + "\path.os", "ПостроительПути");
	КонецПопытки;

	мПуть = Новый ПостроительПути;

	Попытка
		ТипПостроитель = Тип("КонфигурацияЗапуска");
	Исключение
		ПодключитьСценарий(КаталогСценария() + "\config.os", "КонфигурацияЗапуска");
	КонецПопытки;
	
	мКонфигурацияЗапуска = Неопределено;

КонецПроцедуры


Инициализация();