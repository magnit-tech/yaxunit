//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
	
	ВладельцыФорм = ЮТДымовыеТестыСлужебныйВызовСервера.Формы("", Новый Структура);
	
	Для Каждого ВладелецФорм Из ВладельцыФорм Цикл
		
		ОписаниеОбъектаМетаданных = Новый Структура("Тип, Имя", ВладелецФорм.Тип, ВладелецФорм.Имя);
		
		Для Каждого ОписаниеФормы Из ВладелецФорм.Формы Цикл
			
			ЗарегистрироватьТестыФормы(ОписаниеОбъектаМетаданных, ОписаниеФормы);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗарегистрироватьТестыФормы(ОписаниеОбъектаМетаданных, ОписаниеФормы)
	
	ЮТТесты.ВТранзакции().УдалениеТестовыхДанных();
	
	ПредставлениеОбъектаМетаданных = СтрШаблон("%1.%2", ОписаниеОбъектаМетаданных.Тип, ОписаниеОбъектаМетаданных.Имя);
	
	Если ОписаниеФормы.ЭтоФормаОбъекта И ОписаниеФормы.ЭтоФормаГруппы Тогда
		
//		ЮТТесты.ДобавитьКлиентскийТест("ОткрытьФормуГруппы")
//			.СПараметрами(ОписаниеОбъектаМетаданных)
//			.Представление("Открытие формы группы: " + ПредставлениеОбъектаМетаданных);
		
	ИначеЕсли ОписаниеФормы.ЭтоФормаОбъекта Тогда
		
		ЮТТесты.ДобавитьКлиентскийТест("ОткрытьФормуНовогоОбъекта")
			.СПараметрами(ОписаниеОбъектаМетаданных)
			.Представление("Открытие формы нового объекта: " + ПредставлениеОбъектаМетаданных);
		
		ЮТТесты.ДобавитьКлиентскийТест("ОткрытьФормуСуществующегоОбъекта")
			.СПараметрами(ОписаниеОбъектаМетаданных)
			.Представление("Открытие формы существующего объекта: " + ПредставлениеОбъектаМетаданных);
		
	ИначеЕсли ОписаниеФормы.ЭтоФормаВыбора И ОписаниеФормы.ЭтоФормаГруппы Тогда
		
//		ЮТТесты.ДобавитьКлиентскийТест("ОткрытьФормуВыбораГруппы")
//			.СПараметрами(ОписаниеОбъектаМетаданных)
//			.Представление("Открытие формы выбора группы: " + ПредставлениеОбъектаМетаданных);
		
	ИначеЕсли ОписаниеФормы.ЭтоФормаВыбора Тогда
		
//		ЮТТесты.ДобавитьКлиентскийТест("ОткрытьФормуВыбора")
//			.СПараметрами(ОписаниеОбъектаМетаданных)
//			.Представление("Открытие формы выбора: " + ПредставлениеОбъектаМетаданных);
		
	ИначеЕсли ОписаниеФормы.ЭтоФормаСписка Тогда
		
//		ЮТТесты.ДобавитьКлиентскийТест("ОткрытьФормуСписка")
//			.СПараметрами(ОписаниеОбъектаМетаданных)
//			.Представление("Открытие формы списка: " + ПредставлениеОбъектаМетаданных);
		
	КонецЕсли;
	
КонецПроцедуры

#Область Тесты

Процедура ОткрытьФормуНовогоОбъекта(ОбъектМетаданных) Экспорт
	
	ОткрытьЗакрытьФорму(ОбъектМетаданных, "ФормаОбъекта");
	
КонецПроцедуры

Процедура ОткрытьФормуСуществующегоОбъекта(ОбъектМетаданных) Экспорт
	
	Ключ = ЮТДымовыеТестыСлужебныйВызовСервера.СлучайныйЭлемент(ОбъектМетаданных.Тип, ОбъектМетаданных.Имя);
	
	Если НЕ ЗначениеЗаполнено(Ключ) Тогда
		ЮТест.Пропустить(СтрШаблон("Не удалось найти существующий объект для типа `%1.%2`", ОбъектМетаданных.Тип, ОбъектМетаданных.Имя));
	КонецЕсли;
	
	ОткрытьЗакрытьФорму(ОбъектМетаданных, "ФормаОбъекта", Ключ);
	
КонецПроцедуры

Процедура ОткрытьФормуГруппы(ОбъектМетаданных) Экспорт
	
	ОткрытьЗакрытьФорму(ОбъектМетаданных, "ФормаГруппы");
	
КонецПроцедуры

Процедура ОткрытьФормуВыбора(ОбъектМетаданных) Экспорт
	
	ОткрытьЗакрытьФорму(ОбъектМетаданных, "ФормаВыбора");
	
КонецПроцедуры

Процедура ОткрытьФормуВыбораГруппы(ОбъектМетаданных) Экспорт
	
	ОткрытьЗакрытьФорму(ОбъектМетаданных, "ФормаВыбораГруппы");
	
КонецПроцедуры

Процедура ОткрытьФормуСписка(ОбъектМетаданных) Экспорт
	
	ОткрытьЗакрытьФорму(ОбъектМетаданных, "ФормаСписка");
	
КонецПроцедуры

Процедура ОткрытьЗакрытьФорму(ОбъектМетаданных, ИмяФормы, Ключ = Неопределено) 
	
	ПолноеИмяФормы = СтрШаблон("%1.%2.%3", ОбъектМетаданных.Тип, ОбъектМетаданных.Имя, ИмяФормы);
	ЮТЛогирование.Отладка("Открытие формы: " + ПолноеИмяФормы);
	ЮТЛогирование.Отладка("Ключ: " + Ключ);
	
	Параметры = Новый Структура("Ключ", Ключ);
	
	Попытка
	//@skip-check use-non-recommended-method
	Форма = ПолучитьФорму(ПолноеИмяФормы, Параметры, , Новый УникальныйИдентификатор); // BSLLS:GetFormMethod-off
	Исключение
		ЮТЛогирование.Ошибка(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение
	КонецПопытки;
	
	Если Форма = Неопределено Тогда
		ВызватьИсключение "Не удалось получить форму";
	КонецЕсли;
	
	ЭтоУправляемаяФорма = ЭтоУправляемаяФорма(Форма);
	ЮТЛогирование.Отладка("Тип формы: " + Формат(ЭтоУправляемаяФорма, "БЛ='Обычная форма'; БИ='Управляемая форма';"));
	
	Попытка
		Форма.Открыть();
	Исключение
		ЮТЛогирование.Ошибка(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение
	КонецПопытки;
	
	Если Форма.Открыта() Тогда
		Если ЭтоУправляемаяФорма Тогда
			Форма.ОбновитьОтображениеДанных();
		Иначе
			Форма.Обновить();
		КонецЕсли;
		
		Форма.Модифицированность = Ложь;
		Форма.Закрыть();
		
		Если Форма.Открыта() Тогда
			ВызватьИсключение "Не удалось закрыть форму";
		КонецЕсли;
	Иначе
		ВызватьИсключение "Не удалось открыть форму";
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоУправляемаяФорма(Форма)
	
	Возврат ТипЗнч(Форма) = Тип("ФормаКлиентскогоПриложения");
	
КонецФункции

#КонецОбласти

#КонецОбласти
